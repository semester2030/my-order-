#!/bin/bash
# Script to kill process on port 3000

echo "Finding process on port 3000..."
PID=$(lsof -ti:3000)

if [ -z "$PID" ]; then
  echo "No process found on port 3000"
else
  echo "Killing process $PID on port 3000..."
  kill -9 $PID
  echo "Process killed successfully!"
fi
