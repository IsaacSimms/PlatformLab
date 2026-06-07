# Azure Blob Storage Lab — Public Website Storage

## Scenario

A company website serves product images, videos, marketing literature, and customer success stories to a global audience. Requirements:

- Low latency for worldwide customers
- High availability with regional failover
- Anonymous public access (no customer login required)
- Document version tracking
- Quick restore on accidental deletion

**Estimated Time:** 20 minutes

---

## Architecture

```
Storage Account (RA-GRS)
└── Blob Container: public
    └── Blobs (anonymous read access)
```

---

## Tasks

### 1. Create a Storage Account with High Availability

1. In the portal, search for and select **Storage accounts** → **+ Create**
2. Create a new **Resource Group** and give it a name
3. Set **Storage account name** to `publicwebsite` + unique identifier
4. Accept defaults for remaining settings → **Review** → **Create**
5. Once deployed, select **Go to resource**

**Enable geo-redundancy:**

6. Under **Data management**, select **Redundancy**
7. Set to **Read-access Geo-redundant storage (RA-GRS)**
8. Review primary and secondary location info

**Enable anonymous access:**

9. Under **Settings**, select **Configuration**
10. Set **Allow blob anonymous access** to **Enabled**
11. **Save** changes

---

### 2. Create a Blob Container with Anonymous Read Access

1. Under **Data storage**, select **Containers** → **+ Container**
2. Set **Name** to `public` → **Create**

**Configure anonymous read access:**

3. Select the `public` container
4. On the **Overview** blade, select **Change access level**
5. Set **Public access level** to **Blob (anonymous read access for blobs only)**
6. Select **OK**

**Test file upload and URL access:**

7. In the container, select **Upload** → browse to a small image or text file → **Upload**
8. Close the upload window and **Refresh** to confirm the file appears
9. Select the file → **Overview** tab → copy the **URL**
10. Paste the URL into a new browser tab — images render directly; other file types download

---

### 3. Configure Soft Delete (21-day retention)

1. From the storage account **Overview**, go to the **Properties** page
2. Under **Blob service**, select **Blob soft delete**
3. Check **Enable soft delete for blobs**
4. Set **Keep deleted blobs for** to `21` days
5. **Save** changes

**Test restore:**

6. Navigate to the container → select the uploaded file → **Delete** → **OK**
7. On the container Overview, toggle **Show deleted blobs**
8. Select the deleted file → use the ellipsis (**...**) → **Undelete**
9. Refresh and confirm the file is restored

---

### 4. Configure Blob Versioning

1. From the storage account **Overview**, go to **Properties**
2. Under **Blob service**, select **Versioning**
3. Check **Enable versioning for blobs**
4. Choose retention preference (keep all versions or delete after N days)
5. **Save** changes

**Test versioning:**

6. Upload a new version of the same file (overwrites existing)
7. Toggle **Show deleted blobs** to view the previous version
8. Restore a prior version as needed

---

## Key Takeaways

| Feature | Purpose |
|---|---|
| **RA-GRS** | Read access to secondary region during outage |
| **Anonymous blob access** | Customers can read content without authentication |
| **Soft delete** | Recovers blobs for a defined retention window after deletion |
| **Blob versioning** | Maintains history of blob changes; enables point-in-time restore |

> **Blob Storage** is optimized for unstructured data (text, binary, images, video). When a container is set to anonymous access, any client can read its blobs without credentials.
