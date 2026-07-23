# Guide de Démarrage Rapide - CharGen

## 🚀 Installation Rapide

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

---

## 📦 Créer les Packages

### 1. Vérifier que tout compile
```bash
make clean
make
./test.sh  # Tous les tests doivent passer
```

### 2. Builder les packages

#### Pour Debian/Ubuntu (.deb)
```bash
cd packaging
./build-package.sh deb
```
Le fichier `.deb` sera dans `build/deb/`

**Installation :**
```bash
sudo dpkg -i build/deb/chargen_1.0.0-1_amd64.deb
```

#### Pour Fedora/RHEL (.rpm)
```bash
cd packaging
./build-package.sh rpm
```
Le fichier `.rpm` sera dans `build/rpm/`

**Installation :**
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
Le package sera dans `build/arch/`

**Installation :**
```bash
sudo pacman -U build/arch/chargen-1.0.0-1-x86_64.pkg.tar.zst
```

---

## 🌐 Publier sur les Dépôts Officiels

### Ubuntu PPA (Recommandé pour débutants)

1. **Créer un compte Launchpad** : https://launchpad.net

2. **Configurer GPG**
```bash
gpg --gen-key
gpg --list-keys
gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
```

3. **Créer votre PPA**
- Allez sur https://launchpad.net/~YOUR_USERNAME/+activate-ppa
- Créez un PPA nommé "chargen"

4. **Uploader**
```bash
cd CharGen
cp -r packaging/debian .
# Modifier debian/changelog avec votre email
debuild -S -sa
dput ppa:YOUR_USERNAME/chargen ../chargen_1.0.0-1_source.changes
```

5. **Les utilisateurs pourront installer avec :**
```bash
sudo add-apt-repository ppa:YOUR_USERNAME/chargen
sudo apt update
sudo apt install chargen
```

### Fedora COPR

1. **Créer un compte** : https://copr.fedorainfracloud.org

2. **Créer un projet COPR "chargen"** via l'interface web

3. **Installer copr-cli**
```bash
sudo dnf install copr-cli
```

4. **Télécharger votre config** depuis COPR → API → Config

5. **Builder et uploader**
```bash
rpmbuild -bs packaging/chargen.spec
copr-cli build chargen ~/rpmbuild/SRPMS/chargen-1.0.0-1.src.rpm
```

6. **Les utilisateurs pourront installer avec :**
```bash
sudo dnf copr enable YOUR_USERNAME/chargen
sudo dnf install chargen
```

### Arch User Repository (AUR)

1. **Créer un compte AUR** : https://aur.archlinux.org

2. **Ajouter votre clé SSH** dans votre profil AUR

3. **Créer le dépôt**
```bash
git clone ssh://aur@aur.archlinux.org/chargen.git chargen-aur
cd chargen-aur
cp ../CharGen/packaging/PKGBUILD .
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Initial commit: chargen 1.0.0"
git push origin master
```

4. **Les utilisateurs pourront installer avec :**
```bash
yay -S chargen
# ou
paru -S chargen
```

---

## 🎯 Checklist avant Publication

- [ ] Code compilé et testé (`./test.sh` passe à 100%)
- [ ] Version mise à jour dans tous les fichiers
- [ ] CHANGELOG.md à jour
- [ ] README.md complet et clair
- [ ] LICENSE présent
- [ ] Email mis à jour dans les fichiers de packaging
- [ ] GPG key configurée (pour PPA)
- [ ] GitHub repository créé et poussé
- [ ] GitHub Release créée avec les binaires
- [ ] Documentation testée

---

## 📝 Mettre à Jour votre Email

Avant de publier, remplacez `your-email@example.com` dans :
- `packaging/debian/control`
- `packaging/debian/changelog`
- `packaging/chargen.spec`
- `packaging/PKGBUILD`

```bash
# Exemple de remplacement
find packaging -type f -exec sed -i 's/your-email@example.com/votre.email@domaine.com/g' {} +
```

---

## 🔄 Workflow de Publication

1. **Développement**
   ```bash
   git checkout -b feature/nouvelle-fonctionnalite
   # ... développement ...
   make && ./test.sh
   git commit -am "Add: nouvelle fonctionnalité"
   git push origin feature/nouvelle-fonctionnalite
   ```

2. **Merge et Tag**
   ```bash
   git checkout main
   git merge feature/nouvelle-fonctionnalite
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push && git push --tags
   ```

3. **Build et Release**
   ```bash
   cd packaging
   ./build-package.sh all
   ```

4. **GitHub Release**
   - Créer une release sur GitHub
   - Uploader les fichiers `.deb`, `.rpm`, `.pkg.tar.zst`
   - Copier le contenu du CHANGELOG

5. **Update PPA/COPR/AUR**
   - Mettre à jour les versions
   - Re-builder et uploader

---

## 💡 Conseils

1. **Commencez simple** : Publiez d'abord sur GitHub Releases
2. **Testez sur plusieurs distributions** avant de publier
3. **Répondez rapidement** aux issues et questions
4. **Maintenez votre code** : corrigez les bugs rapidement
5. **Documentez tout** : README, man page, exemples

---

## 🆘 Ressources

- Documentation complète : [PACKAGING.md](PACKAGING.md)
- Contributing : [CONTRIBUTING.md](CONTRIBUTING.md)
- Debian Packaging : https://packaging.ubuntu.com/html/
- Fedora Packaging : https://docs.fedoraproject.org/en-US/packaging-guidelines/
- Arch Packaging : https://wiki.archlinux.org/title/Creating_packages

---

## ✅ Prochaines Étapes

1. Tester sur différentes distributions
2. Créer un compte sur les plateformes (Launchpad, COPR, AUR)
3. Configurer vos clés GPG/SSH
4. Faire votre premier upload sur PPA (le plus simple)
5. Créer une GitHub Release
6. Partager votre projet !

Bonne chance ! 🎉
