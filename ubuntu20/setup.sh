#!/bin/bash

echo "🚀 Thiết lập Ubuntu 20.04 VPS trên Docker..."

# Tạo các file cần thiết nếu chưa có
if [ ! -f "Dockerfile" ]; then
    echo "❌ Không tìm thấy Dockerfile. Vui lòng tạo Dockerfile trước."
    exit 1
fi

if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Không tìm thấy docker-compose.yml. Vui lòng tạo file này trước."
    exit 1
fi

# 🔧 Tạo thư mục cần thiết
echo "📁 Creating directories..."
mkdir -p data/tam        # Sẽ trở thành /home/tam trong container
mkdir -p shared
chmod 755 data
chmod 755 data/tam
chmod 755 shared

echo "ℹ️  Directory mapping:"
echo "   ./data/tam  → /home/tam (in container)"
echo "   ./data/root → /home/root (in container)"
echo "   ./shared    → /shared (in container)"

# Dừng và xóa container cũ (nếu có)
echo "🔄 Dừng và xóa container cũ..."
docker-compose down --remove-orphans

# Build và khởi động container
echo "🔨 Build Docker image..."
docker-compose build --no-cache

echo "▶️ Khởi động VPS container..."
docker-compose up -d

# Chờ container khởi động
echo "⏳ Chờ container khởi động..."
sleep 10

# Kiểm tra trạng thái container
if docker ps | grep -q "ubuntu20"; then
    echo "✅ VPS Ubuntu 20.04 đã khởi động thành công!"
    echo ""
    echo "📋 Thông tin kết nối:"
    echo "   SSH: ssh tam@localhost -p 2222"
    echo "   Password: 1"
    echo "   Root password: 1234"
    echo ""
    echo "🌐 Port mapping:"
    echo "   SSH: localhost:2222 -> container:22"
    echo "   HTTP: localhost:8080 -> container:80" 
    echo "   HTTPS: localhost:8443 -> container:443"
    echo ""
    echo "📁 Volume: "
    echo "Directory mapping:"
    echo "   ./data/tam  → /home/tam (in container)"
    echo "   ./shared    → /shared (in container)"
    echo ""
    echo "🔧 Quản lý container:"
    echo "   Xem logs: docker-compose logs -f"
    echo "   Vào container: docker exec -it ubuntu20 bash"
    echo "   Dừng: docker-compose down"
    echo "   Khởi động lại: docker-compose restart"
else
    echo "❌ Có lỗi xảy ra khi khởi động container!"
    echo "📋 Kiểm tra logs:"
    docker-compose logs
fi

# 🔧 Tạo script start đơn giản
cat > start.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Ubuntu20 VPS..."
docker-compose up -d ubuntu20
sleep 3
echo ""
echo "✅ Ubuntu20 VPS started!"
echo "🔐 SSH: ssh tam@localhost -p 2223"
echo "🔑 Password: 1"
echo "🌐 HTTP: http://localhost:8080"
echo ""
echo "📁 Data mapping:"
echo "   Container /home/tam  ↔ Host ./data/tam"
echo "   Container /shared    ↔ Host ./shared"
echo ""
echo "📊 Status: docker-compose ps"
echo "📋 Logs: docker-compose logs -f ubuntu20"
EOF

# 🔧 Tạo script stop đơn giản  
cat > stop.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping Ubuntu20 VPS..."
docker-compose down
echo "✅ Stopped!"
EOF

# 🔧 Tạo script connect
cat > connect.sh << 'EOF'
#!/bin/bash
echo "🔌 Connecting to Ubuntu20 VPS..."
ssh tam@localhost -p 2223
EOF

# 🔧 Tạo script shell
cat > shell.sh << 'EOF'
#!/bin/bash
echo "🐚 Opening shell in Ubuntu20 container..."
docker exec -it ubuntu20 bash
EOF

# 🔧 Tạo script monitor
cat > monitor.sh << 'EOF'
#!/bin/bash
echo "📊 Ubuntu20 VPS Monitoring"
echo "=========================="
echo "🐳 Container Status:"
docker-compose ps
echo ""
echo "📈 Resource Usage:"
docker stats ubuntu20 --no-stream
echo ""
echo "🔍 Container Info:"
docker exec ubuntu20 /usr/local/bin/monitor-resources.sh
EOF

# Make scripts executable
chmod +x *.sh

echo ""
echo "✅ Setup completed!"
echo ""
echo "🎯 Quick Commands:"
echo "   ./start.sh    - Start Ubuntu20 VPS"
echo "   ./stop.sh     - Stop Ubuntu20 VPS" 
echo "   ./connect.sh  - SSH to VPS (password: 1)"
echo "   ./shell.sh    - Direct shell access"
echo "   ./monitor.sh  - Check system status"
echo ""
echo "🚀 Run './start.sh' to begin!"