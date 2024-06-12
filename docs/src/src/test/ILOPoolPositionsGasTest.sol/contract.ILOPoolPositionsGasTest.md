# ILOPoolPositionsGasTest
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/ILOPoolPositionsGasTest.sol)


## State Variables
### nonfungiblePositionManager

```solidity
IILOPool immutable nonfungiblePositionManager;
```


## Functions
### constructor


```solidity
constructor(IILOPool _nonfungiblePositionManager);
```

### getGasCostOfPositions


```solidity
function getGasCostOfPositions(uint256 tokenId) external view returns (uint256);
```

