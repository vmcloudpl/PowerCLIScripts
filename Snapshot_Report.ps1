# vmcloud.pl
# Connect to vCenter Server
Connect-VIServer <vCenter_IP>

# Get all VMs
$VMs = Get-VM

# Create empty array to hold snapshot information
$SnapshotInfo = @()

# Loop through each VM and get snapshot information
foreach ($VM in $VMs) {
    $Snapshots = Get-Snapshot -VM $VM

    # Loop through each snapshot and add information to array
    foreach ($Snapshot in $Snapshots) {
        $SnapshotInfo += [PSCustomObject]@{
            VMName = $VM.Name
            SnapshotName = $Snapshot.Name
            Created = $Snapshot.Created
            Description = $Snapshot.Description
            SizeGB = [math]::Round(($Snapshot.SizeGB),2)
        }
    }
}

# Create HTML output
$HTML = @"
<html>
<head>
<title>Snapshots Report</title>
<style>
    body {background-color: #D3D3D3;}
    table {border: 3px solid black; border-collapse: collapse; font-size: 14px; font-family: Arial, sans-serif; background-color: #3B3B3B; color: white; max-width: 800px;}
    th, td {border: 2px solid black; padding: 10px; text-align: left; width: auto;}
    th {background-color: #2F4F4F; font-weight: bold;}
</style>
</head>
<body>
"@
$HTML += $SnapshotInfo | ConvertTo-Html -Fragment -Property VMName, SnapshotName, Created, Description, SizeGB
$HTML += @"
</body>
</html>
"@

# Output HTML to file
$FilePath = "C:\temp\SnapshotInfo.html"
$HTML | Out-File -FilePath $FilePath

# Output confirmation message
Write-Host "Generating Snapshots Report"
Write-Host "Your snapshots report has been saved to: $FilePath"

# Disconnect from vCenter Server
Disconnect-VIServer -Confirm:$false
