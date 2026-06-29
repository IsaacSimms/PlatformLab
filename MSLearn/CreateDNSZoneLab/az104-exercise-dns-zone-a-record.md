# Create a DNS Zone and an A Record Using Azure DNS

**Source:** Microsoft Learn AZ-104 exercise  
**Duration:** ~12 minutes | **XP:** 100

## Objective

Create a public DNS zone in Azure DNS, add an A record, and verify name resolution using `nslookup` against Azure name servers.

## Prerequisites

- Azure subscription (Microsoft Learn sandbox or personal tenant)
- Resource group (use an existing one or create a dedicated RG such as `rg-az104-dns-centralus` for easy cleanup)

**Note:** In sandbox environments the DNS zone name must be globally unique within that sandbox.

## Step 1: Create the DNS Zone

1. Sign in to the Azure portal.
2. Select **Create a resource**.
3. Search for **DNS zone** and select the offering published by Microsoft.
4. Select **Create**.
5. On the **Basics** tab configure:

   | Setting          | Value                                      | Guidance |
   |------------------|--------------------------------------------|----------|
   | Subscription     | Your subscription                          | - |
   | Resource group   | Existing or new (e.g. `LearnPlatformRG`)   | Dedicated RG recommended for lab cleanup |
   | Name             | `wideworldimportsXXXX.com`                 | Replace `XXXX` with unique letters/numbers; must be unique in the sandbox |

6. Select **Review + create** → **Create**.
7. When deployment finishes, select **Go to resource**.
8. From the command bar select **Record sets**.
9. Note the four Azure DNS name server (NS) addresses. These are required for verification and for registrar delegation in production.

   The zone automatically provisions NS and SOA record sets.

## Step 2: Create the A Record

1. On the **Record sets** blade select **+ Add**.
2. Fill in the record set:

   | Setting            | Value          | Notes |
   |--------------------|----------------|-------|
   | Name               | `www`          | Host / subdomain portion |
   | Type               | `A`            | IPv4 address record |
   | Alias record set   | No             | Use standard A (not an alias) |
   | TTL                | `1`            | - |
   | TTL unit           | Hours          | - |
   | IP Address         | `10.10.10.10`  | Example only — replace with your web server public IP in real deployments |

3. Select **Add**.

**Note:** One record set name can hold multiple A records (different IPs) when you need round-robin or multi-homed endpoints.

## Step 3: Verify Resolution

1. Launch Azure Cloud Shell (Bash).
2. Execute `nslookup` against one of the Azure name servers recorded in Step 1:

   ```bash
   nslookup www.wideworldimportsXXXX.com ns1-04.azure-dns.com
   ```

3. Expected output: The name resolves to `10.10.10.10`.

## Real-World Deployment Notes

- After zone creation, update the authoritative NS records at your domain registrar to delegate the domain to the four Azure DNS name servers.
- This exercise uses a public zone. For hybrid or internal-only resolution use Azure DNS private zones (or a combination).
- TTL of 1 hour is suitable for lab work; production values are typically higher once the zone is stable.

## Cleanup

Delete the DNS zone (or its parent resource group) when finished to avoid ongoing charges.

## AZ-104 Relevance

This exercise maps to the Virtual Networking domain. Key exam concepts reinforced:
- Public vs. private DNS zones
- NS record delegation model
- A/AAAA record creation and multi-record sets
- Verification tooling (`nslookup` targeting specific authoritative servers)
- Distinction between Azure-managed NS/SOA records and customer-managed records

---

**Related artifacts in this repo:**
- `azure-naming-conventions.md` (CAF)
- Networking deep-dive study guide (HTML)
