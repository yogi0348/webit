//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
contract MyERC20Token {
  // Public variables of the token
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  string public tokenType;
  uint256 public tokenPrice;
  uint256 public exchangeRate;

  // This creates an array with all balances
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  event Transfer(address indexed from, address indexed to, uint256 value);

  // Initializes contract with initial supply tokens to the creator of the contract
  constructor(
    uint256 initialSupply,
    string memory tokenName,
    string memory tokenSymbol,
    string memory _tokenType,
    uint256 _tokenPrice,
    uint256 _exchangeRate
  )  {
    totalSupply = initialSupply * 10 ** 18;  // Update total supply with the decimal amount
    balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
    name = tokenName;                                   // Set the name for display purposes
    symbol = tokenSymbol;                               // Set the symbol for display purposes
    decimals = 18;                                     // Amount of decimals for display purposes
    tokenType = _tokenType;                              // Token type
    tokenPrice = _tokenPrice * 10 ** 18;                 // Token price in ETH
    exchangeRate = _exchangeRate * 10 ** 18;             // Exchange rate in ETH
  }

  // Send coins
  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balanceOf[msg.sender] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  // Allow another contract to spend some tokens in your behalf
  function approve(address _spender, uint256 _value) public
    returns (bool success) {
    allowance[msg.sender][_spender] = _value;
    return true;
  }

  // A contract attempts to get the coins
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(balanceOf[_from] >= _value);                 // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
    require(_value <= allowance[_from][msg.sender]);   // Check allowance
    balanceOf[_from] -= _value;                        // Subtract from the sender
    balanceOf[_to] += _value;                          // Add the same to the recipient
    allowance[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  // A contract attempts to get the coins
  function swap(address _from, address _to, uint256 _value, bytes32 _tokenType) public payable returns (bool success) {
    require(balanceOf[_from] >= _value);                 // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
    require(_value <= allowance[_from][msg.sender]);   // Check allowance

    if(_tokenType == "ETH") {
      balanceOf[_from] -= _value;                         // Subtract from the sender
      balanceOf[_to] += _value * exchangeRate;             // Add the same to the recipient
      allowance[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value * exchangeRate);
    } else if(_tokenType == "BNB") {
      balanceOf[_from] -= _value;                         // Subtract from the sender
      balanceOf[_to] += _value * tokenPrice;               // Add the same to the recipient
      allowance[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value * tokenPrice);
    } else if(_tokenType == "MATIC") {
      balanceOf[_from] -= _value;                         // Subtract from the sender
      balanceOf[_to] += _value * exchangeRate;             // Add the same to the recipient
      allowance[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value * exchangeRate);
    } else {
      return false;
    }
    return true;
  }


}
