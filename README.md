
# Vultisig audit details
- Total Prize Pool: $41,600 in USDC
  - HM awards: $33,100 in USDC
  - QA awards: $1,400 in USDC
  - Judge awards: $4,000 in USDC
  - Validator awards: $2,600 USDC 
  - Scout awards: $500 in USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-06-vultisig/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts June 14, 2024 20:00 UTC
- Ends June 21, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-06-vultisig/blob/main/4naly3er-report.md).


_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

- For whitelisted users, max address cap is set as 3 ETH, but we're calculating the ETH amount(used to buy vultisig tokens) from the `beforeTransferHook` which only has the amount of vultisig tokens. So, to calculate the ETH amount, we're using Univ3 TWAP oracle and applied 5% slippage. So it will be slightly different from the actual ETH amount buyers spent.
- Small wei of token amount can be left in contract due to rounding.



# Overview

Vultisig is a multi-chain, multi-platform, threshold signature vault/wallet that requires no special hardware. 
It supports most UTXO, EVM, BFT and EdDSA chains.
Based on Binance tss-lib, but adapted for mobile environment.
It aims to improve security through multi-factor authentication while improving user onboarding and wallet management.
This eliminates the need for the user to secure a seed phrase and improves on-chain privacy with multi-party computation archived with the Threshold Signature Scheme.


## Links

- **Previous audits:**  None
- **Documentation:** https://docs.vultisig.com/
  - Official project documentation:
    - https://docs.vultisig.com/
    - https://github.com/vultisig
  - ILO management and token launch plans:
    - https://ilo-docs.krystal.app/.
- **Website:** https://vultisig.com/
- **X/Twitter:** https://x.com/vultisig
- **Discord:** https://discord.com/invite/54wEtGYxuv

# Scope



### Files in scope


