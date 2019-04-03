SELECT
	CONCAT(N'CY', FORMAT([rs].[OrderDate], N'yyyy')) AS [Year]
	,CONCAT(N'M', FORMAT([rs].[OrderDate], N'MM')) AS [Month]
	,[g].[StateProvinceName] AS [State]
	,SUM([rs].[OrderQuantity]) AS [Quantity]
	,SUM([rs].[SalesAmount]) AS [Sales]
FROM
	[dbo].[FactResellerSales] AS [rs]
	INNER JOIN [dbo].[DimProduct] AS [p] ON [p].[ProductKey] = [rs].[ProductKey]
	INNER JOIN [dbo].[DimReseller] AS [r] ON [r].[ResellerKey] = [rs].[ResellerKey]
	INNER JOIN [dbo].[DimGeography] AS [g] ON [g].[GeographyKey] = [r].[GeographyKey]
WHERE
	[g].[CountryRegionCode] = N'US'
GROUP BY
	CONCAT(N'CY', FORMAT([rs].[OrderDate], N'yyyy'))
	,CONCAT(N'M', FORMAT([rs].[OrderDate], N'MM'))
	,[g].[StateProvinceName]
ORDER BY
	[Year] DESC
	,[Month] ASC;
