#!/bin/bash
# Generate image via ComfyUI API
# Usage: generate.sh --prompt "..." [options]
set -euo pipefail

# Defaults
PROMPT=""
NEGATIVE=""
WIDTH=512
HEIGHT=512
STEPS=20
CFG=7.0
SEED=-1
SAMPLER="euler"
SCHEDULER="normal"

# API config from ~/.config/psn/config.toml
CONFIG_FILE="${HOME}/.config/psn/config.toml"
if [[ -f "$CONFIG_FILE" ]]; then
  API_URL=$(awk -F'"' '/^api_url/ {print $2}' "$CONFIG_FILE")
  API_KEY=$(awk -F'"' '/^api_key/ {print $2}' "$CONFIG_FILE")
else
  echo "Error: Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

if [[ -z "$API_KEY" ]]; then
  echo "Error: tensors.api_key not found in config" >&2
  exit 1
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --prompt)
      PROMPT="$2"
      shift 2
      ;;
    --negative)
      NEGATIVE="$2"
      shift 2
      ;;
    --width)
      WIDTH="$2"
      shift 2
      ;;
    --height)
      HEIGHT="$2"
      shift 2
      ;;
    --steps)
      STEPS="$2"
      shift 2
      ;;
    --cfg)
      CFG="$2"
      shift 2
      ;;
    --seed)
      SEED="$2"
      shift 2
      ;;
    --sampler)
      SAMPLER="$2"
      shift 2
      ;;
    --scheduler)
      SCHEDULER="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Validate required args
if [[ -z "$PROMPT" ]]; then
  echo "Error: --prompt is required" >&2
  exit 1
fi

# Build JSON payload
PAYLOAD=$(jq -n \
  --arg prompt "$PROMPT" \
  --arg negative "$NEGATIVE" \
  --argjson width "$WIDTH" \
  --argjson height "$HEIGHT" \
  --argjson steps "$STEPS" \
  --argjson cfg "$CFG" \
  --argjson seed "$SEED" \
  --arg sampler "$SAMPLER" \
  --arg scheduler "$SCHEDULER" \
  '{
    prompt: $prompt,
    negative_prompt: $negative,
    width: $width,
    height: $height,
    steps: $steps,
    cfg: $cfg,
    seed: $seed,
    sampler: $sampler,
    scheduler: $scheduler
  }')

echo "Generating image..."
echo "  Prompt: $PROMPT"
echo "  Size: ${WIDTH}x${HEIGHT}"
echo "  Steps: $STEPS"

# Call API
RESPONSE=$(curl -s -X POST "${API_URL}/api/comfyui/generate" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY}" \
  -d "$PAYLOAD")

# Check response
SUCCESS=$(echo "$RESPONSE" | jq -r '.success // false')
if [[ "$SUCCESS" != "true" ]]; then
  echo "Error: Generation failed" >&2
  echo "$RESPONSE" | jq . >&2
  exit 1
fi

# Extract image filename
IMAGE=$(echo "$RESPONSE" | jq -r '.images[0] // empty')
PROMPT_ID=$(echo "$RESPONSE" | jq -r '.prompt_id // empty')

if [[ -z "$IMAGE" ]]; then
  echo "Error: No image in response" >&2
  exit 1
fi

echo "  Prompt ID: $PROMPT_ID"
echo "  Image: $IMAGE"

# Download image
OUTPUT_PATH="/tmp/sd_generated_${PROMPT_ID}.png"
curl -s "${API_URL}/api/comfyui/image/${IMAGE}" \
  -H "X-API-Key: ${API_KEY}" \
  -o "$OUTPUT_PATH"

echo ""
echo "Image saved: $OUTPUT_PATH"
echo "$OUTPUT_PATH"
