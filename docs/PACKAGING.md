# Guide de Publication des Packages CharGen

Ce guide explique comment publier CharGen sur différents dépôts de paquets.

## Table des matières

1. [Ubuntu PPA (Launchpad)](#ubuntu-ppa-launchpad)
2. [Debian Repository](#debian-repository)
3. [Fedora COPR](#fedora-copr)
4. [Arch User Repository (AUR)](#arch-user-repository-aur)
5. [Snapcraft (Universal)](#snapcraft-universal)

---

## Ubuntu PPA (Launchpad)

### Prérequis
```bash
sudo apt install devscripts dput
```

### Étapes

1. **Créer un compte Launchpad**
   - Allez sur https://launchpad.net et créez un compte
   - Configurez votre clé GPG

2. **Configurer GPG**
   ```bash
   gpg --gen-key
   gpg --list-keys
   gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
   ```

3. **Préparer le paquet source**
   ```bash
   cd CharGen
   cp -r packaging/debian .
   debuild -S -sa
   ```

4. **Uploader vers PPA**
   ```bash
   dput ppa:your-launchpad-id/chargen ../chargen_1.0.0-1_source.changes
   ```

### Maintenir le PPA
- Les utilisateurs pourront installer avec:
  ```bash
  sudo add-apt-repository ppa:your-launchpad-id/chargen
  sudo apt update
  sudo apt install chargen
  ```

---

## Debian Repository

### Option 1: Proposer inclusion dans Debian officiel

1. **Créer un package ITP (Intent To Package)**
   - Soumettre un bug ITP sur bugs.debian.org
   - Suivre les Debian Policy

2. **Trouver un sponsor**
   - Demander sur debian-mentors mailing list
   - Uploader sur mentors.debian.net

### Option 2: Héberger votre propre dépôt

```bash
# Installer les outils nécessaires
sudo apt install reprepro

# Créer la structure du dépôt
mkdir -p /var/www/debian/{conf,dists,pool}

# Configuration
cat > /var/www/debian/conf/distributions << EOF
Origin: CharGen
Label: CharGen
Codename: stable
Architectures: i386 amd64 source
Components: main
Description: CharGen APT Repository
SignWith: YOUR_GPG_KEY_ID
EOF

# Ajouter le paquet
cd /var/www/debian
reprepro includedeb stable /path/to/chargen_1.0.0-1_amd64.deb

# Les utilisateurs ajoutent le dépôt
echo "deb [signed-by=/usr/share/keyrings/chargen-archive-keyring.gpg] http://your-domain.com/debian stable main" | sudo tee /etc/apt/sources.list.d/chargen.list
```

---

## Fedora COPR

### Prérequis
```bash
sudo dnf install copr-cli
```

### Étapes

1. **Créer un compte Fedora**
   - Allez sur https://accounts.fedoraproject.org
   - Créez un projet COPR sur https://copr.fedorainfracloud.org

2. **Configurer COPR CLI**
   ```bash
   # Télécharger votre config depuis COPR web interface
   vim ~/.config/copr
   ```

3. **Créer le projet**
   ```bash
   copr-cli create chargen --chroot fedora-39-x86_64 --chroot fedora-40-x86_64 \
     --description "Random character generator" \
     --instructions "sudo dnf copr enable YOUR_USERNAME/chargen && sudo dnf install chargen"
   ```

4. **Build et upload**
   ```bash
   # Créer un SRPM
   rpmbuild -bs packaging/chargen.spec
   
   # Upload vers COPR
   copr-cli build chargen ~/rpmbuild/SRPMS/chargen-1.0.0-1.src.rpm
   ```

### Utilisation par les utilisateurs
```bash
sudo dnf copr enable YOUR_USERNAME/chargen
sudo dnf install chargen
```

---

## Arch User Repository (AUR)

### Prérequis
```bash
sudo pacman -S base-devel git
```

### Étapes

1. **Créer un compte AUR**
   - Allez sur https://aur.archlinux.org
   - Créez un compte et ajoutez votre clé SSH

2. **Configurer SSH**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # Ajouter la clé publique sur AUR
   ```

3. **Créer le dépôt AUR**
   ```bash
   git clone ssh://aur@aur.archlinux.org/chargen.git chargen-aur
   cd chargen-aur
   
   # Copier le PKGBUILD
   cp ../CharGen/packaging/PKGBUILD .
   
   # Générer .SRCINFO
   makepkg --printsrcinfo > .SRCINFO
   
   # Commit et push
   git add PKGBUILD .SRCINFO
   git commit -m "Initial commit: chargen 1.0.0"
   git push origin master
   ```

### Utilisation par les utilisateurs
```bash
# Avec yay
yay -S chargen

# Avec paru
paru -S chargen

# Manuellement
git clone https://aur.archlinux.org/chargen.git
cd chargen
makepkg -si
```

---

## Snapcraft (Universal)

### Créer un Snap (multiplateforme)

1. **Créer `snapcraft.yaml`**
   ```bash
   mkdir -p snap
   cat > snap/snapcraft.yaml << 'EOF'
   name: chargen
   version: '1.0.0'
   summary: Random character generator
   description: |
     CharGen is a lightweight command-line utility that generates 
     random characters based on specified criteria.

   base: core22
   confinement: strict
   grade: stable

   apps:
     chargen:
       command: usr/bin/chargen
       plugs: []

   parts:
     chargen:
       plugin: make
       source: .
       build-packages:
         - gcc
         - make
       override-build: |
         make
         make install DESTDIR=$SNAPCRAFT_PART_INSTALL PREFIX=/usr
   EOF
   ```

2. **Build et publish**
   ```bash
   snapcraft
   snapcraft login
   snapcraft upload --release=stable chargen_1.0.0_amd64.snap
   ```

### Utilisation
```bash
sudo snap install chargen
```

---

## GitHub Releases

Pour toutes les distributions, créez des releases GitHub:

```bash
# Tag la version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Build les packages
cd packaging
./build-package.sh all

# Upload manuellement sur GitHub Releases
# Incluez: .deb, .rpm, .pkg.tar.zst, et tarball source
```

---

## Checklist de Publication

- [ ] Code testé et fonctionnel
- [ ] Version bumped dans tous les fichiers
- [ ] Changelog à jour
- [ ] Documentation complète
- [ ] LICENSE correcte
- [ ] Tests passants
- [ ] Packages buildés pour toutes les plateformes
- [ ] GPG keys configurées
- [ ] GitHub Release créée
- [ ] PPA/COPR/AUR mis à jour
- [ ] Documentation d'installation à jour

---

## Automatisation avec GitHub Actions

Créez `.github/workflows/release.yml` pour automatiser:
- Build des packages
- Tests
- Upload vers GitHub Releases
- Notification COPR/AUR

---

## Support et Maintenance

Après publication:
1. Monitorer les issues GitHub
2. Répondre aux questions utilisateurs
3. Mettre à jour régulièrement
4. Maintenir les dépôts à jour
5. Documenter les changements

## Ressources

- [Debian Policy](https://www.debian.org/doc/debian-policy/)
- [Fedora Packaging Guidelines](https://docs.fedoraproject.org/en-US/packaging-guidelines/)
- [Arch Package Guidelines](https://wiki.archlinux.org/title/Arch_package_guidelines)
- [Ubuntu Packaging Guide](https://packaging.ubuntu.com/html/)
