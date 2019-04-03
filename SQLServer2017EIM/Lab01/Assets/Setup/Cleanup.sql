--Drop the table if it exists
IF EXISTS(SELECT * FROM [sys].[tables] WHERE [name] = N'FactResellerSalesQuota')
BEGIN
	PRINT N'Drop the AdventureWorksDW2016.dbo.FactResellerSalesQuota table';
	DROP TABLE [dbo].[FactResellerSalesQuota];
END;
GO

--Drop the proc if it exists
PRINT N'Drop the AdventureWorksDW2016.dbo.uspFactResellerSalesQuotaDelete proc';
GO
IF EXISTS(SELECT * FROM [sys].[procedures] WHERE [name] = N'uspFactResellerSalesQuotaDelete')
BEGIN
	DROP PROC [dbo].[uspFactResellerSalesQuotaDelete];
END;

--Restore the date table back to original rows
PRINT N'Delete the AdventureWorksDW2016.dbo.DimDate records';
GO
SET NOCOUNT ON;
GO
DELETE [dbo].[DimDate] WHERE [DateKey] > 20141231;
GO
SET NOCOUNT OFF;
GO