#!/bin/bash

set -e  # para parar em erro

echo "Iniciando setup do ambiente..."

# 1. Instalar Oh My Zsh (não instalar se já existir)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh já está instalado."
fi

# 2. Copiar .zshrc
echo "Copiando .zshrc para $HOME"
cp -f zsh/.zshrc "$HOME/.zshrc"

# 3. Definir Zsh como shell padrão (somente se não for zsh)
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
  echo "Alterando shell padrão para zsh..."
  chsh -s "$(which zsh)" || echo "Não foi possível mudar shell automaticamente. Faça manualmente com chsh -s $(which zsh)"
else
  echo "Shell padrão já é zsh."
fi

# 4. Copiar configuração do Wezterm
echo "Copiando configuração do Wezterm para $HOME/.wezterm.lua"
cp -f wezterm/.wezterm.lua "$HOME/.wezterm.lua"

# 5. Instalações opcionais
echo "Instalando lazygit..."
if ! command -v lazygit &> /dev/null; then
  sudo add-apt-repository -y ppa:lazygit-team/release
  sudo apt update
  sudo apt install lazygit -y
else
  echo "lazygit já está instalado."
fi

echo "------------------------------------"
echo "Setup concluído!"
echo "Reinicie seu terminal para aplicar as mudanças."
echo "Se o shell padrão não mudou, execute manualmente:"
echo "    chsh -s $(which zsh)"
