# Optimisations - CharGen

## Code source

Le bug le plus sérieux : `ALPHA_MIN` était dupliqué dans `init_list()`. Corrigé.

La logique de `-i` et `-a` ne marchait pas non plus correctement. Elle est réparée :

- `-ci` : minuscules uniquement
- `-ca` : majuscules uniquement
- `-c` seul, sans `-i` ni `-a` : les deux

Le reste du ménage : validation d'entrée avec messages d'erreur clairs sur stderr, ajout de la constante `VERSION` (`"1.0.0"`) dans `random_char.h`, liste des caractères spéciaux nettoyée, option `--version` pour afficher version et licence, aide (`-h`/`--help`) reformatée avec des exemples.

## Makefile

Le Makefile a été retravaillé pour se comporter comme un vrai Makefile de projet C distribuable : support de `DESTDIR` pour le packaging, support de `PREFIX` pour une installation personnalisée, cibles `install`/`uninstall`, compilation en `-O2`, installation automatique de la page de man si `chargen.1` est présent, cibles `.PHONY` correctement déclarées.

```bash
make                            # build
sudo make install                # install dans /usr/local
sudo make PREFIX=/usr install    # install dans /usr
make clean                       # nettoyer
```

## Documentation

Sept fichiers ont été ajoutés ou réécrits : `chargen.1` (man page au format troff), `README.md`, `PACKAGING.md` (guide PPA/COPR/AUR), `CONTRIBUTING.md`, `CHANGELOG.md`, `QUICK_START.md`, `.gitignore`. Une fois le paquet installé, la page de man se consulte avec `man chargen`.

## Packaging

Trois familles de distributions sont couvertes.

Debian/Ubuntu (.deb), fichiers sous `packaging/debian/` :

```text
packaging/debian/
├── control      # métadonnées du package
├── changelog    # historique des versions
├── rules        # script de build
├── compat       # version debhelper
└── copyright    # informations de licence
```

Fedora/RHEL (.rpm) : `packaging/chargen.spec`.

Arch Linux : `packaging/PKGBUILD`.

Le script `packaging/build-package.sh` automatise tout ça :

```text
deb   : build package Debian
rpm   : build package RPM
arch  : build package Arch
all   : build tous les packages
clean : nettoyer
```

Distributions visées : Debian/Ubuntu (via .deb ou PPA), Fedora/RHEL/CentOS (via .rpm ou COPR), Arch (via AUR), et compilation depuis les sources pour le reste. Gestionnaires de paquets couverts : `apt`, `dnf`/`yum`, `pacman`, ou simplement `make install`.

## Tests automatisés

`test.sh` (lancé via `make check`, qui fait `cd tests && ./test.sh`) couvre 24 cas :

- 4 tests fonctionnels de base
- 7 tests d'options
- 4 tests help/version
- 5 tests de gestion d'erreurs
- 4 tests de validation de sortie

Les 24 passent, la sortie est vérifiée par regex et les codes de sortie sont contrôlés.

## CI/CD

`.github/workflows/ci-cd.yml` build et teste le projet automatiquement, passe le code à cppcheck, construit les packages sur release et les envoie vers GitHub Releases. Déclenché sur push vers main/develop, sur pull request, et à la création d'une release.

## Comparaison avant/après

| Aspect | Avant | Après |
| --- | --- | --- |
| Version | non définie | 1.0.0 |
| Installation | copie manuelle | `make install` + packages |
| Documentation | README basique | 7 fichiers |
| Tests | aucun | 24 tests automatisés |
| Packaging | manuel | .deb, .rpm, PKGBUILD |
| CI/CD | aucun | GitHub Actions |
| Man page | non | oui (`chargen.1`) |
| Bugs connus | 2 critiques | 0 |
| Publication | impossible | prêt pour PPA/COPR/AUR |

## Structure du projet

```text
CharGen/
├── .github/workflows/ci-cd.yml   (CI/CD)
├── include/random_char.h         (VERSION ajoutée)
├── src/
│   ├── main.c
│   ├── lib.c
│   ├── error.c                   (amélioré)
│   ├── process.c
│   ├── flag_help.c               (amélioré)
│   └── flag_manager.c            (bugs corrigés)
├── packaging/
│   ├── debian/
│   ├── chargen.spec
│   ├── PKGBUILD
│   └── build-package.sh
├── requirement/requirement.sh
├── tests/test.sh
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── Makefile
├── PACKAGING.md
├── QUICK_START.md
├── README.md
└── chargen.1
```

## Prochaines étapes

Avant publication, déjà fait : remplacement de l'email de contact dans les fichiers de packaging, création du repository GitHub, tag `v1.0.0`, tests des packages sur VM (Debian, Fedora, Arch).

Après publication, reste à faire : ouvrir un compte Launchpad et publier sur PPA, ouvrir un compte COPR et publier sur COPR, publier sur l'AUR, ajouter des exemples d'utilisation, monter une page GitHub Pages.

Idées pour plus tard, sans urgence : support hexadécimal (`-x`), support base64 (`-b`), copie dans le presse-papier, jeux de caractères personnalisés, fichier de config `~/.chargenrc`, mode batch / génération multiple, et faire de `lib.c` une bibliothèque partagée avec une vraie API.

---

## Optimisé et documenté le 20 décembre 2025
