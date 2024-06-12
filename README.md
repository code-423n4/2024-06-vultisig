# ✨ So you want to run an audit

This `README.md` contains a set of checklists for our audit collaboration.

Your audit will use two repos: 
- **an _audit_ repo** (this one), which is used for scoping your audit and for providing information to wardens
- **a _findings_ repo**, where issues are submitted (shared with you after the audit) 

Ultimately, when we launch the audit, this repo will be made public and will contain the smart contracts to be reviewed and all the information needed for audit participants. The findings repo will be made public after the audit report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the audit sponsor (⭐️)**.

---

# Audit setup

## 🐺 C4: Set up repos
- [ ] Create a new private repo named `YYYY-MM-sponsorname` using this repo as a template.
- [ ] Rename this repo to reflect audit date (if applicable)
- [ ] Rename audit H1 below
- [ ] Update pot sizes
  - [ ] Remove the "Bot race findings opt out" section if there's no bot race.
- [ ] Fill in start and end times in audit bullets below
- [ ] Add link to submission form in audit details below
- [ ] Add the information from the scoping form to the "Scoping Details" section at the bottom of this readme.
- [ ] Add matching info to the Code4rena site
- [ ] Add sponsor to this private repo with 'maintain' level access.
- [ ] Send the sponsor contact the url for this repo to follow the instructions below and add contracts here. 
- [ ] Delete this checklist.

# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [ ] Create a PR to this repo with the below changes:
- [ ] Confirm that this repo is a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 48 business hours prior to audit start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the audit — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the audit. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)

## ⭐️ Sponsor: Repo checklist

