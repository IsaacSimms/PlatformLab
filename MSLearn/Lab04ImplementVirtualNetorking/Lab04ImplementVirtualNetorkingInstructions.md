# AZ-104 Lab: Virtual Networking Basics

**Estimated time:** 50 minutes  
**Region:** East US (switch to centralus if capacity issues arise)  
**Resource group:** `az104-rg4`

This is the first of three labs focused on virtual networking. Create virtual networks sized for growth, protect traffic with NSGs and ASGs, and configure public/private Azure DNS zones.

## Lab Scenario

A global organization needs virtual networks that accommodate current resources while supporting significant future growth.

- **CoreServicesVnet** (`10.20.0.0/16`): Highest resource count; largest address space required.
- **ManufacturingVnet** (`10.30.0.0/16`): Manufacturing operations; high density of internal connected devices expected.

**Core principle:** Design an enterprise-wide IP addressing scheme. Avoid overlapping ranges (cloud or on-premises) to reduce troubleshooting complexity and support growth.

## Architecture

See the original lab diagram for VNet/subnet layout:
- CoreServicesVnet: SharedServicesSubnet (`10.20.10.0/24`), DatabaseSubnet (`10.20.20.0/24`)
- ManufacturingVnet: SensorSubnet1 (`10.30.20.0/24`), SensorSubnet2 (`10.30.21.0/24`)

## Tasks

1. Create a virtual network with subnets using the portal.
2. Create a virtual network and subnets using an ARM template.
3. Create and configure an Application Security Group (ASG) with a Network Security Group (NSG).
4. Configure public and private Azure DNS zones.

---

## Task 1: Create a virtual network with subnets using the portal

