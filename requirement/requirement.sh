#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unable to detect the distribution."
    exit 1
fi

install_debian_based()
{
    echo "Debian/Ubuntu distribution detected. Installing build-essential..."
    sudo apt-get update
    sudo apt-get install -y build-essential
}

install_redhat_based()
{
    echo "Red Hat-based distribution detected. Installing build-essential..."
    sudo dnf groupinstall "Development Tools" -y
}

install_arch_based()
{
    echo "Arch-based distribution detected. Installing build-essential..."
    sudo pacman -S base-devel --noconfirm
}

install_opensuse_based()
{
    echo "openSUSE detected. Installing build-essential..."
    sudo zypper install -y -t pattern devel_basis
}

install_alpine_based()
{
    echo "Alpine Linux detected. Installing build-essential..."
    sudo apk add build-base
}

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
