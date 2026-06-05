# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `make check` target (runs `tests/test.sh`) and `make dist` target (source tarball).
- Debian packaging under `packaging/debian/` (control, rules, changelog, compat).
- Governance files: `CONTRIBUTING.md`, `SECURITY.md`, `CHANGELOG.md`, `.editorconfig`.
- Hardened CI: gcc + clang build matrix, `-Werror`, AddressSanitizer / UndefinedBehaviorSanitizer, blocking `cppcheck` quality gate (zero findings required).

### Changed

- Strict argument parsing: unknown flags are now rejected with exit code 84.
- `-i` and `-a` now require `-c` to be set; passing them alone is an error (exit 84).

### Fixed

- RNG seeded once at startup with `time(NULL) ^ getpid()` so same-second invocations produce different output.
- Removed modulo bias in random character selection (rejection-sampling loop).

## [1.0.0] - 2025-01-01

### Added

- Initial release of CharGen: random string generation from selectable character sets.
- `-n` flag: numeric characters (`0-9`).
- `-c` flag: alphabetic characters (both cases by default; narrow with `-i` lowercase or `-a` uppercase).
- `-s` flag: special/punctuation characters.
- Positional count argument: number of characters to generate.
- Default (no flags): all four character sets combined.
- `-h` / `--help` and `-v` / `--version` output.
- Man page (`chargen.1`).
- RPM spec (`packaging/chargen.spec`) and Arch Linux PKGBUILD (`packaging/PKGBUILD`).
- `make install` with `DESTDIR`-aware prefix support.
- GitHub Actions CI/CD pipeline (build, test, cppcheck, release packaging).
- Bash test suite (`tests/test.sh`, 24 exit-code-based tests).

---

[Unreleased]: https://github.com/vct-mrt/CharGen/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/vct-mrt/CharGen/releases/tag/v1.0.0
