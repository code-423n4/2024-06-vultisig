# TestERC20PermitAllowed
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/1de4d92cce6f0722e8736db455733703c706f30f/src/test/TestERC20PermitAllowed.sol)

**Inherits:**
[TestERC20](/src/test/TestERC20.sol/contract.TestERC20.md), [IERC20PermitAllowed](/src/interfaces/external/IERC20PermitAllowed.sol/interface.IERC20PermitAllowed.md)


## Functions
### constructor


```solidity
constructor(uint256 amountToMint) TestERC20(amountToMint);
```

### permit


```solidity
function permit(
    address holder,
    address spender,
    uint256 nonce,
    uint256 expiry,
    bool allowed,
    uint8 v,
    bytes32 r,
    bytes32 s
) external override;
```

