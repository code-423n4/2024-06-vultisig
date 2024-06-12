# PeripheryPaymentsWithFee
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/PeripheryPaymentsWithFee.sol)

**Inherits:**
[PeripheryPayments](/src/base/PeripheryPayments.sol/abstract.PeripheryPayments.md), [IPeripheryPaymentsWithFee](/src/interfaces/IPeripheryPaymentsWithFee.sol/interface.IPeripheryPaymentsWithFee.md)


## Functions
### unwrapWETH9WithFee

Unwraps the contract's WETH9 balance and sends it to recipient as ETH, with a percentage between
0 (exclusive), and 1 (inclusive) going to feeRecipient

*The amountMinimum parameter prevents malicious contracts from stealing WETH9 from users.*


```solidity
function unwrapWETH9WithFee(uint256 amountMinimum, address recipient, uint256 feeBips, address feeRecipient)
    public
    payable
    override;
```

### sweepTokenWithFee

Transfers the full amount of a token held by this contract to recipient, with a percentage between
0 (exclusive) and 1 (inclusive) going to feeRecipient

*The amountMinimum parameter prevents malicious contracts from stealing the token from users*


```solidity
function sweepTokenWithFee(
    address token,
    uint256 amountMinimum,
    address recipient,
    uint256 feeBips,
    address feeRecipient
) public payable override;
```

