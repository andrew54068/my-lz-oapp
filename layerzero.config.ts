import { EndpointId } from '@layerzerolabs/lz-definitions'

import type { OAppOmniGraphHardhat, OmniPointHardhat } from '@layerzerolabs/toolbox-hardhat'

// const contractName = 'MyOApp'
// const contractName = 'MyOrderedOApp'
const contractName = 'StargateOApp'

const optimismSepoliaContract: OmniPointHardhat = {
    eid: EndpointId.OPTSEP_V2_TESTNET,
    contractName,
}

const arbitrumSepoliaContract: OmniPointHardhat = {
    eid: EndpointId.ARBSEP_V2_TESTNET,
    contractName,
}

const amoyContract: OmniPointHardhat = {
    eid: EndpointId.AMOY_V2_TESTNET,
    contractName,
}

const config: OAppOmniGraphHardhat = {
    contracts: [
        {
            contract: optimismSepoliaContract,
        },
        {
            contract: arbitrumSepoliaContract,
        },
        {
            contract: amoyContract,
        },
    ],
    connections: [
        {
            from: arbitrumSepoliaContract,
            to: amoyContract,
        },
        {
            from: amoyContract,
            to: arbitrumSepoliaContract,
        },
        {
            from: optimismSepoliaContract,
            to: amoyContract,
        },
        {
            from: amoyContract,
            to: optimismSepoliaContract,
        },
        {
            from: arbitrumSepoliaContract,
            to: optimismSepoliaContract,
        },
    ],
}

export default config
