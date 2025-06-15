#!/bin/bash

set -e

echo "=============================="
echo "     Zsh-z Ultimate Setup     "
echo "=============================="
echo

echo "Which Zsh plugin manager do you use?"
echo "1. Oh My Zsh"
echo "2. Prezto"
echo "3. Zgen"
echo "4. Zinit"
echo "5. Znap"
echo "6. Zcomet"
echo "7. Zplug"
echo "8. Zim"
read -p "Enter the number (or press Enter to cancel): " choice

if [ -z "$choice" ]; then
  echo "Aborted."
  exit 1
fi

HOME_DIR="$HOME"
ZSHRC="$HOME_DIR/.zshrc"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME_DIR/.oh-my-zsh/custom}"
FONTS_DIR="$HOME_DIR/.local/share/fonts"
MESLO_URL_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"

# Ensure fzf is installed
if ! command -v fzf &>/dev/null; then
  echo "📦 Installing fzf..."
  sudo apt install -y fzf
fi

# Powerlevel10k + Syntax + Suggestions + Theme setup for Oh My Zsh
install_ohmyzsh_plugins() {
  echo "🔧 Installing zsh plugins and Powerlevel10k..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true

  sed -i'' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
  sed -i'' '/^plugins=/ s/)/ zsh-z zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC"
  echo "✅ Oh My Zsh updated with plugins and P10k"
}

install_fonts() {
  echo "🖼️  Installing Nerd Font: MesloLGS NF"
  mkdir -p "$FONTS_DIR"
  for style in Regular Bold Italic "Bold Italic"; do
    curl -fsSL "$MESLO_URL_BASE/MesloLGS%20NF%20$style.ttf" -o "$FONTS_DIR/MesloLGS-NF-$style.ttf"
  done
  fc-cache -fv "$FONTS_DIR"
  echo "✅ Fonts installed. Set terminal font to MesloLGS NF."
}

check_fonts() {
  echo
  echo "🧠 Checking for MesloLGS NF font..."
  if ! fc-list | grep -qi "MesloLGS NF"; then
    read -p "❌ Font not found. Install MesloLGS NF Nerd Font now? (y/n): " install_font
    if [[ $install_font == [Yy]* ]]; then
      install_fonts
    else
      echo "⚠️  Font installation skipped. You may see broken Powerlevel10k symbols."
    fi
  else
    echo "✅ MesloLGS NF already installed."
  fi
}

install_zshz_env() {
  cat <<'EOF' >> "$ZSHRC"

# Zsh-z config
export ZSHZ_CMD="z"
export ZSHZ_COMPLETION="frecent"
export ZSHZ_ECHO=1
export ZSHZ_TILDE=1
export ZSHZ_CASE="smart"
export ZSHZ_UNCOMMON=1
EOF
}

add_helpers() {
  cat <<'EOF' >> "$ZSHRC"

# === Zsh-z Helpers ===

show_frequent_dirs() {
  if [ -f "$HOME/.z" ]; then
    echo "Most visited directories:"
    awk -F"|" '{print $2 " (" int($1) " visits)"}' "$HOME/.z" | sort -nrk2 | head -n 5 | nl
    echo "Use 'z <name>' to jump!"
  fi
}

jump_menu() {
  if [ -f "$HOME/.z" ]; then
    dir=$(awk -F"|" '{print $2}' "$HOME/.z" | sort | uniq | fzf --prompt="Jump to dir: ")
    [ -n "$dir" ] && cd "$dir"
  fi
}
[[ $- == *i* ]] && jump_menu

autoload_conda() {
  local marker=".conda"
  local root_dir="$PWD"
  while [[ "$root_dir" != "/" ]]; do
    if [[ -f "$root_dir/$marker" ]]; then
      local env_name
      env_name=$(cat "$root_dir/$marker" | tr -d '[:space:]')
      if [[ -n "$env_name" ]]; then
        echo "🔹 Activating Conda env: $env_name"
        conda activate "$env_name"
        return
      fi
    fi
    root_dir=$(dirname "$root_dir")
  done
}
precmd_functions+=autoload_conda
EOF
}

preload_git_dirs() {
  echo
  read -p "Preload Git directories into zsh-z? (y/n): " preload
  if [[ $preload == [Yy]* ]]; then
    echo "🔍 Scanning for Git repos in $HOME..."
    for i in $(find "$HOME" -type d -name .git 2>/dev/null | head -n 50); do
      z --add "$(dirname "$i")"
    done
    echo "✅ Git dirs added to zsh-z database."
  fi
}

# Plugin Manager Detection & Zsh-z Activation
case $choice in
  1) install_ohmyzsh_plugins ;;
  2)
    git clone https://github.com/agkozak/zsh-z.git ~/.zprezto-contrib/zsh-z || true
    sed -i'' "s|^#*\s*zstyle ':prezto:load' pmodule-dirs.*|zstyle ':prezto:load' pmodule-dirs \$HOME/.zprezto-contrib|" "$HOME/.zpreztorc"
    sed -i'' "/^zstyle ':prezto:load' pmodule / s|$| \\\n    'zsh-z'|" "$HOME/.zpreztorc"
    ;;
  3) sed -i'' "/zgen load/ i\\
zgen load agkozak/zsh-z
" "$ZSHRC" ;;
  4) sed -i'' "/zinit load/ i\\
zinit load agkozak/zsh-z
" "$ZSHRC" ;;
  5) sed -i'' "/znap source/ i\\
znap source agkozak/zsh-z
" "$ZSHRC" ;;
  6) sed -i'' "/zcomet compinit/ i\\
zcomet load agkozak/zsh-z
" "$ZSHRC" ;;
  7) sed -i'' "/zplug load/ i\\
zplug \"agkozak/zsh-z\"
" "$ZSHRC" ;;
  8) sed -i'' "/^zmodule/ i\\
zmodule https://github.com/agkozak/zsh-z
" "$HOME/.zimrc" ;;
  *) echo "❌ Invalid option. Exiting." && exit 1 ;;
esac

install_zshz_env
add_helpers
preload_git_dirs
check_fonts

echo
echo "🎉 Zsh setup complete! Run: source ~/.zshrc or restart terminal."
