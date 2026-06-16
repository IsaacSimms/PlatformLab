# Proxmox VE on Acer Laptop — Major Project Milestones

**Date:** 2026-06-14  
**Type:** implementation  
**Environment / Systems:** Acer laptop (NVMe), Proxmox VE, home network 192.168.4.0/22, personal Azure-connected homelab

## TL;DR
Converted an old Acer laptop into the first Proxmox VE node (`pve01-homelab`) in a homelab environment. Completed clean installation, resolved repository issues, performed full system upgrade with new kernel, and prepared the system for headless operation.

## Context & Goal
Repurpose old laptop hardware into a dedicated Proxmox server as the foundation for a personal homelab project integrated with an Azure tenant. The focus was on getting a stable, updated, and accessible Proxmox node running.

## Key Points Explored
- Proxmox installer workflow: disk selection, network configuration with static IP `192.168.4.166/22`, and hostname `pve01-homelab.local`.
- Post-install access via web UI at `https://192.168.4.166:8006`.
- Resolution of Enterprise repository 401 errors by disabling `pve-enterprise.sources` and `ceph.sources`, then adding the free `pve-no-subscription` repository.
- Full system upgrade (`apt full-upgrade`) that installed a new kernel (`7.0.6-2-pve`).
- Configuration for headless operation by masking sleep/suspend targets.

## Decisions & Outcomes
- Selected static IP and clean hostname for reliable server identity and future node scaling.
- Switched to free Proxmox repositories to eliminate subscription-related errors.
- Completed full upgrade and new kernel installation.
- Masked power management targets to support always-on headless use.
- Server reached a stable, updated state ready for workloads or idle storage.

## Open Questions / Next Steps
- Reboot to activate new kernel (completed in thread).
- Create first LXC container or VM as initial workload.
- Add additional storage (current 128GB NVMe is limited).
- Implement backup strategy and basic monitoring.
- Further refine headless configuration if needed.

## Artifacts
- Web UI endpoint: `https://192.168.4.166:8006`
- Free repository file: `/etc/apt/sources.list.d/pve-no-subscription.sources`
- Disabled Enterprise files: `pve-enterprise.sources.disabled`, `ceph.sources.disabled`
- User-focused handoff: `user-proxmox-homelab-handoff.md`
- Technical handoff: `proxmox-homelab-thread-handoff.md`
- Session recap: `2026-06-14-proxmox-acer-homelab-setup-recap.md`