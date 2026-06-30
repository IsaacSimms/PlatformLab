# Lab 05 - Implement Intersite Connectivity

**Estimated time:** 50 minutes  
**Region note:** Steps written for East US. You may change the region.  
**Resource group:** az104-rg5 (new or existing)  
**Source:** Microsoft AZ-104 lab content

## Lab Introduction

In this lab you explore communication between virtual networks. You implement virtual network peering and test connections. You will also create a custom route.

This lab requires an Azure subscription. Your subscription type may affect the availability of features in this lab.

## Lab Scenario

Your organization segments core IT apps and services (such as DNS and security services) from other parts of the business, including your manufacturing department. However, in some scenarios, apps and services in the core area need to communicate with apps and services in the manufacturing area. In this lab, you configure connectivity between the segmented areas. This is a common scenario for separating production from development or separating one subsidiary from another.

**Architecture diagram**

[Architecture diagram placeholder — typically illustrates CoreServicesVnet (10.0.0.0/16 with Core and Perimeter subnets) peered to ManufacturingVnet (172.16.0.0/16), plus a planned Network Virtual Appliance (NVA) in the perimeter subnet for Task 6.]

## Job Skills / Tasks

- Task 1: Create a virtual machine in a virtual network.
- Task 2: Create a virtual machine in a different virtual network.
- Task 3: Use Network Watcher to test the connection between virtual machines.
- Task 4: Configure virtual network peerings between different virtual networks.
- Task 5: Use Azure PowerShell to test the connection between virtual machines.
- Task 6: Create a custom route.

---

## Task 1: Create a core services virtual machine and virtual network

In this task, you create a core services virtual network with a virtual machine.

