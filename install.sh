#!/bin/bash

# Script d'installation de Zsh, Oh My Zsh et alias personnalisés

# === 1. Installation de Zsh ===
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

# === 2. Changer le shell par défaut ===
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "⏳ Changement du shell par défaut..."
    chsh -s "$(which zsh)"
else
    echo "✅ Zsh est déjà le shell par défaut."
fi

# === 3. Installation de Oh My Zsh ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⏳ Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh déjà installé."
fi

# === 4. Création automatique du fichier d'alias ===
CUSTOM_ALIAS_FILE="$HOME/.oh-my-zsh/custom/aliases.zsh"

echo "⏳ Création / mise à jour des alias..."
mkdir -p "$(dirname "$CUSTOM_ALIAS_FILE")"

cat > "$CUSTOM_ALIAS_FILE" << 'EOL'
# Alias personnalisés
alias ipy="python3 -mIPython"
alias e="explorer.exe ."
alias t="clear && task"
alias c="code ."
alias tt="taskwarrior-tui"
EOL

echo "✅ Alias ajoutés dans $CUSTOM_ALIAS_FILE"

# === 5. Fin ===
echo "🎉 Installation terminée."
echo "➡ Ouvrez un nouveau terminal ou exécutez : source ~/.zshrc"