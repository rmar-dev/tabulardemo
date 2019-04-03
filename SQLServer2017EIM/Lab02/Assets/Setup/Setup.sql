PRINT N'Update an AdventureWorksDW2016.dbo.DimGeography.SalesTerritoryKey value';
GO
SET NOCOUNT ON;
GO
UPDATE
	[dbo].[DimGeography]
SET
	[SalesTerritoryKey] = 2
WHERE
	[StateProvinceCode] = N'WA'
	AND [SalesTerritoryKey] = 1;
GO

PRINT N'Update AdventureWorksDW2016.dbo.DimGeography.IpAddressLocator values';
GO
UPDATE
	[dbo].[DimGeography]
SET
	[IpAddressLocator] = N'198.51.100.366'
WHERE
	[City] = N'Melbourne';
GO

UPDATE
	[dbo].[DimGeography]
SET
	[IpAddressLocator] = N'192.0.2.1077'
WHERE
	[City] = N'San Francisco';
GO
SET NOCOUNT OFF;
GO