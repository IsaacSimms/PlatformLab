# Lab 09a - Implement Web Apps

## Overview

**Estimated Time:** 20 minutes  
**Requires:** Azure subscription  
**Region:** East US (or substitute if quota fails)

### Scenario
Migrate company websites from on-premises Windows servers (PHP runtime) to Azure App Services to avoid end-of-life hardware replacement costs.

### Skills Covered
- Task 1: Create and configure an Azure web app
- Task 2: Create and configure a deployment slot
- Task 3: Configure web app deployment settings
- Task 4: Swap deployment slots
- Task 5: Configure and test autoscaling

---

## Task 1: Create and Configure an Azure Web App

1. Sign in to the [Azure portal](https://portal.azure.com)
2. Search for and select **App Services**
3. Select **+ Create > Web App**
4. On the **Basics** tab, configure the following:

| Setting | Value |
|---|---|
| Subscription | Your Azure subscription |
| Resource Group | `az104-rg9` (create new if needed) |
| Web App Name | Any globally unique name |
| Publish | Code |
| Runtime Stack | PHP 8.2 |
| Operating System | Linux |
| Region | East US |
| Pricing Plan | Premium V3 P1V3 |
| Zone Redundancy | Disabled (default) |

5. Click **Review + create**, then **Create**
6. Wait for deployment to complete (~1 minute)
7. Select **Go to resource**

> **Note:** If deployment fails due to quota, switch to a different region and retry.

---

## Task 2: Create and Configure a Deployment Slot

1. From the Web App blade, click the **Default domain** link to verify the default page loads
2. Close the new tab and return to the Azure portal
3. In the Web App blade, under **Deployment**, select **Deployment slots**
4. Click **Add slot** and configure:

| Setting | Value |
|---|---|
| Name | `staging` |
| Clone settings from | Do not clone settings |

5. Select **Add**
6. Refresh the page — verify both **Production** and **Staging** slots are listed
7. Select the **staging** slot entry to open its blade
8. Note that the staging slot URL differs from the production slot URL

---

## Task 3: Configure Web App Deployment Settings

> **Important:** Ensure you are working on the **staging slot**, not the production slot.

1. In the staging slot blade, select **Configuration > General settings**
2. Under **SCM Basic Auth Publishing Credentials**, enable the checkbox and select **Apply**
3. Select **Deployment Center > Settings**

> **Note:** If a banner appears stating SCM basic authentication is disabled, select **Enable here** and complete the steps.

4. In the **Source** drop-down, select **External Git**
5. Configure the following:

| Field | Value |
|---|---|
| Repository | `https://github.com/Azure-Samples/php-docs-hello-world` |
| Branch | `master` |

6. Select **Save**
7. From the staging slot, select **Overview**
8. Click the **Default domain** link and open in a new tab
9. Verify the staging slot displays **Hello World**

> **Note:** Deployment may take a minute. Refresh the page if needed.

---

## Task 4: Swap Deployment Slots

1. Navigate back to the **Deployment slots** blade
2. Select **Swap**
3. Review the default settings and click **Start Swap**
4. Wait for the swap completion notification
5. Return to the portal home page
6. Search for **App Services** and select your Web App (returns you to the Production slot)
7. On the Overview blade, click the **Default domain** link
8. Verify the production page now displays **Hello World!**

> **Note:** Copy the Default domain URL — you will need it for Task 5 load testing.

---

## Task 5: Configure and Test Autoscaling

> **Important:** Ensure you are working on the **production slot**, not the staging slot.

1. In the left pane under **App Service plan**, select **Scale out**
2. Under **Scaling**, select **Automatic**
3. Set the following:

| Setting | Value |
|---|---|
| Maximum burst | 2 |
| Minimum instances | 1 |

4. Select **Save**
5. Select **Diagnose and solve problems** (left pane)
6. In the **Load Test your App** box, select **Create Load Test**
7. Select **+ Create**, give the load test a unique name
8. Select **Review + create**, then **Create**
9. Wait for the load test resource to provision, then select **Go to resource**
10. From Overview, select **Create** under "Create by adding HTTP requests"
11. On the **Test plan** tab, click **Add request**
12. Paste your **Default domain URL** in the URL field (ensure it begins with `https://`)
13. Select **Add**, then **Review + create**, then **Create**
14. Navigate to the test from the home page
15. Refresh and monitor live metrics: **Virtual users**, **Response time**, **Requests/sec**
16. Select **Stop > Stop** to end the test run

---

## Cleanup

Delete all lab resources to avoid ongoing charges.

**Portal:**
1. Select the resource group
2. Select **Delete the resource group**
3. Enter the resource group name and confirm deletion (two confirmation dialogs)

**PowerShell:**
```powershell
Remove-AzResourceGroup -Name resourceGroupName
```

**Azure CLI:**
```bash
az group delete --name resourceGroupName
```

---

## Key Takeaways

- **Azure App Services** is a PaaS solution — no infrastructure management required
- Supports multiple runtime stacks: ASP.NET, Java, PHP, Python, and more
- **Deployment slots** provide isolated environments for staging/testing before production
- **Slot swapping** enables zero-downtime deployments
- **Autoscaling** can be rules-based or automatic, responding to traffic demand
- **Premium V3 tier or higher** is required for deployment slots and autoscaling features
