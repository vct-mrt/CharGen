# Homebrew Packaging

This document describes how to distribute CharGen through Homebrew. It is a
maintainer guide, not user-facing installation instructions.

## Homebrew core vs a personal tap

Homebrew core has acceptance criteria for new formulae: a project generally
needs 30+ forks, 30+ watchers, or 75+ stars, or some other form of
demonstrated notability. CharGen does not meet that bar yet. A submission to
`homebrew/homebrew-core` at this stage would be rejected.

The realistic path is a personal tap: a git repository with a `Formula/`
directory that `brew` knows how to fetch. `Formula/chargen.rb` in this
repository is written to be dropped into a tap as-is. Once CharGen
accumulates enough forks, watchers, or stars, homebrew-core submission can
be reconsidered.

## Creating the tap

1. Create a GitHub repository under `vct-mrt` named `homebrew-tap` (or
   `homebrew-chargen` for a single-formula tap). The `homebrew-` prefix is
   required; `brew tap` strips it automatically.
2. Add `Formula/chargen.rb` to that repository, copied from
   `Formula/chargen.rb` in this repository.
3. Commit and push.

Users then install with:

```sh
brew tap vct-mrt/tap
brew install chargen
```

Replace `tap` with `chargen` in both commands if the single-formula tap name
was used instead.

## Release flow

1. Tag the release in this repository and push the tag:

   ```sh
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub generates a source tarball automatically at
   `https://github.com/vct-mrt/CharGen/archive/refs/tags/v1.0.0.tar.gz`.

3. Compute its sha256, either directly:

   ```sh
   curl -sL https://github.com/vct-mrt/CharGen/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
   ```

   or by letting Homebrew do it:

   ```sh
   brew fetch --build-from-source ./Formula/chargen.rb
   ```

   `brew fetch` prints the computed sha256 and caches the tarball. It will
   report a mismatch the first time, since the formula ships with a
   placeholder.

4. Update `url` and `sha256` in `Formula/chargen.rb` to match the new tag and
   digest. The placeholder sha256 currently in the formula (64 zeros) must be
   replaced before the formula will install anything. Homebrew refuses to
   build against a digest that does not match the downloaded tarball.
5. Copy the updated formula into the tap repository, commit, and push.

## Local testing before pushing to the tap

Run these from the CharGen repository root, once the sha256 has been filled
in:

```sh
brew install --build-from-source ./Formula/chargen.rb
brew test chargen
brew audit --strict --new chargen
```

`brew audit --strict --new` is the same check Homebrew's CI runs against
formula submissions. It validates the `desc` line, license identifier,
stanza order, and test block. Fix anything it flags before pushing to the
tap. To test the `head` build instead of the tagged release, add `--HEAD`
to the install command.

## Makefile requirements

The formula's install step is a single call:

```ruby
system "make", "install", "PREFIX=#{prefix}"
```

For this to keep working, the Makefile must continue to:

- Honor `CC ?=` instead of hardcoding a compiler, since Homebrew supplies
  its own toolchain path.
- Honor `CFLAGS` and `LDFLAGS` passed in from the environment instead of
  overwriting them unconditionally.
- Install the binary to `$(PREFIX)/bin` and the man page to
  `$(PREFIX)/share/man/man1` when given `PREFIX`, without requiring
  `DESTDIR` to be set.
- Avoid GNU-only `install` flags such as `-D`. Homebrew CI also runs on
  macOS, where `install` is the BSD variant and does not support `-D`.
  The current Makefile already creates the target directory with
  `mkdir -p` first, which is portable.

If any of these change, update `Formula/chargen.rb` and re-run the local
testing steps above.
