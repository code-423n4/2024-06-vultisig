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
- Total Prize Pool: $41600 in USDC
  - HM awards: $33100 in USDC
  - (remove this line if there is no Analysis pool) Analysis awards: XXX XXX USDC (Notion: Analysis pool)
  - QA awards: $1400 in USDC
  - (remove this line if there is no Bot race) Bot Race awards: XXX XXX USDC (Notion: Bot Race pool)
 
  - Judge awards: $4000 in USDC
  - Lookout awards: XXX XXX USDC (Notion: Sum of Pre-sort fee + Pre-sort early bonus)
  - Scout awards: $500 in USDC
  - (this line can be removed if there is no mitigation) Mitigation Review: XXX XXX USDC (*Opportunity goes to top 3 backstage wardens based on placement in this audit who RSVP.*)
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-06-vultisig/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts June 14, 2024 20:00 UTC
- Ends June 21, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-06-vultisig/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._
## 🐺 C4: Begin Gist paste here (and delete this line)





# Scope

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

