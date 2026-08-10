FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080

# --------------------------------------------------
# System + Kali Desktop + VNC + noVNC
# --------------------------------------------------

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y \
        kali-desktop-xfce \
        kali-linux-everything \
        tigervnc-standalone-server \
        tigervnc-tools \
        novnc \
        websockify \
        dbus-x11 \
        dbus \
        openssl \
        sudo \
        curl \
        wget \
        git \
        nano \
        vim \
        less \
        unzip \
        zip \
        tar \
        gzip \
        bzip2 \
        ca-certificates \
        procps \
        iproute2 \
        iputils-ping \
        net-tools \
        psmisc \
        htop \
        lsof \
        bash-completion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Create VNC directory
# --------------------------------------------------

RUN mkdir -p /root/.vnc && \
    chmod 700 /root/.vnc

# --------------------------------------------------
# XFCE startup
# --------------------------------------------------

RUN printf '%s\n' \
    '#!/bin/sh' \
    'unset SESSION_MANAGER' \
    'unset DBUS_SESSION_BUS_ADDRESS' \
    'export XDG_CURRENT_DESKTOP=XFCE' \
    'export XDG_SESSION_DESKTOP=xfce' \
    'export XDG_CONFIG_DIRS=/etc/xdg/xdg-xfce:/etc/xdg:/etc/xdg' \
    'export XDG_DATA_DIRS=/usr/share/xfce4:/usr/local/share:/usr/share' \
    'startxfce4 &' \
    > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# --------------------------------------------------
# VNC configuration
# --------------------------------------------------

RUN printf '%s\n' \
    'geometry=1280x800' \
    'localhost=no' \
    'SecurityTypes=None' \
    > /root/.vnc/config

# --------------------------------------------------
# Startup script
# --------------------------------------------------

RUN cat > /usr/local/bin/start-kali-desktop.sh <<'EOF'
#!/bin/bash

set -e

export DISPLAY=:1
export HOME=/root
export USER=root

echo "========================================="
echo " Kali Linux XFCE Desktop"
echo " Starting VNC..."
echo "========================================="

# Remove stale VNC files
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# Start TigerVNC
vncserver :1 \
    -geometry 1280x800 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None

echo "VNC started on port 5901"

# Railway gives us $PORT
PORT="${PORT:-6080}"

echo "Starting noVNC/websockify on port $PORT"

exec websockify \
    --web=/usr/share/novnc \
    0.0.0.0:${PORT} \
    127.0.0.1:5901
EOF

RUN chmod +x /usr/local/bin/start-kali-desktop.sh

# --------------------------------------------------
# Railway
# --------------------------------------------------

EXPOSE 6080
EXPOSE 5901

# --------------------------------------------------
# Start
# --------------------------------------------------

CMD ["/usr/local/bin/start-kali-desktop.sh"]
