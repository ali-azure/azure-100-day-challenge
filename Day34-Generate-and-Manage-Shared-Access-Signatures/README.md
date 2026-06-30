# Day 34 — Generate and Manage Shared Access Signatures (SAS Tokens)

### Azure 100 Days of Cloud Challenge — Ali Aden

## Overview

In this project, I configured and validated Azure Shared Access Signatures (SAS) to securely provide temporary access to Azure Blob Storage.

Rather than sharing Storage Account keys, I generated an Account SAS from the Azure Portal using least-privilege permissions to grant time-limited access to Blob Storage resources. I then validated the SAS by accessing a private blob through a web browser before generating a User Delegation SAS using Azure CLI with Microsoft Entra ID authentication.

This project demonstrates how Shared Access Signatures enable secure, temporary access to Azure Storage resources while reducing the security risks associated with sharing long-lived Storage Account keys.

---

## Technologies Used

* Azure Storage Account
* Azure Blob Storage
* Blob Containers
* Shared Access Signatures (Account SAS)
* User Delegation SAS
* Microsoft Entra ID
* Azure Portal
* Azure CLI
* Windows PowerShell

---

## Architecture Diagram

```text
                 Administrator
                       │
                       ▼
                Azure Portal
                       │
             Generate Account SAS
                       │
                       ▼
            Azure Storage Account
             stazure100days01
                       │
                       ▼
               Blob Container
                day34-sas-demo
                       │
                       ▼
                  sample.txt
                       ▲
                       │
               HTTPS + SAS URL
                       │
              Web Browser Validation

                       ▲
                       │
        Azure CLI (Microsoft Entra ID)
                       │
         Generate User Delegation SAS
```

---

## Implementation Steps

### Step 1 — Create a Blob Container

Created a private Blob Container to securely store a test file for SAS validation.

Configuration:

```text
Container:
day34-sas-demo

Public Access:
Private (No anonymous access)
```

---

### Step 2 — Upload a Test Blob

Uploaded a simple text file that would later be accessed using the generated SAS token.

Configuration:

```text
Blob Name:
sample.txt

Blob Type:
Block Blob
```

---

### Step 3 — Configure an Account SAS

Configured an Account Shared Access Signature from the Storage Account Shared access signature blade.

Configuration:

```text
Allowed Services:
Blob

Allowed Resource Types:
Container
Object

Allowed Permissions:
Read
List

Allowed Protocols:
HTTPS Only

Validity:
24 Hours

Signing Key:
Key1
```

The configuration followed the principle of **least privilege** by granting only the minimum permissions required.

---

### Step 4 — Generate the Account SAS

Generated an Account SAS from the Azure Portal.

The generated SAS included:

* Scoped permissions
* Allowed services
* Resource types
* Expiry time
* Cryptographic signature

For security reasons, the SAS token, connection string and Blob Service SAS URL were redacted before publishing this project.

---

### Step 5 — Validate Blob Access

Validated that the generated SAS granted only the configured permissions within the defined validity period by accessing the private blob through a web browser.

This confirmed that the Storage Account key was not required to access the protected resource.

---

### Step 6 — Generate a User Delegation SAS Using Azure CLI

Generated a User Delegation SAS using Azure CLI with Microsoft Entra ID authentication.

Command:

```powershell
az storage container generate-sas `
    --account-name stazure100days01 `
    --name day34-sas-demo `
    --permissions rl `
    --expiry 2026-06-30T22:10:00Z `
    --auth-mode login `
    --as-user `
    --output tsv
```

Unlike an Account SAS, a User Delegation SAS is signed using Microsoft Entra ID credentials rather than the Storage Account key, providing a more secure approach to delegated access where supported.

---

## Validation

### Validation 1 — Blob Container and Test Blob

Verified that the private Blob Container was successfully created and that the test blob had been uploaded.

Confirmed:

* Private Blob Container created
* Test blob uploaded successfully
* Block Blob created

**Screenshot:**

![Blob Container](screenshots/01-storage-container-blob-upload.png)

---

### Validation 2 — Account SAS Configuration

Verified the Account SAS configuration before generation.

Confirmed:

* Blob service selected
* Container and Object resource types
* Read and List permissions
* HTTPS only
* 24-hour expiry

**Screenshots:**

![SAS Configuration Part 1](screenshots/02-sas-configuration-part1.png)

![SAS Configuration Part 2](screenshots/03-sas-configuration-part2.png)

---

### Validation 3 — Account SAS Generation

Verified that Azure successfully generated the Account SAS.

Confirmed:

* Connection string generated
* SAS token generated
* Blob Service SAS URL generated

Sensitive values were redacted before publication.

**Screenshot:**

![Generated SAS](screenshots/04-sas-token-generated.png)

---

### Validation 4 — Browser Validation

Validated that the generated SAS successfully granted temporary access to the private blob.

Confirmed:

* Blob accessible using the SAS URL
* Read permission successfully validated
* Storage Account key was not required

**Screenshot:**

![Browser Validation](screenshots/05-sas-url-validation.png)

---

### Validation 5 — Azure CLI Validation

Generated a User Delegation SAS using Azure CLI and Microsoft Entra ID authentication.

Command:

```powershell
az storage container generate-sas `
    --account-name stazure100days01 `
    --name day34-sas-demo `
    --permissions rl `
    --expiry 2026-06-30T22:10:00Z `
    --auth-mode login `
    --as-user `
    --output tsv
```

Validation confirmed:

* Azure CLI authenticated successfully
* User Delegation SAS generated
* Microsoft Entra ID authentication used
* Storage Account key not required

**Screenshot:**

![Azure CLI Validation](screenshots/06-cli-generate-sas-token.png)

---

## Security Benefits

This implementation provides:

* Eliminates the need to expose Storage Account keys when granting temporary access.
* Grants temporary, time-limited access to Azure Storage resources.
* Applies the principle of least privilege through scoped permissions.
* Restricts access to specific services and resource types.
* Enforces encrypted HTTPS communication.
* Supports secure delegated access using Microsoft Entra ID.
* Reduces the impact of credential exposure through automatic SAS expiry.

---

## Key Notes

* Shared Access Signatures (SAS) provide temporary delegated access to Azure Storage resources without exposing Storage Account keys.
* Account SAS tokens are signed using the Storage Account key.
* User Delegation SAS tokens are signed using Microsoft Entra ID credentials and are the recommended approach where supported.
* Applying least-privilege permissions reduces the security risks associated with delegated access.
* HTTPS-only access helps protect data in transit.
* SAS tokens should always have an appropriate expiry time to minimise the impact of credential exposure.
* All sensitive values, including SAS tokens, connection strings and SAS URLs, were redacted before publishing this project.
