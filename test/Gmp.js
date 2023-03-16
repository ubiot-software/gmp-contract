const { expect } = require("chai");

describe("GMP Contract", () => {
  const setup = async ({ totalSupply = 10000 }) => {
    const [owner] = await ethers.getSigners();
    const PlatziPunks = await ethers.getContractFactory("GMP");
    const deployed = await PlatziPunks.deploy(totalSupply);

    return {
      owner,
      deployed,
    };
  };

  describe("Deployment", () => {
    it("Sets total supply to passed param", async () => {
      const totalSupply = 4000;

      const { deployed } = await setup({ totalSupply });

      const returnedMaxSupply = await deployed.totalSupply();
      expect(totalSupply).to.equal(returnedMaxSupply);
    });
  });
});
