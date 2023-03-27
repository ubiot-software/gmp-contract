const deploy = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract from the account:", deployer.address);

  const GMP = await ethers.getContractFactory("GMP");
  const deployed = await GMP.deploy();
  console.log("GMP is deployed at:", deployed.address);
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
