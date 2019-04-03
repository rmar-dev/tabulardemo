USE [AdventureWorksDW2016];
GO

--Purpose: Retrieves KPI value, goal and status metrics for a given fiscal year
CREATE PROCEDURE [dbo].[uspKpi_ResellerSales]
	@FiscalYear INT
AS
	SET NOCOUNT ON;

	WITH [SalesValues] AS
	(
		SELECT
			[d].[FiscalYear]
			,SUM([rs].[SalesAmount]) AS [Sales]
			,(LAG(SUM([rs].[SalesAmount]), 1, 0) OVER (ORDER BY [d].[FiscalYear]) * 1.15) AS [Target] --Must achieve 15% more than the previous year
		FROM
			[dbo].[FactResellerSales] AS [rs]
			INNER JOIN [dbo].[DimDate] AS [d]
				ON [d].[DateKey] = [rs].[OrderDateKey]
		WHERE
			[d].[FiscalYear] IN ((@FiscalYear - 1), @FiscalYear)
		GROUP BY
			[d].[FiscalYear]
	),
	[KpiValues] AS
	(
		SELECT
			[FiscalYear]
			,[Sales]
			,[Target]
			,CASE
				WHEN ISNULL([Target], 0) = 0 THEN NULL
				ELSE ([Sales] - [Target]) / [Target]
			END AS [Variance]
		FROM
			[SalesValues]
	)
	SELECT
		[Sales]
		,[Target]
		,CASE
			WHEN [Variance] IS NULL THEN NULL
			WHEN [Variance] >= 0 THEN 1         --On-track
			WHEN [Variance] >= -0.1 THEN 0      --Slightly off-track
			ELSE -1                             --Off-track
		END AS [Status]
	FROM
		[KpiValues]
	WHERE
		[FiscalYear] = @FiscalYear;
GO

--Purpose: Retrieves KPI trend values (consisting of monthly sales) for a given fiscal year
CREATE PROCEDURE [dbo].[uspKpi_ResellerSales_Trend]
	@FiscalYear INT
AS
	SET NOCOUNT ON;

	SELECT
		ISNULL(SUM([rs].[SalesAmount]), 0) AS [Sales]
	FROM
		[dbo].[DimDate] AS [d]
		LEFT JOIN [dbo].[FactResellerSales] AS [rs]
			ON [rs].[OrderDateKey] = [d].[DateKey]
	WHERE
		[d].[FiscalYear] = @FiscalYear
	GROUP BY
		(([d].[CalendarYear] * 100) + [d].[MonthNumberOfYear])
	ORDER BY
		(([d].[CalendarYear] * 100) + [d].[MonthNumberOfYear]);
GO

/* TEST

EXEC [dbo].[uspKpi_ResellerSales]
	@FiscalYear = 2012;

EXEC [dbo].[uspKpi_ResellerSales_Trend]
	@FiscalYear = 2012;

EXEC [dbo].[uspKpi_ResellerSales]
	@FiscalYear = 2013;

EXEC [dbo].[uspKpi_ResellerSales_Trend]
	@FiscalYear = 2013;

*/
