# vmcloud.pl
# Connect to vCenter
Connect-VIServer -Server <vCenter_IP>

# Get all VMs in vCenter
$allVMs = Get-VM

# Store VM information
$vmInfo = @()

# Loop through each VM and retrieve its information
foreach ($vm in $allVMs) {
    $vmHost = Get-VMHost -VM $vm
    $vmDisk = $vm | Get-HardDisk
    $vmInfo += [PSCustomObject] @{
        Name = $vm.Name
        PowerState = $vm.PowerState
        NumCPU = $vm.NumCpu
        MemoryMB = $vm.MemoryMB
        GuestOS = $vm.Guest.OSFullName
        IPAddress = ($vm.Guest.IPAddress)[0]
        Cluster = ($vm | Get-Cluster).Name
        Datastore = ($vm | Get-Datastore).Name
        Host = $vmHost.Name
        ProvisionedSpaceGB = [Math]::Round(((($vmDisk.CapacityGB | Measure-Object -Sum).Sum)),2)
    }
}

# Export VM information to a CSV file
$vmInfo | Export-Csv -Path "C:\temp\VM_Info.csv" -NoTypeInformation

# Display a message to confirm that the report has been saved
Write-Host "Report saved to C:\temp\VM_Info.csv"