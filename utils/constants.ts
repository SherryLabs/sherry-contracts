import { avalanche, avalancheFuji, sepolia } from "viem/chains";

export type ContractName =
  | "TRADER_JOE_ROUTER"
  | "UNISWAP_ROUTER";

export const CONTRACT_ADDRESSES: Record<ContractName, Partial<Record<number, string>>> = {
  TRADER_JOE_ROUTER: {
    [avalanche.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
    [avalancheFuji.id]: "0x18556DA13313f3532c54711497A8FedAC273220E", // LBRouter v2.2
  },
  UNISWAP_ROUTER: {
    [avalanche.id]: "0x94b75331ae8d42c1b61065089b7d48fe14aa73b7", // Universal Router
    [sepolia.id]: "0x3a9d48ab9751398bbfa63ad67599bb04e4bdf98b", // Universal Router
  },
}

/**
 * Helper para obtener la dirección de un contrato para una cadena específica.
 * Lanza un error si la dirección no se encuentra.
 * @param contractName El nombre del contrato.
 * @param chainId El ID de la cadena.
 * @returns La dirección del contrato.
 */
export function getContractAddress(
  contractName: ContractName,
  chainId: number
): string {
  const address = CONTRACT_ADDRESSES[contractName]?.[chainId];
  if (!address) {
    throw new Error(
      `Dirección para el contrato ${contractName} en la ChainId ${chainId} no encontrada.`
    );
  }
  return address;
}
