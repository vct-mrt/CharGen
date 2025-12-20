# Tests CharGen

Ce répertoire contient tous les tests automatisés pour CharGen.

## Tests Disponibles

### `test.sh` - Suite de Tests Principale

Suite complète de tests automatisés qui vérifie :

- **Tests fonctionnels** : génération de caractères avec différentes options
- **Tests d'options** : validation de tous les flags (-n, -c, -s, -i, -a)
- **Tests help/version** : vérification des messages d'aide
- **Tests d'erreurs** : gestion des cas d'erreur
- **Tests de validation** : vérification du format de sortie

**Utilisation :**
```bash
cd tests
./test.sh
```

## Exécution dans CI/CD

Ces tests sont automatiquement exécutés par GitHub Actions sur :
- Chaque push sur main/develop
- Chaque pull request
- Chaque création de tag/release

## Ajout de Nouveaux Tests

Pour ajouter un test :

1. Éditer `test.sh`
2. Ajouter votre test avec la fonction `test_command`
3. Lancer `./test.sh` pour vérifier
4. Committer les changements

## Résultats Attendus

Tous les tests doivent passer (exit code 0) :
```
Total tests: 24
Passed: 24
Failed: 0

All tests passed!
```

Si un test échoue, le script retourne exit code 1.
