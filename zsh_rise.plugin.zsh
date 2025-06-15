# rise.plugin.zsh
# Rise Zsh - Developer Productivity Enhancer
# Author: Jeff Panasuik © 2025
#
# Portions adapted from:
# - zsh-z by agkozak (MIT) — https://github.com/agkozak/zsh-z

# Load custom aliases
[ -f "$HOME/.zalias" ] && source "$HOME/.zalias"

# Auto-activate venv or .venv if found
auto_activate_venv() {
  found_venv=0
  for v in venv .venv; do
    if [ -f "$v/bin/activate" ]; then
      found_venv=1
      [[ -n "$VIRTUAL_ENV" ]] && deactivate 2>/dev/null
      echo "🔹 Activating $v in $(pwd)"
      source "$PWD/$v/bin/activate"
      break
    fi
  done
  if [[ "$found_venv" -eq 0 && -n "$VIRTUAL_ENV" ]]; then
    echo "🔹 No venv here, deactivating previous"
    deactivate 2>/dev/null
  fi
}

find_conda_env_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    [[ -f "$dir/.conda" ]] && echo "$dir" && return
    dir="${dir:h}"
  done
}

smart_conda_activate() {
  local env_root envname
  env_root=$(find_conda_env_root)
  if [[ -n "$env_root" ]]; then
    envname=$(<"$env_root/.conda")
    if [[ "$CONDA_DEFAULT_ENV" != "$envname" ]]; then
      if command -v conda >/dev/null 2>&1; then
        echo "🔹 Activating conda environment: $envname"
        conda activate "$envname"
      fi
    fi
  elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    conda deactivate
  fi
}

cd() {
  builtin cd "$@" || return
  ls
  auto_activate_venv
  smart_conda_activate
}

# FZF-powered jump menu using zsh-z database
# Adapted from https://github.com/agkozak/zsh-z (MIT License)
jump_menu() {
  if [ -f "$HOME/.z" ]; then
    dir=$(awk -F"|" '{print $2}' "$HOME/.z" | sort | uniq | fzf --prompt="Jump to dir: ")
    [ -n "$dir" ] && cd "$dir"
  fi
}
[[ $- == *i* ]] && jump_menu

show_frequent_dirs() {
  if [ -f "$HOME/.z" ]; then
    echo "Most visited directories:"
    awk -F"|" '{print $2 " (" int($1) " visits)"}' "$HOME/.z" | sort -nrk2 | head -n 5 | nl
    echo "Use 'z <name>' to jump!"
  fi
}
