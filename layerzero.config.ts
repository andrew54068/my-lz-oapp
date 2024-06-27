import { EndpointId } from '@layerzerolabs/lz-definitions'

import type { OAppOmniGraphHardhat, OmniPointHardhat } from '@layerzerolabs/toolbox-hardhat'

const optimismSepolia2Contract: OmniPointHardhat = {
    eid: EndpointId.OPTSEP_V2_TESTNET,
    contractName: 'MyOApp',
}

const arbitrumSepolia2Contract: OmniPointHardhat = {
    eid: EndpointId.ARBSEP_V2_TESTNET,
    contractName: 'MyOApp',
}

const amoyContract: OmniPointHardhat = {
    eid: EndpointId.AMOY_V2_TESTNET,
    contractName: 'MyOApp',
}

const config: OAppOmniGraphHardhat = {
    contracts: [
        {
            contract: optimismSepolia2Contract,
        },
        {
            contract: arbitrumSepolia2Contract,
        },
        {
            contract: amoyContract,
        },
    ],
    connections: [
        {
            from: arbitrumSepolia2Contract,
            to: amoyContract,
        },
        {
            from: amoyContract,
            to: arbitrumSepolia2Contract,
        },
    ],
}

export default config
