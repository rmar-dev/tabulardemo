Invoke-ASCmd -Server SQLSERVER2017\TABULAR -InputFile "D:\PowerBIReportServer\Lab01\Assets\Scripts\DeleteSalesAnalysis.xmla"
write-host "Press any key to continue..."
[void][System.Console]::ReadKey($true)
