#!/bin/bash

set -e

export DISPLAY=:1
export HOME=/root

echo "=========================================="
echo "        KALI LINUX XFCE DESKTOP"
echo "=========================================="

# تنظيف جلسة VNC قديمة
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# تشغيل TigerVNC
echo "[+] Starting TigerVNC..."

vncserver :1 \
    -geometry 1280x800 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None

echo "[+] TigerVNC running on port 5901"

# Railway يحدد PORT تلقائياً
PORT="${PORT:-6080}"

echo "[+] Starting noVNC on port ${PORT}"

# تشغيل WebSocket/noVNC
exec websockify \
    --web=/usr/share/novnc \
    0.0.0.0:${PORT} \
    127.0.0.1:5901
