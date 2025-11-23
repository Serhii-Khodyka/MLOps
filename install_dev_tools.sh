#!/bin/bash

LOG_FILE="install.log"

echo "=== INSTALL STARTED === $(date)" | tee -a $LOG_FILE

check_and_install() {
    PKG=$1
    CMD=$2
    INSTALL_CMD=$3

    if ! command -v $CMD &> /dev/null; then
        echo "[INFO] Installing $PKG..." | tee -a $LOG_FILE
        eval $INSTALL_CMD >> $LOG_FILE 2>&1
    else
        echo "[OK] $PKG already installed." | tee -a $LOG_FILE
    fi
}

echo "Updating system..." | tee -a $LOG_FILE
sudo apt update -y >> $LOG_FILE 2>&1

# ---------------------------
# Docker
# ---------------------------
check_and_install "Docker" "docker" "sudo apt install -y docker.io"
sudo systemctl enable --now docker 2>> $LOG_FILE
sudo usermod -aG docker $USER 2>> $LOG_FILE

# ---------------------------
# Docker Compose
# ---------------------------
check_and_install "Docker Compose" "docker-compose" \
"sudo apt install -y docker-compose"

# ---------------------------
# Python 3.9+
# ---------------------------
PY_VERSION=$(python3 -V 2>/dev/null | grep -oP '3\.\d+')

if [[ -z "$PY_VERSION" || "$PY_VERSION" < "3.9" ]]; then
    echo "[INFO] Installing Python 3.10..." | tee -a $LOG_FILE
    sudo apt install -y python3.10 python3.10-venv python3-pip >> $LOG_FILE 2>&1
else
    echo "[OK] Python version OK: $(python3 --version)" | tee -a $LOG_FILE
fi

# ---------------------------
# Pip
# ---------------------------
if ! command -v pip3 &> /dev/null; then
    echo "[INFO] Installing pip3..." | tee -a $LOG_FILE
    sudo apt install -y python3-pip >> $LOG_FILE 2>&1
else
    echo "[OK] pip3 already installed: $(pip3 --version)" | tee -a $LOG_FILE
fi

# ---------------------------
# Django
# ---------------------------
if python3 -c "import django" 2>/dev/null; then
    echo "[OK] Django already installed." | tee -a $LOG_FILE
else
    echo "[INFO] Installing Django..." | tee -a $LOG_FILE
    pip3 install Django >> $LOG_FILE 2>&1
fi

# ---------------------------
# Torch + torchvision + pillow
# ---------------------------
pip_pkg_check() {
    python3 - <<EOF
import pkgutil
exit(0 if pkgutil.find_loader("$1") else 1)
EOF
}

echo "[INFO] Checking ML libraries..." | tee -a $LOG_FILE

if pip_pkg_check torch; then
    echo "[OK] torch already installed." | tee -a $LOG_FILE
else
    echo "[INFO] Installing torch..." | tee -a $LOG_FILE
    pip3 install torch >> $LOG_FILE 2>&1
fi

if pip_pkg_check torchvision; then
    echo "[OK] torchvision already installed." | tee -a $LOG_FILE
else
    echo "[INFO] Installing torchvision..." | tee -a $LOG_FILE
    pip3 install torchvision >> $LOG_FILE 2>&1
fi

if pip_pkg_check pillow; then
    echo "[OK] pillow already installed." | tee -a $LOG_FILE
else
    echo "[INFO] Installing pillow..." | tee -a $LOG_FILE
    pip3 install pillow >> $LOG_FILE 2>&1
fi

echo "=== INSTALL FINISHED === $(date)" | tee -a $LOG_FILE
