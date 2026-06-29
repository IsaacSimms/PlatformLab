# Lab 07 — Manage Azure Storage

**Estimated time:** 50 min
**Original region:** East US → substitute `centralus` (your home region)

## Scenario

On-prem data stores hold mostly cold data. Goal: move infrequently-accessed files to cheaper tiers, and evaluate Azure Files as an on-prem file share replacement. Lab covers redundancy, network access, authentication/authorization, and lifecycle management.

## Adaptations Before You Start

> **CAF naming (UL: deviation flagged):** Lab uses `az104-rg7` — not CAF-compliant. Use something like `rg-az104-storage-centralus` for the resource group, and `stlab<unique>` (storage accounts: lowercase letters + digits only, 3–24 chars, globally unique) for the storage account.

> **Region:** Replace every `East US` reference with `Central US`.

## Tasks

1. Create and configure a storage account
2. Create and configure secure blob storage
3. Create and configure secure Azure file storage

---

## Task 1: Create and Configure a Storage Account

### 1.1 Create the account

| Setting | Value |
|---|---|
| Subscription | your subscription |
| Resource group | `rg-az104-storage-centralus` (new) |
| Storage account name | globally unique, 3–24 chars, lowercase letters + digits |
| Region | Central US |
| Performance | Standard |
| Preferred storage type | Azure Blob Storage or Azure Data Lake Storage |
| Redundancy | Geo-redundant storage (GRS) |
| Read access in regional outage | ✅ checked (this makes it RA-GRS) |

> **Tip:** Standard = most workloads. Premium = low-latency/high-IOPS (SSD-backed) enterprise workloads.

- **Advanced / Security tabs:** read the info icons, accept defaults.
- **Networking tab:** set **Public network access → Disable**. Blocks inbound, outbound still works.
- **Data protection tab:** default soft-delete retention = 7 days; blob versioning available. Accept defaults.
- **Encryption tab:** review options, accept defaults.

Click **Review + create → Create**, then **Go to resource**.

### 1.2 Re-enable scoped network access

`Security + networking → Networking` — confirm Public network access shows **Disabled**.

1. Under **Public network access**, click **Manage**.
2. Set to **Enabled**, scope = **Enable from selected networks**.
3. Under **Virtual networks, IP Addresses and exceptions**, **Add your client IPv4 address**.
4. **Save**. (Ignore any banner suggesting a network security perimeter.)

### 1.3 Review redundancy

`Data management → Redundancy` — note primary and paired secondary region (GRS replicates to a fixed paired region; with Central US the pair is North Central US).

### 1.4 Lifecycle management rule

`Data management → Lifecycle management → Add a rule`

| Setting | Value |
|---|---|
| Rule name | `Movetocool` |
| Scope | review options, leave default |
| Condition | If base blobs were last modified **> 30 days ago** |
| Action | Move to **cool** storage |

> **Gotcha:** Lifecycle rules are policy-evaluated on a schedule (not instant) — don't expect immediate tier changes in a short lab session. This is here for conceptual exposure, not a live demo.

---

## Task 2: Secure Blob Storage

### 2.1 Create container + immutability policy

`Data storage → Containers → + Add container`

| Setting | Value |
|---|---|
| Name | `data` |
| Public access level | Private (default — confirm) |

On the container's `…` menu → **Access policy** → **Immutable blob storage → Add policy**:

| Setting | Value |
|---|---|
| Policy type | Time-based retention |
| Retention period | 180 days |

Click **Save**.

> **Gotcha — cleanup risk:** An *unlocked* time-based retention policy can be removed by you before the retention period ends, so RG deletion should still succeed. If RG deletion fails at cleanup, go back to this container's **Access policy** and delete/clear the immutability policy first, then retry.
>
> (Ignore the "Shared Key authorization is disabled" warning here — expected, see 2.4.)

### 2.2 Grant yourself data-plane access (RBAC)

`Configuration` blade → set **Allow storage account key access → Enabled** → **Save**.

> **Note:** This re-enables Shared Key as an *available* auth method at the account level — it doesn't mean it's used by default. The portal's data-plane operations (Storage Browser, blob upload UI) still authenticate as **your Entra ID identity**, which is why the RBAC step below is required regardless.

`Access Control (IAM) → Add role assignment`, assign to your user account:

- **Storage Blob Data Contributor**
- **Storage File Data Privileged Contributor**

> **Gotcha:** RBAC assignments can take a few minutes to propagate. If the portal still shows "unauthorized" right after assigning, wait and refresh — this is the classic Azure RBAC propagation delay, no different from waiting on AD group membership replication on-prem.

### 2.3 Upload a blob

Select container `data` → **Upload** → expand **Advanced**:

