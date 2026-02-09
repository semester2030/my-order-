// Script to create database using Node.js
const { execSync } = require('child_process');
const { Client } = require('pg');

async function createDatabase() {
  console.log('🔍 Attempting to create database...\n');

  // Try using createdb command first
  try {
    execSync('createdb customer_app', { stdio: 'inherit' });
    console.log('✅ Database created successfully using createdb');
    return;
  } catch (e) {
    console.log('⚠️  createdb failed, trying direct connection...');
  }

  // Try direct PostgreSQL connection
  try {
    const client = new Client({
      host: 'localhost',
      port: 5432,
      user: 'postgres',
      database: 'postgres', // Connect to default database
    });

    await client.connect();
    console.log('✅ Connected to PostgreSQL');

    // Check if database exists
    const result = await client.query(
      "SELECT 1 FROM pg_database WHERE datname = 'customer_app'"
    );

    if (result.rows.length > 0) {
      console.log('✅ Database customer_app already exists');
    } else {
      await client.query('CREATE DATABASE customer_app');
      console.log('✅ Database customer_app created successfully');
    }

    await client.end();
  } catch (e) {
    console.log('❌ Error:', e.message);
    console.log('\n📋 Please run manually:');
    console.log('   createdb customer_app');
  }
}

createDatabase();
