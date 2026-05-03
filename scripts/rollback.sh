#!/usr/bin/env bash
LIVE_FILE="/tmp/app-live-slot"
CURRENT=$(cat "$LIVE_FILE")

if [[ "$CURRENT" == "blue" ]]; then ROLLBACK="green"; PORT=3002
else ROLLBACK="blue"; PORT=3001; fi

STATUS=$(curl -sf http://localhost:$PORT/health | grep -o '"ok"' || true)
if [[ "$STATUS" != '"ok"' ]]; then echo "❌ Rollback slot not healthy"; exit 1; fi

echo "$ROLLBACK" > "$LIVE_FILE"
echo "✅ Rolled back to $ROLLBACK → http://localhost:$PORT"
echo "$(date) ROLLBACK to=$ROLLBACK" >> /tmp/app-logs/deploy.log