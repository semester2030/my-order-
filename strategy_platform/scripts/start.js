#!/usr/bin/env node
const { spawn } = require('child_process')

const port = process.env.PORT || '3003'
const child = spawn(process.platform === 'win32' ? 'npx.cmd' : 'npx', ['next', 'start', '-H', '0.0.0.0', '-p', port], {
  stdio: 'inherit',
  env: process.env,
})

child.on('exit', (code) => process.exit(code ?? 1))
process.on('SIGTERM', () => child.kill('SIGTERM'))
process.on('SIGINT', () => child.kill('SIGINT'))
