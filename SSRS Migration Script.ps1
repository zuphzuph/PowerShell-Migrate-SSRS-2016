#Ensure you're created the report path and placed reports to remap within that directory.
#Tool here for moving: https://code.google.com/archive/p/reportsync/
#Ensure you've created the DataSource used and have a valid connection string to your DB within it.
#Set variables:
$reportserver = "hostname";
$url = "https://($reportserver)/reportserver/ReportService2010.asmx?wsdl";
$newDataSourceName = "/ClientDir/dsHERE";
$reportFolderPath = "/ClientDir/Reports/DirContainingReports";
#------------------------------------------------------------------------
$ssrs = New-WebServiceProxy -uri $url -UseDefaultCredential
$reports = $ssrs.ListChildren($reportFolderPath, $false)
$reports | ForEach-Object {
$reportPath = $_.path
Write-Host "Report: " $reportPath
$dataSources = $ssrs.GetItemDataSources($reportPath)
$dataSources | ForEach-Object {
$proxyNamespace = $_.GetType().Namespace
$myDataSource = New-Object ("$proxyNamespace.DataSource")
$myDataSource.Name = $newDataSourceName
$myDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
$myDataSource.Item.Reference = $newDataSourceName
$_.item = $myDataSource.Item
$ssrs.SetItemDataSources($reportPath, $_)
Write-Host "Report's DataSource Reference ($($_.Name)): $($_.Item.Reference)";
}
Write-Host "------------------------"
}
