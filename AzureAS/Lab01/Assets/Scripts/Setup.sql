IF EXISTS(SELECT * FROM [sys].[databases] WHERE [name] = N'AdventureWorksDW2016-Lite')
BEGIN
	PRINT N'Update AdventureWorksDW2016-Lite database';
END
ELSE
BEGIN
	PRINT N'Create AdventureWorksDW2016-Lite database';
	CREATE DATABASE [AdventureWorksDW2016-Lite];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimProductCategory')
BEGIN
	PRINT N'Drop dbo.DimProductCategory table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_DimProductSubcategory_ProductCategoryKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory]
			DROP CONSTRAINT [FK_dbo_DimProductSubcategory_ProductCategoryKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductCategory];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimProductSubcategory')
BEGIN
	PRINT N'Drop dbo.DimProductSubcategory table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_DimProduct_ProductSubcategoryKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProduct]
			DROP CONSTRAINT [FK_dbo_DimProduct_ProductSubcategoryKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory];
END;
GO
	
IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimProduct')
BEGIN
	PRINT N'Drop dbo.DimProduct table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_FactResellerSales_ProductKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]
			DROP CONSTRAINT [FK_dbo_FactResellerSales_ProductKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProduct];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimGeography')
BEGIN
	PRINT N'Drop dbo.DimGeography table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_DimReseller_GeographyKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimReseller]
			DROP CONSTRAINT [FK_dbo_DimReseller_GeographyKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimGeography];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimReseller')
BEGIN
	PRINT N'Drop dbo.DimReseller table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_FactResellerSales_ResellerKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]
			DROP CONSTRAINT [FK_dbo_FactResellerSales_ResellerKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimReseller];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'DimDate')
BEGIN
	PRINT N'Drop dbo.DimDate table';
	IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[foreign_keys] WHERE [name] = N'FK_dbo_FactResellerSales_OrderDateKey')
	BEGIN
		ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]
			DROP CONSTRAINT [FK_dbo_FactResellerSales_OrderDateKey];
	END;

	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[DimDate];
END;
GO

IF EXISTS(SELECT * FROM [AdventureWorksDW2016-Lite].[sys].[tables] WHERE [name] = N'FactResellerSales')
BEGIN
	PRINT N'Drop dbo.FactResellerSales table';
	DROP TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales];
END;
GO

SET NOCOUNT ON;
GO

PRINT N'Create dbo.FactResellerSales table';
SELECT [ProductKey], [OrderDateKey], [ResellerKey], [OrderQuantity], [UnitPrice], [TotalProductCost]
INTO [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]
FROM [AdventureWorksDW2016].[dbo].[FactResellerSales]
WHERE CAST(RIGHT([SalesOrderNumber], 5) AS INT) % 3 = 0; --Import about every third row
GO

PRINT N'Create dbo.DimDate table';
SELECT [DateKey], [FullDateAlternateKey]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimDate]
FROM [AdventureWorksDW2016].[dbo].[DimDate]
WHERE
	[CalendarYear] >= (SELECT [CalendarYear] FROM [AdventureWorksDW2016].[dbo].[DimDate] WHERE [DateKey] = (SELECT MIN([OrderDateKey]) FROM [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]))
	AND [CalendarYear] <= (SELECT [CalendarYear] FROM [AdventureWorksDW2016].[dbo].[DimDate] WHERE [DateKey] = (SELECT MAX([OrderDateKey]) FROM [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]));
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimDate] ADD CONSTRAINT [UQ_dbo_DimDate] UNIQUE ([DateKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales] ADD CONSTRAINT [FK_dbo_FactResellerSales_OrderDateKey] FOREIGN KEY ([OrderDateKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimDate]([DateKey]);
GO

PRINT N'Create dbo.DimReseller table';
SELECT [ResellerKey], [GeographyKey], [BusinessType], [ResellerName]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimReseller]
FROM [AdventureWorksDW2016].[dbo].[DimReseller]
WHERE [ResellerKey] IN (SELECT [ResellerKey] FROM [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimReseller] ADD CONSTRAINT [UQ_dbo_DimReseller] UNIQUE ([ResellerKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales] ADD CONSTRAINT [FK_dbo_FactResellerSales_ResellerKey] FOREIGN KEY ([ResellerKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimReseller]([ResellerKey]);
GO

PRINT N'Create dbo.DimGeography table';
SELECT [GeographyKey], [EnglishCountryRegionName], [StateProvinceName], [City]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimGeography]
FROM [AdventureWorksDW2016].[dbo].[DimGeography];
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimGeography] ADD CONSTRAINT [UQ_dbo_DimGeography] UNIQUE ([GeographyKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimReseller] ADD CONSTRAINT [FK_dbo_DimReseller_GeographyKey] FOREIGN KEY ([GeographyKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimGeography]([GeographyKey]);
GO

PRINT N'Create dbo.DimProduct table';
SELECT [ProductKey], [ProductSubcategoryKey], [EnglishProductName], [Color]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimProduct]
FROM [AdventureWorksDW2016].[dbo].[DimProduct]
WHERE [ProductKey] IN (SELECT [ProductKey] FROM [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProduct] ADD CONSTRAINT [UQ_dbo_DimProduct] UNIQUE ([ProductKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[FactResellerSales] ADD CONSTRAINT [FK_dbo_FactResellerSales_ProductKey] FOREIGN KEY ([ProductKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimProduct]([ProductKey]);
GO

PRINT N'Create dbo.DimProductSubcategory table';
SELECT [ProductSubcategoryKey], [ProductCategoryKey], [EnglishProductSubcategoryName]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory]
FROM [AdventureWorksDW2016].[dbo].[DimProductSubcategory]
WHERE [ProductSubcategoryKey] IN (SELECT [ProductSubcategoryKey] FROM [AdventureWorksDW2016-Lite].[dbo].[DimProduct]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory] ADD CONSTRAINT [UQ_dbo_DimProductSubcategory] UNIQUE ([ProductSubcategoryKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProduct] ADD CONSTRAINT [FK_dbo_DimProduct_ProductSubcategoryKey] FOREIGN KEY ([ProductSubcategoryKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory]([ProductSubcategoryKey]);
GO

PRINT N'Create dbo.DimProductCategory table';
SELECT [ProductCategoryKey], [EnglishProductCategoryName]
INTO [AdventureWorksDW2016-Lite].[dbo].[DimProductCategory]
FROM [AdventureWorksDW2016].[dbo].[DimProductCategory]
WHERE [ProductCategoryKey] IN (SELECT [ProductCategoryKey] FROM [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductCategory] ADD CONSTRAINT [UQ_dbo_DimProductCategory] UNIQUE ([ProductCategoryKey]);
GO

ALTER TABLE [AdventureWorksDW2016-Lite].[dbo].[DimProductSubcategory] ADD CONSTRAINT [FK_dbo_DimProductSubcategory_ProductCategoryKey] FOREIGN KEY ([ProductCategoryKey]) REFERENCES [AdventureWorksDW2016-Lite].[dbo].[DimProductCategory]([ProductCategoryKey]);
GO

SET NOCOUNT OFF;
GO