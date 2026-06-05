# Security Policy

## Random Number Generation — Default vs. Secure Mode

### Default mode (rand()) — NOT cryptographically secure

**CharGen's default mode uses libc `rand()` and is NOT cryptographically secure. Its output is statistically predictable and MUST NOT be used to generate passwords, tokens, API keys, cryptographic keys, nonces, or any other security-sensitive secret.**

This is a deliberate design constraint of the default mode, not a bug. It is documented in the README and targets development/testing use cases only.

### Secure mode (--secure) — suitable for secrets

Passing `--secure` makes CharGen source randomness from `getrandom()`/`/dev/urandom`, which IS suitable for generating passwords, tokens, and other secrets. Without `--secure`, output remains `rand()`-based, statistically predictable, and unsuitable for security use.

If you prefer dedicated tools regardless of mode, the following remain good alternatives:

| Tool | Example |
|------|---------|
| `openssl rand` | `openssl rand -base64 32` |
| `pwgen` | `pwgen -s 32 1` |
| `/dev/urandom` | `head -c 32 /dev/urandom | base64` |
| `python3 secrets` | `python3 -c "import secrets; print(secrets.token_urlsafe(32))"` |

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | Yes       |
| < 1.0   | No        |

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities. Instead, report privately by email:

**martinetti.victor11@gmail.com**

Include in your report:

- A description of the vulnerability and its potential impact.
- Steps to reproduce (command line, input, output, platform).
- Whether you have a suggested fix or patch.

This is a hobby/personal project maintained on a best-effort basis. You can expect an acknowledgement within a few days and a resolution (or documented decision) within a reasonable timeframe.

## Scope

### In scope (treated as security issues)

- Buffer overflows or out-of-bounds reads/writes in argument parsing or generation logic.
- Integer overflows that cause undefined behavior or crashes on valid input.
- Input that causes a crash, hang, or uncontrolled resource consumption (e.g. very large count arguments).
- Arbitrary code execution via malformed arguments.

### Out of scope (by design)

- The use of `rand()` for random number generation in the default mode. This is documented and intentional. Use `--secure` or a dedicated tool when security is required.
- Predictability of output in default (non-`--secure`) mode. Predictability is a known and accepted property of the default mode.
