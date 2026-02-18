---
description: Generate an image via ComfyUI
args:
  - name: prompt
    description: "Image generation prompt"
    type: string
    required: true
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
---

Generate an image using ComfyUI via the tensors API.

Parse the user's input from `$ARGUMENTS` to extract generation parameters. Build and run the command:

```bash
~/.claude/commands/sd/generate.sh --prompt "PROMPT" [OPTIONS]
```

**Required:**
- `--prompt "..."` - The image prompt (required, extract from user input)

**Optional (use defaults if not specified):**
- `--width N` - Width in pixels (default: 512)
- `--height N` - Height in pixels (default: 512)
- `--steps N` - Sampling steps (default: 20)
- `--negative "..."` - Negative prompt (default: empty)
- `--cfg N` - CFG scale (default: 7.0)
- `--seed N` - Random seed, -1 for random (default: -1)
- `--sampler NAME` - Sampler name (default: euler)
- `--scheduler NAME` - Scheduler name (default: normal)

**Examples:**
- User: "a cyberpunk cat" → `--prompt "a cyberpunk cat"`
- User: "a forest, 1024x768, 30 steps" → `--prompt "a forest" --width 1024 --height 768 --steps 30`
- User: "robot, negative: blurry" → `--prompt "robot" --negative "blurry"`

After the script completes:
1. Read the generated image file to display it
2. Report the generation parameters used
