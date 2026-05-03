#!/usr/bin/env bash
LOG=/tmp/app-logs/healthcheck.log
LIVE_FILE="/tmp/app-live-slot"
SLOT=$(cat "$LIVE_FILE" 2>/dev/null || echo "default")

if [[ "$SLOT" == "blue" ]]; then PORT=3001
elif [[ "$SLOT" == "green" ]]; then PORT=3002
else PORT=3000; fi

RESPONSE=$(curl -sf --max-time 5 http://localhost:$PORT/health 2>/dev/null || echo "UNREACHABLE")

if echo "$RESPONSE" | grep -q '"ok"'; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$SLOT:$PORT] ✅ UP" | tee -a "$LOG"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$SLOT:$PORT] ❌ DOWN" | tee -a "$LOG"
fi