#Set variables:
#Change the config mgr Report server name.
$reportserver = "Server Name (DNS or IP)";
$url = "http://$($reportserver)/reportserver/ReportService2010.asmx?wsdl";
#Provide new data source path, you need to replace this with correct one from your SSRS report.
$newDataSourcePath = "Directory Where DS Exists"
#Provide new data source name which is part of above source path.
$newDataSourceName = "Full Path to DS";
#Provide report folder path that contains reports to change the data source.
$reportFolderPath = "/Path to Reports"
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
