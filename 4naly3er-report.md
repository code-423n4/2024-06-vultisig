# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Don't use `_msgSender()` if not supporting EIP-2771 | 5 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 11 |
| [GAS-3](#GAS-3) | Using bools for storage incurs overhead | 7 |
| [GAS-4](#GAS-4) | Cache array length outside of loop | 11 |
| [GAS-5](#GAS-5) | State variables should be cached in stack variables rather than re-reading them from storage | 6 |
| [GAS-6](#GAS-6) | For Operations that will not overflow, you could use unchecked | 126 |
| [GAS-7](#GAS-7) | Use Custom Errors instead of Revert Strings to save Gas | 32 |
| [GAS-8](#GAS-8) | Avoid contract existence checks by using low level calls | 2 |
| [GAS-9](#GAS-9) | Functions guaranteed to revert when called by normal users can be marked `payable` | 16 |
| [GAS-10](#GAS-10) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 16 |
| [GAS-11](#GAS-11) | Using `private` rather than `public` for constants, saves gas | 2 |
| [GAS-12](#GAS-12) | Splitting require() statements that use && saves gas | 1 |
| [GAS-13](#GAS-13) | Increments/decrements can be unchecked in for-loops | 12 |
| [GAS-14](#GAS-14) | Use != 0 instead of > 0 for unsigned integer comparison | 21 |
| [GAS-15](#GAS-15) | `internal` functions not called by the contract should be removed | 3 |
| [GAS-16](#GAS-16) | WETH address definition can be use directly | 3 |
### <a name="GAS-1"></a>[GAS-1] Don't use `_msgSender()` if not supporting EIP-2771
Use `msg.sender` if the code does not implement [EIP-2771 trusted forwarder](https://eips.ethereum.org/EIPS/eip-2771) support

*Instances (5)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

13:         _mint(_msgSender(), 100_000_000 * 1e18);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

55:         if (_msgSender() != _vultisig) {

69:         if (_isBlacklisted[_msgSender()]) {

72:         _addWhitelistedAddress(_msgSender());

73:         payable(_msgSender()).transfer(msg.value);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

### <a name="GAS-2"></a>[GAS-2] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (11)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

226:             _contributed[to] += estimatedETHAmount;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

310:             totalRefundAmount += IILOPool(initializedPools[i])

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

153:         totalRaised += raiseAmount;

171:         _position.raiseAmount += raiseAmount;

196:         _position.liquidity += liquidityDelta;

286:             amount0 += fees0;

287:             amount1 += fees1;

534:                 liquidityUnlocked += uint128(

538:                 liquidityUnlocked += uint128(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

36:             totalShares += vestingConfigs[i].shares;

57:             totalShares += schedule[i].shares;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

### <a name="GAS-3"></a>[GAS-3] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (7)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

27:     bool private _locked;

29:     bool private _isSelfWhitelistDisabled;

43:     mapping(address => bool) private _isBlacklisted;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOPool.sol

37:     bool private _launchSucceeded;

40:     bool private _refundTriggered;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOWhitelist.sol

9:     bool private _openToAll;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Initializable.sol

6:     bool private _initialized;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol)

### <a name="GAS-4"></a>[GAS-4] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (11)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

192:         for (uint i = 0; i < whitelisted.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

106:         for (uint256 index = 0; index < params.vestingConfigs.length; index++) {

399:         for (uint256 index = 1; index < _vestingConfigs.length; index++) {

414:             for (uint256 i = 0; i < projectConfig.schedule.length; i++) {

522:         for (uint256 index = 0; index < vestingSchedule.length; index++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

27:         for (uint256 i = 0; i < vestingConfigs.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/ILOWhitelist.sol

30:         for (uint256 i = 0; i < users.length; i++) {

39:         for (uint256 i = 0; i < users.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Multicall.sol

15:         for (uint256 i = 0; i < data.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="GAS-5"></a>[GAS-5] State variables should be cached in stack variables rather than re-reading them from storage
The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (6)*:
```solidity
File: src/ILOManager.sol

165:             pool = IUniswapV3Factory(UNIV3_FACTORY).createPool(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

371:                 amount0Min = totalRaised;

372:                 (amount1, liquidity) = _saleAmountNeeded(totalRaised);

374:                 (amount0, liquidity) = _saleAmountNeeded(totalRaised);

375:                 amount1 = totalRaised;

376:                 amount1Min = totalRaised;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="GAS-6"></a>[GAS-6] For Operations that will not overflow, you could use unchecked

*Instances (126)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

4: import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

5: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

6: import {IApproveAndCallReceiver} from "./interfaces/IApproveAndCallReceiver.sol";

13:         _mint(_msgSender(), 100_000_000 * 1e18);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

4: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

5: import {IOracle} from "./interfaces/IOracle.sol";

50:         _locked = true; // Initially, liquidity will be locked

192:         for (uint i = 0; i < whitelisted.length; i++) {

222:             if (_contributed[to] + estimatedETHAmount > _maxAddressCap) {

226:             _contributed[to] += estimatedETHAmount;

234:             _whitelistIndex[whitelisted] = ++_whitelistCount;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol

4: import {Vultisig} from "../Vultisig.sol";

5: import {IWhitelist} from "../interfaces/IWhitelist.sol";

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol

4: import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

5: import {OracleLibrary} from "./uniswapv0.8/OracleLibrary.sol";

6: import {IOracle} from "../../interfaces/IOracle.sol";

18:     uint128 public constant BASE_AMOUNT = 1e18; // VULT has 18 decimals

35:         return "VULT/WETH Univ3TWAP";

45:         return (quotedWETHAmount * baseAmount * 95) / 1e20; // 100 / 1e18

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

20:         uint256 prod0; // Least significant 256 bits of the product

21:         uint256 prod1; // Most significant 256 bits of the product

60:         uint256 twos = (~denominator + 1) & denominator;

76:         prod0 |= prod1 * twos;

83:         uint256 inv = (3 * denominator) ^ 2;

87:         inv *= 2 - denominator * inv; // inverse mod 2**8

88:         inv *= 2 - denominator * inv; // inverse mod 2**16

89:         inv *= 2 - denominator * inv; // inverse mod 2**32

90:         inv *= 2 - denominator * inv; // inverse mod 2**64

91:         inv *= 2 - denominator * inv; // inverse mod 2**128

92:         inv *= 2 - denominator * inv; // inverse mod 2**256

100:         result = prod0 * inv;

113:             result++;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

3: import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

4: import "./FullMath.sol";

5: import "./TickMath.sol";

22:         int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

24:         timeWeightedAverageTick = int24(tickCumulativesDelta / int56(uint56(period)));

27:         if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int56(uint56(period)) != 0)) timeWeightedAverageTick--;

46:             uint256 ratioX192 = uint256(sqrtRatioX96) * sqrtRatioX96;

66:             (observationIndex + 1) % observationCardinality

75:         secondsAgo = uint32(block.timestamp) - observationTimestamp;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

9:     int24 internal constant MIN_TICK = -887272;

11:     int24 internal constant MAX_TICK = -MIN_TICK;

24:         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));

28:         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;

29:         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

30:         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

31:         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;

32:         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

33:         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

34:         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

35:         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

36:         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

37:         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

38:         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

39:         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

40:         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

41:         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

42:         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;

43:         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

44:         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;

45:         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;

46:         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

48:         if (tick > 0) ratio = type(uint256).max / ratio;

53:         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));

109:         if (msb >= 128) r = ratio >> (msb - 127);

110:         else r = ratio << (127 - msb);

112:         int256 log_2 = (int256(msb) - 128) << 64;

198:         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

200:         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);

201:         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

19:     uint64 private DEFAULT_DEADLINE_OFFSET = 7 * 24 * 60 * 60; // 7 days

25:     mapping(address => Project) private _cachedProject; // map uniV3Pool => project (aka projectId => project)

26:     mapping(address => address[]) private _initializedILOPools; // map uniV3Pool => list of initialized ilo pools

60:         uint64 refundDeadline = params.launchTime + DEFAULT_DEADLINE_OFFSET;

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

310:             totalRefundAmount += IILOPool(initializedPools[i])

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

68:         return "KRYSTAL-ILO-V1";

106:         for (uint256 index = 0; index < params.vestingConfigs.length; index++) {

152:         require(saleInfo.hardCap - totalRaised >= raiseAmount, "HC");

153:         totalRaised += raiseAmount;

160:             _mint(recipient, (tokenId = _nextId++));

168:             raiseAmount <= saleInfo.maxCapPerUser - _position.raiseAmount,

171:         _position.raiseAmount += raiseAmount;

196:         _position.liquidity += liquidityDelta;

271:                 feeGrowthInside0LastX128 - position.feeGrowthInside0LastX128,

277:                 feeGrowthInside1LastX128 - position.feeGrowthInside1LastX128,

286:             amount0 += fees0;

287:             amount1 += fees1;

293:             position.liquidity = positionLiquidity - liquidity2Claim;

338:             amountCollected0 - amount0

343:             amountCollected1 - amount1

399:         for (uint256 index = 1; index < _vestingConfigs.length; index++) {

403:             _mint(projectConfig.recipient, (tokenId = _nextId++));

414:             for (uint256 i = 0; i < projectConfig.schedule.length; i++) {

522:         for (uint256 index = 0; index < vestingSchedule.length; index++) {

534:                 liquidityUnlocked += uint128(

538:                 liquidityUnlocked += uint128(

540:                         vest.shares * totalLiquidity,

541:                         block.timestamp - vest.start,

542:                         (vest.end - vest.start) * BPS

559:         amount0Left = amount0 - FullMath.mulDiv(amount0, feeBPS, BPS);

560:         amount1Left = amount1 - FullMath.mulDiv(amount1, feeBPS, BPS);

574:             _positionVests[tokenId].totalLiquidity -

582:         uint128 liquidityClaimed = _positionVests[tokenId].totalLiquidity -

587:                 ? liquidityUnlocked - liquidityClaimed

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

27:         for (uint256 i = 0; i < vestingConfigs.length; i++) {

34:             require(BPS - totalShares >= vestingConfigs[i].shares, "TS");

36:             totalShares += vestingConfigs[i].shares;

51:         for (uint256 i = 0; i < scheduleLength; i++) {

56:             require(BPS - totalShares >= schedule[i].shares, "VS");

57:             totalShares += schedule[i].shares;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/ILOWhitelist.sol

30:         for (uint256 i = 0; i < users.length; i++) {

39:         for (uint256 i = 0; i < users.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Multicall.sol

15:         for (uint256 i = 0; i < data.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

```solidity
File: src/base/PeripheryPayments.sol

29:             IWETH9(WETH9).deposit{value: value}(); // wrap only what is needed to pay

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

41:                     sqrtRatioBX96 - sqrtRatioAX96

64:                     sqrtRatioBX96 - sqrtRatioAX96

85:                 sqrtRatioBX96 - sqrtRatioAX96,

87:             ) / sqrtRatioAX96;

106:                 sqrtRatioBX96 - sqrtRatioAX96,

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

```solidity
File: src/libraries/SqrtPriceMathPartial.sol

30:         uint256 numerator2 = sqrtRatioBX96 - sqrtRatioAX96;

44:                 : FullMath.mulDiv(numerator1, numerator2, sqrtRatioBX96) /

68:                     sqrtRatioBX96 - sqrtRatioAX96,

73:                     sqrtRatioBX96 - sqrtRatioAX96,

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/SqrtPriceMathPartial.sol)

### <a name="GAS-7"></a>[GAS-7] Use Custom Errors instead of Revert Strings to save Gas
Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (32)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

15:         require(period != 0, "BP");

63:         require(observationCardinality > 0, "NI");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

25:         require(absTick <= uint256(uint24(MAX_TICK)), "T");

63:         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, "R");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

52:         require(_cachedProject[uniV3Pool].admin == msg.sender, "UA");

101:             require(_project.uniV3PoolAddress != address(0), "NI");

177:                 require(sqrtPriceX96Existing == sqrtPriceX96, "UV3P");

192:         require(_project.uniV3PoolAddress == address(0), "RE");

285:         require(initializedPools.length > 0, "NP");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

146:         require(_isWhitelisted(recipient), "UA");

152:         require(saleInfo.hardCap - totalRaised >= raiseAmount, "HC");

155:         require(totalSold() <= saleInfo.maxSaleAmount, "SA");

188:         require(liquidityDelta > 0, "ZA");

213:         require(_isApprovedOrOwner(msg.sender, tokenId), "UA");

228:         require(_launchSucceeded, "PNL");

348:         require(msg.sender == MANAGER, "UA");

354:         require(!_launchSucceeded, "PL");

356:         require(!_refundTriggered, "IRF");

358:         require(totalRaised >= saleInfo.softCap, "SC");

430:             require(!_launchSucceeded, "PL");

434:             require(block.timestamp >= _project.refundDeadline, "RFT");

595:         require(msg.sender == _project.admin, "UA");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

29:                 require(vestingConfigs[i].recipient == address(0), "VR");

31:                 require(vestingConfigs[i].recipient != address(0), "VR");

34:             require(BPS - totalShares >= vestingConfigs[i].shares, "TS");

39:         require(totalShares == BPS, "TS");

46:         require(schedule[0].start >= launchTime, "VT");

53:             require(schedule[i].start >= lastEnd, "VT");

56:             require(BPS - totalShares >= schedule[i].shares, "VS");

60:         require(totalShares == BPS, "VS");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/PeripheryPayments.sol

14:         require(msg.sender == WETH9, "Not WETH9");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

```solidity
File: src/libraries/TransferHelper.sol

69:         require(success, "STE");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="GAS-8"></a>[GAS-8] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (2)*:
```solidity
File: src/ILOPool.sol

466:         refundAmount = IERC20(SALE_TOKEN).balanceOf(address(this));

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/Multicall.sol

16:             (bool success, bytes memory result) = address(this).delegatecall(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="GAS-9"></a>[GAS-9] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (16)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

136:     function setLocked(bool newLocked) external onlyOwner {

142:     function setMaxAddressCap(uint256 newCap) external onlyOwner {

148:     function setVultisig(address newVultisig) external onlyOwner {

154:     function setIsSelfWhitelistDisabled(bool newFlag) external onlyOwner {

160:     function setOracle(address newOracle) external onlyOwner {

166:     function setPool(address newPool) external onlyOwner {

173:     function setBlacklisted(address blacklisted, bool flag) external onlyOwner {

179:     function setAllowedWhitelistIndex(uint256 newIndex) external onlyOwner {

185:     function addWhitelistedAddress(address whitelisted) external onlyOwner {

191:     function addBatchWhitelist(address[] calldata whitelisted) external onlyOwner {

204:     function checkWhitelist(address from, address to, uint256 amount) external onlyVultisig {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol

22:     function setWhitelistContract(address newWhitelistContract) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol)

```solidity
File: src/ILOManager.sol

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/base/ILOWhitelist.sol

12:     function setOpenToAll(bool openToAll) external override onlyProjectAdmin {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

### <a name="GAS-10"></a>[GAS-10] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (16)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

192:         for (uint i = 0; i < whitelisted.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

113:             result++;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

27:         if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int56(uint56(period)) != 0)) timeWeightedAverageTick--;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: src/ILOManager.sol

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

106:         for (uint256 index = 0; index < params.vestingConfigs.length; index++) {

160:             _mint(recipient, (tokenId = _nextId++));

399:         for (uint256 index = 1; index < _vestingConfigs.length; index++) {

403:             _mint(projectConfig.recipient, (tokenId = _nextId++));

414:             for (uint256 i = 0; i < projectConfig.schedule.length; i++) {

522:         for (uint256 index = 0; index < vestingSchedule.length; index++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

27:         for (uint256 i = 0; i < vestingConfigs.length; i++) {

51:         for (uint256 i = 0; i < scheduleLength; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/ILOWhitelist.sol

30:         for (uint256 i = 0; i < users.length; i++) {

39:         for (uint256 i = 0; i < users.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Multicall.sol

15:         for (uint256 i = 0; i < data.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="GAS-11"></a>[GAS-11] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (2)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol

16:     uint32 public constant PERIOD = 30 minutes;

18:     uint128 public constant BASE_AMOUNT = 1e18; // VULT has 18 decimals

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol)

### <a name="GAS-12"></a>[GAS-12] Splitting require() statements that use && saves gas

*Instances (1)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

63:         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, "R");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

### <a name="GAS-13"></a>[GAS-13] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (12)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

192:         for (uint i = 0; i < whitelisted.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

106:         for (uint256 index = 0; index < params.vestingConfigs.length; index++) {

399:         for (uint256 index = 1; index < _vestingConfigs.length; index++) {

414:             for (uint256 i = 0; i < projectConfig.schedule.length; i++) {

522:         for (uint256 index = 0; index < vestingSchedule.length; index++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

27:         for (uint256 i = 0; i < vestingConfigs.length; i++) {

51:         for (uint256 i = 0; i < scheduleLength; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/ILOWhitelist.sol

30:         for (uint256 i = 0; i < users.length; i++) {

39:         for (uint256 i = 0; i < users.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Multicall.sol

15:         for (uint256 i = 0; i < data.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="GAS-14"></a>[GAS-14] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (21)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

2: pragma solidity >=0.4.0;

30:             require(denominator > 0);

111:         if (mulmod(a, b, denominator) > 0) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

2: pragma solidity >=0.5.0;

63:         require(observationCardinality > 0, "NI");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

2: pragma solidity >=0.5.0;

48:         if (tick > 0) ratio = type(uint256).max / ratio;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

285:         require(initializedPools.length > 0, "NP");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

188:         require(liquidityDelta > 0, "ZA");

467:         if (refundAmount > 0) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/LiquidityManagement.sol

31:         if (amount0Owed > 0)

33:         if (amount1Owed > 0)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

```solidity
File: src/base/PeripheryPayments.sol

2: pragma solidity >=0.7.5;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

```solidity
File: src/libraries/ChainId.sol

2: pragma solidity >=0.7.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/ChainId.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

```solidity
File: src/libraries/PoolAddress.sol

2: pragma solidity >=0.5.0;

34:         require(key.token0 < key.token1);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

```solidity
File: src/libraries/PositionKey.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PositionKey.sol)

```solidity
File: src/libraries/SqrtPriceMathPartial.sol

2: pragma solidity >=0.5.0;

32:         require(sqrtRatioAX96 > 0);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/SqrtPriceMathPartial.sol)

```solidity
File: src/libraries/TransferHelper.sol

2: pragma solidity >=0.6.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="GAS-15"></a>[GAS-15] `internal` functions not called by the contract should be removed
If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (3)*:
```solidity
File: src/base/ILOVest.sol

21:     function _validateSharesAndVests(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/Initializable.sol

7:     function _disableInitialize() internal {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol)

```solidity
File: src/base/LiquidityManagement.sol

47:     function addLiquidity(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

### <a name="GAS-16"></a>[GAS-16] WETH address definition can be use directly
WETH is a wrap Ether contract with a specific address in the Ethereum network, giving the option to define it may cause false recognition, it is healthier to define it directly.

    Advantages of defining a specific contract directly:
    
    It saves gas,
    Prevents incorrect argument definition,
    Prevents execution on a different chain and re-signature issues,
    WETH Address : 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2

*Instances (3)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol

25:     address public immutable WETH;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol)

```solidity
File: src/ILOManager.sol

17:     address public override WETH9;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/base/ILOPoolImmutableState.sol

11:     address public override WETH9;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOPoolImmutableState.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe | 3 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 3 |
| [NC-3](#NC-3) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 3 |
| [NC-4](#NC-4) | `constant`s should be defined rather than using magic numbers | 45 |
| [NC-5](#NC-5) | Control structures do not follow the Solidity Style Guide | 37 |
| [NC-6](#NC-6) | Default Visibility for constants | 1 |
| [NC-7](#NC-7) | Consider disabling `renounceOwnership()` | 3 |
| [NC-8](#NC-8) | Events that mark critical parameter changes should contain both the old and the new value | 3 |
| [NC-9](#NC-9) | Function ordering does not follow the Solidity style guide | 2 |
| [NC-10](#NC-10) | Functions should not be longer than 50 lines | 49 |
| [NC-11](#NC-11) | Change uint to uint256 | 1 |
| [NC-12](#NC-12) | Lack of checks in setters | 9 |
| [NC-13](#NC-13) | Missing Event for critical parameters change | 4 |
| [NC-14](#NC-14) | NatSpec is completely non-existent on functions that should have them | 6 |
| [NC-15](#NC-15) | Incomplete NatSpec: `@param` is missing on actually documented functions | 3 |
| [NC-16](#NC-16) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 6 |
| [NC-17](#NC-17) | Consider using named mappings | 7 |
| [NC-18](#NC-18) | Adding a `return` statement when the function defines a named return variable, is redundant | 3 |
| [NC-19](#NC-19) | `require()` / `revert()` statements should have descriptive reason strings | 4 |
| [NC-20](#NC-20) | Take advantage of Custom Error's return value property | 8 |
| [NC-21](#NC-21) | Avoid the use of sensitive terms | 70 |
| [NC-22](#NC-22) | Strings should use double quotes rather than single quotes | 1 |
| [NC-23](#NC-23) | Contract does not follow the Solidity style guide's suggested layout ordering | 5 |
| [NC-24](#NC-24) | Some require descriptions are not clear | 30 |
| [NC-25](#NC-25) | Use Underscores for Number Literals (add an underscore every 3 digits) | 8 |
| [NC-26](#NC-26) | Internal and private variables and functions names should begin with an underscore | 6 |
| [NC-27](#NC-27) | Constants should be defined rather than using magic numbers | 29 |
| [NC-28](#NC-28) | Variables need not be initialized to zero | 12 |
### <a name="NC-1"></a>[NC-1] Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe
When using `abi.encodeWithSignature`, it is possible to include a typo for the correct function signature.
When using `abi.encodeWithSignature` or `abi.encodeWithSelector`, it is also possible to provide parameters that are not of the correct type for the function.

To avoid these pitfalls, it would be best to use [`abi.encodeCall`](https://solidity-by-example.org/abi-encode/) instead.

*Instances (3)*:
```solidity
File: src/libraries/TransferHelper.sol

20:             abi.encodeWithSelector(

40:             abi.encodeWithSelector(IERC20.transfer.selector, to, value)

55:             abi.encodeWithSelector(IERC20.approve.selector, to, value)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (3)*:
```solidity
File: src/ILOPool.sol

161:             _positionVests[tokenId].schedule = _vestingConfigs[0].schedule;

192:             FullMath.mulDiv(liquidityDelta, _vestingConfigs[0].shares, BPS)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

46:         require(schedule[0].start >= launchTime, "VT");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

### <a name="NC-3"></a>[NC-3] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`
Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a `bytes` data mixed in the concatenation)`)

*Instances (3)*:
```solidity
File: src/ILOManager.sol

109:                 abi.encodePacked(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/libraries/PoolAddress.sol

38:                     abi.encodePacked(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

```solidity
File: src/libraries/PositionKey.sol

11:         return keccak256(abi.encodePacked(owner, tickLower, tickUpper));

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PositionKey.sol)

### <a name="NC-4"></a>[NC-4] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (45)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

13:         _mint(_msgSender(), 100_000_000 * 1e18);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

49:         _maxAddressCap = 3 ether;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol

45:         return (quotedWETHAmount * baseAmount * 95) / 1e20; // 100 / 1e18

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

83:         uint256 inv = (3 * denominator) ^ 2;

87:         inv *= 2 - denominator * inv; // inverse mod 2**8

88:         inv *= 2 - denominator * inv; // inverse mod 2**16

89:         inv *= 2 - denominator * inv; // inverse mod 2**32

90:         inv *= 2 - denominator * inv; // inverse mod 2**64

91:         inv *= 2 - denominator * inv; // inverse mod 2**128

92:         inv *= 2 - denominator * inv; // inverse mod 2**256

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

48:                 ? FullMath.mulDiv(ratioX192, baseAmount, 1 << 192)

49:                 : FullMath.mulDiv(1 << 192, baseAmount, ratioX192);

51:             uint256 ratioX128 = FullMath.mulDiv(sqrtRatioX96, sqrtRatioX96, 1 << 64);

53:                 ? FullMath.mulDiv(ratioX128, baseAmount, 1 << 128)

54:                 : FullMath.mulDiv(1 << 128, baseAmount, ratioX128);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

28:         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;

29:         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

30:         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

31:         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;

32:         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

33:         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

34:         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

35:         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

36:         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

37:         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

38:         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

39:         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

40:         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

41:         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

42:         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;

43:         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

44:         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;

45:         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;

46:         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

53:         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));

64:         uint256 ratio = uint256(sqrtPriceX96) << 32;

109:         if (msb >= 128) r = ratio >> (msb - 127);

112:         int256 log_2 = (int256(msb) - 128) << 64;

198:         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

200:         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);

201:         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

19:     uint64 private DEFAULT_DEADLINE_OFFSET = 7 * 24 * 60 * 60; // 7 days

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/base/ILOVest.sol

26:         uint16 BPS = 10000;

47:         uint16 BPS = 10000;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/Multicall.sol

22:                 if (result.length < 68) revert();

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="NC-5"></a>[NC-5] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (37)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

20:         uint256 prod0; // Least significant 256 bits of the product

21:         uint256 prod1; // Most significant 256 bits of the product

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

27:         if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int56(uint56(period)) != 0)) timeWeightedAverageTick--;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

28:         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;

29:         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

30:         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

31:         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;

32:         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

33:         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

34:         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

35:         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

36:         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

37:         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

38:         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

39:         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

40:         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

41:         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

42:         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;

43:         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

44:         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;

45:         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;

46:         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

48:         if (tick > 0) ratio = type(uint256).max / ratio;

109:         if (msb >= 128) r = ratio >> (msb - 127);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

67:         uniV3PoolAddress = _initUniV3PoolIfNecessary(

155:     function _initUniV3PoolIfNecessary(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

483:         if (raiseAmount == 0) return (0, 0);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/LiquidityManagement.sol

31:         if (amount0Owed > 0)

33:         if (amount1Owed > 0)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

```solidity
File: src/base/Multicall.sol

22:                 if (result.length < 68) revert();

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

29:         if (sqrtRatioAX96 > sqrtRatioBX96)

57:         if (sqrtRatioAX96 > sqrtRatioBX96)

79:         if (sqrtRatioAX96 > sqrtRatioBX96)

100:         if (sqrtRatioAX96 > sqrtRatioBX96)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

```solidity
File: src/libraries/PoolAddress.sol

25:         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

```solidity
File: src/libraries/SqrtPriceMathPartial.sol

26:         if (sqrtRatioAX96 > sqrtRatioBX96)

61:         if (sqrtRatioAX96 > sqrtRatioBX96)

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/SqrtPriceMathPartial.sol)

### <a name="NC-6"></a>[NC-6] Default Visibility for constants
Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (1)*:
```solidity
File: src/base/ILOPoolImmutableState.sol

13:     uint16 constant BPS = 10000;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOPoolImmutableState.sol)

### <a name="NC-7"></a>[NC-7] Consider disabling `renounceOwnership()`
If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (3)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

11: contract Vultisig is ERC20, Ownable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

16: contract Whitelist is Ownable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

15: contract ILOManager is IILOManager, Ownable, Initializable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="NC-8"></a>[NC-8] Events that mark critical parameter changes should contain both the old and the new value
This should especially be done if the new value is not required to be different from the old value

*Instances (3)*:
```solidity
File: src/ILOManager.sol

226:     function setILOPoolImplementation(
             address iloPoolImplementation
         ) external override onlyOwner {
             emit PoolImplementationChanged(

245:     function setDefaultDeadlineOffset(
             uint64 defaultDeadlineOffset
         ) external override onlyOwner {
             emit DefaultDeadlineOffsetChanged(

256:     function setRefundDeadlineForProject(
             address uniV3Pool,
             uint64 refundDeadline
         ) external override onlyOwner {
             Project storage _project = _cachedProject[uniV3Pool];
             emit RefundDeadlineChanged(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="NC-9"></a>[NC-9] Function ordering does not follow the Solidity style guide
According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (2)*:
```solidity
File: src/ILOManager.sol

1: 
   Current order:
   external initialize
   external initProject
   external project
   external initILOPool
   internal _initUniV3PoolIfNecessary
   internal _cacheProject
   external setPlatformFee
   external setPerformanceFee
   external setFeeTaker
   external setILOPoolImplementation
   external transferAdminProject
   external setDefaultDeadlineOffset
   external setRefundDeadlineForProject
   external launch
   external claimRefund
   
   Suggested order:
   external initialize
   external initProject
   external project
   external initILOPool
   external setPlatformFee
   external setPerformanceFee
   external setFeeTaker
   external setILOPoolImplementation
   external transferAdminProject
   external setDefaultDeadlineOffset
   external setRefundDeadlineForProject
   external launch
   external claimRefund
   internal _initUniV3PoolIfNecessary
   internal _cacheProject

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

1: 
   Current order:
   public name
   public symbol
   external initialize
   external positions
   external buy
   external claim
   external launch
   external claimRefund
   external claimProjectRefund
   internal _refundProject
   public totalSold
   internal _saleAmountNeeded
   internal _unlockedLiquidity
   internal _deductFees
   external vestingStatus
   internal _claimableLiquidity
   
   Suggested order:
   external initialize
   external positions
   external buy
   external claim
   external launch
   external claimRefund
   external claimProjectRefund
   external vestingStatus
   public name
   public symbol
   public totalSold
   internal _refundProject
   internal _saleAmountNeeded
   internal _unlockedLiquidity
   internal _deductFees
   internal _claimableLiquidity

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="NC-10"></a>[NC-10] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (49)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

16:     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

77:     function maxAddressCap() external view returns (uint256) {

82:     function vultisig() external view returns (address) {

88:     function whitelistIndex(address account) external view returns (uint256) {

94:     function isBlacklisted(address account) external view returns (bool) {

99:     function isSelfWhitelistDisabled() external view returns (bool) {

104:     function oracle() external view returns (address) {

114:     function whitelistCount() external view returns (uint256) {

119:     function allowedWhitelistIndex() external view returns (uint256) {

125:     function contributed(address to) external view returns (uint256) {

136:     function setLocked(bool newLocked) external onlyOwner {

142:     function setMaxAddressCap(uint256 newCap) external onlyOwner {

148:     function setVultisig(address newVultisig) external onlyOwner {

154:     function setIsSelfWhitelistDisabled(bool newFlag) external onlyOwner {

160:     function setOracle(address newOracle) external onlyOwner {

166:     function setPool(address newPool) external onlyOwner {

173:     function setBlacklisted(address blacklisted, bool flag) external onlyOwner {

179:     function setAllowedWhitelistIndex(uint256 newIndex) external onlyOwner {

185:     function addWhitelistedAddress(address whitelisted) external onlyOwner {

191:     function addBatchWhitelist(address[] calldata whitelisted) external onlyOwner {

204:     function checkWhitelist(address from, address to, uint256 amount) external onlyVultisig {

232:     function _addWhitelistedAddress(address whitelisted) private {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol

17:     function whitelistContract() external view returns (address) {

22:     function setWhitelistContract(address newWhitelistContract) external onlyOwner {

28:     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol

34:     function name() external pure returns (string memory) {

39:     function peek(uint256 baseAmount) external view returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

14:     function mulDiv(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result) {

109:     function mulDivRoundingUp(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

14:     function consult(address pool, uint32 period) internal view returns (int24 timeWeightedAverageTick) {

61:     function getOldestObservationSecondsAgo(address pool) internal view returns (uint32 secondsAgo) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

23:     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {

61:     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {

270:     function launch(address uniV3PoolAddress) external override {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

474:     function totalSold() public view override returns (uint256 _totalSold) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOWhitelist.sol

12:     function setOpenToAll(bool openToAll) external override onlyProjectAdmin {

17:     function isOpenToAll() external view override returns (bool) {

22:     function isWhitelisted(address user) external view override returns (bool) {

51:     function _removeWhitelist(address user) internal {

61:     function _isWhitelisted(address user) internal view returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/libraries/ChainId.sol

8:     function get() internal pure returns (uint256 chainId) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/ChainId.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

14:     function toUint128(uint256 x) private pure returns (uint128 y) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

```solidity
File: src/libraries/PoolAddress.sol

33:     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

```solidity
File: src/libraries/TransferHelper.sol

38:     function safeTransfer(address token, address to, uint256 value) internal {

53:     function safeApprove(address token, address to, uint256 value) internal {

67:     function safeTransferETH(address to, uint256 value) internal {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="NC-11"></a>[NC-11] Change uint to uint256
Throughout the code base, some variables are declared as `uint`. To favor explicitness, consider changing all instances of `uint` to `uint256`

*Instances (1)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

192:         for (uint i = 0; i < whitelisted.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

### <a name="NC-12"></a>[NC-12] Lack of checks in setters
Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (9)*:
```solidity
File: src/ILOManager.sol

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {
             PLATFORM_FEE = _platformFee;

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {
             PERFORMANCE_FEE = _performanceFee;

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {
             FEE_TAKER = _feeTaker;

226:     function setILOPoolImplementation(
             address iloPoolImplementation
         ) external override onlyOwner {
             emit PoolImplementationChanged(
                 ILO_POOL_IMPLEMENTATION,
                 iloPoolImplementation
             );
             ILO_POOL_IMPLEMENTATION = iloPoolImplementation;

245:     function setDefaultDeadlineOffset(
             uint64 defaultDeadlineOffset
         ) external override onlyOwner {
             emit DefaultDeadlineOffsetChanged(
                 owner(),
                 DEFAULT_DEADLINE_OFFSET,
                 defaultDeadlineOffset
             );
             DEFAULT_DEADLINE_OFFSET = defaultDeadlineOffset;

256:     function setRefundDeadlineForProject(
             address uniV3Pool,
             uint64 refundDeadline
         ) external override onlyOwner {
             Project storage _project = _cachedProject[uniV3Pool];
             emit RefundDeadlineChanged(
                 uniV3Pool,
                 _project.refundDeadline,
                 refundDeadline
             );
             _project.refundDeadline = refundDeadline;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/base/ILOWhitelist.sol

12:     function setOpenToAll(bool openToAll) external override onlyProjectAdmin {
            _setOpenToAll(openToAll);

46:     function _setOpenToAll(bool openToAll) internal {
            _openToAll = openToAll;
            emit SetOpenToAll(openToAll);

56:     function _setWhitelist(address user) internal {
            EnumerableSet.add(_whitelisted, user);
            emit SetWhitelist(user, true);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

### <a name="NC-13"></a>[NC-13] Missing Event for critical parameters change
Events help non-contract tools to track changes, and events prevent users from being surprised by changes.

*Instances (4)*:
```solidity
File: src/ILOManager.sol

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {
             PLATFORM_FEE = _platformFee;

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {
             PERFORMANCE_FEE = _performanceFee;

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {
             FEE_TAKER = _feeTaker;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/base/ILOWhitelist.sol

12:     function setOpenToAll(bool openToAll) external override onlyProjectAdmin {
            _setOpenToAll(openToAll);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

### <a name="NC-14"></a>[NC-14] NatSpec is completely non-existent on functions that should have them
Public and external functions that aren't view or pure should have NatSpec comments

*Instances (6)*:
```solidity
File: src/ILOManager.sol

33:     function initialize(

226:     function setILOPoolImplementation(

236:     function transferAdminProject(

245:     function setDefaultDeadlineOffset(

256:     function setRefundDeadlineForProject(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

71:     function initialize(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="NC-15"></a>[NC-15] Incomplete NatSpec: `@param` is missing on actually documented functions
The following functions are missing `@param` NatSpec comments.

*Instances (3)*:
```solidity
File: src/ILOManager.sol

211:     /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
         function setPlatformFee(uint16 _platformFee) external onlyOwner {

216:     /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
         function setPerformanceFee(uint16 _performanceFee) external onlyOwner {

221:     /// @notice set platform fee for decrease liquidity. Platform fee is imutable among all project's pools
         function setFeeTaker(address _feeTaker) external override onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="NC-16"></a>[NC-16] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (6)*:
```solidity
File: src/ILOManager.sol

52:         require(_cachedProject[uniV3Pool].admin == msg.sender, "UA");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

213:         require(_isApprovedOrOwner(msg.sender, tokenId), "UA");

348:         require(msg.sender == MANAGER, "UA");

595:         require(msg.sender == _project.admin, "UA");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/LiquidityManagement.sol

29:         require(msg.sender == _cachedUniV3PoolAddress);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

```solidity
File: src/base/PeripheryPayments.sol

14:         require(msg.sender == WETH9, "Not WETH9");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

### <a name="NC-17"></a>[NC-17] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (7)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

41:     mapping(address => uint256) private _whitelistIndex;

43:     mapping(address => bool) private _isBlacklisted;

45:     mapping(address => uint256) private _contributed;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

25:     mapping(address => Project) private _cachedProject; // map uniV3Pool => project (aka projectId => project)

26:     mapping(address => address[]) private _initializedILOPools; // map uniV3Pool => list of initialized ilo pools

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

43:     mapping(uint256 => Position) private _positions;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

8:     mapping(uint256 => PositionVest) _positionVests;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

### <a name="NC-18"></a>[NC-18] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (3)*:
```solidity
File: src/ILOPool.sol

119:     /// @inheritdoc IILOPool
         function positions(
             uint256 tokenId
         )
             external
             view
             override
             returns (
                 uint128 liquidity,
                 uint256 raiseAmount,
                 uint256 feeGrowthInside0LastX128,
                 uint256 feeGrowthInside1LastX128
             )
         {
             return (

456:     /// @inheritdoc IILOPool
         function claimProjectRefund(
             address projectAdmin
         ) external override refundable OnlyManager returns (uint256 refundAmount) {
             return _refundProject(projectAdmin);

478:     /// @notice return sale token amount needed for the raiseAmount.
         /// @dev sale token amount is rounded up
         function _saleAmountNeeded(
             uint256 raiseAmount
         ) internal view returns (uint256 saleAmountNeeded, uint128 liquidity) {
             if (raiseAmount == 0) return (0, 0);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="NC-19"></a>[NC-19] `require()` / `revert()` statements should have descriptive reason strings

*Instances (4)*:
```solidity
File: src/ILOPool.sol

240:             require(positionLiquidity >= liquidity2Claim);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/Initializable.sol

11:         require(!_initialized);

16:         require(_initialized);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol)

```solidity
File: src/base/LiquidityManagement.sol

29:         require(msg.sender == _cachedUniV3PoolAddress);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

### <a name="NC-20"></a>[NC-20] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (8)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

56:             revert NotVultisig();

67:             revert SelfWhitelistDisabled();

70:             revert Blacklisted();

209:                 revert Locked();

213:                 revert Blacklisted();

217:                 revert NotWhitelisted();

223:                 revert MaxAddressCapOverflow();

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/base/Multicall.sol

22:                 if (result.length < 68) revert();

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)

### <a name="NC-21"></a>[NC-21] Avoid the use of sensitive terms
Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (70)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

16: contract Whitelist is Ownable {

17:     error NotWhitelisted();

20:     error SelfWhitelistDisabled();

21:     error Blacklisted();

29:     bool private _isSelfWhitelistDisabled;

37:     uint256 private _whitelistCount;

39:     uint256 private _allowedWhitelistIndex;

41:     mapping(address => uint256) private _whitelistIndex;

43:     mapping(address => bool) private _isBlacklisted;

66:         if (_isSelfWhitelistDisabled) {

67:             revert SelfWhitelistDisabled();

69:         if (_isBlacklisted[_msgSender()]) {

70:             revert Blacklisted();

72:         _addWhitelistedAddress(_msgSender());

88:     function whitelistIndex(address account) external view returns (uint256) {

89:         return _whitelistIndex[account];

94:     function isBlacklisted(address account) external view returns (bool) {

95:         return _isBlacklisted[account];

99:     function isSelfWhitelistDisabled() external view returns (bool) {

100:         return _isSelfWhitelistDisabled;

114:     function whitelistCount() external view returns (uint256) {

115:         return _whitelistCount;

119:     function allowedWhitelistIndex() external view returns (uint256) {

120:         return _allowedWhitelistIndex;

154:     function setIsSelfWhitelistDisabled(bool newFlag) external onlyOwner {

155:         _isSelfWhitelistDisabled = newFlag;

173:     function setBlacklisted(address blacklisted, bool flag) external onlyOwner {

174:         _isBlacklisted[blacklisted] = flag;

179:     function setAllowedWhitelistIndex(uint256 newIndex) external onlyOwner {

180:         _allowedWhitelistIndex = newIndex;

185:     function addWhitelistedAddress(address whitelisted) external onlyOwner {

186:         _addWhitelistedAddress(whitelisted);

191:     function addBatchWhitelist(address[] calldata whitelisted) external onlyOwner {

192:         for (uint i = 0; i < whitelisted.length; i++) {

193:             _addWhitelistedAddress(whitelisted[i]);

204:     function checkWhitelist(address from, address to, uint256 amount) external onlyVultisig {

212:             if (_isBlacklisted[to]) {

213:                 revert Blacklisted();

216:             if (_allowedWhitelistIndex == 0 || _whitelistIndex[to] > _allowedWhitelistIndex) {

217:                 revert NotWhitelisted();

232:     function _addWhitelistedAddress(address whitelisted) private {

233:         if (_whitelistIndex[whitelisted] == 0) {

234:             _whitelistIndex[whitelisted] = ++_whitelistCount;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol

5: import {IWhitelist} from "../interfaces/IWhitelist.sol";

12: contract VultisigWhitelisted is Vultisig {

14:     address private _whitelistContract;

17:     function whitelistContract() external view returns (address) {

18:         return _whitelistContract;

22:     function setWhitelistContract(address newWhitelistContract) external onlyOwner {

23:         _whitelistContract = newWhitelistContract;

29:         if (_whitelistContract != address(0)) {

30:             IWhitelist(_whitelistContract).checkWhitelist(from, to, amount);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol)

```solidity
File: src/ILOPool.sol

27:     ILOWhitelist,

146:         require(_isWhitelisted(recipient), "UA");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOWhitelist.sol

8: abstract contract ILOWhitelist is IILOWhitelist {

22:     function isWhitelisted(address user) external view override returns (bool) {

23:         return _isWhitelisted(user);

27:     function batchWhitelist(

31:             _setWhitelist(users[i]);

36:     function batchRemoveWhitelist(

40:             _removeWhitelist(users[i]);

44:     EnumerableSet.AddressSet private _whitelisted;

51:     function _removeWhitelist(address user) internal {

52:         EnumerableSet.remove(_whitelisted, user);

53:         emit SetWhitelist(user, false);

56:     function _setWhitelist(address user) internal {

57:         EnumerableSet.add(_whitelisted, user);

58:         emit SetWhitelist(user, true);

61:     function _isWhitelisted(address user) internal view returns (bool) {

62:         return _openToAll || EnumerableSet.contains(_whitelisted, user);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

### <a name="NC-22"></a>[NC-22] Strings should use double quotes rather than single quotes
See the Solidity Style Guide: https://docs.soliditylang.org/en/v0.8.20/style-guide.html#other-recommendations

*Instances (1)*:
```solidity
File: src/libraries/PoolAddress.sol

39:                         hex'ff',

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

### <a name="NC-23"></a>[NC-23] Contract does not follow the Solidity style guide's suggested layout ordering
The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (5)*:
```solidity
File: src/ILOManager.sol

1: 
   Current order:
   VariableDeclaration.UNIV3_FACTORY
   VariableDeclaration.WETH9
   VariableDeclaration.DEFAULT_DEADLINE_OFFSET
   VariableDeclaration.PLATFORM_FEE
   VariableDeclaration.PERFORMANCE_FEE
   VariableDeclaration.FEE_TAKER
   VariableDeclaration.ILO_POOL_IMPLEMENTATION
   VariableDeclaration._cachedProject
   VariableDeclaration._initializedILOPools
   FunctionDefinition.constructor
   FunctionDefinition.initialize
   ModifierDefinition.onlyProjectAdmin
   FunctionDefinition.initProject
   FunctionDefinition.project
   FunctionDefinition.initILOPool
   FunctionDefinition._initUniV3PoolIfNecessary
   FunctionDefinition._cacheProject
   FunctionDefinition.setPlatformFee
   FunctionDefinition.setPerformanceFee
   FunctionDefinition.setFeeTaker
   FunctionDefinition.setILOPoolImplementation
   FunctionDefinition.transferAdminProject
   FunctionDefinition.setDefaultDeadlineOffset
   FunctionDefinition.setRefundDeadlineForProject
   FunctionDefinition.launch
   FunctionDefinition.claimRefund
   
   Suggested order:
   VariableDeclaration.UNIV3_FACTORY
   VariableDeclaration.WETH9
   VariableDeclaration.DEFAULT_DEADLINE_OFFSET
   VariableDeclaration.PLATFORM_FEE
   VariableDeclaration.PERFORMANCE_FEE
   VariableDeclaration.FEE_TAKER
   VariableDeclaration.ILO_POOL_IMPLEMENTATION
   VariableDeclaration._cachedProject
   VariableDeclaration._initializedILOPools
   ModifierDefinition.onlyProjectAdmin
   FunctionDefinition.constructor
   FunctionDefinition.initialize
   FunctionDefinition.initProject
   FunctionDefinition.project
   FunctionDefinition.initILOPool
   FunctionDefinition._initUniV3PoolIfNecessary
   FunctionDefinition._cacheProject
   FunctionDefinition.setPlatformFee
   FunctionDefinition.setPerformanceFee
   FunctionDefinition.setFeeTaker
   FunctionDefinition.setILOPoolImplementation
   FunctionDefinition.transferAdminProject
   FunctionDefinition.setDefaultDeadlineOffset
   FunctionDefinition.setRefundDeadlineForProject
   FunctionDefinition.launch
   FunctionDefinition.claimRefund

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

1: 
   Current order:
   VariableDeclaration.saleInfo
   VariableDeclaration._launchSucceeded
   VariableDeclaration._refundTriggered
   VariableDeclaration._positions
   VariableDeclaration._vestingConfigs
   VariableDeclaration._nextId
   VariableDeclaration.totalRaised
   FunctionDefinition.constructor
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.initialize
   FunctionDefinition.positions
   FunctionDefinition.buy
   ModifierDefinition.isAuthorizedForToken
   FunctionDefinition.claim
   ModifierDefinition.OnlyManager
   FunctionDefinition.launch
   ModifierDefinition.refundable
   FunctionDefinition.claimRefund
   FunctionDefinition.claimProjectRefund
   FunctionDefinition._refundProject
   FunctionDefinition.totalSold
   FunctionDefinition._saleAmountNeeded
   FunctionDefinition._unlockedLiquidity
   FunctionDefinition._deductFees
   FunctionDefinition.vestingStatus
   FunctionDefinition._claimableLiquidity
   ModifierDefinition.onlyProjectAdmin
   
   Suggested order:
   VariableDeclaration.saleInfo
   VariableDeclaration._launchSucceeded
   VariableDeclaration._refundTriggered
   VariableDeclaration._positions
   VariableDeclaration._vestingConfigs
   VariableDeclaration._nextId
   VariableDeclaration.totalRaised
   ModifierDefinition.isAuthorizedForToken
   ModifierDefinition.OnlyManager
   ModifierDefinition.refundable
   ModifierDefinition.onlyProjectAdmin
   FunctionDefinition.constructor
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.initialize
   FunctionDefinition.positions
   FunctionDefinition.buy
   FunctionDefinition.claim
   FunctionDefinition.launch
   FunctionDefinition.claimRefund
   FunctionDefinition.claimProjectRefund
   FunctionDefinition._refundProject
   FunctionDefinition.totalSold
   FunctionDefinition._saleAmountNeeded
   FunctionDefinition._unlockedLiquidity
   FunctionDefinition._deductFees
   FunctionDefinition.vestingStatus
   FunctionDefinition._claimableLiquidity

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOWhitelist.sol

1: 
   Current order:
   VariableDeclaration._openToAll
   FunctionDefinition.setOpenToAll
   FunctionDefinition.isOpenToAll
   FunctionDefinition.isWhitelisted
   FunctionDefinition.batchWhitelist
   FunctionDefinition.batchRemoveWhitelist
   VariableDeclaration._whitelisted
   FunctionDefinition._setOpenToAll
   FunctionDefinition._removeWhitelist
   FunctionDefinition._setWhitelist
   FunctionDefinition._isWhitelisted
   
   Suggested order:
   VariableDeclaration._openToAll
   VariableDeclaration._whitelisted
   FunctionDefinition.setOpenToAll
   FunctionDefinition.isOpenToAll
   FunctionDefinition.isWhitelisted
   FunctionDefinition.batchWhitelist
   FunctionDefinition.batchRemoveWhitelist
   FunctionDefinition._setOpenToAll
   FunctionDefinition._removeWhitelist
   FunctionDefinition._setWhitelist
   FunctionDefinition._isWhitelisted

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Initializable.sol

1: 
   Current order:
   VariableDeclaration._initialized
   FunctionDefinition._disableInitialize
   ModifierDefinition.whenNotInitialized
   ModifierDefinition.afterInitialize
   
   Suggested order:
   VariableDeclaration._initialized
   ModifierDefinition.whenNotInitialized
   ModifierDefinition.afterInitialize
   FunctionDefinition._disableInitialize

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol)

```solidity
File: src/base/LiquidityManagement.sol

1: 
   Current order:
   FunctionDefinition.uniswapV3MintCallback
   StructDefinition.AddLiquidityParams
   FunctionDefinition.addLiquidity
   
   Suggested order:
   StructDefinition.AddLiquidityParams
   FunctionDefinition.uniswapV3MintCallback
   FunctionDefinition.addLiquidity

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

### <a name="NC-24"></a>[NC-24] Some require descriptions are not clear
1. It does not comply with the general require error description model of the project (Either all of them should be debugged in this way, or all of them should be explained with a string not exceeding 32 bytes.)
2. For debug dapps like Tenderly, these debug messages are important, this allows the user to see the reasons for revert practically.

*Instances (30)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

15:         require(period != 0, "BP");

63:         require(observationCardinality > 0, "NI");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

25:         require(absTick <= uint256(uint24(MAX_TICK)), "T");

63:         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, "R");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

52:         require(_cachedProject[uniV3Pool].admin == msg.sender, "UA");

101:             require(_project.uniV3PoolAddress != address(0), "NI");

192:         require(_project.uniV3PoolAddress == address(0), "RE");

285:         require(initializedPools.length > 0, "NP");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

146:         require(_isWhitelisted(recipient), "UA");

152:         require(saleInfo.hardCap - totalRaised >= raiseAmount, "HC");

155:         require(totalSold() <= saleInfo.maxSaleAmount, "SA");

188:         require(liquidityDelta > 0, "ZA");

213:         require(_isApprovedOrOwner(msg.sender, tokenId), "UA");

228:         require(_launchSucceeded, "PNL");

348:         require(msg.sender == MANAGER, "UA");

354:         require(!_launchSucceeded, "PL");

356:         require(!_refundTriggered, "IRF");

358:         require(totalRaised >= saleInfo.softCap, "SC");

430:             require(!_launchSucceeded, "PL");

434:             require(block.timestamp >= _project.refundDeadline, "RFT");

595:         require(msg.sender == _project.admin, "UA");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

29:                 require(vestingConfigs[i].recipient == address(0), "VR");

31:                 require(vestingConfigs[i].recipient != address(0), "VR");

34:             require(BPS - totalShares >= vestingConfigs[i].shares, "TS");

39:         require(totalShares == BPS, "TS");

46:         require(schedule[0].start >= launchTime, "VT");

53:             require(schedule[i].start >= lastEnd, "VT");

56:             require(BPS - totalShares >= schedule[i].shares, "VS");

60:         require(totalShares == BPS, "VS");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/libraries/TransferHelper.sol

69:         require(success, "STE");

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="NC-25"></a>[NC-25] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (8)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

14:     uint160 internal constant MIN_SQRT_RATIO = 4295128739;

16:     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

198:         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

200:         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);

201:         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/base/ILOPoolImmutableState.sol

13:     uint16 constant BPS = 10000;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOPoolImmutableState.sol)

```solidity
File: src/base/ILOVest.sol

26:         uint16 BPS = 10000;

47:         uint16 BPS = 10000;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

### <a name="NC-26"></a>[NC-26] Internal and private variables and functions names should begin with an underscore
According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (6)*:
```solidity
File: src/ILOManager.sol

19:     uint64 private DEFAULT_DEADLINE_OFFSET = 7 * 24 * 60 * 60; // 7 days

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

34:     SaleInfo saleInfo;

48:     uint256 totalRaised;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOPoolImmutableState.sol

20:     uint160 internal SQRT_RATIO_LOWER_X96;

21:     uint160 internal SQRT_RATIO_UPPER_X96;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOPoolImmutableState.sol)

```solidity
File: src/base/LiquidityManagement.sol

47:     function addLiquidity(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol)

### <a name="NC-27"></a>[NC-27] Constants should be defined rather than using magic numbers

*Instances (29)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

110:         else r = ratio << (127 - msb);

115:             r := shr(127, mul(r, r))

117:             log_2 := or(log_2, shl(63, f))

121:             r := shr(127, mul(r, r))

123:             log_2 := or(log_2, shl(62, f))

127:             r := shr(127, mul(r, r))

129:             log_2 := or(log_2, shl(61, f))

133:             r := shr(127, mul(r, r))

135:             log_2 := or(log_2, shl(60, f))

139:             r := shr(127, mul(r, r))

141:             log_2 := or(log_2, shl(59, f))

145:             r := shr(127, mul(r, r))

147:             log_2 := or(log_2, shl(58, f))

151:             r := shr(127, mul(r, r))

153:             log_2 := or(log_2, shl(57, f))

157:             r := shr(127, mul(r, r))

159:             log_2 := or(log_2, shl(56, f))

163:             r := shr(127, mul(r, r))

165:             log_2 := or(log_2, shl(55, f))

169:             r := shr(127, mul(r, r))

171:             log_2 := or(log_2, shl(54, f))

175:             r := shr(127, mul(r, r))

177:             log_2 := or(log_2, shl(53, f))

181:             r := shr(127, mul(r, r))

183:             log_2 := or(log_2, shl(52, f))

187:             r := shr(127, mul(r, r))

189:             log_2 := or(log_2, shl(51, f))

193:             r := shr(127, mul(r, r))

195:             log_2 := or(log_2, shl(50, f))

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

### <a name="NC-28"></a>[NC-28] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (12)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

192:         for (uint i = 0; i < whitelisted.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

67:         uint256 msb = 0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/ILOManager.sol

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

106:         for (uint256 index = 0; index < params.vestingConfigs.length; index++) {

414:             for (uint256 i = 0; i < projectConfig.schedule.length; i++) {

522:         for (uint256 index = 0; index < vestingSchedule.length; index++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/ILOVest.sol

27:         for (uint256 i = 0; i < vestingConfigs.length; i++) {

51:         for (uint256 i = 0; i < scheduleLength; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol)

```solidity
File: src/base/ILOWhitelist.sol

30:         for (uint256 i = 0; i < users.length; i++) {

39:         for (uint256 i = 0; i < users.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol)

```solidity
File: src/base/Multicall.sol

15:         for (uint256 i = 0; i < data.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Use of `tx.origin` is unsafe in almost every context | 1 |
| [L-2](#L-2) | Use a 2-step ownership transfer pattern | 3 |
| [L-3](#L-3) | Use of `tx.origin` is unsafe in almost every context | 1 |
| [L-4](#L-4) | Do not use deprecated library functions | 1 |
| [L-5](#L-5) | Do not leave an implementation contract uninitialized | 2 |
| [L-6](#L-6) | Division by zero not prevented | 3 |
| [L-7](#L-7) | External call recipient may consume all transaction gas | 4 |
| [L-8](#L-8) | Initializers could be front-run | 5 |
| [L-9](#L-9) | Signature use at deadlines should be allowed | 2 |
| [L-10](#L-10) | Prevent accidentally burning tokens | 3 |
| [L-11](#L-11) | Loss of precision | 1 |
| [L-12](#L-12) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 4 |
| [L-13](#L-13) | Unsafe ERC20 operation(s) | 2 |
| [L-14](#L-14) | Unsafe solidity low-level call can cause gas grief attack | 3 |
| [L-15](#L-15) | Unspecific compiler version pragma | 10 |
| [L-16](#L-16) | Upgradeable contract not initialized | 31 |
### <a name="L-1"></a>[L-1] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (1)*:
```solidity
File: src/ILOManager.sol

30:         transferOwnership(tx.origin);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="L-2"></a>[L-2] Use a 2-step ownership transfer pattern
Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (3)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

11: contract Vultisig is ERC20, Ownable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

16: contract Whitelist is Ownable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

15: contract ILOManager is IILOManager, Ownable, Initializable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="L-3"></a>[L-3] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (1)*:
```solidity
File: src/ILOManager.sol

30:         transferOwnership(tx.origin);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="L-4"></a>[L-4] Do not use deprecated library functions

*Instances (1)*:
```solidity
File: src/libraries/TransferHelper.sol

53:     function safeApprove(address token, address to, uint256 value) internal {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="L-5"></a>[L-5] Do not leave an implementation contract uninitialized
An uninitialized implementation contract can be taken over by an attacker, which may impact the proxy. To prevent the implementation contract from being used, it's advisable to invoke the `_disableInitializers` function in the constructor to automatically lock it when it is deployed. This should look similar to this:
```solidity
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
      _disableInitializers();
  }
```

Sources:
- https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable-_disableInitializers--
- https://twitter.com/0xCygaar/status/1621417995905167360?s=20

*Instances (2)*:
```solidity
File: src/ILOManager.sol

29:     constructor() {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

49:     constructor() ERC721("", "") {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="L-6"></a>[L-6] Division by zero not prevented
The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (3)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

24:         timeWeightedAverageTick = int24(tickCumulativesDelta / int56(uint56(period)));

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

48:         if (tick > 0) ratio = type(uint256).max / ratio;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

87:             ) / sqrtRatioAX96;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

### <a name="L-7"></a>[L-7] External call recipient may consume all transaction gas
There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (4)*:
```solidity
File: src/libraries/TransferHelper.sol

19:         (bool success, bytes memory data) = token.call(

39:         (bool success, bytes memory data) = token.call(

54:         (bool success, bytes memory data) = token.call(

68:         (bool success, ) = to.call{value: value}(new bytes(0));

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="L-8"></a>[L-8] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (5)*:
```solidity
File: src/ILOManager.sol

33:     function initialize(

151:         IILOPool(iloPoolAddress).initialize(initParams);

170:             IUniswapV3Pool(pool).initialize(sqrtPriceX96);

175:                 IUniswapV3Pool(pool).initialize(sqrtPriceX96);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

71:     function initialize(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="L-9"></a>[L-9] Signature use at deadlines should be allowed
According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (2)*:
```solidity
File: src/ILOManager.sol

303:             _cachedProject[uniV3PoolAddress].refundDeadline < block.timestamp,

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

533:             if (vest.end < block.timestamp) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="L-10"></a>[L-10] Prevent accidentally burning tokens
Minting and burning tokens to address(0) prevention

*Instances (3)*:
```solidity
File: src/ILOPool.sol

160:             _mint(recipient, (tokenId = _nextId++));

403:             _mint(projectConfig.recipient, (tokenId = _nextId++));

450:         _burn(tokenId);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="L-11"></a>[L-11] Loss of precision
Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (1)*:
```solidity
File: src/libraries/LiquidityAmounts.sol

87:             ) / sqrtRatioAX96;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

### <a name="L-12"></a>[L-12] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (4)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

5: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

4: import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/ILOManager.sol

30:         transferOwnership(tx.origin);

45:         transferOwnership(initialOwner);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="L-13"></a>[L-13] Unsafe ERC20 operation(s)

*Instances (2)*:
```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

73:         payable(_msgSender()).transfer(msg.value);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: src/base/PeripheryPayments.sol

30:             IWETH9(WETH9).transfer(recipient, value);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

### <a name="L-14"></a>[L-14] Unsafe solidity low-level call can cause gas grief attack
Using the low-level calls of a solidity address can leave the contract open to gas grief attacks. These attacks occur when the called contract returns a large amount of data.

So when calling an external contract, it is necessary to check the length of the return data before reading/copying it (using `returndatasize()`).

*Instances (3)*:
```solidity
File: src/libraries/TransferHelper.sol

19:         (bool success, bytes memory data) = token.call(

39:         (bool success, bytes memory data) = token.call(

54:         (bool success, bytes memory data) = token.call(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="L-15"></a>[L-15] Unspecific compiler version pragma

*Instances (10)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol

2: pragma solidity >=0.4.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol)

```solidity
File: src/base/PeripheryPayments.sol

2: pragma solidity >=0.7.5;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol)

```solidity
File: src/libraries/ChainId.sol

2: pragma solidity >=0.7.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/ChainId.sol)

```solidity
File: src/libraries/LiquidityAmounts.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol)

```solidity
File: src/libraries/PoolAddress.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol)

```solidity
File: src/libraries/PositionKey.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PositionKey.sol)

```solidity
File: src/libraries/SqrtPriceMathPartial.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/SqrtPriceMathPartial.sol)

```solidity
File: src/libraries/TransferHelper.sol

2: pragma solidity >=0.6.0;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol)

### <a name="L-16"></a>[L-16] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (31)*:
```solidity
File: hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol

65:         (uint32 observationTimestamp, , , bool initialized) = IUniswapV3Pool(pool).observations(

71:         if (!initialized) {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol)

```solidity
File: src/ILOManager.sol

26:     mapping(address => address[]) private _initializedILOPools; // map uniV3Pool => list of initialized ilo pools

33:     function initialize(

41:     ) external override whenNotInitialized {

59:     ) external override afterInitialize returns (address uniV3PoolAddress) {

112:                     _initializedILOPools[params.uniV3Pool].length

122:                 _initializedILOPools[params.uniV3Pool].length

151:         IILOPool(iloPoolAddress).initialize(initParams);

152:         _initializedILOPools[params.uniV3Pool].push(iloPoolAddress);

170:             IUniswapV3Pool(pool).initialize(sqrtPriceX96);

175:                 IUniswapV3Pool(pool).initialize(sqrtPriceX96);

282:         address[] memory initializedPools = _initializedILOPools[

285:         require(initializedPools.length > 0, "NP");

286:         for (uint256 i = 0; i < initializedPools.length; i++) {

287:             IILOPool(initializedPools[i]).launch();

306:         address[] memory initializedPools = _initializedILOPools[

309:         for (uint256 i = 0; i < initializedPools.length; i++) {

310:             totalRefundAmount += IILOPool(initializedPools[i])

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

```solidity
File: src/ILOPool.sol

50:         _disableInitialize();

71:     function initialize(

73:     ) external override whenNotInitialized {

110:         emit ILOPoolInitialized(

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

```solidity
File: src/base/Initializable.sol

6:     bool private _initialized;

7:     function _disableInitialize() internal {

8:         _initialized = true;

10:     modifier whenNotInitialized() {

11:         require(!_initialized);

13:         _initialized = true;

15:     modifier afterInitialize() {

16:         require(_initialized);

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 20 |
| [M-2](#M-2) | `_safeMint()` should be used rather than `_mint()` wherever possible | 2 |
| [M-3](#M-3) | Fees can be set to be greater than 100%. | 3 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (20)*:
```solidity
File: hardhat-vultisig/contracts/Vultisig.sol

11: contract Vultisig is ERC20, Ownable {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol)

```solidity
File: hardhat-vultisig/contracts/Whitelist.sol

16: contract Whitelist is Ownable {

136:     function setLocked(bool newLocked) external onlyOwner {

142:     function setMaxAddressCap(uint256 newCap) external onlyOwner {

148:     function setVultisig(address newVultisig) external onlyOwner {

154:     function setIsSelfWhitelistDisabled(bool newFlag) external onlyOwner {

160:     function setOracle(address newOracle) external onlyOwner {

166:     function setPool(address newPool) external onlyOwner {

173:     function setBlacklisted(address blacklisted, bool flag) external onlyOwner {

179:     function setAllowedWhitelistIndex(uint256 newIndex) external onlyOwner {

185:     function addWhitelistedAddress(address whitelisted) external onlyOwner {

191:     function addBatchWhitelist(address[] calldata whitelisted) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol)

```solidity
File: hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol

22:     function setWhitelistContract(address newWhitelistContract) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol)

```solidity
File: src/ILOManager.sol

15: contract ILOManager is IILOManager, Ownable, Initializable {

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {

228:     ) external override onlyOwner {

247:     ) external override onlyOwner {

259:     ) external override onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)

### <a name="M-2"></a>[M-2] `_safeMint()` should be used rather than `_mint()` wherever possible
`_mint()` is [discouraged](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L271) in favor of `_safeMint()` which ensures that the recipient is either an EOA or implements `IERC721Receiver`. Both open [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L238-L250) and [solmate](https://github.com/Rari-Capital/solmate/blob/4eaf6b68202e36f67cab379768ac6be304c8ebde/src/tokens/ERC721.sol#L180) have versions of this function so that NFTs aren't lost if they're minted to contracts that cannot transfer them back out.

Be careful however to respect the CEI pattern or add a re-entrancy guard as `_safeMint` adds a callback-check (`_checkOnERC721Received`) and a malicious `onERC721Received` could be exploited if not careful.

Reading material:

- <https://blocksecteam.medium.com/when-safemint-becomes-unsafe-lessons-from-the-hypebears-security-incident-2965209bda2a>
- <https://samczsun.com/the-dangers-of-surprising-code/>
- <https://github.com/KadenZipfel/smart-contract-attack-vectors/blob/master/vulnerabilities/unprotected-callback.md>

*Instances (2)*:
```solidity
File: src/ILOPool.sol

160:             _mint(recipient, (tokenId = _nextId++));

403:             _mint(projectConfig.recipient, (tokenId = _nextId++));

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol)

### <a name="M-3"></a>[M-3] Fees can be set to be greater than 100%.
There should be an upper limit to reasonable fees.
A malicious owner can keep the fee rate at zero, but if a large value transfer enters the mempool, the owner can jack the rate up to the maximum and sandwich attack a user.

*Instances (3)*:
```solidity
File: src/ILOManager.sol

212:     function setPlatformFee(uint16 _platformFee) external onlyOwner {
             PLATFORM_FEE = _platformFee;

217:     function setPerformanceFee(uint16 _performanceFee) external onlyOwner {
             PERFORMANCE_FEE = _performanceFee;

222:     function setFeeTaker(address _feeTaker) external override onlyOwner {
             FEE_TAKER = _feeTaker;

```
[Link to code](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol)
