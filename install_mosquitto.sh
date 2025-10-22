#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🔧 Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "📦 Installing Mosquitto..."
pkg install mosquitto -y

echo "⚙️ Creating default config..."
mkdir -p $PREFIX/etc/mosquitto
cat > $PREFIX/etc/mosquitto/mosquitto.conf <<'EOF'
listener 1883 0.0.0.0
allow_anonymous true
persistence true
persistence_location /data/data/com.termux/files/usr/var/lib/mosquitto/
log_dest file /data/data/com.termux/files/usr/var/log/mosquitto/mosquitto.log
EOF

echo "🚀 Starting Mosquitto broker..."
pkill mosquitto 2>/dev/null || true
mosquitto -c $PREFIX/etc/mosquitto/mosquitto.conf -d

echo "✅ Mosquitto installed and running!"
echo "📡 Listening on port 1883 (0.0.0.0)"
echo "To start manually later: mosquitto -c \$PREFIX/etc/mosquitto/mosquitto.conf -d"
