#!/bin/bash

# Update package list and install build-essential for gcc and make
sudo apt-get update
sudo apt-get install -y build-essential

# Print success message
echo "All required packages have been installed."