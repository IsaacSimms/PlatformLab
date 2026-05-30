# Lab 09b — Implement Azure Container Instances

## Overview

| | |
|---|---|
| **Estimated Time** | 15 minutes |
| **Requires** | Azure subscription |
| **Default Region** | East US |

### Scenario

Evaluate Azure Container Instances and Docker as a path to migrate an on-premises web application to the cloud without managing a large server footprint.

### Skills Covered

- Task 1: Deploy an Azure Container Instance using a Docker image
- Task 2: Test and verify deployment of an Azure Container Instance

---

## Task 1: Deploy an Azure Container Instance

1. Sign in to the [Azure Portal](https://portal.azure.com).

2. Search for and select **Container instances**, then click **+ Create**.

3. On the **Basics** tab, configure the following:

   | Setting | Value |
   |---|---|
   | Subscription | Your Azure subscription |
   | Resource group | `az104-rg9` *(create new if needed)* |
   | Container name | `az104-c1` |
   | Region | East US *(or nearest available)* |
   | Image Source | Quickstart images |
   | Image | `mcr.microsoft.com/azuredocs/aci-helloworld:latest` (Linux) |

4. Click **Next: Networking >** and configure:

   | Setting | Value |
   |---|---|
   | DNS name label | Any valid, globally unique DNS hostname |

   > **Note:** The container will be publicly reachable at `<dns-name-label>.<region>.azurecontainer.io`. If you get a "DNS name label not available" error, choose a different value.

5. Click **Next: Monitoring >** and **uncheck** *Enable container instance logs*.

6. Click **Next: Advanced >** — review settings, no changes needed.

7. Click **Review + Create**, confirm validation passes, then click **Create**.

   > **Note:** Deployment takes approximately 2–3 minutes.

---

## Task 2: Test and Verify Deployment

1. When deployment completes, click **Go to resource**.

2. On the **Overview** blade, verify **Status** shows `Running`.

3. Copy the **FQDN** value, open a new browser tab, and navigate to that URL.

4. Confirm the **Welcome to Azure Container Instance** page loads.

5. Refresh the page several times to generate log entries, then close the tab.

6. In the container instance blade, go to **Settings > Containers**, then click **Logs**.

7. Verify HTTP GET request log entries are present from your browser visits.

---

## Cleanup

Delete resources to avoid ongoing charges. Use any of the following methods:

**Portal:**
> Resource group → Delete the resource group → Enter name to confirm → Delete

**PowerShell:**
```powershell
Remove-AzResourceGroup -Name az104-rg9
```

**Azure CLI:**
```bash
az group delete --name az104-rg9
```
