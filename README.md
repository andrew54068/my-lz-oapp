<p align="center">
  <a href="https://layerzero.network">
    <img alt="LayerZero" style="width: 400px" src="https://docs.layerzero.network/img/LayerZero_Logo_White.svg"/>
  </a>
</p>

<p align="center">
  <a href="https://layerzero.network" style="color: #a77dff">Homepage</a> | <a href="https://docs.layerzero.network/" style="color: #a77dff">Docs</a> | <a href="https://layerzero.network/developers" style="color: #a77dff">Developers</a>
</p>

<h1 align="center">OApp Example</h1>

<p align="center">
  <a href="https://docs.layerzero.network/contracts/oapp" style="color: #a77dff">Quickstart</a> | <a href="https://docs.layerzero.network/contracts/oapp-configuration" style="color: #a77dff">Configuration</a> | <a href="https://docs.layerzero.network/contracts/options" style="color: #a77dff">Message Execution Options</a> | <a href="https://docs.layerzero.network/contracts/endpoint-addresses" style="color: #a77dff">Endpoint Addresses</a>
</p>

<p align="center">Template project for getting started with LayerZero's  <code>OApp</code> contract development.</p>

## 1) Developing Contracts

#### Installing dependencies

We recommend using `pnpm` as a package manager (but you can of course use a package manager of your choice):

```bash
yarn install
```

#### Compiling your contracts

This project supports both `hardhat` and `forge` compilation. By default, the `compile` command will execute both:

```bash
yarn run compile
```

## 2) Deploying Contracts

Set up deployer wallet/account:

- Rename `.env.example` -> `.env`
- Choose your preferred means of setting up your deployer wallet/account:

```
MNEMONIC="test test test test test test test test test test test junk"
or...
PRIVATE_KEY="0xabc...def"

POLYGONSCAN_API_KEY=
OP_ETHERSCAN_API_KEY=
ARB_ETHERSCAN_API_KEY=
```

To deploy your contracts to your desired blockchains, run the following command in your project's folder:

```bash
npx hardhat lz:deploy --tags MyOApp
```

The above command will execute the `deploy/MyOApp.ts` to deploy contract and verify it base on the `networks` setting of `hardhat.config.ts`

### To only verify contract in case of error occurred
```shell
npx hardhat run deploy/verifyContract.ts --network amoy
```

## 3) Wiring Pathways
[more detail](https://docs.layerzero.network/v2/developers/evm/create-lz-oapp/wiring#checking-setpeers)

make sure you set the `connections` correctly in `layerzero.config.ts`

```typescript
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
```

#### Set up the `peer` address for your OApp:
```shell
npx hardhat lz:oapp:wire --oapp-config layerzero.config.ts
```

#### Checking setPeers
```shell
npx hardhat lz:oapp:peers:get --oapp-config layerzero.config.ts
```

#### Checking Pathway
```shell
npx hardhat lz:oapp:config:get --oapp-config layerzero.config.ts
```

#### Send Message From A chain to B chain
```shell
source .env

forge script script/BatchSend.s.sol:SendBatchMessage -vvvv --broadcast --rpc-url arbitrumSepolia --sig "run(address)" -- 0xEBEBaA535eECC0De6B5467AcacC752708Cf3050B
```

## Results

### 1) Send Plain Message 
***Sepolia Arbitrum → Amoy***

```shell
forge script script/BatchSend.s.sol:SendBatchMessage -vvvv --broadcast --rpc-url arbitrumSepolia --sig "run(address)" -- 0xEBEBaA535eECC0De6B5467AcacC752708Cf3050B
```
#### Tx
https://testnet.layerzeroscan.com/tx/0x82beb55088c59d455da7621904dfec557ce9602ee0946bfd040663f5a98c89ef

#### Fee
In Tx Value: 0.027079337675290886 ETH\
Transaction Fee: 0.0001699314 ETH\
Total: 0.027249269075291 ETH (90u)

### 2) Send Ordered Message 
***Sepolia Optimism → Amoy***

```shell
forge script script/BatchOrderedSend.s.sol:SendBatchMessage -vvvv --broadcast --rpc-url optimismSepolia --sig "run()"
```
#### Tx
https://testnet.layerzeroscan.com/tx/0xdb6167547fe887bb02bfa6a516dab4ebdd6f1b5680b8fd11f796881590f11b5a

#### Fee
In Tx Value: 0.000120966573089438 ETH\
Transaction Fee: 0.00000253536904193 ETH\
Total: 0.000123501942131 ETH (0.41u)

### 3) Bridge Token With Message
***Sepolia Arbitrum -> Sepolia Optimism***
```shell
forge script script/SwapToken.s.sol:SwapToken -vvvv --broadcast --rpc-url arbitrumSepolia --sig "run()"
```

#### Discovery
- The `lzCompose` of `ComposerReceiverAMM.sol` will not be executed with `lzReceive` of `OAppReceiver` in the same tx, but the following tx (might in different block).
See [Lz Receive](https://sepolia-optimism.etherscan.io/tx/0x90ecdc62b992e580eec1f086650064274acb225ff69727c6025c8a1b442e1d99) and [Lz Compose](https://sepolia-optimism.etherscan.io/tx/0x90ecdc62b992e580eec1f086650064274acb225ff69727c6025c8a1b442e1d99) for instance.
- No need to set peers for Composer
- If the compose tx will fail, it will be a tx with alert event instead. [ref](https://sepolia-optimism.etherscan.io/tx/0x536c06a873b7e8d48f77c5649a08b2d333952f3a0a1a651e7316ad20b60cc22f), and it will retry multiple times [here](https://sepolia-optimism.etherscan.io/tx/0x31d5cc497d594a5b6c1f213739edc616c16ee188f5074f0ee03382d9e2858f8c), [here](https://sepolia-optimism.etherscan.io/tx/0xafe292bdfafe31fd38f4da4671a23a94ce5d87f31a42a41a6caf7fc72bca1385), [here](https://sepolia-optimism.etherscan.io/tx/0x2c9e8be48c5278e84e8d7d2d2e1fcbc7dffd39526fc37b0f63e25b46c23e527e)

#### Tx
https://testnet.layerzeroscan.com/tx/0xa03e859bea6aa51c8b8a2b6c874291748bdf09eb3c377d1122242f0b2f6ec4cc

#### Fee
In Tx Value: 0.001069370498620569 ETH\
Transaction Fee: 0.0001124491 ETH\
Total: 0.001181819598621 ETH (3.48u)