# Exercise 01: Create and Configure Virtual Networks (Hub & Spoke)

**Estimated time:** 20 minutes  
**Region:** East US (per lab)  
**Resource Group:** RG1

## Scenario & Requirements
Migrate a web application to Azure using a hub-and-spoke topology.

- `app-vnet` (spoke): hosts the application
  - `frontend` subnet → web servers
  - `backend` subnet → database servers
- `hub-vnet`: contains Azure Firewall
  - `AzureFirewallSubnet` (required name for the service)
- Both VNets in the same region
- Secure private communication via VNet peering (bidirectional)

## Prerequisites
- Azure subscription with Contributor role
- Resource group `RG1` (create if it does not exist)

## Step 1: Create app-vnet + Subnets

1. Portal → **Virtual networks** → **+ Create**
2. Configure:

| Property              | Value                  |
|-----------------------|------------------------|
| Resource group        | RG1                    |
| Virtual network name  | app-vnet               |
| Region                | East US                |
| IPv4 address space    | 10.1.0.0/16            |
| Subnet name           | frontend               |
| Subnet address range  | 10.1.0.0/24            |
| Subnet name           | backend                |
| Subnet address range  | 10.1.1.0/24            |

3. Leave all other settings at defaults → **Review + create** → **Create**

## Step 2: Create hub-vnet + AzureFirewallSubnet

1. **+ Create** another virtual network
2. Configure:

| Property              | Value                     |
|-----------------------|---------------------------|
| Resource group        | RG1                       |
| Virtual network name  | hub-vnet                  |
| Region                | East US                   |
| IPv4 address space    | 10.0.0.0/16               |
| Subnet name           | AzureFirewallSubnet       |
| Subnet address range  | 10.0.0.0/26               |

> **Important:** The subnet **must** be named exactly `AzureFirewallSubnet` for Azure Firewall to use it later.

3. **Review + create** → **Create**

## Step 3: Configure VNet Peering

Peering is created from one side; Azure creates the reciprocal peering automatically when using default settings.

1. Open **app-vnet** → **Settings** → **Peerings** → **+ Add**
2. Configure:

| Property                          | Value                    |
|-----------------------------------|--------------------------|
| Remote peering link name          | app-vnet-to-hub          |
| Virtual network                   | hub-vnet                 |
| Local virtual network peering link name | hub-to-app-vnet    |

3. Leave all other settings at defaults (Allow traffic both ways, Allow forwarded traffic, etc.) → **Add**

4. Wait for deployment to complete. Verify **Peering status** shows **Connected** on both sides.

## Verification

- Go to **Virtual networks** blade
- Confirm both `app-vnet` and `hub-vnet` exist
- Open each VNet → **Subnets** blade and verify all three subnets are present with correct CIDRs
- Open `app-vnet` → **Peerings** and confirm status = **Connected**
- (Optional) Use **Network Watcher** → **Topology** or test connectivity with a test VM later

## Key Takeaways

- VNets provide isolated, secure network boundaries. Multiple VNets per region per subscription are supported.
- Choose non-overlapping CIDR blocks for all VNets in your environment.
- Subnets segment a VNet. Each subnet gets a unique address range within the VNet's space.
- Some services (Azure Firewall, Bastion, Gateway) **require** a dedicated subnet with a specific name.
- VNet peering connects two VNets privately and with low latency. The VNets appear as one for connectivity purposes. No public internet traversal.
- Peering is **not transitive** by default. Traffic from spoke1 → hub → spoke2 requires additional configuration (e.g., UDRs or NVA).

## Notes for Your Lab Subscription

- This exercise uses **East US**. Your lab subscription (`sub-primiPlatformLab-cus-001`) defaults to Central US — you can change the region in the wizard or keep East US for the lab.
- After completion, tag the VNets:
  - `Environment=Lab`
  - `Purpose=Networking`
- Create a budget alert scoped to this subscription immediately if you have not already.

---

**Source:** Distilled from official Azure lab exercise instructions (June 2026)