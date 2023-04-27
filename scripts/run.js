const main = async () => {
    const rantContractFactory = await hre.ethers.getContractFactory("RantPortal");
    const rantContract = await rantContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
      });
    await rantContract.deployed();
    
    console.log("Contract address:", rantContract.address);


     /*
     * Get Contract balance
     */
     let contractBalance = await hre.ethers.provider.getBalance(
        rantContract.address
      );
      console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
      );

     /*
    * Let's try two waves now
    */
    const rantTxn = await rantContract.rant("This is rant #1");
    await rantTxn.wait();

    const rantTxn2 = await rantContract.rant("This is rant #2");
    await rantTxn2.wait();

    contractBalance = await hre.ethers.provider.getBalance(rantContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    let allRants = await rantContract.getAllRants();
    console.log(allRants);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();