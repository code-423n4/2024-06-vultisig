import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-erc1820"; // ERC777 is interacting with ERC1820 registry

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  paths: {
    sources: "./hardhat-vultisig/contracts",
    tests: "./hardhat-vultisig/test",
  },
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${vars.get(
        "VULTISIG_ALCHEMY_KEY"
      )}`,
      chainId: 11155111,
      accounts: [vars.get("DEPLOYER_KEY")],
    },
    mainnet: {
      url: `https://eth-mainnet.g.alchemy.com/v2/${vars.get(
        "VULTISIG_ALCHEMY_MAINNET_KEY"
      )}`,
      chainId: 1,
      accounts: [vars.get("DEPLOYER_KEY")],
    },
  },
  typechain: {
    externalArtifacts: [
      "node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json",
      "node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungiblePositionManager.sol/NonfungiblePositionManager.json",
      "node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json",
    ],
  },
};

export default config;
