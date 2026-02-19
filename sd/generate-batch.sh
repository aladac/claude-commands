#!/bin/bash
# Generate batch of images via ComfyUI API
# Usage: generate-batch.sh --prompt "..." --count N [options]
set -euo pipefail

# Defaults
PROMPT=""
NEGATIVE=""
COUNT=4
WIDTH=512
HEIGHT=512
STEPS=20
CFG=7.0
SEED=-1
SAMPLER="euler"
SCHEDULER="normal"
LORA=""
LORA_STRENGTH=1.0
NO_QUALITY=""
NO_NEGATIVE=""

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
    --count)
      COUNT="$2"
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
    --lora)
      LORA="$2"
      shift 2
      ;;
    --lora-strength)
      LORA_STRENGTH="$2"
      shift 2
      ;;
    --no-quality)
      NO_QUALITY="true"
      shift 1
      ;;
    --no-negative)
      NO_NEGATIVE="true"
      shift 1
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

if [[ "$COUNT" -lt 1 ]]; then
  echo "Error: --count must be at least 1" >&2
  exit 1
fi

echo "Generating $COUNT images..."
echo "  Prompt: $PROMPT"
echo "  Size: ${WIDTH}x${HEIGHT}"
echo "  Steps: $STEPS"
[[ -n "$LORA" ]] && echo "  LoRA: $LORA (strength: $LORA_STRENGTH)"
[[ -n "$NO_QUALITY" ]] && echo "  Auto quality: disabled"
[[ -n "$NO_NEGATIVE" ]] && echo "  Auto negative: disabled"
echo ""

# Generate starting seed if random
if [[ "$SEED" -eq -1 ]]; then
  SEED=$((RANDOM * RANDOM))
fi

GENERATED_IMAGES=()

for ((i=0; i<COUNT; i++)); do
  CURRENT_SEED=$((SEED + i))
  echo "[$((i+1))/$COUNT] Generating with seed: $CURRENT_SEED"

  # Build JSON payload
  # Note: LoRA options require API support - included for future compatibility
  PAYLOAD=$(jq -n \
    --arg prompt "$PROMPT" \
    --arg negative "$NEGATIVE" \
    --argjson width "$WIDTH" \
    --argjson height "$HEIGHT" \
    --argjson steps "$STEPS" \
    --argjson cfg "$CFG" \
    --argjson seed "$CURRENT_SEED" \
    --arg sampler "$SAMPLER" \
    --arg scheduler "$SCHEDULER" \
    --arg lora "$LORA" \
    --argjson lora_strength "$LORA_STRENGTH" \
    --argjson no_quality "${NO_QUALITY:-false}" \
    --argjson no_negative "${NO_NEGATIVE:-false}" \
    '{
      prompt: $prompt,
      negative_prompt: $negative,
      width: $width,
      height: $height,
      steps: $steps,
      cfg: $cfg,
      seed: $seed,
      sampler: $sampler,
      scheduler: $scheduler,
      lora_name: (if $lora == "" then null else $lora end),
      lora_strength: $lora_strength,
      no_quality: $no_quality,
      no_negative: $no_negative
    }')

  # Call API
  RESPONSE=$(curl -s -X POST "${API_URL}/api/comfyui/generate" \
    -H "Content-Type: application/json" \
    -H "X-API-Key: ${API_KEY}" \
    -d "$PAYLOAD")

  # Check response
  SUCCESS=$(echo "$RESPONSE" | jq -r '.success // false')
  if [[ "$SUCCESS" != "true" ]]; then
    echo "  Error: Generation failed" >&2
    echo "$RESPONSE" | jq . >&2
    continue
  fi

  # Extract image filename
  IMAGE=$(echo "$RESPONSE" | jq -r '.images[0] // empty')
  PROMPT_ID=$(echo "$RESPONSE" | jq -r '.prompt_id // empty')

  if [[ -z "$IMAGE" ]]; then
    echo "  Error: No image in response" >&2
    continue
  fi

  # Download image
  OUTPUT_PATH="/tmp/sd_batch_${PROMPT_ID}_${CURRENT_SEED}.png"
  curl -s "${API_URL}/api/comfyui/image/${IMAGE}" \
    -H "X-API-Key: ${API_KEY}" \
    -o "$OUTPUT_PATH"

  echo "  Saved: $OUTPUT_PATH"
  GENERATED_IMAGES+=("$OUTPUT_PATH")
done

echo ""
echo "Batch complete. Generated ${#GENERATED_IMAGES[@]} images:"
for img in "${GENERATED_IMAGES[@]}"; do
  echo "  $img"
done
