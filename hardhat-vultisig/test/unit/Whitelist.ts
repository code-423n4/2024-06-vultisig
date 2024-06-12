import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Whitelist", function () {
  async function deployWhitelistFixture() {
    const [owner, otherAccount, batchedAccount, mockContract, pool] = await ethers.getSigners();

    const Whitelist = await ethers.getContractFactory("Whitelist");
    const whitelist = await Whitelist.deploy();
    await whitelist.setPool(pool);

    const MockOracleSuccess = await ethers.getContractFactory("MockOracleSuccess");
    const MockOracleFail = await ethers.getContractFactory("MockOracleFail");

    const mockOracleSuccess = await MockOracleSuccess.deploy();
    const mockOracleFail = await MockOracleFail.deploy();

    return {
      whitelist,
      mockOracleSuccess,
      mockOracleFail,
      owner,
      otherAccount,
      batchedAccount,
      mockContract,
      pool,
    };
  }

  describe("Deployment", function () {
    it("Should set max address cap, locked, isSelfWhitelistDisabled", async function () {
      const { whitelist } = await loadFixture(deployWhitelistFixture);

      expect(await whitelist.maxAddressCap()).to.eq(ethers.parseEther("3"));
      expect(await whitelist.locked()).to.eq(true);
    });
  });

  describe("Ownable", function () {
    // , max address cap, vultisig, uniswap contract, isSelfWhitelistDisabled
    it("Should set locked", async function () {
      const { whitelist } = await loadFixture(deployWhitelistFixture);

      await whitelist.setLocked(false);
      expect(await whitelist.locked()).to.eq(false);
    });

    it("Should set max address cap", async function () {
      const { whitelist } = await loadFixture(deployWhitelistFixture);

      await whitelist.setMaxAddressCap(10_000_000 * 1e6);
      expect(await whitelist.maxAddressCap()).to.eq(10_000_000 * 1e6);
    });

    it("Should set vultisig token", async function () {
      const { whitelist, mockContract } = await loadFixture(deployWhitelistFixture);

      await whitelist.setVultisig(mockContract.address);
      expect(await whitelist.vultisig()).to.eq(mockContract.address);
    });

    it("Should set self whitelist disabled", async function () {
      const { whitelist } = await loadFixture(deployWhitelistFixture);

      await whitelist.setIsSelfWhitelistDisabled(true);
      expect(await whitelist.isSelfWhitelistDisabled()).to.eq(true);
    });

    it("Should set oracle contract", async function () {
      const { whitelist, mockOracleSuccess } = await loadFixture(deployWhitelistFixture);

      await whitelist.setOracle(mockOracleSuccess);
      expect(await whitelist.oracle()).to.eq(mockOracleSuccess);
    });

    it("Should set blacklisted", async function () {
      const { whitelist, otherAccount } = await loadFixture(deployWhitelistFixture);
      expect(await whitelist.isBlacklisted(otherAccount)).to.eq(false);
      await whitelist.setBlacklisted(otherAccount, true);
      expect(await whitelist.isBlacklisted(otherAccount)).to.eq(true);
    });

    it("Should set allowed whitelist index", async function () {
      const { whitelist } = await loadFixture(deployWhitelistFixture);
      const allowed = Math.floor(Math.random() * 1000);
      expect(await whitelist.allowedWhitelistIndex()).to.eq(0);
      await whitelist.setAllowedWhitelistIndex(allowed);
      expect(await whitelist.allowedWhitelistIndex()).to.eq(allowed);
    });

    it("Should add whitelisted address", async function () {
      const { whitelist, owner, otherAccount } = await loadFixture(deployWhitelistFixture);

      expect(await whitelist.whitelistIndex(owner)).to.eq(0);
      await whitelist.addWhitelistedAddress(owner);
      expect(await whitelist.whitelistIndex(owner)).to.eq(1);
      expect(await whitelist.whitelistCount()).to.eq(1);

      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(0);
      await whitelist.addWhitelistedAddress(otherAccount);
      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(2);
      expect(await whitelist.whitelistCount()).to.eq(2);

      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(2);
      expect(await whitelist.whitelistCount()).to.eq(2);
    });

    it("Should add batch whitelisted address", async function () {
      const { whitelist, otherAccount, batchedAccount } = await loadFixture(deployWhitelistFixture);

      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(0);
      expect(await whitelist.whitelistIndex(batchedAccount)).to.eq(0);
      expect(await whitelist.whitelistCount()).to.eq(0);
      await whitelist.addBatchWhitelist([otherAccount, batchedAccount, otherAccount]);
      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(1);
      expect(await whitelist.whitelistIndex(batchedAccount)).to.eq(2);
      expect(await whitelist.whitelistCount()).to.eq(2);
    });

    it("Should revert if called from non-owner address", async function () {
      const { whitelist, otherAccount, batchedAccount, mockContract } = await loadFixture(deployWhitelistFixture);

      await expect(whitelist.connect(otherAccount).setLocked(true)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(whitelist.connect(otherAccount).setMaxAddressCap(10_000)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(whitelist.connect(otherAccount).setVultisig(mockContract)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(whitelist.connect(otherAccount).setIsSelfWhitelistDisabled(true)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(whitelist.connect(otherAccount).setOracle(mockContract)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(whitelist.connect(otherAccount).setBlacklisted(mockContract, true)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );

      await expect(whitelist.connect(otherAccount).setAllowedWhitelistIndex(100)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );

      await expect(whitelist.connect(otherAccount).addWhitelistedAddress(otherAccount)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
      await expect(
        whitelist.connect(otherAccount).addBatchWhitelist([otherAccount, batchedAccount]),
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });

  describe("Self-whitelist", function () {
    it("Should self whitelist when ETH is sent", async function () {
      const { whitelist, otherAccount } = await loadFixture(deployWhitelistFixture);
      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(0);
      const balanceChange = 67335443339441n;

      expect(
        await otherAccount.sendTransaction({
          to: whitelist,
          value: ethers.parseEther("1"),
        }),
      ).to.changeEtherBalance(otherAccount, -balanceChange);
      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(1);
      expect(
        await otherAccount.sendTransaction({
          to: whitelist,
          value: ethers.parseEther("1"),
        }),
      ).to.changeEtherBalance(otherAccount, -balanceChange);
      expect(await whitelist.whitelistIndex(otherAccount)).to.eq(1);
      expect(await whitelist.whitelistCount()).to.eq(1);
    });

    it("Should revert if self whitelist is disabled by owner", async function () {
      const { whitelist, otherAccount } = await loadFixture(deployWhitelistFixture);

      await whitelist.setIsSelfWhitelistDisabled(true);

      await expect(
        otherAccount.sendTransaction({
          to: whitelist,
          value: ethers.parseEther("1"),
        }),
      ).to.be.revertedWithCustomError(whitelist, "SelfWhitelistDisabled");
    });

    it("Should revert if blacklisted by owner", async function () {
      const { whitelist, otherAccount } = await loadFixture(deployWhitelistFixture);

      await whitelist.setBlacklisted(otherAccount, true);

      await expect(
        otherAccount.sendTransaction({
          to: whitelist,
          value: ethers.parseEther("1"),
        }),
      ).to.be.revertedWithCustomError(whitelist, "Blacklisted");
    });
  });

  describe("Checkwhitelist", function () {
    it("Should revert when called from non vultisig contract", async function () {
      const { whitelist, otherAccount, pool } = await loadFixture(deployWhitelistFixture);

      await expect(whitelist.checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "NotVultisig",
      );
    });

    it("Should revert when locked, blacklisted or not whitelisted", async function () {
      const { whitelist, pool, otherAccount, batchedAccount, mockContract } = await loadFixture(deployWhitelistFixture);

      await whitelist.setVultisig(mockContract);

      await expect(whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "Locked",
      );

      await whitelist.setLocked(false);
      await whitelist.setBlacklisted(otherAccount, true);

      await expect(whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "Blacklisted",
      );

      await whitelist.setBlacklisted(otherAccount, false);
      await expect(whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "NotWhitelisted",
      );

      // Whitelist 2 accounts and only allow first one
      await whitelist.addBatchWhitelist([otherAccount, batchedAccount]);
      await whitelist.setAllowedWhitelistIndex(1);

      await expect(
        whitelist.connect(mockContract).checkWhitelist(pool, batchedAccount, 0),
      ).to.be.revertedWithCustomError(whitelist, "NotWhitelisted");
    });

    it("Should revert when ETH amount exceeds max address cap or already contributed", async function () {
      const { whitelist, mockOracleFail, mockOracleSuccess, pool, otherAccount, mockContract } =
        await loadFixture(deployWhitelistFixture);

      await whitelist.setVultisig(mockContract);
      await whitelist.setOracle(mockOracleFail);
      await whitelist.setLocked(false);
      await whitelist.addWhitelistedAddress(otherAccount);
      await whitelist.setAllowedWhitelistIndex(1);

      await expect(whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "MaxAddressCapOverflow",
      );

      await whitelist.setOracle(mockOracleSuccess);
      await whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0);
      expect(await whitelist.contributed(otherAccount)).to.eq(ethers.parseEther("1.5"));

      await whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0);
      expect(await whitelist.contributed(otherAccount)).to.eq(ethers.parseEther("3"));

      await expect(whitelist.connect(mockContract).checkWhitelist(pool, otherAccount, 0)).to.be.revertedWithCustomError(
        whitelist,
        "MaxAddressCapOverflow",
      );
    });
  });
});
