import { avalanche, avalancheFuji, sepolia } from "viem/chains";


type ContractName =
  | "TRADER_JOE_ROUTER"
  | "UNISWAP_ROUTER"
  | "PANGOLIN_V2_ROUTER"
  | "ARENA_SWAP_ROUTER"
  | "SHERRY_FUNDATION_ADDRESS"
  | "SHERRY_TREASURY_ADDRESS";

const CONTRACT_ADDRESSES: Record<ContractName, Partial<Record<number, string>>> = {
  TRADER_JOE_ROUTER: {
    [avalanche.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
    [avalancheFuji.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
  },
  PANGOLIN_V2_ROUTER: {
    [avalanche.id]: "0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106", // PangolinRouter v2
    [avalancheFuji.id]: "0x688d21b0B8Dc35971AF58cFF1F7Bf65639937860", // PangolinRouter v2
  },
  UNISWAP_ROUTER: {
    [avalanche.id]: "0x94b75331ae8d42c1b61065089b7d48fe14aa73b7", // Universal Router
    [sepolia.id]: "0x3a9d48ab9751398bbfa63ad67599bb04e4bdf98b", // Universal Router
  },
  ARENA_SWAP_ROUTER: {
    [avalanche.id]: "0xF56D524D651B90E4B84dc2FffD83079698b9066E", // Arena Swap Router
  },
  SHERRY_FUNDATION_ADDRESS: {
    [avalancheFuji.id]: '0x23e5Cb3118106736277Bc1C2b5F7f8B83411409b',
  },
  SHERRY_TREASURY_ADDRESS: {
    [avalancheFuji.id]: '0xfE5E335363f0B95e5Ce15040976c6Cbab331491a',
  }
}

/**
 * Helper to get a contract address for a specific chain.
 * Throws an error if the address is not found.
 * @param contractName The name of the contract.
 * @param chainId The ID of the chain.
 * @returns The contract address.
 */
export function getContractAddress(
  contractName: ContractName,
  chainId: number
): string {
  const address = CONTRACT_ADDRESSES[contractName]?.[chainId];
  if (!address) {
    throw new Error(
      `Address for contract ${contractName} on ChainId ${chainId} not found.`
    );
  }
  return address;
}

