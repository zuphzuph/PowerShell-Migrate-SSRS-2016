#Set variables:
$reportserver = "DNS/IP";
$url = "http://($reportserver)/reportserver/ReportService2010.asmx?wsdl";
$newDataSourcePath = "ClientName";
$newDataSourceName = "/ClientDir/dsHERE";
$reportFolderPath = "/ClientDir/Dir";
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
