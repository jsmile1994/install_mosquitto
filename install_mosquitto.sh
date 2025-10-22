#!/data/data/com.termux/files/usr/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "🔧 Updating Termux packages (non-interactive)..."
pkg update -y && pkg upgrade -y || true

echo "📦 Installing Mosquitto..."
pkg install mosquitto -y

echo "⚙️ Preparing directories..."
mkdir -p $PREFIX/etc/mosquitto
mkdir -p $PREFIX/var/lib/mosquitto
mkdir -p $PREFIX/var/log

echo "📝 Creating Mosquitto config..."
cat > $PREFIX/etc/mosquitto/mosquitto.conf <<'EOF'
listener 1883 0.0.0.0
allow_anonymous true
persistence true
persistence_location /data/data/com.termux/files/usr/var/lib/mosquitto/
log_dest stdout
EOF

echo "🧹 Stopping any old Mosquitto process..."
pkill mosquitto 2>/dev/null || true

echo "🚀 Starting Mosquitto broker..."
nohup mosquitto -c $PREFIX/etc/mosquitto/mosquitto.conf >/dev/null 2>&1 &

echo "✅ Mosquitto installed and running!"
echo "📡 Listening on port 1883 (0.0.0.0)"
echo
echo "To restart manually later, run:"
echo "  nohup mosquitto -c \$PREFIX/etc/mosquitto/mosquitto.conf >/dev/null 2>&1 &"
