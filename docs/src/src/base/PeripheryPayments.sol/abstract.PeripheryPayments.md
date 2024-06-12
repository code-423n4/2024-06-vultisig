# PeripheryPayments
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/base/PeripheryPayments.sol)

**Inherits:**
[IPeripheryPayments](/src/interfaces/IPeripheryPayments.sol/interface.IPeripheryPayments.md), [ILOPoolImmutableState](/src/base/ILOPoolImmutableState.sol/abstract.ILOPoolImmutableState.md)


## Functions
### receive


```solidity
receive() external payable;
```

### unwrapWETH9

Unwraps the contract's WETH9 balance and sends it to recipient as ETH.

*The amountMinimum parameter prevents malicious contracts from stealing WETH9 from users.*


```solidity
function unwrapWETH9(uint256 amountMinimum, address recipient) public payable override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amountMinimum`|`uint256`|The minimum amount of WETH9 to unwrap|
|`recipient`|`address`|The address receiving ETH|


### sweepToken

Transfers the full amount of a token held by this contract to recipient

*The amountMinimum parameter prevents malicious contracts from stealing the token from users*


```solidity
function sweepToken(address token, uint256 amountMinimum, address recipient) public payable override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The contract address of the token which will be transferred to `recipient`|
|`amountMinimum`|`uint256`|The minimum amount of token required for a transfer|
|`recipient`|`address`|The destination address of the token|


### refundETH

Refunds any ETH balance held by this contract to the `msg.sender`

*Useful for bundling with mint or increase liquidity that uses ether, or exact output swaps
that use ether for the input amount*


```solidity
function refundETH() external payable override;
```

### pay


```solidity
function pay(address token, address payer, address recipient, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The token to pay|
|`payer`|`address`|The entity that must pay|
|`recipient`|`address`|The entity that will receive payment|
|`value`|`uint256`|The amount to pay|


