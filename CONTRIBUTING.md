# Contributing to CharGen

Thank you for your interest in contributing to CharGen — a small, focused CLI tool that generates random strings from selectable character sets. Contributions of all kinds are welcome: bug reports, fixes, tests, and documentation improvements.

## Dev Setup

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
```

Run the test suite:

```bash
cd tests && ./test.sh
# or, from the project root:
make check
```

Install build dependencies on your distro automatically:

```bash
bash requirement/requirement.sh
```

`requirement.sh` detects the package manager (apt, dnf, pacman, …) and installs `gcc`, `make`, and `cppcheck`.

## Coding Style

CharGen follows C99 and Epitech-derived conventions:

- **Error sentinel**: functions return `84` on error, `0` on success. This propagates as the process exit code.
- **Hand-rolled libc**: `my_strlen`, `str_compare`, `my_getnbr`, etc. are kept deliberately — do not replace them with stdlib equivalents.
- **Indentation**: 4 spaces (no tabs in C/H files). See `.editorconfig`.
- **Compiler cleanliness**: code must compile without warnings under `-W -Wall -Wextra -O2`. CI enforces `-Werror` in addition.
- **Static analysis**: `cppcheck --enable=all` must report zero findings. The CI pipeline blocks on any finding.
- **Sanitizers**: CI builds with `-fsanitize=address,undefined`. New code must be clean under ASan/UBSan.
- **Security caveat**: CharGen uses `rand()` and is **not** cryptographically secure. Do not add features that imply security guarantees, and do not remove the warnings in README and SECURITY.md.

## Versioning

The version string lives in **three places** — keep them in sync when bumping:

1. `Makefile` — `VERSION` variable.
2. `include/random_char.h` — `VERSION` macro.
3. `README.md` — version badge.

Also update `CHANGELOG.md`: move items from `## [Unreleased]` to a new numbered section, and add a comparison URL at the bottom.

## Pull Request Process

1. Branch from `main` (e.g. `fix/modulo-bias`, `feat/make-dist`).
2. Ensure `make check` passes and `cppcheck` reports no findings.
3. Use conventional commit messages (`fix:`, `feat:`, `docs:`, `chore:`, etc.).
4. Fill in the PR description with what changed and why.
5. One logical change per PR — keep diffs reviewable.

## Reporting Bugs

Open a GitHub issue. Include: OS and distro, compiler version (`gcc --version`), exact command run, expected vs. actual output, and exit code.

## License

By contributing you agree that your changes will be released under the [GPL-3.0 License](LICENSE).
