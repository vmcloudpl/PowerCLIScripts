#vmcloud.pl
$vCenter  = "vCenter server IP/vCenter server name"
$tableProperties = "<style>"
$tableProperties = $tableProperties + "TABLE{border-width: 1px;border-style: solid;border-color: black;}"
$tableProperties = $tableProperties + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;}"
$tableProperties = $tableProperties + "TD{text-align:center;border-width: 1px;padding: 5px;border-style: solid;border-color: black;}"
$tableProperties = $tableProperties + "</style>"
 
#Main section of check
Write-Host "Looking for snapshots"
$date = get-date
$datefile = get-date -uformat '%m-%d-%Y-%H%M%S'
$filename = "c:\temp\VMwareSnapshots_" + $datefile + ".htm"
  
#Get your list of VMs
Connect-VIServer $vCenter
$ss = Get-vm | Get-Snapshot
Write-Host "   Complete" -ForegroundColor Green
Write-Host "Generating snapshot report"
$ss | Select-Object vm, name, description, @{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}}, Created, powerstate| sort-object Created| ConvertTo-HTML -head $tableProperties -body "<th><font style = `"color:
#FFFFFF`"><big> Snapshots Report</big></font></th> <br></br> <style type=""text/css""> body{font: .8em ""Lucida Grande"", Tahoma, Arial, Helvetica, sans-serif;} ol{margin:0;padding: 0 1.5em;} table{color:#FFF;background:#1464AB;border-collapse:collapse;width:647px;border:5px solid #12548E;} thead{} thead th{padding:1em 1em .5em;border-bottom:1px dotted #FFF;font-size:120%;text-align:left;} thead tr{} td{padding:.5em 1em;} tbody tr.odd td{background:transparent url(tr_bg.png) repeat top left;} tfoot{} tfoot td{padding-bottom:1.5em;} tfoot tr{} * html tr.odd td{background:#1464AB;filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='tr_bg.png', sizingMethod='scale');} #middle{background-color:#095292;} </style> <body BGCOLOR=""#333333""> <table border=""1"" cellpadding=""5""> <table> <tbody> </tbody> </table> </body>" | Out-File $filename
Write-Host "   Complete" -ForegroundColor Green
Write-Host "Your snapshot report has been saved to:" $filename