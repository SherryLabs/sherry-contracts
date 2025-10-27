import {
    base,
    baseSepolia,
    avalanche,
    avalancheFuji,
    celo,
    celoAlfajores,
    sepolia,
    mainnet,
    somniaTestnet,
} from "viem/chains";
import { defineChain } from "viem";

export const somnia = defineChain({
  id: 5031,
  name: "Somnia Mainnet",
  nativeCurrency: { name: "ST", symbol: "ST", decimals: 18 },
  rpcUrls: {
    default: {
      http: ["https://somnia-rpc.publicnode.com"],
    },
  },
  blockExplorers: {
    default: {
      name: "Somnia Explorer",
      url: "https://explorer.somnia.network/",
      apiUrl: "https://explorer.somnia.network/api",
    },
  },
  contracts: {
    multicall3: {
      address: "0x841b8199E6d3Db3C6f264f6C2bd8848b3cA64223",
      blockCreated: 71314235,
    },
  },
  testnet: false,
});

/* * This file contains the configuration for different blockchain networks.
 * Each network is represented as an object with properties such as name, chainIdWh,
 * chainId, rpc URL, tokenBridge address, wormholeRelayer address, and wormhole a.k.a Core address.
 * The configuration is used to interact with the respective blockchain networks
 * and deploy contracts on them.
 */
export const chains = [
    {
        name: "avalanche",
        chainIdWh: 6,
        chainId: avalanche.id,
        rpc: avalanche.rpcUrls.default.http[0],
        tokenBridge: "0x0e082F06FF657D94310cB8cE8B0D9a04541d8052",
        wormholeRelayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        wormhole: "0x54a8e5f9c4CbA08F9943965859F6c34eAF03E26c",
        mainnet: true
    },
    {
        name: "avalancheFuji",
        chainIdWh: 6,
        chainId: avalancheFuji.id,
        rpc: avalancheFuji.rpcUrls.default.http[0],
        tokenBridge: "0x61E44E506Ca5659E6c0bba9b678586fA2d729756",
        wormholeRelayer: "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB",
        wormhole: "0x7bbcE28e64B3F8b84d876Ab298393c38ad7aac4C",
        mainnet: false
    },
    {
        name: "base",
        chainIdWh: 8453,
        chainId: base.id,
        rpc: base.rpcUrls.default.http[0],
        wormhole: "0xbebdb6C8ddC678FfA9f8748f85C815C556Dd8ac6",
        tokenBridge: "0x8d2de8d2f73F1F4cAB472AC9A881C9b123C79627",
        wormholeRelayer: "0x706f82e9bb5b0813501714ab5974216704980e31",
        mainnet: true
    },
    {
        name: "baseSepolia",
        chainIdWh: 10004,
        chainId: baseSepolia.id,
        rpc: baseSepolia.rpcUrls.default.http[0],
        wormhole: "0x79A1027a6A159502049F10906D333EC57E95F083",
        tokenBridge: "0x86F55A04690fd7815A3D802bD587e83eA888B239",
        wormholeRelayer: "0x93BAD53DDfB6132b0aC8E37f6029163E63372cEE",
        mainnet: false
    },
    {
        name: "mainnet",
        chainIdWh: 2,
        chainId: mainnet.id,
        rpc: mainnet.rpcUrls.default.http[0],
        wormhole: "0x98f3c9e6E3fAce36bAAd05FE09d375Ef1464288B",
        tokenBridge: "0x3ee18B2214AFF97000D974cf647E7C347E8fa585",
        wormholeRelayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        mainnet: true
    },
    {
        name: "sepolia",
        chainIdWh: 10002,
        chainId: sepolia.id,
        rpc: sepolia.rpcUrls.default.http[0],
        wormhole: "0x4a8bc80Ed5a4067f1CCf107057b8270E0cC11A78",
        tokenBridge: "0xDB5492265f6038831E89f495670FF909aDe94bd9",
        wormholeRelayer: "0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470",
        mainnet: false
    },
    {
        name: "celo",
        chainIdWh: 14,
        chainId: celo.id,
        rpc: celo.rpcUrls.default.http[0],
        wormhole: "0x796Dff6D74F3E27060B71255Fe517BFb23C93eed",
        tokenBridge: "0x796Dff6D74F3E27060B71255Fe517BFb23C93eed",
        wormholeRelayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        mainnet: true
    },
    {
        name: "celoAlfajores",
        chainIdWh: 14,
        chainId: celoAlfajores.id,
        rpc: celoAlfajores.rpcUrls.default.http[0],
        wormhole: "0x88505117CA88e7dd2eC6EA1E13f0948db2D50D56",
        tokenBridge: "0x05ca6037eC51F8b712eD2E6Fa72219FEaE74E153",
        wormholeRelayer: "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84",
        mainnet: false
    },
    {
        name: "somnia",
        chainIdWh: 25,
        chainId: somnia.id,
        rpc: somnia.rpcUrls.default.http[0],
        wormhole: "0x1C6f653d3A5A9b13D4b4E3b3E2EAAe8dBf2bF051",
    },
    {
        name: "somniaTestnet",
        chainIdWh: 10025,
        chainId: somniaTestnet.id,
        rpc: somniaTestnet.rpcUrls.default.http[0],
        wormhole: "0x1234567890abcdef1234567890abcdef12345678",
        tokenBridge: "0x1234567890abcdef1234567890abcdef12345678",
        wormholeRelayer: "0x1234567890abcdef1234567890abcdef12345678",
        mainnet: false
    }
];



