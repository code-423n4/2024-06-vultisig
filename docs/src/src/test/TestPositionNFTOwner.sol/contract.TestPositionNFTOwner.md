# TestPositionNFTOwner
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/TestPositionNFTOwner.sol)

**Inherits:**
[IERC1271](/src/interfaces/external/IERC1271.sol/interface.IERC1271.md)


## State Variables
### owner

```solidity
address public owner;
```


## Functions
### setOwner


```solidity
function setOwner(address _owner) external;
```

### isValidSignature


```solidity
function isValidSignature(bytes32 hash, bytes memory signature) external view override returns (bytes4 magicValue);
```

