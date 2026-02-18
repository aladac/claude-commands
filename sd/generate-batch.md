---
description: Generate a batch of images from the same prompt via ComfyUI
args:
  - name: prompt
    description: "Image generation prompt"
    type: string
    required: true
  - name: count
    description: "Number of images to generate"
    type: number
    default: 4
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
    description: "Starting seed (-1 for random)"
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
---

Generate multiple images using ComfyUI via the tensors API.

Parse the user's input from `$ARGUMENTS` to extract generation parameters. Build and run the command:

```bash
~/.claude/commands/sd/generate-batch.sh --prompt "PROMPT" [OPTIONS]
```

**Required:**
- `--prompt "..."` - The image prompt (required, extract from user input)

**Optional (use defaults if not specified):**
- `--count N` - Number of images to generate (default: 4)
- `--width N` - Width in pixels (default: 512)
- `--height N` - Height in pixels (default: 512)
- `--steps N` - Sampling steps (default: 20)
- `--negative "..."` - Negative prompt (default: empty)
- `--cfg N` - CFG scale (default: 7.0)
- `--seed N` - Starting seed, -1 for random (default: -1)
- `--sampler NAME` - Sampler name (default: euler)
- `--scheduler NAME` - Scheduler name (default: normal)

**Examples:**
- User: "a cyberpunk cat" → `--prompt "a cyberpunk cat"` (generates 4 images)
- User: "a forest, 8 images" → `--prompt "a forest" --count 8`
- User: "robot, 1024x1024, 6 images, seed 12345" → `--prompt "robot" --width 1024 --height 1024 --count 6 --seed 12345`

After the script completes:
1. Read each generated image file to display them
2. Report the generation parameters and seeds used for each image
