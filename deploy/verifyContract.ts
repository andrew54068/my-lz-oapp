import '@nomicfoundation/hardhat-verify'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import * as hre from 'hardhat'
import { verify } from './verify'

const main = async () => {
    const { getNamedAccounts } = hre

    const { deployer } = await getNamedAccounts()

    console.log(`Network: ${hre.network.name}`)
    console.log(`Deployer: ${deployer}`)

    const endpointV2Deployment = await hre.deployments.get('EndpointV2')

    const args: any[] = [
        endpointV2Deployment.address, // LayerZero's EndpointV2 address
        deployer, // owner
    ]
    await verify(hre, '0x143c2Ad2E9BFa8D8d477F68BE32202b56a83d1aF', args)
}

main()
