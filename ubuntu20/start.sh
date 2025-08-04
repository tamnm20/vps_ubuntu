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
