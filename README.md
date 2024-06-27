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