import '@nomicfoundation/hardhat-verify'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

export const verify = async (
    hre: HardhatRuntimeEnvironment,
    address: string,
    constructorArguments: any[],
    retry: number = 0
) => {
    console.log(`Verifying contract at address: ${address}`);
    try {
        await hre.run('verify:verify', {
            address: address,
            constructorArguments,
        })
    } catch (error: any) {
        if (retry >= 5) {
            throw error
        }
        if (error.message.includes('does not have bytecode.')) {
            // wait 2 second
            await new Promise((resolve) => setTimeout(resolve, 2000))
            await verify(hre, address, constructorArguments, retry + 1)
        }
    }
}

export default verify