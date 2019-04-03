PRINT N'Restore AdventureWorksDW2016.dbo.DimGeography records';
GO
SET NOCOUNT ON;
GO
UPDATE
	[dbo].[DimGeography]
SET
	[IpAddressLocator] = N'198.51.100.366'
WHERE
	[GeographyKey] = 35;
GO

UPDATE
	[dbo].[DimGeography]
SET
	[IpAddressLocator] = N'192.0.2.1077'
WHERE
	[GeographyKey] = 360;
GO

UPDATE
	[dbo].[DimGeography]
SET
	[SalesTerritoryKey] = 2
WHERE
	[StateProvinceCode] = N'WA'
	AND [SalesTerritoryKey] = 1;
GO
SET NOCOUNT OFF;
GO