import { createKolRouter } from './functions';
import { createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { avalanche } from 'viem/chains';

async function main() {
    const privateKey = process.env.DEPLOYER_KEY as string;
    const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
    // Initialize clients
    // ---------------------------------------------------------------------
    const walletClient = createWalletClient({
        account,
        chain: avalanche,
        transport: http(),
    });

    await createKolRouter(account.address, walletClient);
}

main().catch((error) => {
    console.error('Error in script:', error);
});
