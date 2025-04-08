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

echo ">> 🦀 Rust Dev Container tools 🔧 executing ..."
echo ' ____  _   _ ____ _____   _____ ___   ___  _     ____  
|  _ \| | | / ___|_   _| |_   _/ _ \ / _ \| |   / ___| 
| |_) | | | \___ \ | |     | || | | | | | | |   \___ \ 
|  _ <| |_| |___) || |     | || |_| | |_| | |___ ___) |
|_| \_\\___/|____/ |_|     |_| \___/ \___/|_____|____/ 
'
echo ""
rustup default stable
echo ""

echo ">> 🦀 Rust Dev Container ready 🚀 !"
echo ""
echo "🔹💻 Current user: $(whoami)"
echo ""
echo "🔹🛠️ Rustup version: $(rustup --version)"
echo ""
echo "🔹📦 Cargo version: $(cargo --version)"
echo ""
echo "🔹🗃️ Diesel version: $(diesel --version)"
echo ""
echo "🔹🌐 Trunk version: $(trunk --version)"
echo ""
echo "🔹🧬 Dioxus version: $(dx --version)"
echo ""
echo "🔹🛠️ Rustup toolchain list:"
rustup toolchain list

exec bash

# exec "$@"
# # Si aucune commande n’est fournie, démarrer bash
# if [ $# -eq 0 ]; then
#     exec bash # shell bash à la fin du script
# else
#     exec "$@" # Pour pouvoir surcharger la commande depuis `docker run`
# fi
