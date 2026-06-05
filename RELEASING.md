# Release Preparation Guide

This document is a maintainer checklist for preparing and publishing a new CharGen release. It describes the steps — it does not perform them.

## Pre-release checklist

- [ ] All tests pass (`make check`)
- [ ] `cppcheck` reports zero findings
- [ ] `CHANGELOG.md` updated (Unreleased entries moved to a versioned heading)
- [ ] Version number synced in all three places (see below)
- [ ] Man page (`chargen.1`) reflects any new or changed flags
- [ ] README and other docs updated for any new features

## 1. Bump the version (three places — keep in sync)

CharGen's version string lives in three places; they must all be set to the same value:

1. `Makefile` — the `VERSION` variable near the top.
2. `include/random_char.h` — the `VERSION` preprocessor macro.
3. `README.md` — the version badge URL (`version-X.Y.Z-green.svg`).

Example for a `1.1.0` release:

```makefile
# Makefile
VERSION = 1.1.0
```

```c
/* include/random_char.h */
#define VERSION "1.1.0"
```

```markdown
<!-- README.md badge -->
[![Version](https://img.shields.io/badge/version-1.1.0-green.svg)](...)
```

## 2. Update CHANGELOG.md

Move the entries currently under `## [Unreleased]` to a new versioned heading:

```markdown
## [1.1.0] - 2026-06-05

### Added
- ...

### Changed
- ...
```

Leave an empty `## [Unreleased]` section above it for future work. Add a comparison link at the bottom:

```markdown
[1.1.0]: https://github.com/vct-mrt/CharGen/compare/v1.0.0...v1.1.0
```

## 3. Run quality gates locally

```bash
# Build and run the full test suite
make check

# Static analysis — zero findings required
cppcheck --enable=all --inline-suppr --suppress=missingIncludeSystem src/ include/
```

Do not proceed if either gate fails.

## 4. Build release artifacts

```bash
# Source tarball
make dist

# Distribution packages (deb / rpm / arch)
# packaging/debian/ must exist for the deb target
bash packaging/build-package.sh
```

Review the generated artifacts before tagging.

## 5. Commit, tag, and push

```bash
git add Makefile include/random_char.h README.md CHANGELOG.md
git commit -m "chore: release vX.Y.Z"

git tag -a vX.Y.Z -m "vX.Y.Z"
git push origin main
git push origin vX.Y.Z
```

Pushing the tag triggers the CI/CD pipeline, which builds the `.deb` package and source tarball and attaches them to the GitHub Release automatically.

## 6. Create the GitHub Release

After the tag push and CI run succeed:

1. Go to **Releases → Draft a new release** on GitHub.
2. Select the tag `vX.Y.Z`.
3. Copy the relevant CHANGELOG section as the release description.
4. Publish the release (CI artifacts are attached automatically).

This step requires the maintainer's own GitHub credentials.

## 7. Optional downstream updates (manual)

These are not automated and are performed at the maintainer's discretion:

- **AUR**: update `PKGBUILD` (`pkgver`, `sha256sums`) and push to the AUR git remote.
- **Homebrew**: update the formula's `url` and `sha256`, submit a PR to the tap.
