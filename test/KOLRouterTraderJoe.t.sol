// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../contracts/kol-router/KOLRouterTraderJoe.sol";
import "../contracts/kol-router/KOLFactoryTraderJoe.sol";
import "../contracts/kol-router/interfaces/ILBRouter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ERC20 token mock for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

// Trader Joe router mock
contract MockLBRouter {
    // Simulates the return of an expected value for swapExactNATIVEForTokens
    function swapExactNATIVEForTokens(
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256) {
        // Simulates that the operation was successful and returns an output value
        return amountOutMin + 100; // We simply return a value greater than the expected minimum
    }

    // Simulates the return of expected values for swapNATIVEForExactTokens
    function swapNATIVEForExactTokens(
        uint256 amountOut,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory) {
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = msg.value; // Use exact amount to avoid discrepancies
        amounts[1] = amountOut;
        return amounts;
    }

    // Simulates the return of an expected value for swapExactTokensForNATIVE
    function swapExactTokensForNATIVE(
        uint256 amountIn,
        uint256 amountOutMinNATIVE,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    ) external returns (uint256) {
        // Mock consumes the approved tokens from the caller
        address inputToken = address(path.tokenPath[0]);
        MockERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        // Simulates the transfer of NATIVE to the recipient
        payable(to).transfer(amountOutMinNATIVE + 100);
        return amountOutMinNATIVE + 100;
    }

    // Simulates the return of expected values for swapTokensForExactNATIVE
    function swapTokensForExactNATIVE(
        uint256 amountOutNATIVE,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address payable to,
        uint256 deadline
    ) external returns (uint256[] memory) {
        // Mock consumes the approved tokens from the caller
        address inputToken = address(path.tokenPath[0]);
        MockERC20(inputToken).transferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = amountInMax; // Use exact amount to avoid discrepancies
        amounts[1] = amountOutNATIVE;

        // Simulates the transfer of NATIVE to the recipient
        payable(to).transfer(amountOutNATIVE);

        return amounts;
    }

    // Simulates the return of an expected value for swapExactTokensForTokens
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256) {
        // Mock consumes the approved tokens from the caller
        address inputToken = address(path.tokenPath[0]);
        MockERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        return amountOutMin + 100;
    }

    // Simulates the return of expected values for swapTokensForExactTokens
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        ILBRouter.Path calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory) {
        // Mock consumes the approved tokens from the caller
        address inputToken = address(path.tokenPath[0]);
        MockERC20(inputToken).transferFrom(
            msg.sender,
            address(this),
            amountInMax
        );

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = amountInMax; // Use exact amount to avoid discrepancies
        amounts[1] = amountOut;
        return amounts;
    }

    // Receive function to receive ETH
    receive() external payable {}
}

