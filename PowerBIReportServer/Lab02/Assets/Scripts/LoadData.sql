SET NOCOUNT ON;
GO
DELETE [dbo].[FactResellerSales] WHERE [OrderDateKey] BETWEEN 20161201 AND 20161231;
GO
SET NOCOUNT OFF;
GO

PRINT N'Insert dbo.FactResellerSales data';
SET NOCOUNT ON;
GO
BULK INSERT [dbo].[FactResellerSales] FROM N'D:\PowerBIReportServer\Lab02\Assets\Data\ResellerSales_201612.csv'
WITH
(
	DATAFILETYPE = 'char'
	,FIRSTROW = 2
	,FIELDTERMINATOR = ','
	,ROWTERMINATOR = '\n'
	,TABLOCK
);
GO
SET NOCOUNT OFF;
GO