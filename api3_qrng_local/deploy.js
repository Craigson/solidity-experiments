// deploy

const airnodeRrp = await deployContract('@api3/airnode-protocol/contracts/rrp/AirnodeRrpV0.sol');

/**
 * Deploys the contract specified by the path to the artifact and constructor arguments. This method will also write the
 * address of the deployed contract which can be used to connect to the contract.
 *
 * @param artifactsFolderPath
 * @param args Arguments for the contract constructor to be deployed
 * @returns The deployed contract
 */
 export const deployContract = async (artifactsFolderPath: string, args: any[] = []) => {
    const artifact = getArtifact(artifactsFolderPath);
  
    // Deploy the contract
    const contractFactory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, await getUserWallet());
    const contract = await contractFactory.deploy(...args);
    await contract.deployed();
  
    // Make sure the deployments folder exist
    const deploymentsPath = join(__dirname, '../deployments');
    if (!existsSync(deploymentsPath)) mkdirSync(deploymentsPath);
  
    // Try to load the existing deployments file for this network - we want to preserve deployments of other contracts
    const network = readIntegrationInfo().network;
    const deploymentPath = join(deploymentsPath, network + '.json');
    let deployment: any = {};
    if (existsSync(deploymentPath)) deployment = JSON.parse(readFileSync(deploymentPath).toString());
  
    // The key name for this contract is the path of the artifact without the '.sol' extension
    const deploymentName = removeExtension(artifactsFolderPath);
    // Write down the address of deployed contract
    writeFileSync(deploymentPath, JSON.stringify({ ...deployment, [deploymentName]: contract.address }, null, 2));
  
    return contract;
  };

  /**
 * Reads the compiled solidity artifact necessary for contract deployment.
 *
 * @param artifactsFolderPath
 * @returns The compiled artifact
 */
const getArtifact = (artifactsFolderPath: string) => {
    const fullArtifactsPath = join(__dirname, '../artifacts/', artifactsFolderPath);
    const files = readdirSync(fullArtifactsPath);
    const artifactName = files.find((f) => !f.endsWith('.dbg.json'))!;
    const artifactPath = join(fullArtifactsPath, artifactName);
    return require(artifactPath);
  };