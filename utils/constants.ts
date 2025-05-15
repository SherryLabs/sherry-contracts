import { avalanche, avalancheFuji, sepolia } from "viem/chains";

export type ContractName =
  | "TRADER_JOE_ROUTER"
  | "UNISWAP_ROUTER"
  | "PANGOLIN_V2_ROUTER";

export const CONTRACT_ADDRESSES: Record<ContractName, Partial<Record<number, string>>> = {
  TRADER_JOE_ROUTER: {
    [avalanche.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
    [avalancheFuji.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
  },
  PANGOLIN_V2_ROUTER: {
    [avalanche.id]: "0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106", // PangolinRouter v2
    [avalancheFuji.id]: "0x2D99ABD9008Dc933ff5c0CD271B88309593aB921", // PangolinRouter v2
  },
  UNISWAP_ROUTER: {
    [avalanche.id]: "0x94b75331ae8d42c1b61065089b7d48fe14aa73b7", // Universal Router
    [sepolia.id]: "0x3a9d48ab9751398bbfa63ad67599bb04e4bdf98b", // Universal Router
  },
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

