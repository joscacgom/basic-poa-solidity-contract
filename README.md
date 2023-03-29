# Proof of Authority Protocol

## Overview

This is a project built using Hardhat and TypeScript that implements a Proof of Authority (PoA) protocol on the Ethereum network. In a PoA network, transactions are validated by approved nodes, rather than by the entire network through mining. This makes the network faster and more energy-efficient, but it also requires a level of trust between the approved nodes.

## Getting Started

To get started with this project, you will need to have Hardhat and Node.js installed on your computer. You can install Hardhat by running the following command in your terminal:

npm install --save-dev hardhat


You can then clone this repository to your local machine and install the required dependencies by running the following commands:

git clone https://github.com/<your-username>/proof-of-authority.git
cd proof-of-authority
npm install


## Usage

To use this project, you can run the following commands in your terminal:

### Compile the contracts

npx hardhat compile


### Run the tests

npx hardhat test


### Deploy the contracts

npx hardhat run --network <network-name> scripts/deploy.ts


Replace `<network-name>` with the name of the network you want to deploy the contracts to (e.g. `rinkeby` or `mainnet`).

## Contributing

If you would like to contribute to this project, please fork the repository and create a new branch for your feature or bug fix. Once you have made your changes, create a pull request and describe the changes you have made and why they are necessary.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
