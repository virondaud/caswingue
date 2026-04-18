#!/bin/bash
# Lance un serveur local pour tester la version Firebase
# Port 8081 (pour ne pas entrer en conflit avec l'appli principale sur 8080)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PORT=8081

echo ""
echo "🔥 Ça Swingue Manager — Test Firebase"
echo "======================================"
echo ""
echo "📁 Dossier : $DIR"
echo "🌐 URL     : http://localhost:$PORT/"
echo ""
echo "⚠️  Si firebase-config.js n'est pas rempli, ouvre le README.md"
echo ""
echo "Ouverture automatique dans le navigateur dans 3 sec…"
echo "Arrête avec Ctrl+C"
echo ""

# Ouvre le navigateur après 3 sec en background
( sleep 3 && open "http://localhost:$PORT/" ) &

cd "$DIR"
python3 -m http.server $PORT
