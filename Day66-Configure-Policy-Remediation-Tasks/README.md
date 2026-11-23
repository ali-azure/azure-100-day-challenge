
# Day 66 – Configure Policy Remediation Tasks for Non-Compliant Resources

### Azure 100 Days of Cloud Challenge — Ali Aden

## Project Overview

On Day 66 of my Azure 100 Days of Cloud Challenge, I worked with Azure Policy remediation tasks to understand how existing non-compliant resources can be brought back into compliance.

I reused the custom `DeployIfNotExists` policy I created on Day 65. To test the remediation process, I temporarily removed the diagnostic setting from an existing Azure Storage Account.

After removing the setting, I triggered an Azure Policy compliance scan. Azure identified the Storage Account as non-compliant because the required diagnostic setting was missing.

I then created a remediation task using Azure CLI in Windows PowerShell. Azure Policy used the policy assignment's system-assigned managed identity to restore the missing diagnostic setting.

Finally, I ran another compliance scan and confirmed that the Storage Account had returned to a Compliant state.

## Architecture

The diagram below shows the resources involved in the remediation process and how they interact.

```text
                  AZURE SUBSCRIPTION
                          |
                          |
                  RESOURCE GROUP
                 rg-day65-dine-01
                          |
          +---------------+---------------+
          |                               |
          |                               |
     AZURE POLICY                  POLICY ASSIGNMENT
     DeployIfNotExists             pa-day65-storage-
          |                        diagnostics
          |                               |
          |                       System-assigned
          |                       Managed Identity
          |                               |
          |                       Monitoring Contributor
          |                               |
          +---------------+---------------+
                          |
                          |
                  REMEDIATION TASK
       remediate-day65-storage-diagnostics
                          |
                          |
                 COMPLIANCE EVALUATION
                          |
                  NON-COMPLIANT RESOURCE
                          |
                          |
                   AZURE STORAGE
                   st65diag171126a
                          |
                          |
                 REMEDIATION DEPLOYMENT
                          |
                          |
                  DIAGNOSTIC SETTING
             day65-storage-diagnostics-01
                          |
                          |
                LOG ANALYTICS WORKSPACE
                  law-day65-sweden-01
                          |
                          |
                 FINAL COMPLIANCE
                     COMPLIANT
```

## Implementation

### 1. Verify the Existing Policy Assignment

I started by checking the Azure Policy assignments in the existing resource group.

I confirmed that the Day 65 policy assignment was still available:

- Policy Assignment: `pa-day65-storage-diagnostics`
- Resource Group: `rg-day65-dine-01`
- Policy Effect: `DeployIfNotExists`

I also retrieved the full assignment ID, which I needed later when creating the remediation task.

### 2. Check Initial Policy Compliance

I checked Azure Policy for resources with a `NonCompliant` compliance state.

The initial query returned no non-compliant resources. This was consistent with the successful policy configuration from Day 65.

### 3. Verify the Existing Diagnostic Setting

Before making any changes, I checked the Storage Account's diagnostic settings.

I confirmed that the following configuration existed:

- Storage Account: `st65diag171126a`
- Diagnostic Setting: `day65-storage-diagnostics-01`
- Log Analytics Workspace: `law-day65-sweden-01`

This gave me a reference point for checking whether remediation successfully restored the configuration.

### 4. Verify the Managed Identity and Permissions

I inspected the policy assignment and confirmed that it used a system-assigned managed identity.

I then checked its role assignments and confirmed that it had the **Monitoring Contributor** role at the resource group scope.

This was important because the policy assignment's managed identity needed the appropriate permissions to deploy the diagnostic setting.

### 5. Create a Controlled Non-Compliant Scenario

To test remediation, I temporarily removed the existing diagnostic setting from the Storage Account.

I used the following Azure CLI command:

```powershell
az monitor diagnostic-settings delete --name "day65-storage-diagnostics-01" --resource "/subscriptions/b9a64710-a53d-4151-82f3-5451954768e2/resourceGroups/rg-day65-dine-01/providers/Microsoft.Storage/storageAccounts/st65diag171126a"
```

I then checked the diagnostic settings again and confirmed that the setting had been removed.

The Storage Account and its stored data were not deleted. Only the diagnostic configuration was temporarily removed.

### 6. Trigger a Compliance Scan

After removing the diagnostic setting, I triggered an Azure Policy compliance scan at resource group scope.

```powershell
az policy state trigger-scan --resource-group "rg-day65-dine-01"
```

I then queried Azure Policy for non-compliant resources:

```powershell
az policy state list --resource-group "rg-day65-dine-01" --filter "complianceState eq 'NonCompliant'" --query "[].{Resource:resourceId, Policy:policyDefinitionName, State:complianceState}" --output table
```

Azure identified the Storage Account as `NonCompliant`.

