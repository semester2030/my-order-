/**
 * Script to generate bcrypt hash for test customer PIN
 * Usage: npx ts-node src/modules/auth/scripts/generate-customer-pin-hash.ts
 */

import * as bcrypt from 'bcrypt';

async function generatePinHash() {
  const pin = '1234';
  const saltRounds = 10;
  
  const hash = await bcrypt.hash(pin, saltRounds);
  
  console.log('='.repeat(60));
  console.log('Test Customer PIN Hash Generator');
  console.log('='.repeat(60));
  console.log(`PIN: ${pin}`);
  console.log(`Salt Rounds: ${saltRounds}`);
  console.log(`Hash: ${hash}`);
  console.log('='.repeat(60));
  console.log('\nSQL UPDATE statement:');
  console.log(`UPDATE users SET pin_hash = '${hash}', updated_at = NOW() WHERE phone = '0500756706' OR phone = '+966500756706';`);
  console.log('='.repeat(60));
}

generatePinHash().catch(console.error);
