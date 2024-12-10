#!/bin/bash

# Set strict error handling
set -euo pipefail
IFS=$'\n\t'

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
}

# Function to check system requirements
check_requirements() {
    local requirements=(wget curl git powershell)
    
    for req in "${requirements[@]}"; do
        if ! command -v "$req" &> /dev/null; then
            echo "Installing $req..."
            apt-get install -y "$req"
        fi
    done
}

# Function to install PowerShell if not present
install_powershell() {
    if ! command -v pwsh &> /dev/null; then
        echo "Installing PowerShell..."
        # Download the Microsoft repository GPG keys
        wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
        
        # Register the Microsoft repository GPG keys
        dpkg -i packages-microsoft-prod.deb
        
        # Update package list
        apt-get update
        
        # Install PowerShell
        sudo snap install powershell --classic
        
    fi
}

# Function to install Atomic Red Team
install_atomic_red_team() {
    echo "Installing Atomic Red Team..."
    
    # Create installation directory
    local install_dir="/opt/atomic-red-team"
    mkdir -p "$install_dir"
    
    # Set proper permissions
    chmod 750 "$install_dir"
    
    # Download and execute the installation script in PowerShell
    pwsh -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex (iwr 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics"
    
    # Verify installation
    if pwsh -Command "Get-Module -ListAvailable -Name 'invoke-atomicredteam'"; then
        echo "Atomic Red Team installed successfully!"
    else
        echo "Installation failed!"
        exit 1
    fi
}

# Main function
main() {
    # Check if running as root
    check_root
    
    # Update system
    apt-get update
    
    # Check and install requirements
    check_requirements
    
    # Install PowerShell
    install_powershell
    
    # Install Atomic Red Team
    install_atomic_red_team
    
    echo "Installation completed successfully!"
}

# Execute main function
main "$@"

