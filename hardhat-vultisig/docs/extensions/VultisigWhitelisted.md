## VultisigWhitelisted

During whitelist period, `_beforeTokenTransfer` function will call `checkWhitelist` function of whitelist contract
If whitelist period is ended, owner will set whitelist contract address back to address(0) and tokens will be transferred freely

### constructor

```solidity
constructor(address[] _defaultOperators) public
```

### whitelistContract

```solidity
function whitelistContract() external view returns (address)
```

Returns current whitelist contract address

### setWhitelistContract

```solidity
function setWhitelistContract(address newWhitelistContract) external
```

Ownable function to set new whitelist contract address

### \_beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal
```

Before token transfer hook

_It will call `checkWhitelist` function and if it's succsessful, it will transfer tokens, unless revert_
