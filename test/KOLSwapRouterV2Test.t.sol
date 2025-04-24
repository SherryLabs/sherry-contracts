// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "../contracts/kol-router/KOLSwapRouterV2.sol";
import "../contracts/kol-router/interfaces/ILBRouter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ERC20 token mock for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10**decimals());
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
        amounts[0] = msg.value - 100; // Simulates that less ETH was used than sent
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
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = amountInMax - 100; // Simulates that fewer tokens were used than the maximum
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
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = amountInMax - 100; // Simulates that fewer tokens were used than the maximum
        amounts[1] = amountOut;
        return amounts;
    }

    // Receive function to receive ETH
    receive() external payable {}
}

// Main test contract
contract KOLSwapRouterV2Test is Test {
    KOLSwapRouterV2 public router;
    MockLBRouter public mockLBRouter;
    MockERC20 public tokenA;
    MockERC20 public tokenB;

    address public kolAddress = address(0x1);
    address public factoryAddress = address(0x3);
    address payable public user = payable(address(0x4));

    uint256 public constant FEE_AMOUNT = 0.01 ether; // I assume this is the fixed fee
    uint256 public constant INITIAL_USER_BALANCE = 100 ether;
    uint256 public constant INITIAL_TOKEN_BALANCE = 10000 * 1e18;

    function setUp() public {
        // Create the mocks
        mockLBRouter = new MockLBRouter();
        tokenA = new MockERC20("Token A", "TKNA");
        tokenB = new MockERC20("Token B", "TKNB");

        // Deploy the router
        router = new KOLSwapRouterV2(
            kolAddress,
            address(mockLBRouter),
            factoryAddress
        );

        // Set up balances
        vm.deal(user, INITIAL_USER_BALANCE);
        tokenA.mint(user, INITIAL_TOKEN_BALANCE);
        tokenB.mint(user, INITIAL_TOKEN_BALANCE);

        // Set up NATIVE balance for the mock router so it can make transfers
        vm.deal(address(mockLBRouter), 1000 ether);
    }

    // Helper function to create a token path
    function createPath(address tokenIn, address tokenOut) internal pure returns (ILBRouter.Path memory) {
        address[] memory tokenPath = new address[](2);
        tokenPath[0] = tokenIn;
        tokenPath[1] = tokenOut;

        uint256[] memory pairBinSteps = new uint256[](1);
        pairBinSteps[0] = 100; // An arbitrary value for the bin step

        return ILBRouter.Path({
            tokenPath: tokenPath,
            pairBinSteps: pairBinSteps
        });
    }

    // Test for swapExactNATIVEForTokens
    function testSwapExactNATIVEForTokens() public {
        // Prepare test data
        uint256 amountOutMin = 100;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(0), address(tokenA)); // address(0) represents NATIVE

        uint256 valueSent = 1 ether + FEE_AMOUNT; // Value to send including the fee

        // Check initial KOL balance
        uint256 initialKolBalance = address(kolAddress).balance;

        // Execute function as user
        vm.startPrank(user);
        uint256 amountOut = router.swapExactNATIVEForTokens{value: valueSent}(
            amountOutMin,
            path,
            user,
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertTrue(amountOut > amountOutMin, "Output amount should be greater than the expected minimum");
    }

    // Test for swapNATIVEForExactTokens
    function testSwapNATIVEForExactTokens() public {
        // Prepare test data
        uint256 amountOut = 500;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(0), address(tokenA)); // address(0) represents NATIVE

        uint256 valueSent = 1 ether + FEE_AMOUNT; // Value to send including the fee

        // Check initial KOL balance
        uint256 initialKolBalance = address(kolAddress).balance;
        uint256 initialUserBalance = user.balance;

        // Execute function as user
        vm.startPrank(user);
        uint256[] memory amountsIn = router.swapNATIVEForExactTokens{value: valueSent}(
            amountOut,
            path,
            user,
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertTrue(amountsIn[0] < (valueSent - FEE_AMOUNT), "Amount used should be less than the value sent minus fee");
        // Verify that the user received the refund of unused ETH
        assertTrue(user.balance > initialUserBalance - valueSent, "User should have received a refund");
    }

    // Test for swapExactTokensForNATIVE
    function testSwapExactTokensForNATIVE() public {
        // Prepare test data
        uint256 amountIn = 1000 * 1e18;
        uint256 amountOutMinNATIVE = 0.5 ether;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(tokenA), address(0)); // address(0) represents NATIVE

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);

        // Check initial balances
        uint256 initialKolBalance = address(kolAddress).balance;
        uint256 initialUserTokenBalance = tokenA.balanceOf(user);
        uint256 initialUserNativeBalance = user.balance;

        // Execute the function
        uint256 amountOut = router.swapExactTokensForNATIVE{value: FEE_AMOUNT}(
            amountIn,
            amountOutMinNATIVE,
            path,
            payable(user),
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertEq(tokenA.balanceOf(user), initialUserTokenBalance - amountIn, "Tokens not transferred correctly");
        assertTrue(amountOut > amountOutMinNATIVE, "Output amount should be greater than the expected minimum");
        assertTrue(user.balance > initialUserNativeBalance - FEE_AMOUNT, "User should have received NATIVE");
    }

    // Test for swapTokensForExactNATIVE
    function testSwapTokensForExactNATIVE() public {
        // Prepare test data
        uint256 amountOutNATIVE = 0.5 ether;
        uint256 amountInMax = 1000 * 1e18;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(tokenA), address(0)); // address(0) represents NATIVE

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountInMax);

        // Check initial balances
        uint256 initialKolBalance = address(kolAddress).balance;
        uint256 initialUserTokenBalance = tokenA.balanceOf(user);
        uint256 initialUserNativeBalance = user.balance;

        // Execute the function
        uint256[] memory amountsIn = router.swapTokensForExactNATIVE{value: FEE_AMOUNT}(
            amountOutNATIVE,
            amountInMax,
            path,
            payable(user),
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertTrue(amountsIn[0] < amountInMax, "Should have used fewer tokens than the maximum");
        assertEq(tokenA.balanceOf(user), initialUserTokenBalance - amountsIn[0], "Tokens not transferred correctly");
        assertEq(user.balance, initialUserNativeBalance - FEE_AMOUNT + amountOutNATIVE, "NATIVE not received correctly");
    }

    // Test for swapExactTokensForTokens
    function testSwapExactTokensForTokens() public {
        // Prepare test data
        uint256 amountIn = 1000 * 1e18;
        uint256 amountOutMin = 500 * 1e18;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(tokenA), address(tokenB));

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountIn);

        // Check initial balances
        uint256 initialKolBalance = address(kolAddress).balance;
        uint256 initialUserTokenABalance = tokenA.balanceOf(user);

        // Execute the function
        uint256 amountOut = router.swapExactTokensForTokens{value: FEE_AMOUNT}(
            amountIn,
            amountOutMin,
            path,
            user,
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertEq(tokenA.balanceOf(user), initialUserTokenABalance - amountIn, "Tokens A not transferred correctly");
        assertTrue(amountOut > amountOutMin, "Output amount should be greater than the expected minimum");
    }

    // Test for swapTokensForExactTokens
    function testSwapTokensForExactTokens() public {
        // Prepare test data
        uint256 amountOut = 500 * 1e18;
        uint256 amountInMax = 1000 * 1e18;
        uint256 deadline = block.timestamp + 3600;
        ILBRouter.Path memory path = createPath(address(tokenA), address(tokenB));

        // Approve tokens for the router
        vm.startPrank(user);
        tokenA.approve(address(router), amountInMax);

        // Check initial balances
        uint256 initialKolBalance = address(kolAddress).balance;
        uint256 initialUserTokenABalance = tokenA.balanceOf(user);

        // Execute the function
        uint256[] memory amountsIn = router.swapTokensForExactTokens{value: FEE_AMOUNT}(
            amountOut,
            amountInMax,
            path,
            user,
            deadline
        );
        vm.stopPrank();

        // Verifications
        assertEq(address(kolAddress).balance, initialKolBalance + FEE_AMOUNT, "Fee not transferred correctly to KOL");
        assertTrue(amountsIn[0] < amountInMax, "Should have used fewer tokens than the maximum");
        assertEq(tokenA.balanceOf(user), initialUserTokenABalance - amountsIn[0], "Tokens A not transferred correctly");
    }
}