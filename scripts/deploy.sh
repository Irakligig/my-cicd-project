#!/usr/bin/env bash
set -e
LIVE_FILE="/tmp/app-live-slot"
CURRENT=$(cat "$LIVE_FILE" 2>/dev/null || echo "none")

if [[ "$CURRENT" == "blue" ]]; then TARGET="green"; PORT=3002
else TARGET="blue"; PORT=3001; fi

echo "==> Deploying to $TARGET slot on port $PORT"

PID=$(lsof -ti tcp:$PORT 2>/dev/null || true)
[[ -n "$PID" ]] && kill "$PID" && sleep 1

PORT=$PORT node /mnt/c/Users/darkb/my-cicd-project/app.js >> /tmp/app-logs/app-$TARGET.log 2>&1 &
sleep 4

STATUS=$(curl -sf http://localhost:$PORT/health | grep -o '"ok"' || true)
if [[ "$STATUS" != '"ok"' ]]; then echo "❌ Health check failed."; exit 1; fi

echo "$TARGET" > "$LIVE_FILE"
echo "✅ Live slot: $TARGET → http://localhost:$PORT"
echo "$(date) DEPLOY slot=$TARGET port=$PORT" >> /tmp/app-logs/deploy.log