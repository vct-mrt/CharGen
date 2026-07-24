# CharGen

[![CI](https://github.com/vct-mrt/CharGen/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/vct-mrt/CharGen/actions/workflows/ci-cd.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/vct-mrt/CharGen/releases)
[![Language: C](https://img.shields.io/badge/language-C-blue.svg)]()

## Description

`CharGen` is a command-line utility written in C that generates random characters from selectable character sets. Useful for passwords, test data, or random strings in general. No dependencies beyond libc; single binary, about 400 lines of C across six source files.

## Features

- Multiple character sets: numbers, letters (upper/lowercase), and special characters, combinable via flags
- Optional cryptographically secure mode (`--secure`), sourced from `getrandom()`/`/dev/urandom` instead of `rand()`
- Packages for Debian, Fedora/RHEL, and Arch Linux, or build from source with no extra dependencies beyond libc

## Installation

### From Source

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
sudo make install
```

`make install` respects `PREFIX` (default `/usr/local`) and `DESTDIR`, so it works for packaging too.

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
| --- | --- |
| `-h, --help` | Display help message |
| `-v, --version` | Display version information |
| `-n` | Generate only numeric characters (0-9) |
| `-c` | Generate only alphabetic characters (a-z, A-Z) |
| `-s` | Generate only special characters |
| `-i` | Use lowercase letters (requires `-c`) |
| `-a` | Use uppercase letters (requires `-c`) |
| `--secure` | Use a cryptographically secure RNG (getrandom), suitable for passwords/tokens |

With no flags, CharGen generates alphanumeric characters plus special characters. Flags combine: `-ns` means numbers and special characters, `-ci` means lowercase letters only.

### Examples

```bash
chargen 16              # 16 chars, default alphanumeric + special, e.g. aB3$xY9!mK2@pL8%
chargen -n 8            # 8 numeric chars, e.g. 42819537
chargen -ci 12          # 12 lowercase letters, e.g. xkcdpassword
chargen -ca 20          # 20 uppercase letters, e.g. RANDOMUPPERCASETEXT
chargen -ns 32          # 32 chars, numbers + special, e.g. #8!2$9@1&5*7%3(4)6+0-=_
chargen --secure 16     # 16 chars, cryptographically secure
chargen --secure -c 20  # 20 letters, cryptographically secure
```

Any argument that isn't a recognized flag or the character count is rejected: CharGen exits with status `84` on bad input (unknown flags, missing count, non-numeric count, `-i`/`-a` without `-c`) and `0` on success.

## For Maintainers

See [PACKAGING.md](docs/PACKAGING.md) for information on building and distributing packages.

## Development

### Compilation

```bash
make               # Standard build
make debug         # Build with debug symbols
make check         # Build and run the test suite (tests/test.sh)
make clean         # Clean build artifacts
sudo make install  # Install to $PREFIX/bin (default /usr/local/bin)
```

### Project Structure

```text
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
│   ├── chargen.spec     # RPM spec file
│   ├── PKGBUILD         # Arch Linux package file
│   └── build-package.sh # Build script
├── requirement/
│   └── requirement.sh   # Dependency installer
├── tests/
│   └── test.sh          # Test suite
├── Makefile
├── LICENSE              # GPL-3.0
└── README.md
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the dev setup, coding style, and PR process.

## License

This project is licensed under the GNU General Public License v3.0, see the [LICENSE](LICENSE) file for details.

## Author

- **vct-mrt** - [GitHub](https://github.com/vct-mrt)

---

CharGen's default mode uses the standard C `rand()` function, suitable for general purposes (test data, random strings) but **not** cryptographically secure. For security-critical output, use the `--secure` flag, which sources randomness from `getrandom()`/`/dev/urandom` instead of `rand()` and is suitable for passwords and tokens. If you prefer dedicated tools, `pwgen` and `openssl rand` remain good alternatives.
