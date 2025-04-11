#!/bin/sh
# Purpose:
# Author: Oumar Makan Camara
# ------------------------------------------
# 
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

set -o errexit
set -o nounset
IFS=$'\n\t'

echo ">> 🦀 Rust Dev Container tools 🔧  executing ..."
echo ' ____  _   _ ____ _____   _____ ___   ___  _     ____  
|  _ \| | | / ___|_   _| |_   _/ _ \ / _ \| |   / ___| 
| |_) | | | \___ \ | |     | || | | | | | | |   \___ \ 
|  _ <| |_| |___) || |     | || |_| | |_| | |___ ___) |
|_| \_\\___/|____/ |_|     |_| \___/ \___/|_____|____/ 
'

# Créer l'utilisateur rust-tools s'il n'existe pas
if ! id "rust-tools" >/dev/null 2>&1; then
  sudo adduser --disabled-password --gecos "" rust-tools
fi

# Déplacer le README pour que rust-tools y ait accès
# cp -pr ./README.md /home/rust-tools/
sudo chown -R rust-tools:rust-tools /home/rust-tools

# Ajoute sudo si nécessaire (à activer si tu veux vraiment du sudo dans ton conteneur)
sudo echo "rust-tools ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rust-tools

# Afficher les outils installés
su - rust-tools <<EOF
echo ""
rustup default stable
echo ""

echo ">> 🦀 Rust Dev Container ready 🚀 !"
echo ""
echo "🔹💻 Current user: \$(whoami)"
echo ""
echo "🔹🛠️ Rustup version: \$(rustup --version)"
echo "🔹📦 Cargo version: \$(cargo --version)"
echo "🔹🗃️ Diesel version: \$(diesel --version)"
echo "🔹🌐 Trunk version: \$(trunk --version)"
echo "🔹🧬 Dioxus version: \$(dx --version)"
echo ""
echo "🔹🛠️ Rustup toolchain list:"
rustup toolchain list
rustup target list | grep installed
rustup component list | grep installed

# Garde le conteneur en vie
exec sh
EOF

# exec "$@"
# # Si aucune commande n’est fournie, démarrer bash
# if [ $# -eq 0 ]; then
#     exec bash # shell bash à la fin du script
# else
#     exec "$@" # Pour pouvoir surcharger la commande depuis `docker run`
# fi
