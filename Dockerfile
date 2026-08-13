# استخدام نظام Linux Ubuntu المستقر
FROM ubuntu:22.04

# منع الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:99

# تحديث النظام وتثبيت Python و Tor و Google Chrome و XVFB (الشاشة الوهمية)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    curl \
    tor \
    xvfb \
    ffmpeg \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# تثبيت Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -fy \
    && rm google-chrome-stable_current_amd64.deb

# ضبط المجلد الحالي داخل الحاوية
WORKDIR /app

# نسخ ملفات المشروع
COPY . /app

# تثبيت مكتبات Python
RUN pip3 install --no-cache-dir undetected_chromedriver selenium requests

# إعداد ملف Tor لفتح منفذ التحكم
RUN echo "ControlPort 9051\nCookieAuthentication 0\nDataDirectory /var/lib/tor" > /etc/tor/torrc

# إنشاء سكربت التشغيل الذي يبدأ Tor والشاشة الوهمية ثم البوت
RUN echo '#!/bin/sh\n\
service tor start\n\
sleep 5\n\
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &\n\
sleep 2\n\
python3 -u bot_master1.py\n\
' > /app/start.sh && chmod +x /app/start.sh

# الأمر النهائي للتشغيل
CMD ["/app/start.sh"]
