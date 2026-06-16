# Proxmox Homelab Initial Container Setup

**Date:** 2026-06-16
**Type:** implementation
**Environment / Systems:** Proxmox VE on Acer laptop (pve01-homelab), Ubuntu 24.04 LXC container

## TL;DR
Successfully resolved Proxmox subscription nag, enabled SSH, created and configured the first test LXC container (ID 100, Ubuntu 24.04), performed initial updates and basic tooling inside the container, and verified networking and functionality. Container is now stopped and ready for future use.

## Context & Goal
User had a freshly installed Proxmox VE server on an old Acer laptop (`pve01-homelab`, IP 192.168.4.166) with basic setup already complete (updated kernel, sleep disabled, no-subscription repo). Goal was to move from host-level setup into actually running workloads by creating the first test container.

## Key Points Explored
- Fixed the "No valid subscription" popup in the Proxmox web UI by editing `/usr/share/pve-manager/js/pvemanagerlib.js`.
- Enabled root SSH login by modifying `/etc/ssh/sshd_config` (`PermitRootLogin yes`) and restarting ssh.
- Used `pveam` to update the appliance catalog and download the Ubuntu 24.04 LXC template.
- Created container 100 using `pct create` with explicit parameters: 512 MiB RAM, 1 core, unprivileged, DHCP networking, 8 GiB thin rootfs on local-lvm.
- Entered the running container, updated packages, and installed `curl`, `htop`, and `nano`.
- Verified container received DHCP IP (192.168.4.173), had working internet access, and was using allocated resources correctly.

## Decisions & Outcomes
- Chose Ubuntu 24.04 LTS template for the first container (good balance of familiarity and stability).
- Used unprivileged container (`--unprivileged 1`) as the secure default.
- Performed initial package update and installed minimal useful tooling immediately after creation.
- Container was started, used for verification, then stopped. All changes persisted.

## Artifacts
- Container ID 100 (`test-lxc`) — created, updated, and stopped.
- Commands used: `pct create`, `pct start`, `pct enter`, `pct stop`, `pct status`, `pct list`.
- Modified host files: `/usr/share/pve-manager/js/pvemanagerlib.js` (subscription nag fix) and `/etc/ssh/sshd_config` (SSH enablement).