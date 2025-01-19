export const chains = [
    {
        name: "avalanche",
        chainId: 6,
        rpc: "https://api.avax.network/ext/bc/C/rpc",
        tokenBridge: "0x0e082F06FF657D94310cB8cE8B0D9a04541d8052",
        wormholeRelayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        wormhole: "0x54a8e5f9c4CbA08F9943965859F6c34eAF03E26c"
    },
    {
        name: "avalancheFuji",
        chainId: 6,
        rpc: "https://api.avax-test.network/ext/bc/C/rpc",
        tokenBridge: "0x61E44E506Ca5659E6c0bba9b678586fA2d729756",
        wormholeRelayer: "0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB",
        wormhole: "0x7bbcE28e64B3F8b84d876Ab298393c38ad7aac4C"
    },
    {
        name: "celoAlfajores",
        chainId: 14,
        rpc: "https://alfajores-forno.celo-testnet.org",
        tokenBridge: "0x05ca6037eC51F8b712eD2E6Fa72219FEaE74E153",
        wormholeRelayer: "0x306B68267Deb7c5DfCDa3619E22E9Ca39C374f84",
        wormhole: "0x88505117CA88e7dd2eC6EA1E13f0948db2D50D56"
    },
    {
        name: "celo",
        chainId: 14,
        rpc: "https://alfajores-forno.celo.org",
        tokenBridge: "0x796Dff6D74F3E27060B71255Fe517BFb23C93eed",
        wormholeRelayer: "0x27428DD2d3DD32A4D7f7C497eAaa23130d894911",
        wormhole: "0x796Dff6D74F3E27060B71255Fe517BFb23C93eed"
    }
]
