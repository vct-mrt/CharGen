# Snap packaging

CharGen ships a Snap package built from `snap/snapcraft.yaml` and published by
the `.github/workflows/snap.yml` workflow. The snap uses `base: core22` and
`strict` confinement, builds from the project Makefile, and derives its version
from the git tag. This document covers the one-time maintainer setup, the
release flow, and end-user installation.

## 1. One-time maintainer setup

These steps are performed once by a maintainer with access to the Snap Store
account that owns the `chargen` name.

### 1a. Install snapcraft and log in

```
sudo snap install snapcraft --classic
snapcraft login
```

Logging in requires a free Ubuntu One / Snapcraft developer account. Create one
at https://snapcraft.io/account if you do not already have one.

### 1b. Register the snap name (once)

```
snapcraft register chargen
```

Snap names are globally unique across the Snap Store. If `chargen` is already
taken by another publisher, choose a different name, register that instead, and
update the `name:` field in `snap/snapcraft.yaml` so it matches the registered
name. Publishing will fail if the name in the recipe does not match a name your
account owns.

### 1c. Export store credentials into a GitHub secret

CI publishes non-interactively using exported store credentials rather than an
interactive login. Export a credentials file scoped to the `chargen` snap with
the ACLs the workflow needs, upload it as the `SNAPCRAFT_STORE_CREDENTIALS`
GitHub Actions secret, then delete the local file:

```
snapcraft export-login --snaps=chargen \
  --acls package_access,package_push,package_release,package_update \
  chargen-store-creds.txt
gh secret set SNAPCRAFT_STORE_CREDENTIALS < chargen-store-creds.txt
rm chargen-store-creds.txt
```

The credentials file grants publishing rights to the snap and must be treated
as a secret. Do not commit it, and delete it once it has been uploaded.

Web UI alternative: open the credentials file, copy its contents, then go to
the repository's Settings > Secrets and variables > Actions > New repository
secret, name it `SNAPCRAFT_STORE_CREDENTIALS`, and paste the contents as the
value.

## 2. Release flow

The `Snap` workflow reacts to the following events:

- Tag push (`git push origin vX.Y.Z`): the workflow builds the snap, with the
  version derived from the tag via `git describe`, and publishes it to the
  `stable` channel automatically.
- Pull requests: the workflow builds the snap to verify the recipe still works,
  but does not publish anything.
- `workflow_dispatch`: allows a maintainer to trigger a manual build from the
  Actions tab.

A typical release is therefore just tagging and pushing:

```
git tag v1.0.0
git push origin v1.0.0
```

## 3. End-user installation

Install from the Snap Store:

```
sudo snap install chargen
```

Then run it like any other build of CharGen:

```
chargen 16
chargen --secure -ncs 20
```

Installed snaps refresh automatically; snapd updates chargen in the background
when a new revision is published to the tracked channel, so no manual upgrade
step is required.

To follow a pre-release channel, if one is ever published, select it explicitly:

```
sudo snap install chargen --channel=edge
```

## 4. Notes and troubleshooting

- Confinement is `strict`. CharGen only writes to stdout and reads
  `/dev/urandom`, both of which are permitted under the base confinement, so no
  additional interfaces or plugs are declared.
- To build and test locally without publishing, run `snapcraft` (or
  `snapcraft --use-lxd`) in the repository root. This produces a `chargen_*.snap`
  file, which you can install with:

  ```
  sudo snap install ./chargen_*.snap --dangerous
  ```

  The `--dangerous` flag is required because a locally built snap is not signed
  by the store.
- If a publish step fails with an authentication error, the exported
  credentials have most likely expired or were exported without the required
  ACLs. Re-run the `snapcraft export-login` command from section 1c and update
  the `SNAPCRAFT_STORE_CREDENTIALS` secret.
- The snap name in the store must match the `name:` field in
  `snap/snapcraft.yaml`. If you rename the snap, update both.
