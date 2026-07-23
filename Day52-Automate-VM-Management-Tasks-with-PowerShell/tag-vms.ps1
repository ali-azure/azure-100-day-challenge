# Variables
$ResourceGroup = "rg-azure-100-days"
$VMName = "vm-automation-lab"

# Tags
$Tags = @{
    Environment = "Lab"
    Project = "Azure100Days"
    Owner = "Ali"
}

# Get the Virtual Machine
$VM = Get-AzVM `
    -ResourceGroupName $ResourceGroup `
    -Name $VMName

# Apply the tags to the VM
Update-AzTag `
    -ResourceId $VM.Id `
    -Tag $Tags `
    -Operation Merge

Write-Host "Tags have been applied successfully to VM '$VMName'."