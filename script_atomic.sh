#!/bin/bash

# Set strict error handling
set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install PowerShell using snap
echo "Installing PowerShell..."
snap install powershell --classic

# Wait a moment for PowerShell to be properly installed
sleep 2

# Run Atomic Red Team installation commands
echo "Installing Atomic Red Team..."
pwsh -Command "IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1'); Install-AtomicRedTeam"

echo "Installing Atomic Red Team tests..."
pwsh -Command "IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1'); Install-AtomicRedTeam -getAtomics -Force"

echo "Installation completed!"