This confirmed that Azure Policy had detected the missing diagnostic setting.

### 7. Create the Remediation Task

Once the non-compliant resource had been identified, I created a remediation task using the existing policy assignment.

```powershell
az policy remediation create --name "remediate-day65-storage-diagnostics" --policy-assignment "/subscriptions/b9a64710-a53d-4151-82f3-5451954768e2/resourceGroups/rg-day65-dine-01/providers/Microsoft.Authorization/policyAssignments/f796804afdef5cc5ab8f3aa0" --resource-group "rg-day65-dine-01"
```

Azure accepted the remediation task and started processing the existing non-compliant resource.

### 8. Monitor the Remediation Task

I used the following command to check the remediation task:

```powershell
az policy remediation show --name "remediate-day65-storage-diagnostics" --resource-group "rg-day65-dine-01" --output json
```

The results confirmed that the remediation had completed successfully.

| Property | Result |
|---|---|
| Provisioning State | Succeeded |
| Total Deployments | 1 |
| Successful Deployments | 1 |
| Failed Deployments | 0 |
| Discovery Mode | ExistingNonCompliant |

Azure successfully completed one deployment without any failures.

### 9. Verify the Restored Diagnostic Setting

After the remediation task succeeded, I checked the Storage Account's diagnostic settings again.

I confirmed that Azure Policy had restored:

`day65-storage-diagnostics-01`

The diagnostic setting was connected to the original Log Analytics Workspace:

`law-day65-sweden-01`

This confirmed that the remediation deployment had restored the missing configuration.

### 10. Perform Final Compliance Validation

After confirming that the diagnostic setting had been restored, I triggered another Azure Policy compliance scan.

```powershell
az policy state trigger-scan --resource-group "rg-day65-dine-01"
```

I then checked the compliance state for the policy definition:

```powershell
az policy state list --resource-group "rg-day65-dine-01" --filter "policyDefinitionName eq 'dd1649a3bab95ee7b1cf4ba4'" --query "[].{Resource:resourceId, State:complianceState, Policy:policyDefinitionName}" --output table
```

The final result showed:

**Compliant**

This confirmed that the Storage Account had returned to compliance after the remediation task.

## Validation Results

| Validation | Expected Result | Actual Result |
|---|---|---|
| Initial compliance check | No non-compliant resources | Confirmed |
| Controlled test | Storage Account becomes NonCompliant | Confirmed |
| Remediation task | Successfully created | Accepted |
| Remediation deployment | Successful | 1 successful deployment |
| Failed deployments | 0 | 0 |
| Diagnostic setting | Restored | Confirmed |
| Final compliance | Compliant | Compliant |

## Screenshots

The following screenshots show the steps I completed and the results from the Azure environment.

| Screenshot | Description |
|---|---|
| 01-Azure-Environment.png | Existing Azure resources and resource group |
| 02-Policy-Assignment.png | Day 65 Azure Policy assignment |
| 03-Initial-Compliance.png | Initial policy compliance check |
| 04-Diagnostic-Setting-Before-Remediation.png | Original diagnostic setting |
| 05-Diagnostic-Setting-Removed.png | Diagnostic setting temporarily removed |
| 06-Initial-NonCompliance.png | Storage Account identified as NonCompliant |
| 07-Remediation-Task-Created.png | Remediation task creation |
| 08-Remediation-Succeeded.png | Successful remediation results |
| 09-Diagnostic-Setting-Restored.png | Diagnostic setting restored |
| 10-Final-Compliance.png | Final Compliant policy result |

## Lessons Learned

During this lab, I learned:

- How Azure Policy identifies existing non-compliant resources.
- Why existing resources may need a separate remediation task.
- How to trigger an Azure Policy compliance scan.
- How to create remediation tasks using Azure CLI.
- How system-assigned managed identities are used during remediation.
- Why the correct RBAC permissions are important.
- How to monitor remediation deployment results.
- How to check whether a resource has returned to compliance.

## Skills Demonstrated

- Microsoft Azure
- Azure Policy
- DeployIfNotExists
- Azure Policy Remediation
- Azure CLI
- Windows PowerShell
- Microsoft Entra ID
- Managed Identities
- Azure Role-Based Access Control (RBAC)
- Azure Monitor
- Diagnostic Settings
- Log Analytics
- Cloud Compliance Management

## Project Outcome

I successfully completed the Azure Policy remediation exercise using the existing Day 65 infrastructure.

I created a controlled non-compliant scenario, identified the affected Storage Account and used an Azure Policy remediation task to restore the missing diagnostic setting.

The remediation completed with **1 successful deployment and 0 failed deployments**.

The final compliance scan confirmed that the Storage Account was Compliant again.

This lab gave me practical experience with Azure Policy remediation, managed identities, RBAC permissions and compliance monitoring.
