import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import {MIN_VALIDATIONS,MAX_NUMBER_NODES,MAX_NUMBER_INACTIVE_DAYS} from "../hardhat-helper-config";

const deployPoABase: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy,log } = deployments;
  const { deployer } = await getNamedAccounts();

  const poaContract=await deploy("PoABase", {
    from: deployer,
    args: [MIN_VALIDATIONS,MAX_NUMBER_NODES,MAX_NUMBER_INACTIVE_DAYS],
    log: true,
  });
  log(`PoABase deployed to: ${poaContract.address}`);
};

export default deployPoABase;
deployPoABase.tags = ["PoABase"];
