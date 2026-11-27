# Day 67 – Set Up Policy Exemptions for Specific Resources

### Azure 100 Days of Cloud Challenge — Ali Aden

## Project Overview

For Day 67, I worked with Azure Policy Exemptions and explored how to exclude specific resources from a policy assignment without disabling the policy for the entire resource group.

I created two types of exemptions:

- **Waiver:** A permanent exemption for a resource where a policy requirement does not apply.
- **Mitigated:** A temporary exemption for a resource while an issue is being reviewed or addressed.

I reused my custom Azure Policy definition from Day 65, which checks Storage Accounts for diagnostic settings and uses the `DeployIfNotExists` effect to deploy them when they are missing.

As I was working in a new Azure subscription, I reused my existing Storage Accounts and created a second policy assignment in another resource group to practise both exemption categories.

I completed the configuration and validation using Azure CLI in Windows PowerShell.

## Architecture

The following diagram shows the policy assignments, Storage Accounts and exemptions created during this exercise.

```text
                    Azure Subscription
                            |
                  Custom Azure Policy
                pol-day65-storage-diagnostics
                            |
               +------------+------------+
               |                         |
               v                         v
        rg-day65-dine-01        rg-day65-policy-lab
               |                         |
               v                         v
        Day 65 Assignment         Day 67 Assignment
        pa-day65-storage-         pa-day67-storage-
        diagnostics               diagnostics
               |                         |
               v                         v
        st65diag171126a          stday65diagnostics
               |                         |
               v                         v
        Waiver Exemption         Mitigated Exemption
               |                         |
               v                         v
            EXEMPT                    EXEMPT
                                      |
                                Expires:
                                24 Dec 2026
```

**Important:** The second resource group also contains an existing Day 65 policy assignment. The Storage Account remains NonCompliant under that separate assignment but is Exempt under the Day 67 assignment.

## Implementation

### 1. Reviewed the Existing Policy Assignment

I started by checking the policy assignment created during Day 65.

The existing assignment was:

| Setting | Value |
|---|---|
| Assignment name | `f796804afdef5cc5ab8f3aa0` |
| Display name | `pa-day65-storage-diagnostics` |
| Policy definition | `dd1649a3bab95ee7b1cf4ba4` |
| Resource group | `rg-day65-dine-01` |
| Region | Sweden Central |

I checked the associated Storage Account, `st65diag171126a`, and confirmed that its diagnostic setting was configured.

### 2. Created a Second Policy Assignment

My second Storage Account, `stday65diagnostics`, was located in `rg-day65-policy-lab`.

The original Day 65 assignment only covered `rg-day65-dine-01`, so it could not be used to create an exemption for the Storage Account in the other resource group.

I therefore created a second assignment using the same custom policy definition.

The new assignment details were:

| Setting | Value |
|---|---|
| Assignment name | `pa-day67-storage-diagnostics` |
| Policy definition | `dd1649a3bab95ee7b1cf4ba4` |
| Resource group | `rg-day65-policy-lab` |
| Region | Sweden Central |
| Managed identity | SystemAssigned |

I also assigned the **Monitoring Contributor** role to the new managed identity at the resource group scope.

This provided the identity with the permissions required by the policy to configure diagnostic settings.

### 3. Checked Policy Compliance

I triggered a policy compliance scan in `rg-day65-policy-lab`.

The Storage Account `stday65diagnostics` was identified as NonCompliant under the new Day 67 assignment because it did not have the required diagnostic setting.

I also discovered another existing policy assignment in the same resource group:

`assign-day65-diagnostics`

This meant the same Storage Account was being evaluated against two different policy definitions.

I checked the assignment IDs and policy definition IDs to make sure the exemptions would be created against the correct assignments.

### 4. Created a Waiver Exemption

I created a Waiver exemption for the Storage Account:

`st65diag171126a`

The exemption details were:

| Setting | Value |
|---|---|
| Name | `day67-storage-waiver` |
| Category | Waiver |
| Resource group | `rg-day65-dine-01` |
| Policy assignment | Original Day 65 assignment |
| Expiry | None |

I added a justification explaining that this was a simulated lab waiver to demonstrate a permanent policy exemption.

The Storage Account was already Compliant before I created the exemption. I have included this detail because the purpose was to practise creating and validating a Waiver, rather than to resolve an existing compliance issue.

After the exemption was created, Azure reported the resource as Exempt under the original policy assignment.

### 5. Created a Mitigated Exemption

I then created a Mitigated exemption for the second Storage Account:

`stday65diagnostics`

The exemption details were:

| Setting | Value |
|---|---|
| Name | `day67-storage-mitigated` |
| Category | Mitigated |
| Resource group | `rg-day65-policy-lab` |
| Policy assignment | `pa-day67-storage-diagnostics` |
| Expiry | 24 December 2026 |

