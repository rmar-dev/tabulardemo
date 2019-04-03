USE [AdventureWorksDW2016];
GO
CREATE PROC [dbo].[uspFactResellerSalesQuotaDelete]
	@FiscalYear INT
AS
	SET NOCOUNT ON;

	DELETE
		[frsq]
	FROM
		[dbo].[FactResellerSalesQuota] AS [frsq]
		JOIN [dbo].[DimDate] AS [d]
			ON [d].[DateKey] = [frsq].[DateKey]
	WHERE
		[d].[FiscalYear] = @FiscalYear;
GO
