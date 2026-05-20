# 📘 Day 10 — Automated Resource Group Tagging with PowerShell

**Azure 100 Days of Cloud Challenge — Ali Aden**

---

## 📌 Overview  
Today I automated Azure Resource Group tagging using PowerShell to enforce consistent governance across the subscription.  
This ensures standardised metadata, improves cost tracking, and removes manual tagging errors.

This workflow uses PowerShell to interact with Azure Resource Manager (ARM) and apply governance tags programmatically at scale.

---

## 🛠 Tools Used  
- Azure Portal  
- Azure Cloud Shell  
- PowerShell (Az Module)  
- Azure Resource Manager (ARM)  
- Azure Tagging & Governance features  

---

## 🧩 Steps Completed  
This setup simulates a real-world governance automation scenario used by cloud engineers.

### 1. List All Resource Groups  
Retrieved all RGs in the subscription to identify missing or inconsistent tags.

### 2. Define Standard Tag Set  
Created a reusable tag dictionary:
- Environment  
- Owner  
- CostCenter  
- CreatedBy  

### 3. Build the Automation Script  
Developed a PowerShell loop to detect untagged RGs and apply standard tags.

### 4. Execute the Script  
Ran the script to automatically tag all untagged resource groups.

### 5. Verify Tags via PowerShell  
Confirmed tags were applied using `Format-List`.

### 6. Validate Governance Rule  
Filtered RGs by `CostCenter` tag to ensure compliance.

### 7. Confirm in Azure Portal  
Validated tagging visually using the Resource Groups view.

---

## 🔄 Before & After  

### Before  
- No standardised tagging  
- Limited cost visibility  
- Governance gaps across resources  
- Manual tagging required  

### After  
- All RGs tagged automatically  
- Consistent governance enforced  
- Standard metadata applied across environment  
- Zero manual tagging effort  

---

## ✅ Validation  

- Script detected untagged RGs correctly  
- Tags applied using `Update-AzTag -Operation Merge`  
- Verified via PowerShell output  
- Confirmed in Azure Portal  
- Governance filter (`CostCenter`) validated  

---

## 🧠 Skills Demonstrated  
- PowerShell automation  
- Azure Resource Manager operations  
- Governance and tagging strategy  
- Cloud Shell scripting  
- Subscription-wide resource auditing  
- Infrastructure standardisation  

---

## 🛠 Troubleshooting  

### Missing Tags Property  
Some RGs returned `$null` for `.Tags`.  
**Fix:** Added conditional check: `$null -eq $rg.Tags`.

### Portal Not Showing Tags  
Tags column was hidden by default.  
**Fix:** Enabled via *Manage View → Edit Columns*.

---

## 🔐 Why This Matters  

- Enables cost allocation and reporting  
- Improves ownership visibility  
- Supports automation and policy enforcement  
- Standardises resource metadata  
- Scales governance across environments  

Automated tagging is a foundational practice for maintaining control in large Azure environments.

---

## ⚠️ Risk Considerations  

- Missing tags reduce visibility into ownership and cost allocation  
- Inconsistent tagging breaks automation and governance policies  
- Incorrect tag values can lead to reporting inaccuracies  
- Lack of tagging standards makes environments difficult to manage at scale  

---

## 🧠 What I Learned  
Automated tagging enables consistent governance and eliminates manual errors.  
Understanding how Azure stores and merges tags is critical for maintaining accurate metadata.  
Tagging strategies play a key role in cost management, automation, and operational control.

---

## 🔄 Next Steps / Automation  

- Enforce mandatory tags using Azure Policy  
- Schedule tagging scripts using Azure Automation  
- Integrate tag data into cost management dashboards  
- Apply tagging at resource creation using IaC (Bicep/Terraform)  

---

## 📸 Screenshots  

(Insert your screenshots here following your naming pattern)

---

## 💻 Commands Used  

### List Resource Groups
```powershell
Get-AzResourceGroup
```

### Define Standard Tags
```powershell
$standardTags = @{
    Environment = "Learning"
    Owner       = "Ali"
    CostCenter  = "Training"
    CreatedBy   = "PowerShell-Automation"
}
```

### Automation Script
```powershell
$resourceGroups = Get-AzResourceGroup

foreach ($rg in $resourceGroups) {
    if ($null -eq $rg.Tags -or $rg.Tags.Count -eq 0) {
        Write-Host "Tagging: $($rg.ResourceGroupName)" -ForegroundColor Yellow
        Update-AzTag -ResourceId $rg.ResourceId -Tag $standardTags -Operation Merge
        Write-Host "Done!" -ForegroundColor Green
    }
    else {
        Write-Host "Skipping: $($rg.ResourceGroupName) — already has tags" -ForegroundColor Cyan
    }
}
```

### Validation
```powershell
Get-AzResourceGroup | Where-Object { $_.Tags.ContainsKey('CostCenter') }
```

---

## 📄 Sample Output (Sanitised)

```text
ResourceGroupName : rg-rbac-practice
Tags :
    CreatedBy    PowerShell-Automation
    CostCenter   Training
    Owner        Ali
    Environment  Learning
```

---

## 🎯 Key Takeaway  
Automation transforms governance from a manual task into a scalable, consistent, and reliable cloud practice.