I added a justification explaining that this was a temporary lab exemption while the diagnostic settings were being reviewed.

I included a review requirement and an expiry date 30 days after creation.

The justification recorded that existing Azure access controls remained applicable. I did not claim that additional compensating controls, such as a WAF or network restrictions, had been configured or independently verified.

### 6. Verified Both Exemptions Using Azure CLI

After creating the exemptions, I used Azure CLI to check that they were recorded correctly.

I used the following command:

```powershell
az policy exemption list `
  --resource-group "rg-day65-dine-01" `
  --disable-scope-strict-match true `
  --output table
```

I repeated the command for `rg-day65-policy-lab`.

One thing I learned was that the exemptions were created at individual Storage Account scope, rather than directly at resource group scope.

Using `--disable-scope-strict-match true` allowed the resource group listing to include exemptions created at these child resource scopes.

Both exemptions appeared with their correct categories and justifications. The Mitigated exemption also displayed its expiry date.

### 7. Checked the Final Compliance Results

Finally, I checked the compliance results for both resource groups.

For the first Storage Account, Azure returned:

```text
Resource: st65diag171126a
State: Exempt
Assignment: f796804afdef5cc5ab8f3aa0
```

For the second Storage Account, Azure returned two results:

```text
Resource: stday65diagnostics

State: NonCompliant
Assignment: 7e7efdf0ad6a5a8eb3dc8cf3

State: Exempt
Assignment: pa-day67-storage-diagnostics
```

This was an important result.

The Mitigated exemption applied only to `pa-day67-storage-diagnostics`. It did not remove the NonCompliant result from the separate existing Day 65 assignment.

This confirmed that Azure Policy exemptions are linked to specific policy assignments rather than automatically excluding a resource from every policy that applies to it.

## Validation Results

| Validation | Result |
|---|---|
| Second policy assignment created | Successful |
| Managed identity configured | Successful |
| Monitoring Contributor role assigned | Successful |
| Waiver exemption created | Successful |
| Mitigated exemption created | Successful |
| Waiver justification recorded | Confirmed |
| Mitigated justification recorded | Confirmed |
| Mitigated expiry date configured | Confirmed |
| Waiver resource compliance result | Exempt |
| Mitigated resource compliance result | Exempt under Day 67 assignment |
| Assignment-specific exemption behaviour | Confirmed |

## Screenshots

The following screenshots provide evidence of the work completed and the results from my Azure environment.

| Screenshot | Description |
|---|---|
| [01-Azure-Policy-Assignments.png](screenshots/01-Azure-Policy-Assignments.png) | Existing and new Azure Policy assignments |
| [02-Waiver-Exemption.png](screenshots/02-Waiver-Exemption.png) | Waiver exemption and justification |
| [03-Mitigated-Exemption.png](screenshots/03-Mitigated-Exemption.png) | Mitigated exemption and expiry date |
| [04-Exemptions-CLI-Verification.png](screenshots/04-Exemptions-CLI-Verification.png) | Both exemptions verified using Azure CLI |
| [05-Waiver-Compliance-Exempt.png](screenshots/05-Waiver-Compliance-Exempt.png) | Waiver resource showing Exempt |
| [06-Mitigated-Compliance-Exempt.png](screenshots/06-Mitigated-Compliance-Exempt.png) | Mitigated resource showing Exempt under the Day 67 assignment |

## Lessons Learned

This exercise helped me understand how Azure Policy Exemptions can be used to manage exceptions without disabling an entire policy assignment.

The main differences I learned were:

- **Waiver:** Used when a policy requirement genuinely does not apply to a specific resource. It normally has no expiry date.
- **Mitigated:** Used for a temporary exception where the risk is being managed while the resource is brought into compliance. An expiry date helps ensure the exception is reviewed.

I also learned that exemptions are linked to individual policy assignments. A resource can therefore be Exempt under one assignment and NonCompliant under another.

Another useful lesson was the importance of documenting the reason for an exemption. In a production environment, I would link temporary exemptions to a remediation ticket, document verified compensating controls and review the exemption before its expiry date.

## Skills Demonstrated

- Azure Policy Management
- Azure Policy Exemptions
- Waiver and Mitigated Exemptions
- Azure Policy Assignments
- Azure CLI
- Windows PowerShell
- Managed Identities
- Azure RBAC
- Policy Compliance Monitoring
- Azure Governance and Compliance

## Project Outcome

I successfully created and verified two Azure Policy exemptions using Azure CLI.

The Waiver and Mitigated exemptions were both recognised by Azure, and the compliance results showed Exempt under their respective policy assignments.

This exercise gave me practical experience with managing policy exceptions and helped me understand why exemptions need to be scoped correctly, justified and reviewed.

It also showed me how Azure can maintain separate compliance results for the same resource when multiple policy assignments apply to it.