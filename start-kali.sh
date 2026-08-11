#!/bin/bash

set -e

export DISPLAY=:1
export HOME=/root

echo "=========================================="
echo "        KALI LINUX XFCE DESKTOP"
echo "=========================================="

rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

echo "[+] Starting TigerVNC..."

vncserver :1 \
    -geometry 1280x800 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None

echo "[+] TigerVNC started on port 5901"

PORT="${PORT:-6080}"

echo "[+] Starting noVNC on port ${PORT}"

exec websockify \
    --web=/usr/share/novnc \
    0.0.0.0:${PORT} \
    127.0.0.1:5901