// Main test contract
contract KOLSwapRouterTest is Test {
    KOLFactoryTraderJoe public factory;
    KOLRouterTraderJoe public router;
    MockLBRouter public mockLBRouter;
    MockERC20 public tokenA;
    MockERC20 public tokenB;

    address public owner = address(0x1);
    address public kolAddress = address(0x2);
    address public sherryFoundation = address(0x3);
    address public sherryTreasury = address(0x4);
    address payable public user = payable(address(0x5));

    uint256 public constant INITIAL_USER_BALANCE = 100 ether;
    uint256 public constant INITIAL_TOKEN_BALANCE = 10000 * 1e18;

    // Fee configuration - matches the default from KOLFactoryBase
    uint16 public constant KOL_FEE_RATE = 100; // 1%
    uint16 public constant FOUNDATION_FEE_RATE = 50; // 0.5%
    uint16 public constant TREASURY_FEE_RATE = 50; // 0.5%
    uint16 public constant TOTAL_FEE_RATE = 200; // 2%
    uint16 public constant BASIS_POINTS = 10000;

    event SwapExecuted(
        address indexed kol,
        address indexed trader,
        address tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 kolFee,
        uint256 foundationFee,
        uint256 treasuryFee
    );

    function setUp() public {
        // Create the mocks
        mockLBRouter = new MockLBRouter();
        tokenA = new MockERC20("Token A", "TKNA");
        tokenB = new MockERC20("Token B", "TKNB");

        // Deploy the factory as owner
        vm.startPrank(owner);
        factory = new KOLFactoryTraderJoe(
            address(mockLBRouter),
            sherryFoundation,
            sherryTreasury
        );

        // Create router for KOL
        address routerAddress = factory.createKOLRouter(kolAddress);
        router = KOLRouterTraderJoe(payable(routerAddress));
        vm.stopPrank();

        // Set up balances
        vm.deal(user, INITIAL_USER_BALANCE);
        vm.deal(sherryFoundation, 0);
        vm.deal(sherryTreasury, 0);
        tokenA.mint(user, INITIAL_TOKEN_BALANCE);
        tokenB.mint(user, INITIAL_TOKEN_BALANCE);

        // Set up NATIVE balance for the mock router so it can make transfers
        vm.deal(address(mockLBRouter), 1000 ether);
    }

    // Helper function to calculate expected fees
    function calculateFees(
        uint256 amount
    )
        internal
        pure
        returns (
            uint256 kolFee,
            uint256 foundationFee,
            uint256 treasuryFee,
            uint256 netAmount
        )
    {
        kolFee = (amount * KOL_FEE_RATE) / BASIS_POINTS;
        foundationFee = (amount * FOUNDATION_FEE_RATE) / BASIS_POINTS;
        treasuryFee = (amount * TREASURY_FEE_RATE) / BASIS_POINTS;
        netAmount = amount - kolFee - foundationFee - treasuryFee;
    }

    // Helper function to create a token path
    function createPath(
        address tokenIn,
        address tokenOut
    ) internal pure returns (ILBRouter.Path memory) {
        // Create tokenPath array
        IERC20[] memory tokenPath = new IERC20[](2);
        tokenPath[0] = IERC20(tokenIn);
        tokenPath[1] = IERC20(tokenOut);

        // Create pairBinSteps array
        uint256[] memory pairBinSteps = new uint256[](1);
        pairBinSteps[0] = 100; // An arbitrary value for the bin step

        // Create versions array
        ILBRouter.Version[] memory versions = new ILBRouter.Version[](1);
        versions[0] = ILBRouter.Version.V2_2; // Use the appropriate version

        // Create and return the Path struct with all three required fields
        return
            ILBRouter.Path({
                pairBinSteps: pairBinSteps,
                versions: versions,
                tokenPath: tokenPath
            });
    }

    // Test for swapExactNATIVEForTokens with percentage fees
    function testSwapExactNATIVEForTokens() public {
        // Prepare test data
        uint256 amountOutMin = 100;
        uint256 valueSent = 1 ether;
        ILBRouter.Path memory path = createPath(address(0), address(tokenA)); // address(0) represents NATIVE

        // Calculate expected fees
        (
            uint256 expectedKolFee,
            uint256 expectedFoundationFee,
            uint256 expectedTreasuryFee,
            uint256 expectedNetAmount
        ) = calculateFees(valueSent);

        // Check initial balances
        uint256 initialRouterBalance = address(router).balance;
        uint256 initialFoundationBalance = sherryFoundation.balance;
        uint256 initialTreasuryBalance = sherryTreasury.balance;

        // Expect the SwapExecuted event
        vm.expectEmit(true, true, true, true);
        emit SwapExecuted(
            kolAddress,
            user,
            address(0),
            address(tokenA),
            expectedNetAmount,
            expectedKolFee,
            expectedFoundationFee,
            expectedTreasuryFee
        );

        // Execute function as user
        vm.startPrank(user);
        uint256 amountOut = router.swapExactNATIVEForTokens{value: valueSent}(
            amountOutMin,
            path,
            user,
            block.timestamp + 3600
        );
        vm.stopPrank();

        // Verifications
        assertEq(
            address(router).balance,
            initialRouterBalance + expectedKolFee,
            "KOL fee not accumulated correctly in the router"
        );

        assertEq(
            sherryFoundation.balance,
            initialFoundationBalance + expectedFoundationFee,
            "Foundation fee not transferred correctly"
        );

        assertEq(
            sherryTreasury.balance,
            initialTreasuryBalance + expectedTreasuryFee,
            "Treasury fee not transferred correctly"
        );

        assertTrue(
            amountOut > amountOutMin,
            "Output amount should be greater than the expected minimum"
        );
    }

    // Test for swapNATIVEForExactTokens with percentage fees
    function testSwapNATIVEForExactTokens() public {
        // Prepare test data
        uint256 amountOut = 500;
        uint256 valueSent = 1 ether;
        ILBRouter.Path memory path = createPath(address(0), address(tokenA));

        // Calculate expected fees
        (
            uint256 expectedKolFee,
            uint256 expectedFoundationFee,
            uint256 expectedTreasuryFee,
            uint256 expectedNetAmount
        ) = calculateFees(valueSent);

        // Check initial balances
        uint256 initialRouterBalance = address(router).balance;
        uint256 initialFoundationBalance = sherryFoundation.balance;
        uint256 initialTreasuryBalance = sherryTreasury.balance;
        uint256 initialUserBalance = user.balance;

        // Execute function as user
        vm.startPrank(user);
        uint256[] memory amountsIn = router.swapNATIVEForExactTokens{
            value: valueSent
        }(amountOut, path, user, block.timestamp + 3600);
        vm.stopPrank();

        // Verifications
        assertEq(
            address(router).balance,
            initialRouterBalance + expectedKolFee,
            "KOL fee not accumulated correctly in the router"
        );

        assertEq(
            sherryFoundation.balance,
            initialFoundationBalance + expectedFoundationFee,
            "Foundation fee not transferred correctly"
        );

        assertEq(
            sherryTreasury.balance,
            initialTreasuryBalance + expectedTreasuryFee,
            "Treasury fee not transferred correctly"
        );

        // Since our mock returns the exact net amount, no refund should happen
        assertEq(
            amountsIn[0],
            expectedNetAmount,
            "Amount used should be equal to the net amount after fees"
        );

        // User should have spent exactly valueSent
        assertEq(
            user.balance,
            initialUserBalance - valueSent,
            "User balance should reflect the exact amount sent"
        );
    }

    // Test for swapExactTokensForNATIVE with percentage fees
    function testSwapExactTokensForNATIVE() public {
        // Prepare test data
        uint256 amountIn = 1000 * 1e18;
        uint256 amountOutMinNATIVE = 0.5 ether;

        ILBRouter.Path memory path = createPath(address(tokenA), address(0));

        // Calculate expected fees
        (
            uint256 expectedKolFee,
            uint256 expectedFoundationFee,
            uint256 expectedTreasuryFee,
            uint256 expectedNetAmount
        ) = calculateFees(amountIn);

        // Check initial balances
        uint256 initialFoundationTokenBalance = tokenA.balanceOf(
            sherryFoundation
        );
        uint256 initialTreasuryTokenBalance = tokenA.balanceOf(sherryTreasury);
        uint256 initialUserTokenBalance = tokenA.balanceOf(user);
        uint256 initialUserNativeBalance = user.balance;

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);

        // Execute the function
        uint256 amountOut = router.swapExactTokensForNATIVE(
            amountIn,
            amountOutMinNATIVE,
            path,
            payable(user),
            block.timestamp + 3600
        );
        vm.stopPrank();

        // Router should only keep the KOL fee, the rest goes to DEX, Foundation, and Treasury
        assertEq(
            tokenA.balanceOf(address(router)),
            expectedKolFee,
            "Router should only keep KOL fee"
        );

        assertEq(
            tokenA.balanceOf(sherryFoundation),
            initialFoundationTokenBalance + expectedFoundationFee,
            "Foundation fee tokens not transferred correctly"
        );

        assertEq(
            tokenA.balanceOf(sherryTreasury),
            initialTreasuryTokenBalance + expectedTreasuryFee,
            "Treasury fee tokens not transferred correctly"
        );

        assertEq(
            tokenA.balanceOf(user),
            initialUserTokenBalance - amountIn,
            "User tokens not transferred correctly"
        );

        assertTrue(
            amountOut > amountOutMinNATIVE,
            "Output amount should be greater than the expected minimum"
        );

        assertTrue(
            user.balance > initialUserNativeBalance,
            "User should have received NATIVE"
        );
    }

    // Test for swapExactTokensForTokens with percentage fees
    function testSwapExactTokensForTokens() public {
        // Prepare test data
        uint256 amountIn = 1000 * 1e18;
        uint256 amountOutMin = 500 * 1e18;

        ILBRouter.Path memory path = createPath(
            address(tokenA),
            address(tokenB)
        );

        // Calculate expected fees
        (
            uint256 expectedKolFee,
            uint256 expectedFoundationFee,
            uint256 expectedTreasuryFee,
            uint256 expectedNetAmount
        ) = calculateFees(amountIn);

        // Check initial balances
        uint256 initialFoundationTokenBalance = tokenA.balanceOf(
            sherryFoundation
        );
        uint256 initialTreasuryTokenBalance = tokenA.balanceOf(sherryTreasury);
        uint256 initialUserTokenABalance = tokenA.balanceOf(user);

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);

        // Execute the function
        uint256 amountOut = router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            user,
            block.timestamp + 3600
        );
        vm.stopPrank();

        // The router receives the full amountIn, then sends fees to Foundation/Treasury
        // What remains in the router is: amountIn - foundationFee - treasuryFee - netAmount (sent to DEX)
        // Since the DEX doesn't return tokens in this mock, the router keeps: amountIn - foundationFee - treasuryFee - netAmount
        // But actually, the router should keep the KOL fee: expectedKolFee
        uint256 expectedRouterBalance = expectedKolFee;

        // Verifications
        assertEq(
            tokenA.balanceOf(address(router)),
            expectedRouterBalance,
            "Router should only keep KOL fee"
        );

        assertEq(
            tokenA.balanceOf(sherryFoundation),
            initialFoundationTokenBalance + expectedFoundationFee,
            "Foundation fee tokens not transferred correctly"
        );

        assertEq(
            tokenA.balanceOf(sherryTreasury),
            initialTreasuryTokenBalance + expectedTreasuryFee,
            "Treasury fee tokens not transferred correctly"
        );

        assertEq(
            tokenA.balanceOf(user),
            initialUserTokenABalance - amountIn,
            "User tokens A not transferred correctly"
        );

        assertTrue(
            amountOut > amountOutMin,
            "Output amount should be greater than the expected minimum"
        );
    }

    // Test KOL withdrawing fees (multiple tokens)
    function testWithdrawKOLFees() public {
        // First perform swaps to accumulate fees in different tokens
        // Native fee from swap
        uint256 valueSent = 1 ether;
        uint256 amountOutMin = 100;

        ILBRouter.Path memory pathNative = createPath(
            address(0),
            address(tokenA)
        );

        vm.prank(user);
        router.swapExactNATIVEForTokens{value: valueSent}(
            amountOutMin,
            pathNative,
            user,
            block.timestamp + 3600
        );

        // Token fee from swap
        uint256 amountIn = 1000 * 1e18;
        ILBRouter.Path memory pathToken = createPath(
            address(tokenA),
            address(tokenB)
        );

        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);
        router.swapExactTokensForTokens(
            amountIn,
            500 * 1e18,
            pathToken,
            user,
            block.timestamp + 3600
        );
        vm.stopPrank();

        // Calculate expected fees
        (uint256 expectedNativeKolFee, , , ) = calculateFees(valueSent);
        (uint256 expectedTokenKolFee, , , ) = calculateFees(amountIn);

        // Get balances before withdrawal
        uint256 routerNativeBalance = address(router).balance;
        uint256 routerTokenABalance = tokenA.balanceOf(address(router));
        uint256 kolNativeBalance = kolAddress.balance;
        uint256 kolTokenABalance = tokenA.balanceOf(kolAddress);

        // Verify the router has the expected fees
        assertEq(
            routerNativeBalance,
            expectedNativeKolFee,
            "Router should have expected native KOL fee"
        );
        assertEq(
            routerTokenABalance,
            expectedTokenKolFee,
            "Router should have expected token KOL fee"
        );

        // Prepare token addresses array
        address[] memory tokenAddresses = new address[](1);
        tokenAddresses[0] = address(tokenA);

        // KOL withdraws fees
        vm.prank(kolAddress);
        router.withdrawKOLFees(tokenAddresses);

        // Verify balances after withdrawal
        assertEq(
            address(router).balance,
            0,
            "Router should have zero native balance after withdrawal"
        );

        assertEq(
            tokenA.balanceOf(address(router)),
            0,
            "Router should have zero tokenA balance after withdrawal"
        );

        assertEq(
            kolAddress.balance,
            kolNativeBalance + routerNativeBalance,
            "KOL should have received all native fees"
        );

        assertEq(
            tokenA.balanceOf(kolAddress),
            kolTokenABalance + routerTokenABalance,
            "KOL should have received all tokenA fees"
        );
    }

    // Test fee balance queries
    function testGetKOLFeeBalances() public {
        // Perform swaps to accumulate fees
        // Native fee
        uint256 valueSent = 1 ether;
        uint256 amountOutMin = 100;

        ILBRouter.Path memory pathNative = createPath(
            address(0),
            address(tokenA)
        );

        vm.prank(user);
        router.swapExactNATIVEForTokens{value: valueSent}(
            amountOutMin,
            pathNative,
            user,
            block.timestamp + 3600
        );

        // Token fee
        uint256 amountIn = 1000 * 1e18;
        ILBRouter.Path memory pathToken = createPath(
            address(tokenA),
            address(tokenB)
        );

        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);
        router.swapExactTokensForTokens(
            amountIn,
            500 * 1e18,
            pathToken,
            user,
            block.timestamp + 3600
        );
        vm.stopPrank();

        // Prepare token addresses array
        address[] memory tokenAddresses = new address[](2);
        tokenAddresses[0] = address(0); // Native
        tokenAddresses[1] = address(tokenA);

        // Get balances
        uint256[] memory balances = router.getKOLFeeBalances(tokenAddresses);

        // Calculate expected fees
        (uint256 expectedNativeKolFee, , , ) = calculateFees(valueSent);
        (uint256 expectedTokenKolFee, , , ) = calculateFees(amountIn);

        // Verify balances
        assertEq(
            balances[0],
            expectedNativeKolFee,
            "Native balance should match expected KOL fee"
        );

        assertEq(
            balances[1],
            expectedTokenKolFee,
            "TokenA balance should match expected KOL fee"
        );
    }

    // Test fee rate configuration
    function testFeeRateConfiguration() public {
        // Test getting fee rates from factory
        assertEq(
            factory.getKOLFeeRate(),
            KOL_FEE_RATE,
            "KOL fee rate mismatch"
        );
        assertEq(
            factory.getFoundationFeeRate(),
            FOUNDATION_FEE_RATE,
            "Foundation fee rate mismatch"
        );
        assertEq(
            factory.getTreasuryFeeRate(),
            TREASURY_FEE_RATE,
            "Treasury fee rate mismatch"
        );
        assertEq(
            factory.getTotalFeeRate(),
            TOTAL_FEE_RATE,
            "Total fee rate mismatch"
        );

        // Test updating fee rates (only owner can do this)
        vm.prank(owner);
        factory.setFeeRates(150, 75, 75); // 1.5%, 0.75%, 0.75%

        assertEq(factory.getKOLFeeRate(), 150, "Updated KOL fee rate mismatch");
        assertEq(
            factory.getFoundationFeeRate(),
            75,
            "Updated Foundation fee rate mismatch"
        );
        assertEq(
            factory.getTreasuryFeeRate(),
            75,
            "Updated Treasury fee rate mismatch"
        );
        assertEq(
            factory.getTotalFeeRate(),
            300,
            "Updated total fee rate mismatch"
        );
    }

    // Test calculateNetAmount function
    function testCalculateNetAmount() public view {
        uint256 inputAmount = 1 ether;
        uint256 expectedNetAmount = inputAmount -
            (inputAmount * TOTAL_FEE_RATE) /
            BASIS_POINTS;

        uint256 actualNetAmount = router.calculateNetAmount(inputAmount);

        assertEq(
            actualNetAmount,
            expectedNetAmount,
            "Net amount calculation mismatch"
        );
    }

    // Test access control - only KOL can withdraw
    function testOnlyKOLCanWithdraw() public {
        address[] memory tokenAddresses = new address[](1);
        tokenAddresses[0] = address(tokenA);

        // Non-KOL trying to withdraw should fail
        vm.prank(user);
        vm.expectRevert("Only KOL can call this function");
        router.withdrawKOLFees(tokenAddresses);
    }

    // Test that fees are sent immediately to Foundation and Treasury
    function testImmediateFeeDistribution() public {
        uint256 valueSent = 1 ether;
        uint256 amountOutMin = 100;

        ILBRouter.Path memory path = createPath(address(0), address(tokenA));

        // Check initial balances
        uint256 initialFoundationBalance = sherryFoundation.balance;
        uint256 initialTreasuryBalance = sherryTreasury.balance;

        // Calculate expected fees
        (
            ,
            uint256 expectedFoundationFee,
            uint256 expectedTreasuryFee,

        ) = calculateFees(valueSent);

        // Execute swap
        vm.prank(user);
        router.swapExactNATIVEForTokens{value: valueSent}(
            amountOutMin,
            path,
            user,
            block.timestamp + 3600
        );

        // Verify immediate fee distribution
        assertEq(
            sherryFoundation.balance,
            initialFoundationBalance + expectedFoundationFee,
            "Foundation should receive fee immediately"
        );

        assertEq(
            sherryTreasury.balance,
            initialTreasuryBalance + expectedTreasuryFee,
            "Treasury should receive fee immediately"
        );
    }
}
