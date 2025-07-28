// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../../contracts/gtm/Onboarding.sol";
import "../../contracts/gtm/MiniAppLauncher.sol";
import "../mocks/SimpleWormholeRelayerMock.sol";

contract OnboardingSystemTest is Test {
    Onboarding public onboarding;
    MiniAppLauncher public launcher;
    SimpleWormholeRelayerMock public mockRelayer;
    
    address public deployer;
    address public user1;
    address public user2;
    address public creator1;
    
    uint16 constant AVALANCHE_CHAIN_ID = 6;
    uint16 constant CELO_CHAIN_ID = 14;
    
    function setUp() public {
        deployer = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        creator1 = makeAddr("creator1");
        
        // Deploy mock Wormhole relayer
        mockRelayer = new SimpleWormholeRelayerMock();
        vm.deal(address(mockRelayer), 10 ether);
        
        // Deploy contracts
        onboarding = new Onboarding(address(mockRelayer)); // mockRelayer acts as messageReceiver for tests
        launcher = new MiniAppLauncher(
            address(mockRelayer),
            AVALANCHE_CHAIN_ID,
            address(mockRelayer), // messageReceiver
            address(onboarding)   // onboarding contract
        );
        
        // For testing, we set the onboarding contract's messageReceiver to our mockRelayer
        // In reality, you'd deploy a real SL1MessageReceiver and register it properly
        
        // Fund users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
        vm.deal(creator1, 10 ether);
    }
    
    function testCreateMiniApp() public {
        vm.prank(creator1);
        launcher.createMiniApp("awesome-game");
        
        MiniAppLauncher.MiniApp memory miniApp = launcher.getMiniApp("awesome-game");
        assertEq(miniApp.creator, creator1);
        assertEq(miniApp.id, "awesome-game");
        assertTrue(miniApp.active);
        assertEq(miniApp.interactionCount, 0);
    }
    
    function testCreateMiniAppOnCelo() public {
        onboarding.createMiniApp("awesome-game");
        
        assertTrue(onboarding.doesMiniAppExist("awesome-game"));
        
        (uint256 totalInteractions, uint256 totalMiniApps, uint256 totalPoaps, uint256 availableSlots) = onboarding.getStats();
        assertEq(totalMiniApps, 1);
        assertEq(availableSlots, 49);
    }
    
    function testInteractWithMiniApp() public {
        // Create mini-app
        vm.prank(creator1);
        launcher.createMiniApp("awesome-game");
        
        // Create corresponding mini-app on Celo
        onboarding.createMiniApp("awesome-game");
        
        // Get interaction cost
        uint256 cost = launcher.getInteractionCost();
        
        // User interacts with mini-app
        vm.prank(user1);
        launcher.interactWithMiniApp{value: cost}("awesome-game", "johndoe");
        
        // Check mini-app interaction count
        MiniAppLauncher.MiniApp memory miniApp = launcher.getMiniApp("awesome-game");
        assertEq(miniApp.interactionCount, 1);
    }
    
    function testCrossChainOnboarding() public {
        // Create mini-app on both sides
        vm.prank(creator1);
        launcher.createMiniApp("awesome-game");
        onboarding.createMiniApp("awesome-game");
        
        // User interacts (this should trigger cross-chain message)
        uint256 cost = launcher.getInteractionCost();
        vm.prank(user1);
        launcher.interactWithMiniApp{value: cost}("awesome-game", "johndoe");
        
        // Check onboarding contract received interaction
        (uint256 totalInteractions, , , ) = onboarding.getStats();
        assertEq(totalInteractions, 1);
        
        // Check user has interactions
        bytes32[] memory userInteractions = onboarding.getUserInteractions(user1);
        assertEq(userInteractions.length, 1);
    }
    
    function testLocalInteraction() public {
        // Create mini-app on Celo
        onboarding.createMiniApp("local-app");
        
        // Process local interaction
        vm.prank(user1);
        onboarding.processLocalInteraction("local-app", "alice");
        
        // Check stats
        (uint256 totalInteractions, , , ) = onboarding.getStats();
        assertEq(totalInteractions, 1);
        
        // Check mini-app interaction count
        uint256 count = onboarding.getMiniAppInteractionCount("local-app");
        assertEq(count, 1);
    }
    
    function testMultipleUsers() public {
        // Create mini-app
        onboarding.createMiniApp("popular-app");
        
        // Multiple users interact
        vm.prank(user1);
        onboarding.processLocalInteraction("popular-app", "alice");
        
        vm.prank(user2);
        onboarding.processLocalInteraction("popular-app", "bob");
        
        // Check stats
        (uint256 totalInteractions, , , ) = onboarding.getStats();
        assertEq(totalInteractions, 2);
        
        uint256 appCount = onboarding.getMiniAppInteractionCount("popular-app");
        assertEq(appCount, 2);
    }
    
    function testMaxMiniApps() public {
        // Try to create more than 50 mini-apps
        for (uint i = 0; i < 50; i++) {
            onboarding.createMiniApp(string(abi.encodePacked("app-", vm.toString(i))));
        }
        
        // 51st should fail
        vm.expectRevert("Maximum mini-apps reached");
        onboarding.createMiniApp("app-51");
    }
    
    function testInvalidInteractions() public {
        // Try to interact with non-existent mini-app
        vm.expectRevert("Mini-app does not exist");
        onboarding.processLocalInteraction("non-existent", "alice");
        
        // Try with empty twitter handle
        onboarding.createMiniApp("test-app");
        vm.expectRevert("Twitter handle required");
        onboarding.processLocalInteraction("test-app", "");
    }
    
    function testFeeCollection() public {
        vm.prank(creator1);
        launcher.createMiniApp("paid-app");
        
        uint256 cost = launcher.getInteractionCost();
        uint256 initialBalance = address(launcher).balance;
        
        vm.prank(user1);
        launcher.interactWithMiniApp{value: cost}("paid-app", "paiduser");
        
        // Check fees were collected
        assertTrue(address(launcher).balance > initialBalance);
        
        // Test withdrawal
        uint256 contractBalance = address(launcher).balance;
        launcher.withdrawFees();
        assertEq(address(launcher).balance, 0);
        assertEq(deployer.balance, contractBalance);
    }
    
    receive() external payable {}
}