- [ ] Modify the [Overview](#overview) section of this `README.md` file. Describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the auditors should keep in mind when reviewing. (Here are two well-constructed examples: [Ajna Protocol](https://github.com/code-423n4/2023-05-ajna) and [Maia DAO Ecosystem](https://github.com/code-423n4/2023-05-maia))
- [ ] Review the Gas award pool amount, if applicable. This can be adjusted up or down, based on your preference - just flag it for Code4rena staff so we can update the pool totals across all comms channels.
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] [This checklist in Notion](https://code4rena.notion.site/Key-info-for-Code4rena-sponsors-f60764c4c4574bbf8e7a6dbd72cc49b4#0cafa01e6201462e9f78677a39e09746) provides some best practices for Code4rena audit repos.

## ⭐️ Sponsor: Final touches
- [ ] Review and confirm the pull request created by the Scout (technical reviewer) who was assigned to your contest. *Note: any files not listed as "in scope" will be considered out of scope for the purposes of judging, even if the file will be part of the deployed contracts.*
- [ ] Check that images and other files used in this README have been uploaded to the repo as a file and then linked in the README using absolute path (e.g. `https://github.com/code-423n4/yourrepo-url/filepath.png`)
- [ ] Ensure that *all* links and image/file paths in this README use absolute paths, not relative paths
- [ ] Check that all README information is in markdown format (HTML does not render on Code4rena.com)
- [ ] Delete this checklist and all text above the line below when you're ready.

---

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

- For whitelisted users, max address cap is set as 3 ETH, but we're calculating the ETH amount(used to buy vultisig tokens) from the `beforeTransferHook` which only has the amount of vultisig tokens. So, to calculate the ETH amount, we're using univ3 TWAP oracle and applied 5% slippage. So it will be slightly different from the actual ETH amount buyers spent.
- Small wei of token amount can left in contract due to rounding.

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  
  - ✅ SCOUTS: If there are multiple report links, please format them in a list.
- **Documentation:** https://docs.vultisig.com/
  - Official project documentation:
    - https://docs.vultisig.com/
    - https://github.com/vultisig
  - ILO management and token launch plans:
    - https://ilo-docs.krystal.app/.
- **Website:** 🐺 CA: add a link to the sponsor's website
- **X/Twitter:** 🐺 CA: add a link to the sponsor's Twitter
- **Discord:** 🐺 CA: add a link to the sponsor's Discord

# Scope

[ ✅ SCOUTS: add scoping and technical details here ]

### Files in scope
- ✅ This should be completed using the `metrics.md` file
- ✅ Last row of the table should be Total: SLOC
- ✅ SCOUTS: Have the sponsor review and and confirm in text the details in the section titled "Scoping Q amp; A"

*For sponsors that don't use the scoping tool: list all files in scope in the table below (along with hyperlinks) -- and feel free to add notes to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |


*See [scope.txt](https://github.com/code-423n4/2024-06-vultisig/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | SLOC  | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /hardhat-vultisig/contracts/Vultisig.sol | 1| **** | 14 | |@openzeppelin/contracts/token/ERC20/ERC20.sol<br>@openzeppelin/contracts/access/Ownable.sol|
| /hardhat-vultisig/contracts/Whitelist.sol | 1| **** | 130 | |@openzeppelin/contracts/access/Ownable.sol|
| /hardhat-vultisig/contracts/extensions/VultisigWhitelisted.sol | 1| **** | 18 | ||
| /hardhat-vultisig/contracts/oracles/uniswap/UniswapV3Oracle.sol | 1| **** | 26 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol|
| /hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/FullMath.sol | 1| **** | 55 | ||
| /hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/OracleLibrary.sol | 1| **** | 46 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol|
| /hardhat-vultisig/contracts/oracles/uniswap/uniswapv0.8/TickMath.sol | 1| **** | 172 | ||
| /src/ILOManager.sol | 1| **** | 170 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol<br>@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/libraries/TickMath.sol<br>@openzeppelin/contracts/access/Ownable.sol<br>@openzeppelin/contracts/proxy/Clones.sol|
| /src/ILOPool.sol | 1| **** | 331 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint128.sol<br>@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@openzeppelin/contracts/token/ERC721/ERC721.sol|
| /src/base/ILOPoolImmutableState.sol | 1| **** | 17 | ||
| /src/base/ILOVest.sol | 1| **** | 36 | ||
| /src/base/ILOWhitelist.sol | 1| **** | 41 | |@openzeppelin/contracts/utils/EnumerableSet.sol|
| /src/base/Initializable.sol | 1| **** | 16 | ||
| /src/base/LiquidityManagement.sol | 1| **** | 44 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol<br>@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol<br>@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol|
| /src/base/Multicall.sol | 1| **** | 19 | ||
| /src/base/PeripheryPayments.sol | 1| **** | 25 | |@openzeppelin/contracts/token/ERC20/IERC20.sol|
| /src/libraries/ChainId.sol | 1| **** | 8 | ||
| /src/libraries/LiquidityAmounts.sol | 1| **** | 47 | |@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint96.sol<br>@uniswap/v3-core/contracts/libraries/SqrtPriceMath.sol|
| /src/libraries/PoolAddress.sol | 1| **** | 32 | ||
| /src/libraries/PositionKey.sol | 1| **** | 10 | ||
| /src/libraries/SqrtPriceMathPartial.sol | 1| **** | 36 | |@uniswap/v3-core/contracts/libraries/FullMath.sol<br>@uniswap/v3-core/contracts/libraries/UnsafeMath.sol<br>@uniswap/v3-core/contracts/libraries/FixedPoint96.sol|
| /src/libraries/TransferHelper.sol | 1| **** | 34 | |@openzeppelin/contracts/token/ERC20/IERC20.sol|
| **Totals** | **22** | **** | **1327** | | |


### Files out of scope
✅ SCOUTS: List files/directories out of scope

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
### Are there any ERC20's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

Any (all possible ERC20s)


### Are there any ERC777's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC721's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC1155's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



✅ SCOUTS: Once done populating the table below, please remove all the Q/A data above.

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       🖊️             |
| Test coverage                           | ✅ SCOUTS: Please populate this after running the test coverage command                          |
| ERC721 used  by the protocol            |            🖊️              |
| ERC777 used by the protocol             |           🖊️                |
| ERC1155 used by the protocol            |              🖊️            |
| Chains the protocol will be deployed on | Ethereum |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   Yes  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  No  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | No    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   No  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | No    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | Yes    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | Yes    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | Yes    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | Yes    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | No    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | No    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | No    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  Yes   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | Yes    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   Yes  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | Yes    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Yes    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | Yes   |
| Pausability (e.g. Uniswap pool gets paused)               |  Yes   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |


### EIP compliance checklist
EIP721 (or ERC721)

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/Token.sol                           | ERC20, ERC721                |
| src/NFT.sol                             | ERC721                       |


# Additional context

## Main invariants

Vultisig token will be initially listed on UniswapV3(VULT/ETH pool).
    `Whitelist` contract will handle the initial whitelist launch and after this period, we will set `whitelist` contract address in Vultisig contract back to address(0) so tokens will be transferred without any restrictions.
    In `whitelist` contract, there's `checkWhitelist` function which checks if:

    - If `from` address is uniswap v3 pool which holds liquidity, then it means, this transfer is the `buy` action. We will apply the following WL logic. But if `to` address is `owner` address, then still ignore. Because `owner` has exclusive access like increase/decrease liquidity as well as collecting fees.
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
    - Set allowed whitelisted index(Especially when self whitelist is allowed, anyone can just send ETH and get whitelisted slot and each slot will be assigned by an index called `whitelistIndex`. There could be some suspicious actors so owner can add those addresses to the blacklist. In this case, the total whitelisted addresses will be `whitelistCount - blacklistedCount`. So owner can increase allowedWhitelistedIndex by blacklistedCount to make sure that always 1k whitelisted slots are secured.)
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

    - Once project init, it init a uniswap v3 pool. That pool address will be used as project id. You cannot change initial price after project is initialized.

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Attack ideas (where to focus for bugs)
- is there any senario that makes raise and sale token lock forever?

- For vultisig token contract, we've added `approveAndCall` function which will just handle token approval and transfer within a single transaction. And the actual receiver contract should implement `IApproveAndCallReceiver` interface, especially `receiveApproval` function. This will be only used for trusted receiver contracts btw.

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## All trusted roles in the protocol

Trusted roles in protocol: Vultisig token owner, Whitelist contract owner, ILOManager owner

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                          | Has superpowers                |
| Administrator                             | Can change fees                       |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

No

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Running tests

The repo contains 2 contract sets. Vultisig contracts are written in hardhat so you need to npm install and then use `npx hardhat` to compile and run tests for `hardhat-vultisig` contracts.
    Secondly, ILO contracts are built by foundry. So you need to use `forge` to build and run the tests as below:

    Vultisig contracts build and deploy steps:

    https://github.com/KYRDTeam/ilo-contracts/tree/master/hardhat-vultisig#readme

    ILO contracts build and deploy step are provided:

    https://github.com/KYRDTeam/ilo-contracts?tab=readme-ov-file#build-and-deploy

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```
To run gas benchmarks
```bash
make gas
```

✅ SCOUTS: Add a screenshot of your terminal showing the gas report
✅ SCOUTS: Add a screenshot of your terminal showing the test coverage

## Miscellaneous
Employees of Vultisig and employees' family members are ineligible to participate in this audit.
