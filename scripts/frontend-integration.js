// frontend-integration.js
// Example Stacks.js script to interact with voting contract

const { StacksTestnet } = require('@stacks/network');
const { makeContractCall, broadcastTransaction } = require('@stacks/transactions');
const { StacksWalletProvider } = require('@stacks/wallet-sdk');

const network = new StacksTestnet();
const contractAddress = 'ST123...'; // Replace with deployed contract address
const contractName = 'voting-system';
const senderKey = 'YOUR_PRIVATE_KEY'; // Replace with your private key

async function vote(candidateName) {
  const txOptions = {
    contractAddress,
    contractName,
    functionName: 'vote',
    functionArgs: [candidateName],
    senderKey,
    network,
  };
  const transaction = await makeContractCall(txOptions);
  const result = await broadcastTransaction(transaction, network);
  console.log('Vote transaction result:', result);
}

// Example usage:
vote('Proposal A');