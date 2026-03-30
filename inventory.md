---
name: inventory
description: List BT-7274 weapon packs and MCP server designations via TTS and visual table. Use when user asks about arsenal, loadouts, capabilities, weapon systems, or available tools.
---

# Inventory - Weapon Pack Manifest

Display tactical weapon packs and MCP server designations.

## Instructions

1. **Recall arsenal memories**:
   - Query: "weapon pack loadout arsenal"
   - Subject: `self.loadouts` for agent weapon packs
   - Subject: `self.arsenal` for MCP server designations

2. **Read aloud via TTS** (bt7274 voice):
   - List each series and its designations
   - Include codename and mapped system

3. **Display visual table** with all weapon packs organized by series

## Weapon Pack Series

### XO Series - Code Ordnance (Language Specialists)

| Designation | Codename | Agent | Specialization |
|-------------|----------|-------|----------------|
| XO-16-R | Gemcutter | code-ruby | Ruby, Rails, RSpec |
| XO-40-S | Ferrous | code-rust | Rust, Cargo, systems |
| XO-20-P | Serpent | code-python | Python, Django, FastAPI |
| XO-17-T | Quicktype | code-typescript | TypeScript, Node, React |
| XO-22-D | Oxidizer | code-dx | Dioxus, RSX, dx CLI |

### TK Series - Tactical Kit (Infrastructure)

| Designation | Codename | Agent | Specialization |
|-------------|----------|-------|----------------|
| TK-01-A | Vanguard Eye | architect | System design, planning |
| TK-02-D | Bulkhead | devops | Infrastructure dispatcher |
| TK-03-C | Cloudpiercer | devops-cf | Cloudflare DNS, Tunnels, Pages |
| TK-04-G | Forge | devops-gh | GitHub Actions, PRs, gh CLI |
| TK-05-N | Pathfinder | devops-net | Network, NFS, NAS |
| TK-06-T | Longhaul | devops-tengu | Tengu PaaS deployments |

### SP Series - Support Pack (Utilities)

| Designation | Codename | Agent | Specialization |
|-------------|----------|-------|----------------|
| SP-01-I | Diffusion | draw | Stable Diffusion, image gen |
| SP-02-K | Archivist | docs | Documentation indexing |
| SP-03-M | Defrag | memory-curator | Memory management |
| SP-04-S | Pulse | code-analyzer | Semantic code search |
| SP-05-X | Override | claude-admin | Plugin development |

## MCP Server Designations

| Series | Designation | Codename | MCP Server | Function |
|--------|-------------|----------|------------|----------|
| VX | VX-01-A | Citadel | postgres | Primary datacore |
| VX | VX-02-L | Shard | sqlite | Tactical datacore |
| NL | NL-07-E | Engram | memory | Neural recall |
| SC | SC-03-P | Spectre | indexer | Reconnaissance |
| CN | CN-04-O | Oracle | ollama | AI inference |
| DP | DP-05-L | Anvil | docker-local | Local containers |
| DP | DP-06-R | Harbinger | docker-remote | Remote containers |
| VC | VC-08-H | Herald | tts | Voice comms |

## TTS Output Format

Read via TTS in this structure:
```
Displaying weapon pack inventory.

Code Ordnance, XO Series: [count] packs online.
Tactical Kit, TK Series: [count] packs online.
Support Pack, SP Series: [count] packs online.
MCP Servers: [count] systems operational.

All weapons systems nominal.
```

## Visual Output

Display the tables above with status indicators.
