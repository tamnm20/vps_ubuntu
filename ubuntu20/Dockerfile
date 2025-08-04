FROM ubuntu:20.04

# 🔧 DISK OPTIMIZATION - Giảm image size
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Ho_Chi_Minh \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 🔧 MEMORY OPTIMIZATION - Cài packages trong 1 layer để giảm size
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt update && apt install -y build-essential\
    openssh-server \
    sudo \
    curl \
    wget \
    nano \
    vim \
    git \
    htop \
    net-tools \
    iputils-ping \
    ca-certificates \
    gnupg \
    lsb-release \
    # 🔧 MONITORING TOOLS (các commands free, vmstat, df, du đã có sẵn)
    sysstat \
    iotop \
    ncdu \
    procps \
    coreutils \
    # Clean up trong cùng layer để giảm size
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# 🔧 SSH Configuration
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 🔧 USER MANAGEMENT với disk quota (nếu cần)
RUN useradd -m -s /bin/bash -G sudo tam && \
    echo "tam:1" | chpasswd && \
    usermod -aG sudo tam && \
    echo "root:1234" | chpasswd
# 🔧 SYSTEM LIMITS Configuration
RUN echo '# System Resource Limits\n\
# 🔧 Memory limits\n\
* soft memlock 1048576\n\
* hard memlock 1048576\n\
# 🔧 Process limits\n\
* soft nproc 4096\n\
* hard nproc 8192\n\
# 🔧 File descriptor limits\n\
* soft nofile 65536\n\
* hard nofile 65536\n\
# 🔧 User-specific limits\n\
vpsuser soft nproc 2048\n\
vpsuser hard nproc 4096\n\
' > /etc/security/limits.conf

# 🔧 DISK CLEANUP Script
RUN echo '#!/bin/bash\n\
# Disk cleanup script\n\
echo "🧹 Cleaning up disk space..."\n\
apt-get autoremove -y\n\
apt-get autoclean\n\
rm -rf /var/log/*.log\n\
rm -rf /tmp/*\n\
rm -rf /var/tmp/*\n\
find /var/log -type f -name "*.log" -delete\n\
echo "✅ Cleanup completed!"\n\
df -h\n\
' > /usr/local/bin/cleanup-disk.sh && chmod +x /usr/local/bin/cleanup-disk.sh

# 🔧 RESOURCE MONITORING Script  
RUN echo '#!/bin/bash\n\
echo "📊 SYSTEM RESOURCES MONITORING"\n\
echo "================================"\n\
echo "💾 MEMORY USAGE:"\n\
free -h\n\
echo ""\n\
echo "🖥️ CPU USAGE:"\n\
top -bn1 | head -5\n\
echo ""\n\
echo "💽 DISK USAGE:"\n\
df -h\n\
echo ""\n\
echo "📁 TOP DISK USAGE:"\n\
du -sh /* 2>/dev/null | sort -hr | head -10\n\
echo ""\n\
echo "🔄 RUNNING PROCESSES:"\n\
ps aux --sort=-%mem | head -10\n\
' > /usr/local/bin/monitor-resources.sh && chmod +x /usr/local/bin/monitor-resources.sh

# ✅ Bật màu sắc cho ls (bằng alias + cấu hình shell)
RUN echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc && \
    echo "export PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> /etc/bash.bashrc

# 🔧 STARTUP Script với resource monitoring
RUN echo '#!/bin/bash\n\
echo "🚀 Starting Ubuntu VPS..."\n\
echo "📊 Initial resource check:"\n\
/usr/local/bin/monitor-resources.sh\n\
echo ""\n\
echo "🔑 Starting SSH service..."\n\
service ssh start\n\
echo "✅ VPS ready!"\n\
echo ""\n\
echo "💡 Useful commands:"\n\
echo "   monitor-resources.sh  - Check system resources"\n\
echo "   cleanup-disk.sh       - Clean up disk space"\n\
echo "   htop                  - Interactive process viewer"\n\
echo "   ncdu /                - Disk usage analyzer"\n\
echo ""\n\
# Keep container running\n\
tail -f /dev/null\n\
' > /start.sh && chmod +x /start.sh

# 🔧 EXPOSE PORTS
EXPOSE 22

# 🔧 HEALTHCHECK để monitor tài nguyên
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD service ssh status || exit 1

CMD ["/start.sh"]