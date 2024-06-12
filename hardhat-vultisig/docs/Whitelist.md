## Whitelist

The main functionalities are:

- Self whitelist by sending ETH to this contract(only when self whitelist is allowed - controlled by \_isSelfWhitelistDisabled flag)
- Ownable: Add whitelisted/blacklisted addresses
- Ownable: Set max USDC amount to buy(default 3 ETH)
- Ownable: Set univ3 TWAP oracle
- Vultisig contract `_beforeTokenTransfer` hook will call `checkWhitelist` function and this function will check if buyer is eligible

### NotWhitelisted

```solidity
error NotWhitelisted()
```

### AlreadyContributed

```solidity
error AlreadyContributed()
```

### Locked

```solidity
error Locked()
```

### NotVultisig

```solidity
error NotVultisig()
```

### SelfWhitelistDisabled

```solidity
error SelfWhitelistDisabled()
```

### Blacklisted

```solidity
error Blacklisted()
```

### MaxAddressCapOverflow

```solidity
error MaxAddressCapOverflow()
```

### constructor

```solidity
constructor() public
```

Set the default max address cap to 10k USDC and lock token transfers initially

### onlyVultisig

```solidity
modifier onlyVultisig()
```

Check if called from vultisig token contract.

### receive

```solidity
receive() external payable
```

Self-whitelist using ETH transfer

_reverts if whitelist is disabled
reverts if address is already blacklisted
ETH will be sent back to the sender_

### maxAddressCap

```solidity
function maxAddressCap() external view returns (uint256)
```

Returns max address cap

### vultisig

```solidity
function vultisig() external view returns (address)
```

Returns vultisig address

### whitelistIndex

```solidity
function whitelistIndex(address account) external view returns (uint256)
```

Returns the whitelisted index. If not whitelisted, then it will be 0

#### Parameters

| Name    | Type    | Description               |
| ------- | ------- | ------------------------- |
| account | address | The address to be checked |

### isBlacklisted

```solidity
function isBlacklisted(address account) external view returns (bool)
```

Returns if the account is blacklisted or not

#### Parameters

| Name    | Type    | Description               |
| ------- | ------- | ------------------------- |
| account | address | The address to be checked |

### isSelfWhitelistDisabled

```solidity
function isSelfWhitelistDisabled() external view returns (bool)
```

Returns if self-whitelist is allowed or not

### oracle

```solidity
function oracle() external view returns (address)
```

Returns Univ3 TWAP oracle address

### whitelistCount

```solidity
function whitelistCount() external view returns (uint256)
```

Returns current whitelisted address count

### allowedWhitelistIndex

```solidity
function allowedWhitelistIndex() external view returns (uint256)
```

Returns current allowed whitelist index

### contributed

```solidity
function contributed(address to) external view returns (uint256)
```

Returns contributed USDC amount for address

#### Parameters

| Name | Type    | Description               |
| ---- | ------- | ------------------------- |
| to   | address | The address to be checked |

### locked

```solidity
function locked() external view returns (bool)
```

If token transfer is locked or not

### setLocked

```solidity
function setLocked(bool newLocked) external
```

Setter for locked flag

#### Parameters

| Name      | Type | Description        |
| --------- | ---- | ------------------ |
| newLocked | bool | New flag to be set |

### setMaxAddressCap

```solidity
function setMaxAddressCap(uint256 newCap) external
```

Setter for max address cap

#### Parameters

| Name   | Type    | Description                 |
| ------ | ------- | --------------------------- |
| newCap | uint256 | New cap for max USDC amount |

### setVultisig

```solidity
function setVultisig(address newVultisig) external
```

Setter for vultisig token

#### Parameters

| Name        | Type    | Description                |
| ----------- | ------- | -------------------------- |
| newVultisig | address | New vultisig token address |

### setIsSelfWhitelistDisabled

```solidity
function setIsSelfWhitelistDisabled(bool newFlag) external
```

Setter for self-whitelist period

#### Parameters

| Name    | Type | Description                        |
| ------- | ---- | ---------------------------------- |
| newFlag | bool | New flag for self-whitelist period |

### setOracle

```solidity
function setOracle(address newOracle) external
```

Setter for Univ3 TWAP oracle

#### Parameters

| Name      | Type    | Description        |
| --------- | ------- | ------------------ |
| newOracle | address | New oracle address |

### setBlacklisted

```solidity
function setBlacklisted(address blacklisted, bool flag) external
```

Setter for blacklist

#### Parameters

| Name        | Type    | Description          |
| ----------- | ------- | -------------------- |
| blacklisted | address | Address to be added  |
| flag        | bool    | New flag for address |

### setAllowedWhitelistIndex

```solidity
function setAllowedWhitelistIndex(uint256 newIndex) external
```

Setter for allowed whitelist index

#### Parameters

| Name     | Type    | Description                     |
| -------- | ------- | ------------------------------- |
| newIndex | uint256 | New index for allowed whitelist |

### addWhitelistedAddress

```solidity
function addWhitelistedAddress(address whitelisted) external
```

Add whitelisted address

#### Parameters

| Name        | Type    | Description         |
| ----------- | ------- | ------------------- |
| whitelisted | address | Address to be added |

### addBatchWhitelist

```solidity
function addBatchWhitelist(address[] whitelisted) external
```

Add batch whitelists

#### Parameters

| Name        | Type      | Description                    |
| ----------- | --------- | ------------------------------ |
| whitelisted | address[] | Array of addresses to be added |

### checkWhitelist

```solidity
function checkWhitelist(address to, uint256 amount) external
```

Check if address to is eligible for whitelist

_Revert if locked, not whitelisted, blacklisted or already contributed
Update contributed amount_

#### Parameters

| Name   | Type    | Description                        |
| ------ | ------- | ---------------------------------- |
| to     | address | Recipient address                  |
| amount | uint256 | Number of tokens to be transferred |
