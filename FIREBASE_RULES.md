# 🔐 Règles de sécurité Firebase — À APPLIQUER

## 🚨 Urgence : actuellement en mode test (lecture/écriture publique)

Copie les règles ci-dessous dans :
**Firebase Console → Realtime Database → Règles**

URL directe :
https://console.firebase.google.com/project/ca-swingue-test/database/ca-swingue-test-default-rtdb/rules

## Règles à appliquer

```json
{
  "rules": {
    ".read": false,
    ".write": false,

    "games": {
      "$gameId": {
        ".read": "$gameId.matches(/^g-[a-z0-9]{6,10}$/)",
        ".write": "$gameId.matches(/^g-[a-z0-9]{6,10}$/) && auth != null",
        ".validate": "newData.hasChildren(['updatedAt'])"
      }
    },

    "users": {
      "$userId": {
        ".read": "$userId.matches(/^user-[a-z0-9]{4,12}$/)",
        ".write": "$userId.matches(/^user-[a-z0-9]{4,12}$/) && auth != null"
      }
    },

    "championships": {
      "$champId": {
        ".read": "auth != null && $champId.matches(/^[a-z0-9][a-z0-9-]{3,50}$/)",

        "info": {
          ".write": "auth != null && (!data.exists() || data.child('ownerUid').val() === auth.uid || data.child('coAdminUids').val().contains(auth.uid))"
        },

        "rounds": {
          "$roundId": {
            ".write": "auth != null && (!data.exists() || data.child('addedByUid').val() === auth.uid || root.child('championships').child($champId).child('info/ownerUid').val() === auth.uid || root.child('championships').child($champId).child('info/coAdminUids').val().contains(auth.uid))"
          }
        }
      }
    }
  }
}
```

## Ce que font ces règles

### `games/` (partage live)
- Lecture/écriture ouverte aux URLs de format `g-xxxxxx`
- Écriture exige auth (anonymous suffit)
- Validation : doit contenir `updatedAt`

### `users/` (backup cloud perso)
- Lecture/écriture ouverte aux URLs de format `user-xxxxxx`
- Écriture exige auth

### `championships/` (championnats en ligne)
- Lecture : tout utilisateur authentifié avec le bon format de code
- Modification `info` : seulement propriétaire ou co-admins
- Ajout `rounds` : tout utilisateur authentifié
- Modification/suppression `rounds` : auteur de la manche OU propriétaire du championnat OU co-admin

## Étapes à suivre

### 1. Activer Anonymous Authentication

Dans la console Firebase :
1. **Authentication** (dans le menu)
2. **Sign-in method** / **Méthodes de connexion**
3. Cherche **"Anonymous"** / **"Anonyme"**
4. Clique → **Enable** → **Save**

### 2. Coller les règles

1. **Realtime Database** (dans le menu)
2. Onglet **"Rules"** / **"Règles"**
3. Remplace tout le contenu par les règles ci-dessus
4. Clique **"Publish"** / **"Publier"**

### 3. Vérifier

- Teste ton app sur le téléphone après ces changements
- Si "Auth timeout" → vérifie que Anonymous Auth est bien activée
- Si "Permission denied" → les règles sont trop strictes, reviens-voir-moi

## En cas de problème

Reviens à une règle plus permissive temporairement :

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

Cela n'autorise que les utilisateurs authentifiés, mais sans restriction par chemin.
