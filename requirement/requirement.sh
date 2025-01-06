#!/bin/bash

# Detect the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unable to detect the distribution."
    exit 1
fi

# Installation function for Debian/Ubuntu-based distributions
install_debian_based() {
    echo "Debian/Ubuntu distribution detected. Installing build-essential..."
    sudo apt-get update
    sudo apt-get install -y build-essential
}

# Installation function for Red Hat-based distributions (RHEL, CentOS, Fedora)
install_redhat_based() {
    echo "Red Hat-based distribution detected. Installing build-essential..."
    sudo dnf groupinstall "Development Tools" -y  # For Fedora and CentOS/RHEL 8+
    # For older versions of RHEL/CentOS, use:
    # sudo yum groupinstall "Development Tools" -y
}

# Installation function for Arch-based distributions
install_arch_based() {
    echo "Arch-based distribution detected. Installing build-essential..."
    sudo pacman -S base-devel --noconfirm
}

# Installation function for openSUSE-based distributions
install_opensuse_based() {
    echo "openSUSE detected. Installing build-essential..."
    sudo zypper install -y -t pattern devel_basis
}

# Installation function for Alpine Linux-based distributions
install_alpine_based() {
    echo "Alpine Linux detected. Installing build-essential..."
    sudo apk add build-base
}

# Check the distribution and call the appropriate installation function
case $DISTRO in
    debian|ubuntu)
        install_debian_based
        ;;
    fedora|centos|rhel)
        install_redhat_based
        ;;
    arch)
        install_arch_based
        ;;
    opensuse)
        install_opensuse_based
        ;;
    alpine)
        install_alpine_based
        ;;
    *)
        echo "Unsupported distribution for installing build-essential."
        exit 1
        ;;
esac

echo "All required packages have been installed."