*See [scope.txt](https://github.com/code-423n4/2024-06-vultisig/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | SLOC  | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| [/hardhat-vultisig/contracts/Vultisig.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Vultisig.sol) | 1| **** | 14 | |@openzeppelin/contracts/token/ERC20/ERC20.sol<br>@openzeppelin/contracts/access/Ownable.sol|
| [/hardhat-vultisig/contracts/Whitelist.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/Whitelist.sol) | 1| **** | 130 | |@openzeppelin/contracts/access/Ownable.sol|
| [/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol) | 1| **** | 18 | ||
| [/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol) | 1| **** | 26 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol|
| [/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol) | 1| **** | 55 | ||
| [/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol) | 1| **** | 46 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol|
| [/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol) | 1| **** | 172 | ||
| [/src/ILOManager.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOManager.sol) | 1| **** | 170 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol<br>@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/libraries/TickMath.sol<br>@openzeppelin/contracts/access/Ownable.sol<br>@openzeppelin/contracts/proxy/Clones.sol|
| [/src/ILOPool.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/ILOPool.sol) | 1| **** | 331 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint128.sol<br>@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@openzeppelin/contracts/token/ERC721/ERC721.sol|
| [/src/base/ILOPoolImmutableState.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOPoolImmutableState.sol) | 1| **** | 17 | ||
| [/src/base/ILOVest.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOVest.sol) | 1| **** | 36 | ||
| [/src/base/ILOWhitelist.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/ILOWhitelist.sol) | 1| **** | 41 | |@openzeppelin/contracts/utils/EnumerableSet.sol|
| [/src/base/Initializable.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Initializable.sol) | 1| **** | 16 | ||
| [/src/base/LiquidityManagement.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/LiquidityManagement.sol) | 1| **** | 44 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol<br>@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol|
| [/src/base/Multicall.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/Multicall.sol) | 1| **** | 19 | ||
| [/src/base/PeripheryPayments.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/base/PeripheryPayments.sol) | 1| **** | 25 | |@openzeppelin/contracts/token/ERC20/IERC20.sol|
| [/src/libraries/ChainId.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/ChainId.sol) | 1| **** | 8 | ||
| [/src/libraries/LiquidityAmounts.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/LiquidityAmounts.sol) | 1| **** | 47 | |@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint96.sol<br>@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol|
| [/src/libraries/PoolAddress.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PoolAddress.sol) | 1| **** | 32 | ||
| [/src/libraries/PositionKey.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/PositionKey.sol) | 1| **** | 10 | ||
| [/src/libraries/SqrtPriceMathPartial.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/SqrtPriceMathPartial.sol) | 1| **** | 36 | |@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@uniswap/v3-core/contracts/libraries/UnsafeMath.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint96.sol|
| [/src/libraries/TransferHelper.sol](https://github.com/code-423n4/2024-06-vultisig/blob/main/src/libraries/TransferHelper.sol) | 1| **** | 34 | |@openzeppelin/contracts/token/ERC20/IERC20.sol|
| **Totals** | **22** | **** | **1327** | | |


### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2024-06-vultisig/blob/main/out_of_scope.txt)*

| File         |
| ------------ |
| ./hardhat-vultisig/contracts/interfaces/IApproveAndCallReceiver.sol |
| ./hardhat-vultisig/contracts/interfaces/IOracle.sol |
| ./hardhat-vultisig/contracts/interfaces/IWhitelist.sol |
| ./hardhat-vultisig/contracts/mocks/ApprovalReceiver.sol |
| ./hardhat-vultisig/contracts/mocks/MockOracleFail.sol |
| ./hardhat-vultisig/contracts/mocks/MockOracleSuccess.sol |
| ./hardhat-vultisig/contracts/mocks/MockWhitelistFail.sol |
| ./hardhat-vultisig/contracts/mocks/MockWhitelistSuccess.sol |
| ./hardhat-vultisig/contracts/mocks/WETH9.sol |
| ./script/Common.s.sol |
| ./script/Deploy.s.sol |
| ./script/Init.s.sol |
| ./script/Verify.s.sol |
| ./src/interfaces/IILOManager.sol |
| ./src/interfaces/IILOPool.sol |
| ./src/interfaces/IILOPoolImmutableState.sol |
| ./src/interfaces/IILOSale.sol |
| ./src/interfaces/IILOVest.sol |
| ./src/interfaces/IILOWhitelist.sol |
| ./src/interfaces/IMulticall.sol |
| ./src/interfaces/external/IERC1271.sol |
| ./src/interfaces/external/IERC20PermitAllowed.sol |
| ./src/interfaces/external/IWETH9.sol |
| ./test/ILOManager.t.sol |
| ./test/ILOPool.t.sol |
| ./test/IntegrationTestBase.sol |
| ./test/Mock.t.sol |
| Totals: 27 |


## Scoping Q &amp; A

### General questions


| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any (all possible ERC20s) that complies with [ERC20 token behaviors in scope](https://github.com/code-423n4/2024-06-vultisig#erc20-token-behaviors-in-scope)            |
| Test coverage                           | Vultisig -     Functions: 81.13%, Lines: 63.78% ,   ILO - Functions: 72.22%, Lines: 71.68%                    |
| ERC721 used  by the protocol            |            None              |
| ERC777 used by the protocol             |           None                |
| ERC1155 used by the protocol            |              None            |
| Chains the protocol will be deployed on | Ethereum |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   ✅  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  ❌  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | ❌    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   ❌  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | ❌    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | ✅    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | ✅    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | ✅    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | ✅    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | ❌    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | ❌    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | ❌    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  ✅   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | ✅    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   ✅  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | ✅    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | ✅    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | ✅   |
| Pausability (e.g. Uniswap pool gets paused)               |  ✅   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   ❌  |


### EIP compliance checklist




| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/ILOPool.sol                           | EIP721 (or ERC721)              |



# Additional context

## Main invariants

Vultisig token will be initially listed on UniswapV3(VULT/ETH pool).
    `Whitelist` contract will handle the initial whitelist launch and after this period, we will set `whitelist` contract address in Vultisig contract back to address(0) so tokens will be transferred without any restrictions.
    
In `whitelist` contract, there's `checkWhitelist` function which checks if:

   - If `from` address is uniswap v3 pool which holds liquidity, then it means, this transfer is the `buy` action. 
We will apply the following WL logic. 
But if `to` address is `owner` address, then still ignore. Because `owner` has exclusive access like increase/decrease liquidity as well as collecting fees.
    - Token purchase is locked or not
    - Buyer is blacklisted or not
    - Buyer whitelist index is within allowed index range(starting from 1 and within 1 ~ allowedWhitelistIndex - inclusive)
    - ETH amount is greater than max address cap(default 3 ETH) or not

   Whitelist contract owner can:

   - Set locked period
   - Set maximum address cap
   - Set vultisig token contract
   - Set self whitelisted period
   - Set TWAP oracle address
   - Set blacklisted flag for certain addresses
   - Set allowed whitelisted index(Especially when self whitelist is allowed, anyone can just send ETH and get whitelisted slot and each slot will be assigned by an index called `whitelistIndex`. 
There could be some suspicious actors so owner can add those addresses to the blacklist. In this case, the total whitelisted addresses will be `whitelistCount - blacklistedCount`. So owner can increase allowedWhitelistedIndex by blacklistedCount to make sure that always 1k whitelisted slots are secured.)
    - Add whitelisted addresses(single address and batched list)

   Regarding ILO contracts:

   - `ILOPool.saleInfo`: contains infomation for a sale like hard cap(max raise amount), soft cap(min raise amount to launch), max cap per user, sale start, sale end, max sale amount

   - `ILOPool._vestingConfigs`: contains vesting config for both investor and project. First element will be config for investor.

   - `ILOManager._initializedILOPools`: ilo pools associated with a project. When launch project, all ilo pools needs to launch successfully, otherwise, it will reverted. When project admin claim refund. it will claim refund for all initialized pools.

   - ILOManager owner(trusted role) can extend/set refund deadline to any projects at any time. But after refund triggered or after launch, this is meaningless.

   - Only project admin can init ilo pool for project and claim project refund (sale token deposited into ilo pool)

   - iloPool belongs to only one project. One project can create many ilo pool.

   - iloPool can only launch from manager. only project admin can launch project(aka launch all ilo pool)

   - Anyone can trigger refund when refund condition met.

   - Anyone can launch pool when all condition met.

   - After refund triggered, no one can launch pool anymore.

   - After pool launch, no one can trigger refund anymore.

   - Once project inits, it inits a uniswap v3 pool. That pool address will be used as project id. You cannot change initial price after project is initialized.


## Attack ideas (where to focus for bugs)
- is there any senario that makes raise and sale token lock forever?

- For vultisig token contract, we've added `approveAndCall` function which will just handle token approval and transfer within a single transaction. And the actual receiver contract should implement `IApproveAndCallReceiver` interface, especially `receiveApproval` function. This will be only used for trusted receiver contracts btw.

## All trusted roles in the protocol


| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
|Vultisig token owner  & Whitelist contract owner  |- Can set locked period|
||- Can set maximum address cap|
||- Can set vultisig token contract|
||- Can set self whitelisted period|
||- Can set TWAP oracle address|
||- Can set blacklisted flag for certain addresses|
||- Can set allowed whitelisted index|
|ILOManager owner| - Can extend/set refund deadline to any projects|
|                | - Can change protocol and performance fees |
|                | - Can change ilo pool implementation |
|                | - Can change FeeTaker |
|                | - Can change default refund deadline offset |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

None



## Running tests

The repo contains 2 contract sets. Vultisig contracts are written in Hardhat so you need to `npm install` and then use `npx hardhat` to compile and run tests for `hardhat-vultisig` contracts.

Before compiling the contracts make sure to set `VULTISIG_ALCHEMY_KEY`, `DEPLOYER_KEY`, `VULTISIG_ALCHEMY_MAINNET_KEY`.
E.g.:
```javascript
npx hardhat vars set DEPLOYER_KEY yourKeyToSet
```

```bash
git clone https://github.com/code-423n4/2024-06-vultisig.git
git submodule update --init --recursive
npm install
cd hardhat-vultisig
npx hardhat test
```
To run code coverage;
```bash
npx hardhat coverage
```
Secondly, ILO contracts are built by Foundry. So you need to use `forge` to build and run the tests as below:

```bash
cd src
forge build
forge test
```
To run code coverage;
```bash
forge coverage
```
Vultisig contracts build and deploy steps are provided [here](https://github.com/KYRDTeam/ilo-contracts/tree/master/hardhat-vultisig#readme)

ILO contracts build and deploy step are provided [here](https://github.com/KYRDTeam/ilo-contracts?tab=readme-ov-file#build-and-deploy)

![Screenshot from 2024-06-12 22-38-08](https://github.com/code-423n4/2024-06-vultisig/assets/65364747/b49bc5f5-a346-4ee5-b8c7-5e06a7fb99e5?raw=true)
![Screenshot from 2024-06-12 22-36-46](https://github.com/code-423n4/2024-06-vultisig/assets/65364747/cfe500dd-4dec-435f-9499-9d750b367797?raw=true)


## Miscellaneous
Employees of Vultisig and employees' family members are ineligible to participate in this audit.
