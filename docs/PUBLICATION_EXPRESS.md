# 🚀 Guide Express : Publier CharGen

## ⚡ En 5 Minutes : GitHub Release

```bash
# 1. Compiler et tester
make clean && make
./test.sh

# 2. Créer le tag
git add .
git commit -m "Release v1.0.0"
git tag -a v1.0.0 -m "Première release stable"
git push && git push --tags

# 3. Builder les packages
cd packaging
chmod +x build-package.sh
./build-package.sh all

# 4. Créer la release sur GitHub
# - Aller sur https://github.com/VOTRE_USERNAME/CharGen/releases/new
# - Tag: v1.0.0
# - Titre: CharGen v1.0.0
# - Description: Copier depuis CHANGELOG.md
# - Uploader les fichiers dans build/
```

**✅ C'est fait ! Les gens peuvent maintenant télécharger et installer.**

---

## 📦 Publication PPA (Ubuntu/Debian) - 30 minutes

### Étape 1 : Configuration (une seule fois)

```bash
# Installer les outils
sudo apt install devscripts debhelper dput

# Créer une clé GPG
gpg --gen-key
# Suivre les instructions (nom, email, mot de passe)

# Trouver votre Key ID
gpg --list-keys
# Copier l'ID (ligne pub xxx/VOTRE_KEY_ID)

# Envoyer la clé aux serveurs
gpg --send-keys VOTRE_KEY_ID --keyserver keyserver.ubuntu.com

# Créer un compte Launchpad
firefox https://launchpad.net
# Créer compte → Profil → GPG keys → Importer votre clé
```

### Étape 2 : Créer votre PPA

1. Aller sur https://launchpad.net/~VOTRE_USERNAME
2. Cliquer "Create a new PPA"
3. URL: chargen
4. Display name: CharGen
5. Description: Random character generator
6. Créer

### Étape 3 : Préparer et Uploader

```bash
cd /home/vct/Documents/PERSO/CharGen

# Mettre votre email dans les fichiers
sed -i 's/your-email@example.com/VOTRE_EMAIL@gmail.com/g' packaging/debian/changelog
sed -i 's/your-email@example.com/VOTRE_EMAIL@gmail.com/g' packaging/debian/control

# Copier les fichiers debian
cp -r packaging/debian .

# Builder le package source
debuild -S -sa

# Uploader vers PPA
cd ..
dput ppa:VOTRE_USERNAME/chargen chargen_1.0.0-1_source.changes
```

### Étape 4 : Attendre le Build

- Aller sur https://launchpad.net/~VOTRE_USERNAME/+archive/ubuntu/chargen
- Attendre ~15 minutes que le build se termine
- Statut passe de "Building" à "Published"

### ✅ Installation par les Utilisateurs

```bash
sudo add-apt-repository ppa:VOTRE_USERNAME/chargen
sudo apt update
sudo apt install chargen
```

---

## 🎩 Publication COPR (Fedora/RHEL) - 20 minutes

### Étape 1 : Configuration

```bash
# Sur Fedora/RHEL
sudo dnf install copr-cli rpm-build

# Créer compte sur https://copr.fedorainfracloud.org
firefox https://copr.fedorainfracloud.org

# Télécharger la config
# Aller sur : API → Download config
# Sauver dans ~/.config/copr
```

### Étape 2 : Créer le Projet

```bash
# Via ligne de commande
copr-cli create chargen \
  --chroot fedora-39-x86_64 \
  --chroot fedora-40-x86_64 \
  --description "Random character generator" \
  --instructions "sudo dnf copr enable VOTRE_USERNAME/chargen && sudo dnf install chargen"

# OU via interface web
# https://copr.fedorainfracloud.org/coprs/VOTRE_USERNAME/add/
```

### Étape 3 : Builder et Uploader

