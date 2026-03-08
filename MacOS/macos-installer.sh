#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] macOS installer untuk Chrome dan ChromeDriver"

if ! command -v brew >/dev/null 2>&1; then
  echo "[ERROR] Homebrew belum terpasang. Install dulu: https://brew.sh"
  exit 1
fi

echo "[INFO] Install Google Chrome"
if [ -d "/Applications/Google Chrome.app" ] || brew list --cask google-chrome >/dev/null 2>&1; then
  echo "[INFO] Google Chrome sudah terpasang."
else
  brew install --cask google-chrome || true
fi

echo "[INFO] Install ChromeDriver"
if command -v chromedriver >/dev/null 2>&1; then
  echo "[INFO] ChromeDriver sudah terpasang."
else
  brew install --cask chromedriver || brew install chromedriver || true
fi

echo "[INFO] Versi Chrome dan ChromeDriver"
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version || true
chromedriver --version || true

echo "[INFO] Set alias permanen di ~/.zshrc dan ~/.bash_profile (jika ada)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_PATH=""
if [ -x "$SCRIPT_DIR/dist/aitf-engine" ]; then
  BIN_PATH="$SCRIPT_DIR/dist/aitf-engine"
elif [ -x "$SCRIPT_DIR/aitf-engine" ]; then
  BIN_PATH="$SCRIPT_DIR/aitf-engine"
fi

if [ -n "$BIN_PATH" ]; then
  ALIAS_LINE="alias aitf-engine=\"$BIN_PATH\""
else
  ALIAS_LINE='alias aitf-engine="./aitf-engine"'
  echo "[WARN] Binary tidak ditemukan di $SCRIPT_DIR. Alias default mengarah ke ./aitf-engine"
fi

for file in "$HOME/.zshrc" "$HOME/.bash_profile"; do
  if [ -f "$file" ]; then
    if ! grep -q 'alias aitf-engine=' "$file"; then
      echo "$ALIAS_LINE" >> "$file"
    fi
  fi
done
alias aitf-engine="${BIN_PATH:-./aitf-engine}"
echo "[INFO] Jalankan: source ~/.zshrc (atau ~/.bash_profile) untuk aktifkan alias di shell baru."

echo "[PASSED] Installation Success"
