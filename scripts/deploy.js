const main = async () => {
    const rantContractFactory = await hre.ethers.getContractFactory("RantPortal");
    const rantContract = await rantContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.001"),
    });
  
    await rantContract.deployed();
  
    console.log("RantPortal address: ", rantContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();