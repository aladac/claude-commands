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

Run the batch generation script:

```bash
~/.claude/commands/sd/generate-batch.sh \
  --prompt "$ARGUMENTS.prompt" \
  --count "$ARGUMENTS.count" \
  --width "$ARGUMENTS.width" \
  --height "$ARGUMENTS.height" \
  --steps "$ARGUMENTS.steps" \
  --negative "$ARGUMENTS.negative" \
  --cfg "$ARGUMENTS.cfg" \
  --seed "$ARGUMENTS.seed" \
  --sampler "$ARGUMENTS.sampler" \
  --scheduler "$ARGUMENTS.scheduler"
```

After the script completes successfully:
1. Read each generated image file to display them
2. Report the generation parameters and seeds used for each image
