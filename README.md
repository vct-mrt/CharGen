# CharGen

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/vct-mrt/CharGen/releases)

## Description

`CharGen` is a lightweight, fast command-line utility written in C that generates random characters based on specified criteria. Perfect for creating passwords, test data, or random strings for any purpose.

## Features

- 🎲 **Multiple character sets**: numbers, letters (upper/lowercase), special characters
- ⚡ **Fast and lightweight**: minimal dependencies, efficient C implementation
- 🎯 **Flexible options**: combine different character types as needed
- 📦 **Easy installation**: available for Debian, Fedora/RHEL, and Arch Linux
- 🔒 **Secure**: uses system random number generator

## Installation

### From Package Manager (Recommended)

#### Fedora/RHEL/CentOS
```bash
sudo dnf copr enable vct-mrt/chargen
sudo dnf install chargen
```

#### Ubuntu/Debian (Coming Soon)
```bash
# PPA coming soon
```

#### Arch Linux (AUR)
```bash
yay -S chargen
# or
paru -S chargen
```

### From Source

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
sudo make install
```

### Quick Install (Temporary)

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
bash requirement/requirement.sh  # Install build dependencies
make
sudo cp chargen /usr/local/bin/
```

## Usage

### Basic Syntax
```bash
chargen [options] <number>
```

### Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Display help message |
| `-v, --version` | Display version information |
| `-n` | Generate only numeric characters (0-9) |
| `-c` | Generate only alphabetic characters (a-z, A-Z) |
| `-s` | Generate only special characters |
| `-i` | Use lowercase letters (requires `-c`) |
| `-a` | Use uppercase letters (requires `-c`) |

### Examples

Generate 16 random characters (default: alphanumeric + special):
```bash
chargen 16
```

Generate 8 numeric characters:
```bash
chargen -n 8
# Output: 42819537
```

Generate 12 lowercase letters:
```bash
chargen -ci 12
# Output: xkcdpassword
```

Generate 20 uppercase letters:
```bash
chargen -ca 20
# Output: RANDOMUPPERCASETEXT
```

Generate 32 characters with numbers and special characters:
```bash
chargen -ns 32
# Output: #8!2$9@1&5*7%3(4)6+0-=_
```

Generate a strong password (16 chars, all types):
```bash
chargen 16
# Output: aB3$xY9!mK2@pL8%
```

## For Maintainers

See [PACKAGING.md](PACKAGING.md) for information on building and distributing packages.

## Development

### Compilation
```bash
make              # Standard build
make debug        # Build with debug symbols
make clean        # Clean build artifacts
```

### Project Structure
```
CharGen/
├── include/
│   └── random_char.h    # Header file with declarations
├── src/
│   ├── main.c           # Entry point
│   ├── lib.c            # Utility functions
│   ├── error.c          # Error handling
│   ├── process.c        # Character generation logic
│   ├── flag_help.c      # Help and version display
│   └── flag_manager.c   # Command-line argument parsing
├── packaging/           # Distribution packages
│   ├── debian/          # Debian package files
│   ├── chargen.spec     # RPM spec file
│   ├── PKGBUILD         # Arch Linux package file
│   └── build-package.sh # Build script
├── requirement/
│   └── requirement.sh   # Dependency installer
├── Makefile
├── LICENSE              # GPL-3.0
└── README.md
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Author

- **vct-mrt** - [GitHub](https://github.com/vct-mrt)

## Acknowledgments

- Built with ❤️ using C
- Inspired by the need for a simple, fast character generator

---

**Note**: For security-critical applications (like password generation), consider using dedicated tools like `pwgen` or `openssl rand`. CharGen uses the standard C `rand()` function which is suitable for general purposes but may not be cryptographically secure.
