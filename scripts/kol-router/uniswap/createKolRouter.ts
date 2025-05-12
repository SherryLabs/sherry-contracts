import { createKolRouter } from './functions';
import { createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { avalanche } from 'viem/chains';

async function main() {
    const privateKey = process.env.DEPLOYER_KEY as string;
    const account = privateKeyToAccount(`0x${privateKey.slice(2)}`);
    const fee = "20000000000000";
    // Initialize clients
    // ---------------------------------------------------------------------
    const walletClient = createWalletClient({
        account,
        chain: avalanche,
        transport: http(),
    });

    await createKolRouter(account.address, fee, walletClient);
}

main().catch((error) => {
    console.error('Error in script:', error);
});
