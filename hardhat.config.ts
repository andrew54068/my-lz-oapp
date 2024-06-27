// Get the environment configuration from .env file
//
// To make use of automatic environment setup:
// - Duplicate .env.example file and name it .env
// - Fill in the environment variables
import 'dotenv/config'

import 'hardhat-deploy'
import 'hardhat-contract-sizer'
import '@nomiclabs/hardhat-ethers'
import '@layerzerolabs/toolbox-hardhat'
import { HardhatUserConfig, HttpNetworkAccountsUserConfig } from 'hardhat/types'

import { EndpointId } from '@layerzerolabs/lz-definitions'

// Set your preferred authentication method
//
// If you prefer using a mnemonic, set a MNEMONIC environment variable
// to a valid mnemonic
const MNEMONIC = process.env.MNEMONIC

// If you prefer to be authenticated using a private key, set a PRIVATE_KEY environment variable
const PRIVATE_KEY = process.env.PRIVATE_KEY

const {
    POLYGONSCAN_API_KEY, // polygonscan API KEY
    OP_ETHERSCAN_API_KEY, // optimistic scan API KEY
    ARB_ETHERSCAN_API_KEY, // arbitrum scan API KEY
} = process.env

const accounts: HttpNetworkAccountsUserConfig | undefined = MNEMONIC
    ? { mnemonic: MNEMONIC }
    : PRIVATE_KEY
      ? [PRIVATE_KEY]
      : undefined

if (accounts == null) {
    console.warn(
        'Could not find MNEMONIC or PRIVATE_KEY environment variables. It will not be possible to execute transactions in your example.'
    )
}

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: '0.8.22',
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    networks: {
        arbitrumSepolia: {
            eid: EndpointId.ARBSEP_V2_TESTNET,
            url: process.env.ARBITRUM_SEPOLIA_RPC_URL,
            accounts,
        },
        optimismSepolia: {
            eid: EndpointId.OPTSEP_V2_TESTNET,
            url:
                process.env.OPTIMISM_SEPOLIA_RPC_URL,
            accounts,
        },
        amoy: {
            eid: EndpointId.AMOY_V2_TESTNET,
            url: process.env.POLYGON_AMOY_RPC_URL,
            accounts,
        },
    },
    namedAccounts: {
        deployer: {
            default: 0, // wallet address of index[0], of the mnemonic in .env
        },
    },
    verify: {
        etherscan: {
            apiKey: ARB_ETHERSCAN_API_KEY,
        },
    },
    etherscan: {
        enabled: true,
        apiKey: {
            arbSepolia: ARB_ETHERSCAN_API_KEY!,
            opSepolia: OP_ETHERSCAN_API_KEY!,
            amoy: POLYGONSCAN_API_KEY!,
        },
        customChains: [
            {
                network: 'opSepolia',
                chainId: 11155420,
                urls: {
                    apiURL: 'https://api-sepolia-optimistic.etherscan.io/api',
                    browserURL: 'https://sepolia-optimism.etherscan.io',
                },
            },
            {
                network: 'arbSepolia',
                chainId: 421614,
                urls: {
                    apiURL: 'https://api-sepolia.arbiscan.io/api',
                    browserURL: 'https://sepolia.arbiscan.io',
                },
            },
            {
                network: 'amoy',
                chainId: 80002,
                urls: {
                    apiURL: 'https://api-amoy.polygonscan.com/api',
                    browserURL: 'https://amoy.polygonscan.com',
                },
            },
        ],
    },
    sourcify: {
        enabled: false,
    },
}

export default config
