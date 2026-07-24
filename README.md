# CharGen

[![CI](https://github.com/vct-mrt/CharGen/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/vct-mrt/CharGen/actions/workflows/ci-cd.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-1.0.1-green.svg)](https://github.com/vct-mrt/CharGen/releases)
[![Language: C](https://img.shields.io/badge/language-C-blue.svg)]()

## Description

`CharGen` is a command-line utility written in C that generates random characters from selectable character sets. Useful for passwords, test data, or random strings in general. Linux-only, no dependencies beyond libc; single binary, about 400 lines of C across six source files.

## Features

- Multiple character sets: numbers, letters (upper/lowercase), and special characters, combinable via flags
- Optional cryptographically secure mode (`--secure`), sourced from `getrandom()` with a `/dev/urandom` fallback instead of `rand()`
- Installable from signed apt and dnf repositories, from the Snap Store, or built from source with no extra dependencies beyond libc

## Installation

### Debian / Ubuntu (apt)

```bash
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://vct-mrt.github.io/CharGen/apt/KEY.gpg | sudo tee /etc/apt/keyrings/chargen.gpg >/dev/null
echo 'deb [signed-by=/etc/apt/keyrings/chargen.gpg] https://vct-mrt.github.io/CharGen/apt stable main' | sudo tee /etc/apt/sources.list.d/chargen.list
sudo apt update && sudo apt install chargen
```

### Fedora / RHEL (dnf)

```bash
sudo dnf config-manager --add-repo https://vct-mrt.github.io/CharGen/rpm/chargen.repo
sudo dnf install chargen
```

### Snap

```bash
sudo snap install chargen
```

The apt and dnf packages come from self-hosted, GPG-signed repositories published to GitHub Pages. See [docs/REPOSITORY.md](docs/REPOSITORY.md) for repository details and [docs/SNAP.md](docs/SNAP.md) for the Snap package.

### From source

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
sudo make install
```

`make install` respects `PREFIX` (default `/usr/local`) and `DESTDIR`, and installs the binary plus the `chargen.1` man page.

## Usage

### Basic syntax

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
| `--secure` | Use a cryptographically secure RNG (`getrandom()` / `/dev/urandom`) |

The `<number>` argument is required and must be a positive integer. With no charset flag, CharGen uses all sets (numbers, letters, and special characters). Short flags combine: `-ns` means numbers and special characters, `-ci` means lowercase letters only.

### Examples

```bash
chargen 16              # 16 chars, default: all sets, e.g. aB3$xY9!mK2@pL8%
chargen -n 8            # 8 numeric chars, e.g. 42819537
chargen -ci 12          # 12 lowercase letters, e.g. xkcdpassword
chargen -ncs 20         # 20 chars, numbers + letters + special
chargen -ncs 20 --secure  # same, cryptographically secure
```

Any argument that isn't a recognized flag or the character count is rejected: CharGen exits with status `84` on bad input (unknown flags, missing count, non-numeric count, `-i`/`-a` without `-c`) and `0` on success.

## Development

### Compilation

```bash
make               # Standard build
make debug         # Build with debug symbols
make check         # Build and run the test suite (tests/test.sh)
make clean         # Clean build artifacts
sudo make install  # Install to $PREFIX/bin (default /usr/local/bin)
```

### Project structure

```text
CharGen/
├── include/
│   └── random_char.h    # Declarations and constants
├── src/
│   ├── main.c           # Entry point
│   ├── lib.c            # Utility functions and RNG
│   ├── error.c          # Argument validation
│   ├── process.c        # Character generation logic
│   ├── flag_help.c      # Help and version display
│   └── flag_manager.c   # Command-line argument parsing
├── packaging/           # Distribution packaging
├── requirement/
│   └── requirement.sh   # Dependency installer
├── tests/
│   └── test.sh          # Test suite
├── chargen.1            # Man page
├── Makefile
├── LICENSE              # GPL-3.0
└── README.md
```

## For maintainers

See [docs/PACKAGING.md](docs/PACKAGING.md) for building packages, [docs/REPOSITORY.md](docs/REPOSITORY.md) for the apt/dnf repositories, and [docs/SNAP.md](docs/SNAP.md) for the Snap package.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the dev setup, coding style, and PR process.

## License

This project is licensed under the GNU General Public License v3.0, see the [LICENSE](LICENSE) file for details.

## Author

- **vct-mrt** - [GitHub](https://github.com/vct-mrt)

---

CharGen's default mode uses the standard C `rand()` function, suitable for general purposes (test data, random strings) but **not** cryptographically secure. For security-critical output, use the `--secure` flag, which sources randomness from `getrandom()` with a `/dev/urandom` fallback and is suitable for passwords and tokens. If you prefer dedicated tools, `pwgen` and `openssl rand` remain good alternatives.
