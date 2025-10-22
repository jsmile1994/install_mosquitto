#!/data/data/com.termux/files/usr/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "🔧 Updating Termux packages (non-interactive)..."
pkg update -y && pkg upgrade -y || true

echo "📦 Installing Mosquitto..."
pkg install mosquitto -y

echo "⚙️ Creating Mosquitto config..."
mkdir -p $PREFIX/etc/mosquitto
cat > $PREFIX/etc/mosquitto/mosquitto.conf <<'EOF'
listener 1883 0.0.0.0
allow_anonymous true
persistence true
persistence_location /data/data/com.termux/files/usr/var/lib/mosquitto/
log_dest file /data/data/com.termux/files/usr/var/log/mosquitto/mosquitto.log
EOF

echo "🧹 Cleaning up any old Mosquitto process..."
pkill mosquitto 2>/dev/null || true

echo "🚀 Starting Mosquitto broker..."
mosquitto -c $PREFIX/etc/mosquitto/mosquitto.conf -d

echo "✅ Mosquitto installed and running!"
echo "📡 Listening on port 1883 (0.0.0.0)"
echo
echo "To restart manually later, run:"
echo "  mosquitto -c \$PREFIX/etc/mosquitto/mosquitto.conf -d"
