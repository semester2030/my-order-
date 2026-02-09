// Quick setup check script
const { execSync } = require('child_process');

console.log('🔍 Checking setup...\n');

// Check PostgreSQL
try {
  const pgCheck = execSync('pg_isready', { encoding: 'utf-8' });
  console.log('✅ PostgreSQL:', pgCheck.trim());
} catch (e) {
  console.log('❌ PostgreSQL: Not running');
}

// Check Node version
try {
  const nodeVersion = execSync('node -v', { encoding: 'utf-8' });
  console.log('✅ Node.js:', nodeVersion.trim());
} catch (e) {
  console.log('❌ Node.js: Not found');
}

// Check database
try {
  const dbCheck = execSync('psql -l | grep customer_app', { encoding: 'utf-8' });
  if (dbCheck.trim()) {
    console.log('✅ Database: customer_app exists');
  } else {
    console.log('⚠️  Database: customer_app not found');
    console.log('   Run: createdb customer_app');
  }
} catch (e) {
  console.log('⚠️  Database: Could not check (may need to create)');
  console.log('   Run: createdb customer_app');
}

console.log('\n📋 Next steps:');
console.log('1. createdb customer_app');
console.log('2. npm run migration:generate -- src/migrations/InitialMigration');
console.log('3. npm run migration:run');
