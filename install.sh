#!/bin/bash

# Script d'installation de Zsh, Oh My Zsh, alias et remplacement du .zshrc

# === Installation de Zsh ===
if ! command -v zsh &> /dev/null; then
    echo "Zsh non trouvé, installation en cours..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm zsh
    else
        echo "Gestionnaire de paquets non reconnu. Installez Zsh manuellement."
        exit 1
    fi
else
    echo "✅ Zsh déjà installé."
fi

# === Changer le shell par défaut ===
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "⏳ Changement du shell par défaut..."
    chsh -s "$(which zsh)"
else
    echo "✅ Zsh est déjà le shell par défaut."
fi

# === Installation de Oh My Zsh ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⏳ Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh déjà installé."
fi

# === Remplacement du .zshrc par celui du dossier courant ===
if [ -f "./.zshrc" ]; then
    echo "⏳ Sauvegarde de l'ancien .zshrc (si présent)"
    if [ -f "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    fi
    echo "⏳ Copie du nouveau .zshrc"
    cp "./.zshrc" "$HOME/.zshrc"
    echo "✅ Nouveau .zshrc installé."
else
    echo "⚠ Aucun fichier .zshrc trouvé dans le dossier courant, remplacement ignoré."
fi

# === Création / mise à jour du fichier d'alias ===
CUSTOM_ALIAS_FILE="$HOME/.oh-my-zsh/custom/aliases.zsh"
echo "⏳ Création / mise à jour des alias..."
mkdir -p "$(dirname "$CUSTOM_ALIAS_FILE")"

cat > "$CUSTOM_ALIAS_FILE" << 'EOL'
# Alias personnalisés
alias ll='ls -lah'
alias gs='git status'
alias gp='git pull'
alias up='cd ..'
EOL
echo "✅ Alias ajoutés dans $CUSTOM_ALIAS_FILE"

# === gitconfig ===
if [ -f "./.gitconfig" ]; then
    echo "⏳ Installation de la configuration Git..."
    cp "./.gitconfig" "$HOME/.gitconfig"
    echo "✅ Configuration Git installée."
else
    echo "⚠ Aucun fichier gitconfig trouvé dans le dossier courant, installation ignorée."
fi

# === Installation des paquets depuis la liste packages.txt ===
if [ -f "./packages.txt" ]; then
    echo "⏳ Installation des paquets listés dans packages.txt..."
    PACKAGES=$(grep -v '^#' ./packages.txt | tr '\n' ' ')
    if [ -n "$PACKAGES" ]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y $PACKAGES
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y $PACKAGES
        elif command -v pacman &> /dev/null; then
            sudo pacman -Syu --noconfirm $PACKAGES
        else
            echo "Gestionnaire de paquets non reconnu. Installez manuellement : $PACKAGES"
        fi
    else
        echo "Aucun paquet à installer dans packages.txt"
    fi
else
    echo "Aucun fichier packages.txt trouvé, installation des paquets ignorée."
fi

# === Fin ===
echo "🎉 Installation terminée."
echo "➡ Ouvrez un nouveau terminal ou exécutez : source ~/.zshrc"
