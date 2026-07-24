# CharGen Package Repositories

CharGen ships signed apt and dnf package repositories hosted on GitHub Pages at
<https://vct-mrt.github.io/CharGen/>. Metadata is generated and GPG-signed by the
`.github/workflows/pages-repo.yml` workflow, which runs whenever a GitHub Release
is published. This document covers the one-time maintainer setup, the per-release
flow, and end-user installation.

## 1. One-time maintainer setup

These steps are performed once by the repository owner. They configure the signing
key, the GitHub Actions secret that holds it, and GitHub Pages.

### 1a. Generate a dedicated GPG signing key

Use a key dedicated to repository signing, separate from any personal key. The key
must have no passphrase, because the workflow imports and uses it non-interactively.
Generate it in unattended batch mode:

```sh
cat > /tmp/chargen-key.conf <<'EOF'
%no-protection
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Name-Real: CharGen Repository Signing Key
Name-Email: martinetti.victor11@gmail.com
Expire-Date: 0
%commit
EOF
gpg --batch --generate-key /tmp/chargen-key.conf
rm -f /tmp/chargen-key.conf
```

An ed25519 key works as well and produces smaller signatures; substitute
`Key-Type: eddsa`, `Key-Curve: ed25519`, and drop `Key-Length` if you prefer it.

Find the key id (the long hex string after `sec`):

```sh
gpg --list-secret-keys --keyid-format=long
```

Export the ASCII-armored private key, replacing `<KEYID>` with the id from the
previous command:

```sh
gpg --armor --export-secret-keys <KEYID> > chargen-private.asc
```

`chargen-private.asc` is the full private signing key. Treat it as a secret: do not
commit it, do not share it, and delete it from disk once it has been added to the
GitHub Actions secret (step 1b):

```sh
shred -u chargen-private.asc   # or: rm -f chargen-private.asc
```

### 1b. Add the private key as a GitHub Actions secret

The workflow reads the key from the repository secret named `GPG_PRIVATE_KEY`.

In the GitHub web UI: repository **Settings > Secrets and variables > Actions >
New repository secret**. Set the name to `GPG_PRIVATE_KEY` and paste the entire
contents of `chargen-private.asc`, including the `-----BEGIN PGP PRIVATE KEY
BLOCK-----` and `-----END PGP PRIVATE KEY BLOCK-----` lines.

No passphrase secret is required, because the key was generated with
`%no-protection`.

Equivalently, with the GitHub CLI:

```sh
gh secret set GPG_PRIVATE_KEY < chargen-private.asc
```

### 1c. Enable GitHub Pages

The workflow deploys via the GitHub Pages Actions integration, so no publishing
branch is needed.

In the GitHub web UI: repository **Settings > Pages > Build and deployment**, set
**Source** to **GitHub Actions**.

After the first successful `pages-repo` workflow run, the repositories are served
at <https://vct-mrt.github.io/CharGen/>.

## 2. Release flow (per version)

Each released version flows automatically from a git tag through package builds to
the published repositories.

1. Bump the version to `X.Y.Z` in `include/random_char.h` (the `#define VERSION`
   line) and in the `Makefile`, and commit the change.
2. Tag and push:

   ```sh
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

Pushing the tag runs the `build-packages` job, which builds the `.deb`, `.rpm`, and
source tarball and attaches them to a new GitHub Release. Publishing that Release
triggers `pages-repo.yml`, which downloads every `.deb` and `.rpm` from all
Releases into a cumulative pool, regenerates and signs the apt and dnf metadata,
and redeploys the Pages site.

Older versions remain installable: the package pool is rebuilt from all Releases on
every run, so previously published packages stay in the repositories alongside the
new one.

## 3. End-user installation

### 3a. Fedora / RHEL / dnf

```sh
sudo dnf config-manager --add-repo https://vct-mrt.github.io/CharGen/rpm/chargen.repo
sudo dnf install chargen
```

On some systems the `config-manager` subcommand is provided by the
`dnf-plugins-core` package; install it first with `sudo dnf install dnf-plugins-core`
if the command is not found.

### 3b. Debian / Ubuntu / apt

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://vct-mrt.github.io/CharGen/apt/KEY.gpg | sudo tee /etc/apt/keyrings/chargen.gpg >/dev/null
echo 'deb [signed-by=/etc/apt/keyrings/chargen.gpg] https://vct-mrt.github.io/CharGen/apt stable main' | sudo tee /etc/apt/sources.list.d/chargen.list
sudo apt update
sudo apt install chargen
```

Once configured, updates arrive with the normal `sudo apt upgrade` (Debian/Ubuntu)
or `sudo dnf upgrade` (Fedora/RHEL).

## 4. Troubleshooting and notes

- **First run.** GitHub Pages must be enabled (step 1c) and the `GPG_PRIVATE_KEY`
  secret must be set (step 1b) before the first Release. Without them the workflow
  fails at the key-import or Pages-deploy step.
- **apt signature errors.** The `apt/KEY.gpg` file served by the repository is a
  dearmored binary keyring. It must be saved verbatim to
  `/etc/apt/keyrings/chargen.gpg`, exactly as shown in section 3b. If apt reports a
  bad signature, re-fetch the key and confirm the destination path. The armored
  form is available at `apt/KEY.asc` and the dnf key at `rpm/KEY.gpg` if a tool
  needs those instead.
- **Key rotation.** To rotate the signing key, generate a new key (section 1a),
  update the `GPG_PRIVATE_KEY` secret (section 1b), and re-run the workflow via its
  `workflow_dispatch` trigger to re-sign and redeploy. End users then re-fetch the
  public key using the commands in section 3.
- **Architecture.** The repositories currently publish `amd64` (x86_64) packages
  only, because the CI runners are x86_64. Supporting `arm64` would require adding
  an arm64 build to the packaging matrix.
