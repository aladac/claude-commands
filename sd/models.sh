#!/bin/bash
# List available ComfyUI models with sizes and CivitAI metadata
set -euo pipefail

JUNKPILE_HOST="chi@junkpile"

# Get model info with file sizes from junkpile
ssh "$JUNKPILE_HOST" bash << 'REMOTE_EOF'
MODELS_DIR="/var/lib/tensors/models"

# Get JSON from tsr db and add file sizes
cd /opt/tensors/app
JSON=$(sudo -u tensors uv run tsr db list -j 2>/dev/null)

# Output combined data as JSON with sizes
echo "$JSON" | python3 -c "
import json
import os
import sys

data = json.load(sys.stdin)
result = []

for item in data:
    path = item.get('file_path', '')
    # Only include /var/lib/tensors paths
    if not path.startswith('/var/lib/tensors'):
        continue

    # Get file size
    try:
        size_bytes = os.path.getsize(path)
        if size_bytes >= 1024**3:
            size = f'{size_bytes / 1024**3:.1f}G'
        elif size_bytes >= 1024**2:
            size = f'{size_bytes / 1024**2:.0f}M'
        else:
            size = f'{size_bytes / 1024:.0f}K'
    except:
        size = '?'

    item['size'] = size
    item['filename'] = os.path.basename(path)
    result.append(item)

# Sort by filename
result.sort(key=lambda x: x['filename'].lower())

print(json.dumps(result, indent=2))
"
REMOTE_EOF
