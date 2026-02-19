---
description: SSH to junkpile (default) or a Hetzner server
args:
  - name: server
    description: "Server name (default: junkpile, or hetzner server name)"
    type: string
    required: false
---

SSH to a remote server and run commands as bt7274.

## Default: junkpile (192.168.0.170)

```bash
ssh bt7274
```

## Hetzner servers

If `$ARGUMENTS` contains a server name, SSH to that Hetzner server instead:

```bash
ssh root@$ARGUMENTS.your-server.de
```

## Usage

After connecting, you can run system commands. Common tasks:

- **System status**: `uptime`, `free -h`, `df -h`
- **Services**: `systemctl status <service>`
- **Logs**: `journalctl -u <service> -n 50`
- **Docker**: `docker ps`, `docker logs <container>`
- **GPU**: `nvidia-smi`

## Known servers

| Alias | Host | User |
|-------|------|------|
| junkpile (default) | 192.168.0.170 | bt7274 |
| hetzner servers | `<name>.your-server.de` | root |

Parse `$ARGUMENTS` to determine which server to connect to. If empty or "junkpile" or "j", use bt7274@192.168.0.170. Otherwise, treat as a Hetzner server name.
