#!/bin/bash
# Generate image via ComfyUI using tsr CLI
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
MODEL=""
COUNT=1
LORA=""
LORA_STRENGTH=1.0
NO_QUALITY=""
NO_NEGATIVE=""
COMFYUI_URL="${COMFYUI_URL:-http://junkpile:8188}"

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
    --model)
      MODEL="$2"
      shift 2
      ;;
    --count)
      COUNT="$2"
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
    --url)
      COMFYUI_URL="$2"
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

# Build output path (remote on junkpile)
REMOTE_OUTPUT_DIR="/home/chi/Pictures/tensors"
LOCAL_OUTPUT_DIR="${HOME}/Pictures/tensors"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILENAME="sd_${TIMESTAMP}.png"
REMOTE_OUTPUT_PATH="${REMOTE_OUTPUT_DIR}/${OUTPUT_FILENAME}"
LOCAL_OUTPUT_PATH="${LOCAL_OUTPUT_DIR}/${OUTPUT_FILENAME}"

mkdir -p "$LOCAL_OUTPUT_DIR"

# Build tsr command arguments
TSR_ARGS="comfy generate '$PROMPT' -u '$COMFYUI_URL' -W $WIDTH -H $HEIGHT --steps $STEPS --cfg $CFG --seed $SEED --sampler '$SAMPLER' --scheduler '$SCHEDULER' --count $COUNT -o '$REMOTE_OUTPUT_PATH'"

# Add optional args
if [[ -n "$NEGATIVE" ]]; then
  TSR_ARGS="$TSR_ARGS -n '$NEGATIVE'"
fi

if [[ -n "$MODEL" ]]; then
  TSR_ARGS="$TSR_ARGS -m '$MODEL'"
fi

if [[ -n "$LORA" ]]; then
  TSR_ARGS="$TSR_ARGS -l '$LORA' --lora-strength $LORA_STRENGTH"
fi

if [[ -n "$NO_QUALITY" ]]; then
  TSR_ARGS="$TSR_ARGS --no-quality"
fi

if [[ -n "$NO_NEGATIVE" ]]; then
  TSR_ARGS="$TSR_ARGS --no-negative"
fi

echo "Generating image on junkpile..."
echo "  Prompt: $PROMPT"
echo "  Size: ${WIDTH}x${HEIGHT}"
echo "  Steps: $STEPS"
echo "  Count: $COUNT"
[[ -n "$MODEL" ]] && echo "  Model: $MODEL"
[[ -n "$LORA" ]] && echo "  LoRA: $LORA (strength: $LORA_STRENGTH)"
[[ -n "$NO_QUALITY" ]] && echo "  Auto quality: disabled"
[[ -n "$NO_NEGATIVE" ]] && echo "  Auto negative: disabled"
echo ""

# Run tsr comfy generate on junkpile via SSH
ssh junkpile "mkdir -p '$REMOTE_OUTPUT_DIR' && cd ~/Projects/tensors && uv run tsr $TSR_ARGS"

# Copy generated image(s) back to local machine
echo ""
if [[ "$COUNT" -eq 1 ]]; then
  scp "junkpile:$REMOTE_OUTPUT_PATH" "$LOCAL_OUTPUT_PATH"
  echo "Image saved: $LOCAL_OUTPUT_PATH"
  echo "$LOCAL_OUTPUT_PATH"
else
  scp "junkpile:${REMOTE_OUTPUT_DIR}/sd_${TIMESTAMP}*.png" "$LOCAL_OUTPUT_DIR/"
  echo "Images saved to: $LOCAL_OUTPUT_DIR/"
  ls -1 "${LOCAL_OUTPUT_DIR}"/sd_${TIMESTAMP}*.png
fi
