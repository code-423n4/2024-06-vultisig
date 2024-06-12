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
