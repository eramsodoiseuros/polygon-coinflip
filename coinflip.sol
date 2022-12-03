pragma solidity ^0.5.0;

import "https://github.com/polygon-network/solidity/contracts/interfaces/IBridge.sol";
import "https://github.com/polygon-network/solidity/contracts/interfaces/IBridgeMapper.sol";
import "https://github.com/polygon-network/solidity/contracts/PolygonMapper.sol";

// the contract for the coin flip game
contract CoinFlip {
  // the address of the player
  address player;

  // the amount of POLY that the player has bet
  uint256 betAmount;

  // the result of the coin flip
  bool result;

  // the contract for the PolygonMapper
  PolygonMapper public polygonMapper;

  // an event to signal the outcome of the coin flip
  event CoinFlipResult(bool result);

  // constructor to initialize the contract
  constructor(PolygonMapper _polygonMapper) public {
    player = msg.sender;
    betAmount = 0;
    polygonMapper = _polygonMapper;
  }

  // method to place a bet on the coin flip
  function placeBet(uint256 amount) public payable {
    require(amount > 0, 'You must bet more than 0 POLY');
    require(amount <= msg.value, 'You must send the correct amount of POLY');
    require(player == msg.sender, 'Only the player can place a bet');
    betAmount = amount;
  }

  // method to flip the coin and determine the result
  function flip() public {
    require(player == msg.sender, 'Only the player can flip the coin');
    result = keccak256(abi.encodePacked(now, betAmount))[0] % 2 == 0;
    emit CoinFlipResult(result);
  }

