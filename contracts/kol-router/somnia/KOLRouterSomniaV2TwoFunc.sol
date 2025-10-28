// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ISomniaRouter.sol";
import "../interfaces/IKOLFactory.sol";

/**
 * @title KOLRouterSomniaV2TwoFunc
 * @notice 2-function minimal KOL router for Somnia - only essential swaps
 * @dev Only swapExactTokensForTokens and swapExactAVAXForTokens
 */
contract KOLRouterSomniaV2TwoFunc {
    address public kolAddress;
    IKOLFactory public factory;
    address public dexRouter;
    address public sherryFoundationAddress;
    address public sherryTreasuryAddress;

    bool private initialized;
    uint private locked;

    event SwapExecuted(address indexed kol, address indexed trader, address tokenIn, address indexed tokenOut, uint256 amountIn, uint256 kolFee, uint256 foundationFee, uint256 treasuryFee);

    modifier nonReentrant() {
        require(locked == 1, "Reentrant");
        locked = 2;
        _;
        locked = 1;
    }

    function initialize(address _kol, address _dex, address _factory, address _foundation, address _treasury) external {
        require(!initialized, "Already initialized");
        kolAddress = _kol;
        dexRouter = _dex;
        factory = IKOLFactory(_factory);
        sherryFoundationAddress = _foundation;
        sherryTreasuryAddress = _treasury;
        locked = 1;
        initialized = true;
    }

    function _deductFees(uint256 amt, address tok) internal returns (uint256, uint256, uint256, uint256) {
        uint16 bp = factory.getBasisPoints();
        uint256 kf = (amt * factory.getKOLFeeRate()) / bp;
        uint256 ff = (amt * factory.getFoundationFeeRate()) / bp;
        uint256 tf = (amt * factory.getTreasuryFeeRate()) / bp;

        if (tok == address(0)) {
            payable(sherryFoundationAddress).transfer(ff);
            payable(sherryTreasuryAddress).transfer(tf);
        } else {
            IERC20(tok).transfer(sherryFoundationAddress, ff);
            IERC20(tok).transfer(sherryTreasuryAddress, tf);
        }

        return (amt - kf - ff - tf, kf, ff, tf);
    }

    function swapExactTokensForTokens(uint amtIn, uint amtOutMin, address[] calldata path, address to, uint deadline) external nonReentrant returns (uint[] memory amounts) {
        IERC20(path[0]).transferFrom(msg.sender, address(this), amtIn);
        (uint256 net, uint256 kf, uint256 ff, uint256 tf) = _deductFees(amtIn, path[0]);
        IERC20(path[0]).approve(dexRouter, net);
        amounts = ISomniaRouter(dexRouter).swapExactTokensForTokens(net, amtOutMin, path, to, deadline);
        emit SwapExecuted(kolAddress, msg.sender, path[0], path[path.length - 1], net, kf, ff, tf);
    }

    function swapExactAVAXForTokens(uint amtOutMin, address[] calldata path, address to, uint deadline) external payable nonReentrant returns (uint[] memory amounts) {
        (uint256 net, uint256 kf, uint256 ff, uint256 tf) = _deductFees(msg.value, address(0));
        amounts = ISomniaRouter(dexRouter).swapExactAVAXForTokens{value: net}(amtOutMin, path, to, deadline);
        emit SwapExecuted(kolAddress, msg.sender, address(0), path[path.length - 1], net, kf, ff, tf);
    }

    function withdrawKOLFees(address[] calldata toks) external nonReentrant {
        require(msg.sender == kolAddress, "Only KOL");
        if (address(this).balance > 0) payable(kolAddress).transfer(address(this).balance);
        for (uint256 i = 0; i < toks.length; i++) {
            if (toks[i] != address(0)) {
                uint256 bal = IERC20(toks[i]).balanceOf(address(this));
                if (bal > 0) IERC20(toks[i]).transfer(kolAddress, bal);
            }
        }
    }

    receive() external payable {}
}