```bash
cd /home/vct/Documents/PERSO/CharGen

# Mettre votre email
sed -i 's/your-email@example.com/VOTRE_EMAIL@gmail.com/g' packaging/chargen.spec

# Créer le SRPM
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
tar czf ~/rpmbuild/SOURCES/chargen-1.0.0.tar.gz --transform 's,^,chargen-1.0.0/,' .
cp packaging/chargen.spec ~/rpmbuild/SPECS/
rpmbuild -bs ~/rpmbuild/SPECS/chargen.spec

# Uploader vers COPR
copr-cli build chargen ~/rpmbuild/SRPMS/chargen-1.0.0-1.src.rpm
```

### ✅ Installation par les Utilisateurs

```bash
sudo dnf copr enable VOTRE_USERNAME/chargen
sudo dnf install chargen
```

---

## 🏔️ Publication AUR (Arch Linux) - 15 minutes

### Étape 1 : Configuration

```bash
# Créer compte sur https://aur.archlinux.org
firefox https://aur.archlinux.org/register/

# Configurer SSH
ssh-keygen -t ed25519 -C "VOTRE_EMAIL@gmail.com"
cat ~/.ssh/id_ed25519.pub
# Copier la clé → AUR Account → My Account → SSH Public Key
```

### Étape 2 : Préparer le Package

```bash
cd /home/vct/Documents/PERSO/CharGen

# Mettre votre email
sed -i 's/your-email@example.com/VOTRE_EMAIL@gmail.com/g' packaging/PKGBUILD

# Créer le tarball pour AUR
git archive --format=tar.gz --prefix=chargen-1.0.0/ HEAD > chargen-1.0.0.tar.gz

# Calculer le SHA256
sha256sum chargen-1.0.0.tar.gz
# Copier le hash et le mettre dans PKGBUILD (remplacer SKIP)
```

### Étape 3 : Publier sur AUR

```bash
# Cloner le dépôt AUR
cd /tmp
git clone ssh://aur@aur.archlinux.org/chargen.git
cd chargen

# Copier PKGBUILD
cp /home/vct/Documents/PERSO/CharGen/packaging/PKGBUILD .

# Générer .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# Commit et push
git add PKGBUILD .SRCINFO
git commit -m "Initial import: chargen 1.0.0"
git push
```

### ✅ Installation par les Utilisateurs

```bash
yay -S chargen
# ou
paru -S chargen
```

---

## 📋 Checklist Finale

Avant de publier, vérifier :

```bash
# Tests
□ make clean && make              # Compile sans erreur
□ ./test.sh                       # Tous les tests passent
□ ./chargen 16                    # Fonctionne
□ ./chargen --help                # Aide s'affiche

# Configuration
□ Email remplacé dans packaging/*
□ Repository GitHub créé
□ LICENSE présent
□ README.md à jour

# Publication
□ Git tag créé et pushé
□ GitHub Release créée
□ Packages uploadés sur GitHub

# Optionnel mais recommandé
□ PPA Launchpad créé
□ COPR créé
□ AUR uploadé
```

---

## 🎯 Commandes Rapides

### Compiler et Tester
```bash
make clean && make && ./test.sh
```

### Builder Tous les Packages
```bash
cd packaging && ./build-package.sh all
```

### Créer Release Git
```bash
git tag -a v1.0.0 -m "Release 1.0.0"
git push && git push --tags
```

### Test Installation Locale
```bash
sudo make install
chargen 16
sudo make uninstall
```

---

## 🆘 Problèmes Courants

### "debuild: command not found"
```bash
sudo apt install devscripts
```

### "rpmbuild: command not found"
```bash
sudo dnf install rpm-build
```

### "makepkg: command not found"
```bash
# Vous devez être sur Arch Linux
sudo pacman -S base-devel
```

### "GPG signing failed"
```bash
# Vérifier que la clé existe
gpg --list-keys

# Exporter la clé
gpg --send-keys VOTRE_KEY_ID --keyserver keyserver.ubuntu.com
```

---

## 📞 Aide Supplémentaire

- **Documentation complète** : [PACKAGING.md](PACKAGING.md)
- **Guide détaillé** : [QUICK_START.md](QUICK_START.md)
- **Optimisations** : [OPTIMIZATIONS.md](OPTIMIZATIONS.md)

---

**Bon courage ! Votre projet est prêt à conquérir le monde Linux ! 🐧**
