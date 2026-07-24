# Guide de Démarrage Rapide - CharGen

## Installation rapide

### Depuis les sources

```bash
git clone https://github.com/vct-mrt/CharGen.git
cd CharGen
make
sudo make install
```

### Test de l'installation

```bash
chargen 16
chargen --help
```

## Créer les packages

### 1. Vérifier que tout compile

```bash
make clean
make check
```

`make check` compile le binaire puis lance la suite de tests dans `tests/test.sh`.

### 2. Builder les packages

#### Pour Debian/Ubuntu (.deb)

```bash
cd packaging
./build-package.sh deb
```

Le fichier `.deb` atterrit dans `build/deb/`. Installez-le avec `sudo dpkg -i build/deb/chargen_1.0.0-1_amd64.deb`.

#### Pour Fedora/RHEL (.rpm)

```bash
cd packaging
./build-package.sh rpm
```

Le fichier `.rpm` atterrit dans `build/rpm/`.

```bash
sudo dnf install build/rpm/chargen-1.0.0-1.x86_64.rpm
# ou
sudo rpm -i build/rpm/chargen-1.0.0-1.x86_64.rpm
```

#### Pour Arch Linux

```bash
cd packaging
./build-package.sh arch
```

Le package atterrit dans `build/arch/`. Installez-le avec `sudo pacman -U build/arch/chargen-1.0.0-1-x86_64.pkg.tar.zst`.

## Publier sur les dépôts officiels

### Ubuntu PPA (recommandé pour débutants)

1. Créez un compte sur https://launchpad.net
2. Configurez GPG :

   ```bash
   gpg --gen-key
   gpg --list-keys
   gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
   ```

3. Créez votre PPA : allez sur https://launchpad.net/~YOUR_USERNAME/+activate-ppa et nommez-le "chargen".
4. Uploadez :

   ```bash
   cd CharGen
   cp -r packaging/debian .
   # Modifier debian/changelog avec votre email
   debuild -S -sa
   dput ppa:YOUR_USERNAME/chargen ../chargen_1.0.0-1_source.changes
   ```

5. Les utilisateurs installent avec :

   ```bash
   sudo add-apt-repository ppa:YOUR_USERNAME/chargen
   sudo apt update
   sudo apt install chargen
   ```

### Fedora COPR

1. Créez un compte sur https://copr.fedorainfracloud.org
2. Créez un projet COPR nommé "chargen" via l'interface web.
3. Installez copr-cli :

   ```bash
   sudo dnf install copr-cli
   ```

4. Téléchargez votre config depuis l'interface COPR, onglet API, section Config.
5. Buildez et uploadez :

   ```bash
   rpmbuild -bs packaging/chargen.spec
   copr-cli build chargen ~/rpmbuild/SRPMS/chargen-1.0.0-1.src.rpm
   ```

6. Les utilisateurs installent avec :

   ```bash
   sudo dnf copr enable YOUR_USERNAME/chargen
   sudo dnf install chargen
   ```

### Arch User Repository (AUR)

1. Créez un compte sur https://aur.archlinux.org
2. Ajoutez votre clé SSH dans votre profil AUR.
3. Créez le dépôt :

   ```bash
   git clone ssh://aur@aur.archlinux.org/chargen.git chargen-aur
   cd chargen-aur
   cp ../CharGen/packaging/PKGBUILD .
   makepkg --printsrcinfo > .SRCINFO
   git add PKGBUILD .SRCINFO
   git commit -m "Initial commit: chargen 1.0.0"
   git push origin master
   ```

4. Les utilisateurs installent avec :

   ```bash
   yay -S chargen
   # ou
   paru -S chargen
   ```

## Avant de publier

1. Le code compile et `make check` passe entièrement.
2. La version est à jour dans tous les fichiers concernés.
3. `CHANGELOG.md` est à jour.
4. `README.md` est à jour.
5. `LICENSE` est présent.
6. L'email est à jour dans les fichiers de packaging.
7. La clé GPG est configurée (pour la PPA).
8. Le dépôt GitHub est créé et poussé.
9. Une GitHub Release est créée avec les binaires.
10. La documentation a été testée.

## Mettre à jour votre email

`packaging/chargen.spec` et `packaging/PKGBUILD` contiennent déjà l'email du mainteneur. Si vous forkez le projet ou changez de mainteneur, remplacez cette adresse dans ces deux fichiers avant de publier, et dans `packaging/debian/control` et `packaging/debian/changelog` une fois ce dépôt Debian créé.

```bash
# Exemple de remplacement
find packaging -type f -exec sed -i 's/ancien-email@example.com/nouvel-email@example.com/g' {} +
```

## Workflow de publication

1. Développement :

   ```bash
   git checkout -b feature/nouvelle-fonctionnalite
   # ... développement ...
   make check
   git commit -am "Add: nouvelle fonctionnalité"
   git push origin feature/nouvelle-fonctionnalite
   ```

2. Merge et tag :

   ```bash
   git checkout main
   git merge feature/nouvelle-fonctionnalite
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push && git push --tags
   ```

3. Build et release :

   ```bash
   cd packaging
   ./build-package.sh all
   ```

4. GitHub Release : créez une release sur GitHub, uploadez les fichiers `.deb`, `.rpm`, `.pkg.tar.zst`, et copiez le contenu du CHANGELOG.
5. Mise à jour PPA/COPR/AUR : mettez à jour les versions, puis re-buildez et uploadez.

## Conseils

1. Publiez d'abord sur GitHub Releases, c'est le canal le plus simple à mettre en place.
2. Testez sur plusieurs distributions avant de publier.
3. Répondez aux issues et questions rapidement.
4. Corrigez les bugs rapidement.
5. Documentez les changements : README, man page, exemples.

## Ressources

- Documentation complète : [PACKAGING.md](PACKAGING.md)
- Contributing : [../CONTRIBUTING.md](../CONTRIBUTING.md)
- Debian Packaging : https://packaging.ubuntu.com/html/
- Fedora Packaging : https://docs.fedoraproject.org/en-US/packaging-guidelines/
- Arch Packaging : https://wiki.archlinux.org/title/Creating_packages
