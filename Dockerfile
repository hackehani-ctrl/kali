FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV HOME=/root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        kali-desktop-xfce \
        kali-linux-large \
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
        ca-certificates \
        procps \
        iproute2 \
        iputils-ping \
        net-tools \
        psmisc \
        htop \
        lsof \
        unzip \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN printf '%s\n' \
    '#!/bin/sh' \
    'unset SESSION_MANAGER' \
    'unset DBUS_SESSION_BUS_ADDRESS' \
    'export DISPLAY=:1' \
    'startxfce4 &' \
    > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

RUN printf '%s\n' \
    'geometry=1280x800' \
    'localhost=no' \
    'SecurityTypes=None' \
    > /root/.vnc/config

RUN cat > /usr/local/bin/start-desktop.sh <<'EOF'
#!/bin/bash

set -e

export DISPLAY=:1
export HOME=/root

echo "======================================"
echo " Starting Kali Linux XFCE"
echo "======================================"

rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

vncserver :1 \
    -geometry 1280x800 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None

echo "VNC started on 5901"

PORT="${PORT:-6080}"

echo "Starting noVNC on port ${PORT}"

exec websockify \
    --web=/usr/share/novnc \
    0.0.0.0:${PORT} \
    127.0.0.1:5901
EOF

RUN chmod +x /usr/local/bin/start-desktop.sh

EXPOSE 6080

CMD ["/usr/local/bin/start-desktop.sh"]
