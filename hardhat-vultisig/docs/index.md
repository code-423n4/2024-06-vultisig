# Solidity API

## Vultisig

### constructor

```solidity
constructor(address[] _defaultOperators) public
```

## Whitelist

The main functionalities are:

- Self whitelist by sending ETH to this contract(only when self whitelist is allowed - controlled by \_isSelfWhitelistDisabled flag)
- Ownable: Add whitelisted/blacklisted addresses
- Ownable: Set max USDC amount to buy(default 10k USDC)
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

## IOracle

### name

```solidity
function name() external view returns (string)
```

### peek

```solidity
function peek(uint256 baseAmount) external view returns (uint256 answer)
```

## IWhitelist

### checkWhitelist

```solidity
function checkWhitelist(address sender, uint256 amount) external
```

## UniswapV3Oracle

For VULT/USDC pool, it will return TWAP price for the last 30 mins and add 5% slippage

_This price will be used in whitelist contract to calculate the USDC tokenIn amount.
The actual amount could be different because, the ticks used at the time of purchase won't be the same as this TWAP_

### PERIOD

```solidity
uint32 PERIOD
```

TWAP period

### BASE_AMOUNT

```solidity
uint128 BASE_AMOUNT
```

Will calculate 1 VULT price in USDC

### pool

```solidity
address pool
```

VULT/USDC pair

### baseToken

```solidity
address baseToken
```

VULT token address

### USDC

```solidity
address USDC
```

USDC token address

### constructor

```solidity
constructor(address _pool, address _baseToken, address _USDC) public
```

### name

```solidity
function name() external view returns (string)
```

Returns VULT/USDC Univ3TWAP

### peek

```solidity
function peek(uint256 baseAmount) external view returns (uint256)
```

Returns TWAP price for 1 VULT for the last 30 mins

## FullMath

Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision

_Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits_

### mulDiv

```solidity
function mulDiv(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

_Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv_

#### Parameters

| Name        | Type    | Description      |
| ----------- | ------- | ---------------- |
| a           | uint256 | The multiplicand |
| b           | uint256 | The multiplier   |
| denominator | uint256 | The divisor      |

#### Return Values

| Name   | Type    | Description        |
| ------ | ------- | ------------------ |
| result | uint256 | The 256-bit result |

### mulDivRoundingUp

```solidity
function mulDivRoundingUp(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

#### Parameters

| Name        | Type    | Description      |
| ----------- | ------- | ---------------- |
| a           | uint256 | The multiplicand |
| b           | uint256 | The multiplier   |
| denominator | uint256 | The divisor      |

#### Return Values

| Name   | Type    | Description        |
| ------ | ------- | ------------------ |
| result | uint256 | The 256-bit result |

## OracleLibrary

Provides functions to integrate with V3 pool oracle

### consult

```solidity
function consult(address pool, uint32 period) internal view returns (int24 timeWeightedAverageTick)
```

Fetches time-weighted average tick using Uniswap V3 oracle

#### Parameters

| Name   | Type    | Description                                                              |
| ------ | ------- | ------------------------------------------------------------------------ |
| pool   | address | Address of Uniswap V3 pool that we want to observe                       |
| period | uint32  | Number of seconds in the past to start calculating time-weighted average |

#### Return Values

| Name                    | Type  | Description                                                                       |
| ----------------------- | ----- | --------------------------------------------------------------------------------- |
| timeWeightedAverageTick | int24 | The time-weighted average tick from (block.timestamp - period) to block.timestamp |

### getQuoteAtTick

```solidity
function getQuoteAtTick(int24 tick, uint128 baseAmount, address baseToken, address quoteToken) internal pure returns (uint256 quoteAmount)
```

Given a tick and a token amount, calculates the amount of token received in exchange

#### Parameters

| Name       | Type    | Description                                                             |
| ---------- | ------- | ----------------------------------------------------------------------- |
| tick       | int24   | Tick value used to calculate the quote                                  |
| baseAmount | uint128 | Amount of token to be converted                                         |
| baseToken  | address | Address of an ERC20 token contract used as the baseAmount denomination  |
| quoteToken | address | Address of an ERC20 token contract used as the quoteAmount denomination |

#### Return Values

| Name        | Type    | Description                                               |
| ----------- | ------- | --------------------------------------------------------- |
| quoteAmount | uint256 | Amount of quoteToken received for baseAmount of baseToken |

## TickMath

Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
prices between 2**-128 and 2**128

### MIN_TICK

```solidity
int24 MIN_TICK
```

_The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2\*\*-128_

### MAX_TICK

```solidity
int24 MAX_TICK
```

_The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2\*\*128_

### MIN_SQRT_RATIO

```solidity
uint160 MIN_SQRT_RATIO
```

_The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)_

### MAX_SQRT_RATIO

```solidity
uint160 MAX_SQRT_RATIO
```

_The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)_

### getSqrtRatioAtTick

```solidity
function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96)
```

Calculates sqrt(1.0001^tick) \* 2^96

_Throws if |tick| > max tick_

#### Parameters

| Name | Type  | Description                          |
| ---- | ----- | ------------------------------------ |
| tick | int24 | The input tick for the above formula |

#### Return Values

| Name         | Type    | Description                                                                                                        |
| ------------ | ------- | ------------------------------------------------------------------------------------------------------------------ |
| sqrtPriceX96 | uint160 | A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0) at the given tick |

### getTickAtSqrtRatio

```solidity
function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick)
```

Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio

_Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
ever return._

#### Parameters

| Name         | Type    | Description                                              |
| ------------ | ------- | -------------------------------------------------------- |
| sqrtPriceX96 | uint160 | The sqrt ratio for which to compute the tick as a Q64.96 |

#### Return Values

| Name | Type  | Description                                                                    |
| ---- | ----- | ------------------------------------------------------------------------------ |
| tick | int24 | The greatest tick for which the ratio is less than or equal to the input ratio |

## MockOracleFail

### name

```solidity
function name() external view returns (string)
```

### peek

```solidity
function peek(uint256 baseAmount) external view returns (uint256)
```

## MockOracleSuccess

### name

```solidity
function name() external view returns (string)
```

### peek

```solidity
function peek(uint256 baseAmount) external view returns (uint256)
```

## MockWhitelistFail

### checkWhitelist

```solidity
function checkWhitelist(address sender, uint256 amount) external
```

## MockWhitelistSuccess

### checkWhitelist

```solidity
function checkWhitelist(address sender, uint256 amount) external
```
