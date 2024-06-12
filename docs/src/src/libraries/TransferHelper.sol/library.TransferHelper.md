# TransferHelper
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/0939257443ab7b868ff7f798a9104a43c7166792/src/libraries/TransferHelper.sol)


## Functions
### safeTransferFrom

Transfers tokens from the targeted address to the given destination

Errors with 'STF' if transfer fails


```solidity
function safeTransferFrom(address token, address from, address to, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The contract address of the token to be transferred|
|`from`|`address`|The originating address from which the tokens will be transferred|
|`to`|`address`|The destination address of the transfer|
|`value`|`uint256`|The amount to be transferred|


### safeTransfer

Transfers tokens from msg.sender to a recipient

*Errors with ST if transfer fails*


```solidity
function safeTransfer(address token, address to, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The contract address of the token which will be transferred|
|`to`|`address`|The recipient of the transfer|
|`value`|`uint256`|The value of the transfer|


### safeApprove

Approves the stipulated contract to spend the given allowance in the given token

*Errors with 'SA' if transfer fails*


```solidity
function safeApprove(address token, address to, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|The contract address of the token to be approved|
|`to`|`address`|The target of the approval|
|`value`|`uint256`|The amount of the given token the target will be allowed to spend|


### safeTransferETH

Transfers ETH to the recipient address

*Fails with `STE`*


```solidity
function safeTransferETH(address to, uint256 value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|The destination of the transfer|
|`value`|`uint256`|The value to be transferred|


