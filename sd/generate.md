---
description: Generate an image via ComfyUI
args:
  - name: prompt
    description: "Image generation prompt"
    type: string
    required: true
  - name: model
    description: "Checkpoint model name (e.g., dreamshaper_8.safetensors)"
    type: string
  - name: width
    description: "Image width in pixels"
    type: number
    default: 512
  - name: height
    description: "Image height in pixels"
    type: number
    default: 512
  - name: steps
    description: "Number of sampling steps"
    type: number
    default: 20
  - name: negative
    description: "Negative prompt"
    type: string
    default: ""
  - name: cfg
    description: "CFG scale (guidance)"
    type: number
    default: 7.0
  - name: seed
    description: "Random seed (-1 for random)"
    type: number
    default: -1
  - name: sampler
    description: "Sampler name"
    type: string
    default: "euler"
  - name: scheduler
    description: "Scheduler name"
    type: string
    default: "normal"
  - name: count
    description: "Number of images to generate"
    type: number
    default: 1
  - name: lora
    description: "LoRA model name (e.g., spumcostyle.safetensors)"
    type: string
  - name: lora_strength
    description: "LoRA strength (0.0-1.0)"
    type: number
    default: 1.0
  - name: no_quality
    description: "Disable auto quality tags"
    type: boolean
    default: false
  - name: no_negative
    description: "Disable auto negative prompt"
    type: boolean
    default: false
---

Generate an image using ComfyUI via the `tsr` CLI.

Parse the user's input from `$ARGUMENTS` to extract generation parameters. Build and run the command:

```bash
~/.claude/commands/sd/generate.sh --prompt "PROMPT" [OPTIONS]
```

**Required:**
- `--prompt "..."` - The image prompt (required, extract from user input)

**Optional (use defaults if not specified):**
- `--model NAME` - Checkpoint model (e.g., dreamshaper_8.safetensors)
- `--width N` - Width in pixels (default: 512)
- `--height N` - Height in pixels (default: 512)
- `--steps N` - Sampling steps (default: 20)
- `--negative "..."` - Negative prompt (default: empty)
- `--cfg N` - CFG scale (default: 7.0)
- `--seed N` - Random seed, -1 for random (default: -1)
- `--sampler NAME` - Sampler name (default: euler)
- `--scheduler NAME` - Scheduler name (default: normal)
- `--count N` - Number of images to generate (default: 1)
- `--lora NAME` - LoRA model name (auto-prepends trigger words from CivitAI)
- `--lora-strength N` - LoRA strength 0.0-1.0 (default: 1.0)
- `--no-quality` - Disable auto quality tags (score_9, masterpiece, etc.)
- `--no-negative` - Disable auto negative prompt based on model family

**Model Family Auto-Detection:**
The system auto-detects model family and applies appropriate defaults:
- **Pony**: Adds `score_9, score_8_up, score_7_up` quality tags
- **Illustrious**: Adds `masterpiece, best quality, highres`
- **SD 1.5**: Adds `masterpiece, best quality`
- **SDXL/Flux**: Minimal or no auto-tags

**Available Models:**
- `dreamshaper_8.safetensors` - SD 1.5, fast
- `realisticVisionV60B1_v51VAE.safetensors` - SD 1.5, realistic
- `ponyDiffusionV6XL_v6StartWithThisOne.safetensors` - SDXL/Pony
- `cyberrealisticPony_v160.safetensors` - SDXL/Pony
- `obsessiveCompulsive_v20.safetensors` - SDXL/Pony

**Examples:**
- User: "a cyberpunk cat" → `--prompt "a cyberpunk cat"`
- User: "dreamshaper a forest" → `--prompt "a forest" --model "dreamshaper_8.safetensors"`
- User: "a forest, 1024x768, 30 steps" → `--prompt "a forest" --width 1024 --height 768 --steps 30`
- User: "robot, negative: blurry" → `--prompt "robot" --negative "blurry"`
- User: "generate 4 variations of a sunset" → `--prompt "a sunset" --count 4`
- User: "girl with spumcostyle lora" → `--prompt "girl" --lora "spumcostyle.safetensors"`
- User: "raw prompt, no auto tags" → `--prompt "raw prompt" --no-quality --no-negative`

After the script completes:
1. Read the generated image file to display it
2. Output this exact formatted summary:

```
Generation complete, Pilot.

| Parameter | Value |
|-----------|-------|
| Model | {model used or "auto"} |
| Prompt | "{the prompt}" |
| Size | {width}x{height} |
| Steps | {steps} |
| Prompt ID | {prompt_id from output} |
```
