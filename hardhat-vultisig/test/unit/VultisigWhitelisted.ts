import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("VultisigWhitelisted", function () {
  async function deployVultisigWhitelistedFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const VultisigWhitelisted = await ethers.getContractFactory("VultisigWhitelisted");
    const vultisig = await VultisigWhitelisted.deploy();

    const MockWhitelistSuccess = await ethers.getContractFactory("MockWhitelistSuccess");
    const MockWhitelistFail = await ethers.getContractFactory("MockWhitelistFail");

    const mockWhitelistSuccess = await MockWhitelistSuccess.deploy();
    const mockWhitelistFail = await MockWhitelistFail.deploy();

    return { vultisig, owner, otherAccount, mockWhitelistSuccess, mockWhitelistFail };
  }

  describe("Ownable", function () {
    it("Should set the right whitelist contract", async function () {
      const { vultisig, mockWhitelistSuccess } = await loadFixture(deployVultisigWhitelistedFixture);

      await vultisig.setWhitelistContract(mockWhitelistSuccess);

      expect(await vultisig.whitelistContract()).to.eq(mockWhitelistSuccess);
    });

    it("Should revert if called from non-owner contract", async function () {
      const { vultisig, otherAccount, mockWhitelistSuccess } = await loadFixture(deployVultisigWhitelistedFixture);

      await expect(vultisig.connect(otherAccount).setWhitelistContract(mockWhitelistSuccess)).to.be.revertedWith(
        "Ownable: caller is not the owner",
      );
    });
  });

  describe("Transfer", function () {
    it("Should transfer when whitelist contract is not set", async function () {
      const amount = ethers.parseEther("1000");
      const { vultisig, owner, otherAccount } = await loadFixture(deployVultisigWhitelistedFixture);
      expect(await vultisig.transfer(otherAccount.address, amount)).to.changeTokenBalances(
        vultisig,
        [owner.address, otherAccount.address],
        [-amount, amount],
      );
    });

    it("Should transfer when checkWhitelist succeeds", async function () {
      const amount = ethers.parseEther("1000");
      const { vultisig, owner, otherAccount, mockWhitelistSuccess } = await loadFixture(
        deployVultisigWhitelistedFixture,
      );
      await vultisig.setWhitelistContract(mockWhitelistSuccess);
      expect(await vultisig.transfer(otherAccount.address, amount)).to.changeTokenBalances(
        vultisig,
        [owner.address, otherAccount.address],
        [-amount, amount],
      );
    });

    it("Should revert transfer when checkWhitelist reverts", async function () {
      const amount = ethers.parseEther("1000");
      const { vultisig, otherAccount, mockWhitelistFail } = await loadFixture(deployVultisigWhitelistedFixture);

      await vultisig.setWhitelistContract(mockWhitelistFail);
      await expect(vultisig.transfer(otherAccount.address, amount)).to.be.reverted;
    });
  });
});
