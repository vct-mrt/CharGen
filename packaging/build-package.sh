#!/bin/bash
# Build script for creating packages for different distributions

set -e

VERSION="1.0.0"
PKGNAME="chargen"
BUILD_DIR="build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to create source tarball
create_tarball() {
    echo_info "Creating source tarball..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    # Create a clean copy for packaging
    git archive --format=tar.gz --prefix="${PKGNAME}-${VERSION}/" HEAD > "$BUILD_DIR/${PKGNAME}-${VERSION}.tar.gz"
    
    echo_info "Tarball created: $BUILD_DIR/${PKGNAME}-${VERSION}.tar.gz"
}

# Function to build Debian package
build_deb() {
    echo_info "Building Debian package..."
    
    if ! command -v dpkg-buildpackage &> /dev/null; then
        echo_error "dpkg-buildpackage not found. Install with: sudo apt install build-essential devscripts"
        return 1
    fi
    
    # Create debian directory in project root
    cp -r packaging/debian .
    
    # Build package
    dpkg-buildpackage -us -uc -b
    
    # Move packages to build directory
    mkdir -p "$BUILD_DIR/deb"
    mv ../*.deb "$BUILD_DIR/deb/" 2>/dev/null || true
    mv ../*.changes "$BUILD_DIR/deb/" 2>/dev/null || true
    mv ../*.buildinfo "$BUILD_DIR/deb/" 2>/dev/null || true
    
    # Cleanup
    rm -rf debian
    
    echo_info "Debian package built successfully in $BUILD_DIR/deb/"
}

# Function to build RPM package
build_rpm() {
    echo_info "Building RPM package..."
    
    if ! command -v rpmbuild &> /dev/null; then
        echo_error "rpmbuild not found. Install with: sudo dnf install rpm-build"
        return 1
    fi
    
    # Setup RPM build environment
    mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
    
    # Copy tarball and spec file
    cp "$BUILD_DIR/${PKGNAME}-${VERSION}.tar.gz" ~/rpmbuild/SOURCES/
    cp packaging/chargen.spec ~/rpmbuild/SPECS/
    
    # Build RPM
    rpmbuild -ba ~/rpmbuild/SPECS/chargen.spec
    
    # Copy built packages
    mkdir -p "$BUILD_DIR/rpm"
    cp ~/rpmbuild/RPMS/*/*.rpm "$BUILD_DIR/rpm/" 2>/dev/null || true
    cp ~/rpmbuild/SRPMS/*.rpm "$BUILD_DIR/rpm/" 2>/dev/null || true
    
    echo_info "RPM package built successfully in $BUILD_DIR/rpm/"
}

# Function to build Arch package
build_arch() {
    echo_info "Building Arch package..."
    
    if ! command -v makepkg &> /dev/null; then
        echo_error "makepkg not found. This script must be run on Arch Linux"
        return 1
    fi
    
    # Create build directory
    mkdir -p "$BUILD_DIR/arch"
    cd "$BUILD_DIR/arch"
    
    # Copy PKGBUILD and source
    cp ../../packaging/PKGBUILD .
    cp "../${PKGNAME}-${VERSION}.tar.gz" .
    
    # Build package
    makepkg -f
    
    cd ../..
    
    echo_info "Arch package built successfully in $BUILD_DIR/arch/"
}

# Main script
case "$1" in
    deb)
        create_tarball
        build_deb
        ;;
    rpm)
        create_tarball
        build_rpm
        ;;
    arch)
        create_tarball
        build_arch
        ;;
    all)
        create_tarball
        echo_info "Building all packages..."
        build_deb || echo_warning "Debian package build failed"
        build_rpm || echo_warning "RPM package build failed"
        build_arch || echo_warning "Arch package build failed"
        ;;
    clean)
        echo_info "Cleaning build directory..."
        rm -rf "$BUILD_DIR"
        rm -rf debian
        echo_info "Clean complete"
        ;;
    *)
        echo "Usage: $0 {deb|rpm|arch|all|clean}"
        echo ""
        echo "Commands:"
        echo "  deb   - Build Debian/Ubuntu .deb package"
        echo "  rpm   - Build Fedora/RHEL .rpm package"
        echo "  arch  - Build Arch Linux package"
        echo "  all   - Build all packages"
        echo "  clean - Clean build directory"
        exit 1
        ;;
esac

echo_info "Done!"
