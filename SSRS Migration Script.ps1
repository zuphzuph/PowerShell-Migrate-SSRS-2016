﻿#Set variables:
#Change the Configmgr Report server name
$reportserver = "Server Name (DNS or IP)";
$url = "http://$($reportserver)/reportserver/ReportService2010.asmx?wsdl";
#Provide New Data source Path ,you need to replace this with correct one from your SSRS report
$newDataSourcePath = "Directory Where DS Exists"
#Provide new Data source Name which is part of above source path
$newDataSourceName = "Full Path to DS";
# provide Report folder path that contains reports to change the Data source.
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
