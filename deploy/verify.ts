import '@nomicfoundation/hardhat-verify'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

export const verify = async (
    hre: HardhatRuntimeEnvironment,
    address: string,
    constructorArguments: any[],
    retry: number = 0
) => {
    try {
        await hre.run('verify:verify', {
            address: address,
            constructorArguments,
        })
    } catch (error: any) {
        if (retry >= 3) {
            throw error
        }
        if (error.message.includes('does not have bytecode.')) {
            await verify(hre, address, constructorArguments, retry + 1)
        }
    }
}

export default verify