1. Sign in to the Azure portal: [https://portal.azure.com](https://portal.azure.com).

2. Search for and select **Virtual Machines**.

3. From the virtual machines page, select **Create** then select **Virtual machine**.

4. On the **Basics** tab, complete the form with the following values, then select **Next : Disks >**. Leave defaults for unspecified settings.

   | Setting                  | Value                                              |
   |--------------------------|----------------------------------------------------|
   | Subscription             | your subscription                                  |
   | Resource group           | az104-rg5 (Create new if necessary)                |
   | Virtual machine name     | CoreServicesVM                                     |
   | Region                   | East US                                            |
   | Availability options     | No infrastructure redundancy required              |
   | Security type            | Standard                                           |
   | Image                    | Windows Server 2025 Datacenter - x64 Gen2 (See all images) |
   | Size                     | Standard_D2s_v3                                    |
   | Username                 | localadmin                                         |
   | Password                 | Provide a complex password                         |
   | Public inbound ports     | None                                               |

5. On the **Disks** tab, take the defaults and select **Next : Networking >**.

6. On the **Networking** tab, for **Virtual network**, select **Create new**.

7. Configure the virtual network with these values, then select **OK** (remove/replace existing info if needed):

   | Setting              | Value            |
   |----------------------|------------------|
   | Name                 | CoreServicesVnet |
   | Address range        | 10.0.0.0/16      |
   | Subnet Name          | Core             |
   | Subnet address range | 10.0.0.0/24      |

8. Select the **Monitoring** tab. For **Boot diagnostics**, select **Disable**.

9. Select **Review + create**, then select **Create**.

10. You do not need to wait for the resources to be created. Continue to the next task.

    > **Note:** You created the virtual network inline while creating the virtual machine. You could also create the VNet infrastructure first, then add VMs.

---

## Task 2: Create a virtual machine in a different virtual network

In this task, you create a manufacturing services virtual network with a virtual machine.

1. From the Azure portal, search for and navigate to **Virtual Machines**.

2. From the virtual machines page, select **Create** then select **Virtual machine**.

3. On the **Basics** tab, complete the form with the following values, then select **Next : Disks >**. Leave defaults for unspecified settings.

   | Setting                  | Value                                              |
   |--------------------------|----------------------------------------------------|
   | Subscription             | your subscription                                  |
   | Resource group           | az104-rg5                                          |
   | Virtual machine name     | ManufacturingVM                                    |
   | Region                   | East US                                            |
   | Availability options     | No infrastructure redundancy required              |
   | Security type            | Standard                                           |
   | Image                    | Windows Server 2025 Datacenter - x64 Gen2 (See all images) |
   | Size                     | Standard_D2s_v3                                    |
   | Username                 | localadmin                                         |
   | Password                 | Provide a complex password                         |
   | Public inbound ports     | None                                               |

   > **Note:** If deployment fails due to capacity or quota limits, adjust the configuration or choose a different region.

4. On the **Disks** tab, take the defaults and select **Next : Networking >**.

5. On the **Networking** tab, for **Virtual network**, select **Create new**.

6. Configure the virtual network with these values, then select **OK** (adjust address range if needed):

   | Setting              | Value               |
   |----------------------|---------------------|
   | Name                 | ManufacturingVnet   |
   | Address range        | 172.16.0.0/16       |
   | Subnet Name          | Manufacturing       |
   | Subnet address range | 172.16.0.0/24       |

7. Select the **Monitoring** tab. For **Boot Diagnostics**, select **Disable**.

8. Select **Review + create**, then select **Create**.

---

## Task 3: Use Network Watcher to test the connection between virtual machines

In this task, you verify that resources in peered virtual networks can communicate with each other. Network Watcher will be used to test the connection. **Before continuing, ensure both virtual machines have been deployed and are running.**

1. From the Azure portal, search for and select **Network Watcher**.

2. From Network Watcher, in the **Network diagnostic tools** menu, select **Connection troubleshoot**.

3. Complete the **Connection troubleshoot** page with these values:

   | Field                    | Value                          |
   |--------------------------|--------------------------------|
   | Source type              | Virtual machine                |
   | Virtual machine          | CoreServicesVM                 |
   | Destination type         | Select a virtual machine       |
   | Virtual machine          | ManufacturingVM                |
   | Preferred IP Version     | Both                           |
   | Protocol                 | TCP                            |
   | Destination port         | 3389                           |
   | Source port              | (blank)                        |
   | Diagnostic tests         | Defaults                       |

4. Select **Run diagnostic tests**.

   > **Note:** It may take a couple of minutes for the results to be returned. The screen selections will be greyed out while collecting results. The Connectivity test should show **Unreachable**. This is expected because the virtual machines are in different virtual networks (no peering yet).

---

## Task 4: Configure virtual network peerings between virtual networks

In this task, you create a virtual network peering to enable communications between resources in the virtual networks.

1. In the Azure portal, select the **CoreServicesVnet** virtual network.

2. In CoreServicesVnet, under **Settings**, select **Peerings**.

3. Under Peerings, select **+ Add**. If not specified, take the defaults. Use these values:

   - **Peering link name:** ManufacturingVnet-to-CoreServicesVnet
   - **Virtual network:** ManufacturingVnet (az104-rg5)
   - **Allow 'ManufacturingVnet' to access 'CoreServicesVnet':** selected (default)
   - **Allow 'ManufacturingVnet' to receive forwarded traffic from 'CoreServicesVnet':** selected

   - **Peering link name:** CoreServicesVnet-to-ManufacturingVnet
   - **Allow 'CoreServicesVnet' to access 'ManufacturingVnet':** selected (default)
   - **Allow 'CoreServicesVnet' to receive forwarded traffic from 'ManufacturingVnet':** selected

4. Click **Add**.

5. In CoreServicesVnet, under **Peerings**, verify that the **CoreServicesVnet-to-ManufacturingVnet** peering is listed. Refresh the page to ensure the **Peering status** is **Connected**.

6. Switch to the **ManufacturingVnet** and verify the **ManufacturingVnet-to-CoreServicesVnet** peering is listed. Ensure the **Peering status** is **Connected**. Refresh if necessary.

---

## Task 5: Use Azure PowerShell to test the connection between virtual machines

In this task, you retest the connection between the virtual machines in different virtual networks after peering is configured.

### Verify the private IP address of the CoreServicesVM

1. From the Azure portal, search for and select the **CoreServicesVM** virtual machine.

2. On the **Overview** blade, in the **Networking** section, record the **Private IP address** of the machine. You will need this for the connection test.

### Test the connection to the CoreServicesVM from the ManufacturingVM

> **Tip:** There are multiple ways to check connections. This task uses Run command. You could also continue using Network Watcher or RDP into the VM and run `Test-Connection`.

1. Switch to the **CoreServicesVM** virtual machine. In the **Operations** blade, select **Run command**, then select **RunPowerShellScript**.

   Run the following command to enable the Windows Firewall rule that allows inbound RDP traffic:

   ```powershell
   Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
   ```

2. Wait for the script to complete, then switch to the **ManufacturingVM** virtual machine.

3. In the **Operations** blade, select the **Run command** blade.

4. Select **RunPowerShellScript** and run the `Test-NetConnection` command. Use the private IP address of CoreServicesVM recorded earlier:

   ```powershell
   Test-NetConnection <CoreServicesVM private IP address> -port 3389
   ```

5. It may take a couple of minutes for the script to time out. The top of the page shows an informational message: **Script execution in progress…**

6. The test connection should now **succeed** because peering has been configured. (Your computer name and remote address may differ from any example graphic.)

---

## Task 6: Create a custom route

In this task, you want to control network traffic between the perimeter subnet and the internal core services subnet. A virtual network appliance will be installed in the perimeter subnet and all traffic should be routed there.

1. Search for and select the **CoreServicesVnet**.

2. Select **Subnets** and then **+ Subnet**. Be sure to select **Add** to save your changes.

   | Setting         | Value          |
   |-----------------|----------------|
   | Name            | perimeter      |
   | Starting address| 10.0.1.0/24    |

3. In the Azure portal, search for and select **Route tables**, then select **+ Create**.

4. Enter the following details, select **Review + create**, and then select **Create**.

   | Setting                  | Value                |
   |--------------------------|----------------------|
   | Subscription             | your subscription    |
   | Resource group           | az104-rg5            |
   | Region                   | East US              |
   | Name                     | rt-CoreServices      |
   | Propagate gateway routes | No                   |

5. After the route table deploys, search for and select **Route Tables**.

6. Select the resource (not the checkbox) **rt-CoreServices**.

7. Expand **Settings** then select **Routes** and then **+ Add**. Create a route from a future Network Virtual Appliance (NVA) to the CoreServices virtual network.

   | Setting                  | Value                                      |
   |--------------------------|--------------------------------------------|
   | Route name               | PerimetertoCore                            |
   | Destination type         | IP Addresses                               |
   | Destination IP addresses | 10.0.0.0/16 (core services virtual network)|
   | Next hop type            | Virtual appliance (notice other choices)   |
   | Next hop address         | 10.0.1.7 (future NVA)                      |

8. Select **Add**.

9. The last step is to associate the route with the subnet. Select **Subnets** and then **+ Associate**. Complete the configuration:

   | Setting        | Value                    |
   |----------------|--------------------------|
   | Virtual network| CoreServicesVnet (az104-rg5) |
   | Subnet         | Perimeter                |

> **Note:** You have created a user-defined route (UDR) to direct traffic from the DMZ/perimeter to the new NVA.

---

## Cleanup Your Resources

If you are working with your own subscription, delete the lab resources to free capacity and minimize cost. The easiest way is to delete the lab resource group.

### Azure Portal

1. In the Azure portal, select the resource group **az104-rg5**.
2. Select **Delete the resource group**.
3. Enter the resource group name to confirm, then click **Delete**.
4. In the confirmation dialog stating that deletion is permanent, click **Delete** again.

### Azure PowerShell

```powershell
Remove-AzResourceGroup -Name az104-rg5
```

### Azure CLI

```bash
az group delete --name az104-rg5
```

---

**End of Lab 05 instructions.**

This file is the canonical reference for walking through the lab. All steps, values, PowerShell commands, and notes are preserved and formatted for clarity. Ready for step-by-step execution.