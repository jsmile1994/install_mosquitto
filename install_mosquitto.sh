#!/data/data/com.termux/files/usr/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "🔧 Updating Termux packages..."
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

echo "🧹 Killing old Mosquitto process (if any)..."
pkill -f mosquitto 2>/dev/null || true
sleep 1

echo "🚀 Starting Mosquitto broker..."
# Dùng full path để tránh lỗi PATH khi chạy qua nohup
nohup /data/data/com.termux/files/usr/bin/mosquitto -c /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf >/data/data/com.termux/files/usr/var/log/mosquitto_run.log 2>&1 &

sleep 2

echo "🔍 Checking if Mosquitto is running..."
if pgrep -f mosquitto >/dev/null; then
  echo "✅ Mosquitto broker is running!"
  echo "📡 Listening on port 1883 (0.0.0.0)"
else
  echo "❌ Failed to start Mosquitto. Check log:"
  echo "   cat $PREFIX/var/log/mosquitto_run.log"
  exit 1
fi

echo
echo "To restart manually later, run:"
echo "  nohup /data/data/com.termux/files/usr/bin/mosquitto -c /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf >/data/data/com.termux/files/usr/var/log/mosquitto_run.log 2>&1 &"
