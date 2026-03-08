#!/usr/bin/env bash
set -euo pipefail

SUDO_PASSWORD=""
if sudo -n true 2>/dev/null; then
  echo "[INFO] Sudo tanpa password terdeteksi."
else
  echo -n "Masukan sudo password: [tekan 'ENTER' apabila tidak ada password] "
  read -s SUDO_PASSWORD
  echo
  if [ -n "${SUDO_PASSWORD}" ]; then
    sudo -S -v <<< "$SUDO_PASSWORD"
  else
    sudo -v
  fi
fi

echo "[INFO] Install Chromium & Chromium Driver"
if [ -n "${SUDO_PASSWORD}" ]; then
  sudo -S apt update <<< "$SUDO_PASSWORD"
  sudo -S apt install -y chromium chromium-driver <<< "$SUDO_PASSWORD"
else
  sudo apt update
  sudo apt install -y chromium chromium-driver
fi
chromium --version || true
chromedriver --version || true

echo "[INFO] Install xvfb dependencies"
if [ -n "${SUDO_PASSWORD}" ]; then
  sudo -S apt update <<< "$SUDO_PASSWORD"
sudo -S apt install -y \
  xvfb \
  libxi6 \
  libgconf-2-4 \
  libnss3 \
  libatk-bridge2.0-0 \
  libgtk-3-0 \
  libxss1 \
  libasound2 \
  libgbm1 \
  fonts-liberation \
  xdg-utils <<< "$SUDO_PASSWORD" || true
else
  sudo apt update
  sudo apt install -y \
  xvfb \
  libxi6 \
  libgconf-2-4 \
  libnss3 \
  libatk-bridge2.0-0 \
  libgtk-3-0 \
  libxss1 \
  libasound2 \
  libgbm1 \
  fonts-liberation \
  xdg-utils || true
fi

echo "[INFO] Install xvfb"
if [ -n "${SUDO_PASSWORD}" ]; then
  sudo -S apt install -y xvfb <<< "$SUDO_PASSWORD"
else
  sudo apt install -y xvfb
fi

alias aitf-engine="xvfb-run -a ./aitf-engine"
for file in "$HOME/.bashrc" "$HOME/.profile"; do
  if [ -f "$file" ]; then
    if ! grep -q 'alias aitf-engine=' "$file"; then
      echo 'alias aitf-engine="xvfb-run -a ./aitf-engine"' >> "$file"
    fi
  fi
done

echo "[PASSED] Installation Success"