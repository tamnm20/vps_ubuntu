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
