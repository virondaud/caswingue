# 📡 Ça Swingue Manager — Version test Firebase

Version expérimentale avec **partage live** des parties de golf. Les proches peuvent suivre les scores en temps réel depuis leur téléphone, sans installer d'app.

## 🎯 Fonctionnement

1. Tu lances une partie normalement
2. Tu cliques sur 📡 en haut de l'écran
3. Un QR code + URL est généré
4. Tu envoies le lien à tes proches (WhatsApp, SMS…)
5. Ils ouvrent le lien → ils voient les scores se mettre à jour **en temps réel** (~300ms)

**Aucune modification** n'est faite à ton appli actuelle dans `site/`. Tout est isolé ici.

---

## 🚀 Étape 1 — Créer ton projet Firebase (5 minutes)

### 1.1 Aller sur la console Firebase
- Va sur https://console.firebase.google.com/
- Connecte-toi avec ton compte Google

### 1.2 Créer un projet
- Clique **"Créer un projet"** (ou "Add project")
- Nom : `ca-swingue-test` (ou autre)
- Décoche **Google Analytics** (pas nécessaire)
- Clique **"Créer"** — attendre 30 sec

### 1.3 Créer la Realtime Database
- Dans le menu de gauche : **Build → Realtime Database**
- Clique **"Créer une base de données"**
- Localisation : **Europe (europe-west1)** ← important pour la latence
- Mode : **Mode test** (lecture/écriture publique — parfait pour ton usage)
- Clique **Activer**

### 1.4 Récupérer la configuration
- Clique sur l'icône ⚙️ en haut à gauche → **"Paramètres du projet"**
- Descends jusqu'à **"Tes applications"**
- Clique sur l'icône **Web** `</>`
- Nom de l'app : `ca-swingue-web`
- **PAS BESOIN** de cocher Firebase Hosting
- Clique **"Enregistrer l'app"**
- Une config JavaScript s'affiche → **copie les 7 lignes** `apiKey`, `authDomain`, `databaseURL`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`

### 1.5 Coller dans `firebase-config.js`
Ouvre le fichier `firebase-config.js` de ce dossier et remplace les valeurs `XXX-REPLACE-ME` par celles de ton projet.

⚠️ **Si `databaseURL` est manquant dans l'interface Firebase** : va dans **Realtime Database**, la barre en haut contient l'URL (genre `https://ca-swingue-test-default-rtdb.europe-west1.firebasedatabase.app`). Copie-la.

---

## 🧪 Étape 2 — Tester localement

### 2.1 Lancer le serveur
Depuis ce dossier :

```bash
./lancer_test.command
```

Ou manuellement :

```bash
python3 -m http.server 8081 -d /Users/mathieuvirondaud/claude/golf/ça_swingue/firebase_test
```

### 2.2 Ouvrir l'app
Ouvre dans Safari (ou Chrome) :

```
http://localhost:8081/
```

### 2.3 Tester le partage
1. Ajoute des joueurs, crée un parcours, lance une partie
2. Dans la partie, clique sur 📡 (en haut à droite)
3. La modale s'ouvre avec QR code + URL
4. Ouvre l'URL **dans un autre onglet** (ou autre téléphone) → tu verras la page spectateur
5. Reviens dans la première fenêtre, entre un score → tu verras la page spectateur se mettre à jour automatiquement

---

## 🔐 Sécurité

### Règles par défaut (mode test)
Tout le monde avec l'URL de la base peut lire/écrire. **C'est OK pour tester**. Pour prod :

### Règles recommandées (à coller dans Firebase → Realtime Database → Règles)
```json
{
  "rules": {
    "games": {
      "$gameId": {
        ".read": true,
        ".write": true,
        ".validate": "$gameId.matches(/^g-[a-z0-9]{6}$/)"
      }
    }
  }
}
```
Cela limite les IDs au format `g-xxxxxx` et rend les lectures/écritures publiques mais sans possibilité de spam (nom impossible à deviner).

Pour une vraie sécurité : activer Firebase Authentication (Google Sign-In) et lier l'écriture à `auth.uid`.

---

## 📊 Quota gratuit Firebase

Plan **Spark** (gratuit, pas de carte requise) :
- 1 GB stockage
- 10 GB transfert/mois
- 100 connexions simultanées
- 20k écritures/jour

Ton usage estimé (quelques parties/semaine, 4 joueurs, 3 spectateurs max) : **~0,01%** du quota. Aucun risque de payer.

---

## 🗂️ Fichiers de ce dossier

- `index.html` — copie de `site/golf_manager.html` + intégration Firebase
- `spectator.html` — page spectateur (lecture seule)
- `firebase-config.js` — config Firebase (à remplir)
- `lancer_test.command` — lancer un serveur local sur port 8081
- `README.md` — ce fichier

---

## ❌ Désinstaller / nettoyer

Si tu ne veux pas garder cette version, supprime juste le dossier :

```bash
rm -rf /Users/mathieuvirondaud/claude/golf/ça_swingue/firebase_test
```

Et côté Firebase (optionnel) :
- Paramètres du projet → Supprimer le projet

Rien ne change dans ton appli principale.

---

## ✅ Si tu gardes

Pour intégrer à la version principale :
1. Copier les ajouts (bouton 📡 + fonctions Firebase) dans `site/golf_manager.html`
2. Créer `site/firebase-config.js` avec les mêmes clés
3. Copier `spectator.html` dans `site/`
4. Déployer comme d'habitude

Je peux te faire le merge si tu valides la version test.