| Setting | Value |
|---|---|
| File | any small file |
| Blob type | Block blob |
| Block size | 4 MiB |
| Access tier | Hot |
| Upload folder | `securitytest` |
| Encryption scope | Use existing default container scope |

Confirm the folder and file exist. Note the `…` options: Download, Delete, Change tier, Acquire lease.

### 2.4 Confirm private access blocks anonymous reads

Open the file's **Overview** → copy **URL** from Properties → paste into an InPrivate window.

**Expected result:** XML error — `ResourceNotFound` or `PublicAccessNotPermitted`. This confirms the container's "Private" access level is enforced.

### 2.5 Generate a SAS for time-limited access

File's `…` → **Generate SAS**.

> **Gotcha:** Because Shared Key authorization is disabled at the account level, **Account key** signing is unavailable here — you must use **User delegation key** (Entra ID-backed SAS).

| Setting | Value |
|---|---|
| Signing method | User delegation key |
| Permissions | Read |
| Start date/time | yesterday / now |
| Expiry date/time | tomorrow / now |
| Allowed IP addresses | (blank) |

**Generate SAS token and URL** → copy the **Blob SAS URL** → open in a new InPrivate window.

**Expected result:** file content loads successfully — the SAS token grants scoped, time-limited access independent of the container's private setting.

---

## Task 3: Azure File Storage

### 3.1 Create a classic file share

`Data storage → Classic file shares → + Classic file share`

| Setting | Value |
|---|---|
| Name | `share1` |
| Access tier | Transaction optimized (default) |
| Enable backup | ❌ unchecked (kept off to simplify the lab) |

**Review + create → Create**. Ignore the post-creation backup prompt.

### 3.2 Storage Browser — upload a file

`Storage browser → Classic file shares → share1`

- **+ Add directory** to build folder structure.
- If you hit an authorization error, switch auth method to **Microsoft Entra user account** in the Storage Browser toolbar (same RBAC propagation note as 2.2 may apply).
- **Upload** a file.

At this point, no network restrictions exist on the share.

### 3.3 Restrict storage account access to a VNet

**Create the VNet:**

`Virtual networks → + Create`

| Setting | Value |
|---|---|
| Resource group | `rg-az104-storage-centralus` |
| Name | `vnet1` |
| Other settings | defaults |

**Add a service endpoint:**

`vnet1 → Settings → Service endpoints → + Add`

| Setting | Value |
|---|---|
| Service | `Microsoft.Storage` |
| Service endpoint policies | 0 selected (default) |
| Subnets | Default subnet |

**Re-scope storage account networking:**

Back on the storage account → `Security + networking → Networking → Manage` (under Public network access):

1. **Add a virtual network** → **Add existing network** → select `vnet1` / default subnet → **Add**.
2. Under **IPv4 Addresses**, **delete your client IP** entry (added in 1.2).
3. **Save**.

### 3.4 Verify the restriction

Go to **Storage browser → Refresh** → navigate to the file share or blob container.

**Expected result:** "not authorized to perform this operation."

> **Gotcha (the actual lesson here):** This is correct behavior, not a bug. Storage Browser runs in **your browser**, and your browser's traffic originates from your client IP — which is *not* inside `vnet1`. Only resources actually deployed inside `vnet1` (e.g., a VM) would pass the service endpoint check. Allow a couple of minutes for the network rule change to propagate before concluding it's broken.

---

## Cleanup ("cattle, not pets")

Capture any screenshots/notes for the `AzurePlatform` repo first, then delete the resource group.

**Portal:** Resource group → **Delete resource group** → type the RG name to confirm → **Delete** (confirm again — permanent).

**PowerShell:**
```powershell
Remove-AzResourceGroup -Name "rg-az104-storage-centralus"
```

**CLI:**
```bash
az group delete --name rg-az104-storage-centralus
```

> **Gotcha:** If deletion fails or hangs, the most likely cause is the immutability policy from 2.1. Go back to the `data` container's **Access policy**, remove the time-based retention policy, then retry deletion.

---

## Key Takeaways for Retention

- **Public network access** at the storage account is a coarse on/off + allow-list (IP or VNet service endpoint) — conceptually similar to a firewall ACL, not identity-based.
- **RBAC vs Shared Key vs SAS** are three distinct auth layers for data-plane access:
  - RBAC (Entra ID) — used by portal tools like Storage Browser.
  - Shared Key — account-wide secret, often disabled for security; toggled separately from RBAC.
  - SAS (User delegation) — short-lived, scoped, Entra-ID-backed token for sharing access without exposing identity or keys.
- **Immutability policies** (time-based retention) can block container/RG deletion — design and cleanup consideration, not just a compliance checkbox.
- **VNet service endpoints** extend a VNet's identity to a PaaS resource's firewall — the resource still has a public endpoint, but only traffic *originating from* the allowed subnet is accepted.
