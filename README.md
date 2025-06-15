# Rise Zsh ⚡

A sleek productivity plugin for Zsh — designed to boost developer flow with auto-activation, smart directory jumping, and effortless customization.

## ✨ Features

- 🧠 Smart `cd`: lists files and auto-activates venv/conda
- 📂 FZF-powered jump menu for top-visited dirs (`zsh-z`)
- 🐍 Auto-activate `.venv` or `.conda` environments
- 📜 Auto-source `.zalias` for personal aliases
- 🎨 Works beautifully with Powerlevel10k

## 📦 Installation

### Oh My Zsh

git clone https://github.com/YOURNAME/rise-zsh ~/.oh-my-zsh/custom/plugins/rise-zsh


#For .zshrc
plugins+=(rise-zsh)


#For zinit
zinit light YOURNAME/rise-zsh

#For Znap
znap source YOURNAME/rise-zsh

#Manual
git clone https://github.com/YOURNAME/rise-zsh ~/.zsh_plugins/rise-zsh
echo "source ~/.zsh_plugins/rise-zsh/rise.plugin.zsh" >> ~/.zshrc


📄 License
Rise Zsh is released under a hybrid license:

🧩 Portions authored by Jeff Panasuik © 2025 are released under Creative Commons Zero v1.0 Universal (CC0 1.0) — freely usable in any context, including commercial use, without attribution.

📚 Portions adapted from the following open-source projects retain their original licenses and attribution requirements:

zsh-z by agkozak – MIT

zsh-autosuggestions – MIT

zsh-syntax-highlighting – BSD 3-Clause

Powerlevel10k by romkatv – MIT

➡️ Use of the full plugin must comply with these licenses.

To request commercial support or ask about licensing Jeff’s original code separately, email:
📩 jeff.panasuik@gmail.com

---

🔔 Commercial License Grant:
An exception to the above non-commercial terms is granted to:
**SignaVision Solutions Inc.**  
This organization is hereby granted a **non-exclusive, perpetual, royalty-free license** to use, modify, and distribute the Rise Zsh plugin in **commercial settings**.
All other users must obtain explicit permission for commercial use of the original components written by Jeff Panasuik.