1. Sign in to the [Azure portal](https://portal.azure.com).

2. Search for and select **Virtual networks** → **Create**.

3. **Basics** tab:

   | Setting        | Value                                      |
   |----------------|--------------------------------------------|
   | Resource group | `az104-rg4` (create if needed)             |
   | Name           | `CoreServicesVnet`                         |
   | Region         | East US                                    |

4. **Address space** tab: Replace the default IPv4 address space with `10.20.0.0/16`.

5. Select **+ Add a subnet**. Create each and select **Add** after configuring:

   | Subnet name            | Starting address | Size |
   |------------------------|------------------|------|
   | `SharedServicesSubnet` | `10.20.10.0`     | /24  |
   | `DatabaseSubnet`       | `10.20.20.0`     | /24  |

   > Delete the default subnet (before or after). Azure reserves the first 5 addresses in every subnet.

6. **Review + create** → confirm validation → **Create**.

7. After deployment, select **Go to resource**.

8. Verify **Address space** and **Subnets** blades.

9. Under **Automation**, select **Export template**.

10. Download from both the **Template** tab and the **Parameters** tab. Files land in your Downloads folder as `template.json` and `parameters.json`.

---

## Task 2: Create a virtual network and subnets using a template

Use the exported files from Task 1 as the base for `ManufacturingVnet`.

### Modify template.json

1. Open `template.json` in VS Code (trusted window recommended).

2. Use Replace All to perform these bulk changes:
   - `CoreServicesVnet` → `ManufacturingVnet`
   - `10.20.0.0` → `10.30.0.0`

3. Update the subnet sections:
   - `SharedServicesSubnet` → `SensorSubnet1`
   - `10.20.10.0/24` → `10.30.20.0/24`
   - `DatabaseSubnet` → `SensorSubnet2`
   - `10.20.20.0/24` → `10.30.21.0/24`

4. Scan the full file against the architecture diagram. Save.

### Modify parameters.json

1. Open `parameters.json`.

2. Replace the single occurrence of `CoreServicesVnet` with `ManufacturingVnet`.

3. Save.

### Deploy

1. Portal: search for **Deploy a custom template** → **Build your own template in the editor** → **Load file** → select modified `template.json` → **Save**.

2. Select **Edit parameters** → **Load file** → select modified `parameters.json` → **Save**.

3. Confirm resource group `az104-rg4` → **Review + create** → **Create**.

4. After deployment succeeds, verify `ManufacturingVnet` and its subnets exist in the portal.

> Partial failures: remove any successfully created resources manually and retry the deployment.

---

## Task 3: Create and configure communication between an Application Security Group and a Network Security Group

### Create the Application Security Group

1. Search for and select **Application security groups** → **Create**.

2. Configure:

   | Setting        | Value             |
   |----------------|-------------------|
   | Subscription   | your subscription |
   | Resource group | `az104-rg4`       |
   | Name           | `asg-web`         |
   | Region         | East US           |

3. **Review + create** → **Create**.

> Associate this ASG with target VMs later; the NSG rule below will govern traffic to those VMs.

### Create and associate the Network Security Group

1. Search for and select **Network security groups** → **Create**.

2. **Basics**:

   | Setting        | Value             |
   |----------------|-------------------|
   | Subscription   | your subscription |
   | Resource group | `az104-rg4`       |
   | Name           | `myNSGSecure`     |
   | Region         | East US           |

3. **Review + create** → **Create** → **Go to resource**.

4. **Settings** → **Subnets** → **Associate**:

   | Setting         | Value                  |
   |-----------------|------------------------|
   | Virtual network | `CoreServicesVnet`     |
   | Subnet          | `SharedServicesSubnet` |

5. Select **OK**.

### Inbound rule: allow traffic from the ASG

1. On the NSG, **Inbound security rules** → **+ Add**.

2. Configure rule:

   | Setting                            | Value                          |
   |------------------------------------|--------------------------------|
   | Source                             | Application security group     |
   | Source application security groups | `asg-web`                      |
   | Source port ranges                 | `*`                            |
   | Destination                        | Any                            |
   | Service                            | Custom                         |
   | Destination port ranges            | `80,443`                       |
   | Protocol                           | TCP                            |
   | Action                             | Allow                          |
   | Priority                           | `100`                          |
   | Name                               | `AllowASG`                     |

3. Select **Add**.

### Outbound rule: deny Internet access

1. **Outbound security rules**.

2. Note the immutable `AllowInternetOutBound` rule (priority 65001).

3. **+ Add** and configure:

   | Setting                 | Value                  |
   |-------------------------|------------------------|
   | Source                  | Any                    |
   | Source port ranges      | `*`                    |
   | Destination             | Service tag            |
   | Destination service tag | Internet               |
   | Service                 | Custom                 |
   | Destination port ranges | `*`                    |
   | Protocol                | Any                    |
   | Action                  | Deny                   |
   | Priority                | `4096`                 |
   | Name                    | `DenyInternetOutbound` |

4. Select **Add**.

---

## Task 4: Configure public and private Azure DNS zones

### Public DNS zone

1. Search for and select **DNS zones** → **+ Create**.

2. **Basics** (domain name must be globally unique):

   | Property       | Value                                                                 |
   |----------------|-----------------------------------------------------------------------|
   | Subscription   | your subscription                                                     |
   | Resource group | `az104-rg4`                                                           |
   | Name           | `contoso-lab104.com` (replace if taken; do not use reserved contoso.com) |
   | Region         | East US                                                               |

3. **Review + create** → **Create** → **Go to resource**.

4. On **Overview**, copy one of the four Azure DNS name server FQDNs/IPs.

5. **DNS Management** → **Recordsets** → **+ Add**:

   | Property         | Value      |
   |------------------|------------|
   | Name             | `www`      |
   | Type             | A          |
   | Alias record set | No         |
   | TTL              | `1`        |
   | IP address       | `10.1.1.4` |

6. Select **Add**.

7. From a terminal, run (update domain and name server as needed):

   ```sh
   nslookup www.contoso-lab104.com <name-server-you-copied>
   ```

8. Confirm resolution returns `10.1.1.4`.

### Private DNS zone

1. Search for and select **Private dns zones** → **+ Create**.

2. Configure:

   | Property       | Value                            |
   |----------------|----------------------------------|
   | Subscription   | your subscription                |
   | Resource group | `az104-rg4`                      |
   | Name           | `private.contoso-lab104.com`     |
   | Region         | East US                          |

3. **Review + create** → **Create** → **Go to resource**.

4. **DNS Management** → **Virtual network links** → create link:

   | Setting         | Value                |
   |-----------------|----------------------|
   | Link name       | `manufacturing-link` |
   | Virtual network | `ManufacturingVnet`  |

5. Select **Create**.

6. **DNS Management** → **+ Recordsets** (example for a future VM):

   | Property   | Value      |
   |------------|------------|
   | Name       | `sensorvm` |
   | Type       | A          |
   | TTL        | `1`        |
   | IP address | `10.1.1.4` |

---

## Cleanup

Delete the entire resource group to remove all lab artifacts and stop billing.

**Portal:**
- Navigate to resource group `az104-rg4` → **Delete resource group** → type the name to confirm → **Delete**.

**PowerShell:**
```powershell
Remove-AzResourceGroup -Name az104-rg4 -Force
```

**Azure CLI:**
```bash
az group delete --name az104-rg4 --yes
```

> **Cattle, not pets:** These resources are disposable. Export any templates or notes you want to retain into the `AzurePlatform` repo before deletion. Follow the same pattern used in prior labs (e.g., `rg-az104-*` naming where it adds clarity).

---

**Next steps after this lab:** Proceed to the remaining two virtual networking labs in the AZ-104 series, then integrate NSG/ASG patterns and private DNS into your hybrid home lab and CodeSmith deployment architecture.