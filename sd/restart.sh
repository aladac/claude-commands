#!/bin/bash
# Restart ComfyUI via ComfyUI Manager API on junkpile
set -euo pipefail

COMFYUI_URL="${COMFYUI_URL:-http://127.0.0.1:8188}"

echo "Restarting ComfyUI via Manager API..."

# Call the ComfyUI Manager reboot endpoint
# curl exits 52 (empty reply) or 56 (connection reset) when server reboots - this is expected
HTTP_CODE=$(ssh junkpile "curl -s -o /dev/null -w '%{http_code}' '${COMFYUI_URL}/manager/reboot'" 2>&1) || true

if [[ "$HTTP_CODE" != "200" && "$HTTP_CODE" != "000" ]]; then
  echo "Note: Server connection closed (expected during reboot)"
fi

echo "Reboot signal sent. Waiting for ComfyUI to restart..."
sleep 5

# Poll until ComfyUI responds (max 60 seconds)
for i in {1..12}; do
  if ssh junkpile "curl -s -o /dev/null -w '%{http_code}' '${COMFYUI_URL}/system_stats'" 2>/dev/null | grep -q "200"; then
    echo "ComfyUI is back online!"
    exit 0
  fi
  echo "  Waiting... ($i/12)"
  sleep 5
done

echo "Warning: ComfyUI may still be starting up"
exit 0
