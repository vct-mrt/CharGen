# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-20

### Added
- Initial release of CharGen
- Random character generation with multiple character sets
- Support for numeric characters (-n flag)
- Support for alphabetic characters (-c flag) with case control (-i/-a)
- Support for special characters (-s flag)
- Combination of multiple character sets
- Help message (--help, -h)
- Version information (--version, -v)
- Man page documentation
- Comprehensive error handling with user-friendly messages
- Test suite with 24 automated tests
- Packaging support for:
  - Debian/Ubuntu (.deb)
  - Fedora/RHEL (.rpm)
  - Arch Linux (PKGBUILD)
- Installation via `make install`
- CI/CD pipeline with GitHub Actions
- Complete documentation (README, CONTRIBUTING, PACKAGING)

### Fixed
- Correct handling of -i and -a flags with -c
- Proper validation of number arguments
- Edge cases for zero and negative numbers

### Security
- Input validation to prevent integer overflow
- Bounds checking on all user inputs

## [Unreleased]

### Planned
- Add hexadecimal output option (-x)
- Add base64 output option (-b)
- Add clipboard support
- Add quiet mode (-q)
- Add custom character set option
- Man page translation (FR, ES, DE)
- Cryptographically secure random option
- Configuration file support (~/.chargenrc)
- Output to file option (-o)
- Batch generation mode

---

[1.0.0]: https://github.com/vct-mrt/CharGen/releases/tag/v1.0.0
