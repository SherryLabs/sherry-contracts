import { encodePacked, parseEther } from 'viem';

/**
 * Debug helper to analyze swap parameters before sending the transaction
 * @param tokenAddress Token address to receive
 * @param recipientAddress Address that will receive tokens
 * @param amountInEther Amount of native token in ETH/MONAD units
 */
export function debugSwapParameters(
  tokenAddress: string,
  recipientAddress: string,
  amountInEther: string = "0.1"
) {
  // Validate addresses
  if (!tokenAddress.startsWith('0x') || tokenAddress.length !== 42) {
    console.error('❌ Invalid token address format:', tokenAddress);
  }
  
  if (!recipientAddress.startsWith('0x') || recipientAddress.length !== 42) {
    console.error('❌ Invalid recipient address format:', recipientAddress);
  }

  // Convert amount
  const amountInWei = parseEther(amountInEther);
  const deadline = BigInt(Math.floor(Date.now() / 1000) + 3600);
  
  try {
    // Encode route parameter
    const routeEncoded = encodePacked(
      ['address', 'uint32', 'address'],
      [
        '0x0000000000000000000000000000000000000000',
        50331648, // uint32((3 << 24) | (0 << 16) | 0)
        tokenAddress as `0x${string}`
      ]
    );
    
    // Print detailed information
    console.log('===== SWAP PARAMETERS ANALYSIS =====');
    console.log('Router Address: 0x1b1f2Bfc5e551b955F2a3F973876cEE917FB4d05');
    console.log('\n1. ROUTE ENCODING:');
    console.log('- Native token address: 0x0000000000000000000000000000000000000000');
    console.log('- Path type uint32:', 50331648, '(decoded: 3 << 24 | 0 << 16 | 0)');
    console.log('- Target token:', tokenAddress);
    console.log('- Encoded route (hex):', routeEncoded);
    console.log('- Route byte length:', routeEncoded.length, 'bytes');
    
    console.log('\n2. VALUE AND AMOUNT PARAMETERS:');
    console.log('- amountIn (wei):', amountInWei.toString());
    console.log('- amountIn (MONAD):', amountInEther);
    console.log('- value to send (wei):', amountInWei.toString());
    console.log('- value to send (MONAD):', amountInEther);
    
    console.log('\n3. OTHER PARAMETERS:');
    console.log('- minAmountOut:', '0');
    console.log('- deadline (timestamp):', deadline.toString());
    console.log('- deadline (date):', new Date(Number(deadline) * 1000).toLocaleString());
    console.log('- recipient:', recipientAddress);
    console.log('- msgSender:', recipientAddress);
    
    console.log('\n4. FULL ARGUMENTS ARRAY:');
    const args = [
      routeEncoded,
      recipientAddress,
      amountInWei,
      0n, // minAmountOut
      deadline,
      recipientAddress
    ];
    console.log(args);
    
    console.log('\n5. COMMON ERRORS AND SOLUTIONS:');
    console.log('- If "invalid BigNumber value" error, check that amountIn matches the value sent');
    console.log('- If "transaction failed" with no specific error, check that router has approval');
    console.log('- If "insufficient allowance" error, you need to approve tokens first');
    console.log('==============================');
    
    return {
      routeEncoded,
      args,
      amountInWei
    };
  } catch (error) {
    console.error('❌ Error encoding parameters:', error);
    throw error;
  }
}

// Add this to your frontend code
export function compareWithBackendRoute(frontendRoute: string, backendRoute: string) {
  console.log('===== ROUTE COMPARISON =====');
  console.log('Frontend route length:', frontendRoute.length);
  console.log('Backend route length:', backendRoute.length);
  
  if (frontendRoute === backendRoute) {
    console.log('✅ Routes match exactly!');
    return;
  }
  
  console.log('❌ Routes do NOT match');
  
  // Compare each character to find differences
  let differences = 0;
  for (let i = 0; i < Math.max(frontendRoute.length, backendRoute.length); i++) {
    if (frontendRoute[i] !== backendRoute[i]) {
      console.log(`Difference at position ${i}:`, {
        frontend: frontendRoute[i] || 'missing',
        backend: backendRoute[i] || 'missing'
      });
      differences++;
      if (differences > 10) {
        console.log('Too many differences, stopping comparison');
        break;
      }
    }
  }
  
  console.log('=========================');
}
