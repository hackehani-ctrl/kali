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
        tar \
        gzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc

RUN cat > /root/.vnc/xstartup <<'EOF'
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export DISPLAY=:1
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=xfce

exec startxfce4
EOF

RUN chmod +x /root/.vnc/xstartup

RUN cat > /root/.vnc/config <<'EOF'
geometry=1280x800
depth=24
localhost=no
SecurityTypes=None
EOF

COPY start-kali.sh /usr/local/bin/start-kali.sh

RUN chmod +x /usr/local/bin/start-kali.sh

EXPOSE 6080

CMD ["/usr/local/bin/start-kali.sh"]
