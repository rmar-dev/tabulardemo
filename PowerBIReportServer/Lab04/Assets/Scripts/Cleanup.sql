PRINT N'Deleting the dbo.vCorporateDate view';
IF EXISTS (SELECT * FROM [sys].[views] WHERE [schema_id] = 1 AND [name] = N'vCorporateDate')
	DROP VIEW [dbo].[vCorporateDate];
GO

PRINT N'Deleting the dbo.vReportSalespersonSummary view';
IF EXISTS (SELECT * FROM [sys].[views] WHERE [schema_id] = 1 AND [name] = N'vReportSalespersonSummary')
	DROP VIEW [dbo].[vReportSalespersonSummary];
GO

PRINT N'Deleting the dbo.vReportSalespersonDetail view';
IF EXISTS (SELECT * FROM [sys].[views] WHERE [schema_id] = 1 AND [name] = N'vReportSalespersonDetail')
	DROP VIEW [dbo].[vReportSalespersonDetail];
GO