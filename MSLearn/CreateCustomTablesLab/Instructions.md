# AZ-104 Lab: Route Tables, Custom Routes, and Virtual Networks

**Date:** 2026-07-02  
**Type:** Hands-on lab exercise  
**Project:** AzurePlatform  
**Resource Group:** Replace `myResourceGroupName` with your actual resource group name (e.g., `LearnPlatformRG`)

## Overview

This lab demonstrates creating a custom route table with a user-defined route (UDR) for traffic destined to a private subnet via a virtual appliance. It also covers creating a VNet with multiple subnets and associating the route table.

**Note:** You might encounter a deprecation warning for some commands. Ignore it for this module.

---

## 1. Create Route Table and Custom Route

1. Open Azure Cloud Shell and switch to **Classic version** (Settings → Go to Classic version).

2. Create the route table:

   ```bash
   az network route-table create \
       --name publictable \
       --resource-group "myResourceGroupName" \
       --disable-bgp-route-propagation false
   ```

3. Add custom route for private subnet traffic:

   ```bash
   az network route-table route create \
       --route-table-name publictable \
       --resource-group "myResourceGroupName" \
       --name productionsubnet \
       --address-prefix 10.0.1.0/24 \
       --next-hop-type VirtualAppliance \
       --next-hop-ip-address 10.0.2.4
   ```

---

## 2. Create Virtual Network and Subnets

1. Create VNet with public subnet:

   ```bash
   az network vnet create \
       --name vnet \
       --resource-group "myResourceGroupName" \
       --address-prefixes 10.0.0.0/16 \
       --subnet-name publicsubnet \
       --subnet-prefixes 10.0.0.0/24
   ```

2. Create private subnet:

   ```bash
   az network vnet subnet create \
       --name privatesubnet \
       --vnet-name vnet \
       --resource-group "myResourceGroupName" \
       --address-prefixes 10.0.1.0/24
   ```

3. Create DMZ subnet:

   ```bash
   az network vnet subnet create \
       --name dmzsubnet \
       --vnet-name vnet \
       --resource-group "myResourceGroupName" \
       --address-prefixes 10.0.2.0/24
   ```

4. Verify subnets:

   ```bash
   az network vnet subnet list \
       --resource-group "myResourceGroupName" \
       --vnet-name vnet \
       --output table
   ```

---

## 3. Associate Route Table with Public Subnet

```bash
az network vnet subnet update \
    --name publicsubnet \
    --vnet-name vnet \
    --resource-group "myResourceGroupName" \
    --route-table publictable
```

---

## Key Concepts (AZ-104 Relevant)

- **User-Defined Routes (UDRs):** Override Azure's default system routes. Useful for forcing traffic through appliances (firewalls, NVA).
- **Route Table:** Container for routes. Associated at subnet level.
- **Next Hop Types:** VirtualAppliance for routing to NVAs.
- **Address Prefixes:** CIDR blocks for VNet (10.0.0.0/16) and subnets.
- **BGP Route Propagation:** Disabled here to ensure custom routes take precedence in some scenarios.

**Best Practice:** Use descriptive naming (CAF-aligned). Clean up resources post-lab. Export templates for IaC reference.

## Next Steps
- Verify routing with Network Watcher.
- Test traffic flow once VMs are deployed in subnets.
- Explore peering and service endpoints in follow-on labs.
