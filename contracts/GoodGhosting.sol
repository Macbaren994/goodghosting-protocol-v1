pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../aave/ILendingPoolAddressesProvider.sol";
import "../aave/ILendingPool.sol";

/**
 * Play the save game.
 *
 * No safe math was though to shortcut the hacking time.
 *
 */
contract GoodGhosting {

    address public thisContract;
    // Token that patients use to buy in the game - DAI
    IERC20 public daiToken;

    // Pointer to aDAI
    IERC20 public adaiToken;

    // Which Aave instance we use to swap DAI to interest bearing aDAI
    ILendingPoolAddressesProvider public lendingPoolAddressProvider;


    uint public mostRecentSegmentTimeStamp;
    uint public mostRecentSegmentPaid;
    uint public lastSegment;
    uint public moneyPot;
    uint public segmentPayment;
    event SendMessage(address reciever, string message);



    constructor(IERC20 _inboundCurrency, IERC20 _interestCurrency, ILendingPoolAddressesProvider _lendingPoolAddressProvider) public {
        daiToken = _inboundCurrency;
        adaiToken = _interestCurrency;
        lendingPoolAddressProvider = _lendingPoolAddressProvider;
        thisContract = address(this);
        mostRecentSegmentTimeStamp = block.timestamp;
        mostRecentSegmentPaid = 0;
        lastSegment = 16;
        moneyPot = 0;
        segmentPayment = 10;

        // Allow lending pool convert DAI deposited on this contract to aDAI on lending pool
        // uint MAX_ALLOWANCE = 2**256 - 1;
        // address core = lendingPoolAddressProvider.getLendingPoolCore();
        // daiToken.approve(core, MAX_ALLOWANCE);
    }

    function getDaiTokenAddress() public view returns (address ){
        return address(daiToken);
    }

    function getThisContractAddress() public view returns(address){
        return address(this);
    }


    function transferDaiToContract() internal {
        daiToken.transferFrom(msg.sender, thisContract, segmentPayment);
    }

    function checkSegment( uint timeSince) public {
        if (now >= (timeSince + 1 weeks)) {
          transferDaiToContract();
          emit SendMessage(msg.sender, "payment made");
          return;
        } else {
          emit SendMessage(msg.sender, "too early to pay");
          return;
        }
    }


    function makeDeposit() public {
        checkSegment(mostRecentSegmentTimeStamp);
    }

}
