pragma solidity 0.6.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ERC20Mintable.sol";

contract MockCurvePool is MockERC20Mintable {
    IERC20 public reserve;

    constructor(
        string memory name,
        string memory symbol,
        IERC20 _reserve
    ) MockERC20Mintable(name, symbol) public {
        reserve = _reserve;
    }

    function add_liquidity(
        uint256[] memory _amounts,
        uint256 _min_mint_amount,
        bool _use_underlying
    ) external returns (uint256) {
        reserve.transferFrom(msg.sender, address(this), _amounts[0]);
        _mint(msg.sender, _amounts[0]);
        return _amounts[0];
    }

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 _min_amount,
        bool _use_underlying
    ) external returns (uint256) {
        _token_amount = IERC20(address(this)).balanceOf(msg.sender);
        _burn(msg.sender, _token_amount);
        IERC20(reserve).transfer(msg.sender, _token_amount);
    }

    function calc_withdraw_one_coin(uint256 _token_amount, int128 i) external view returns (uint256) {
        return IERC20(address(this)).balanceOf(msg.sender);
    }

    function lp_token() external view returns (address) {
        return address(this);
    }
}