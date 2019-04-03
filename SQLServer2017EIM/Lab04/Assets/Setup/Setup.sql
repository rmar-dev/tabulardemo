IF NOT EXISTS(SELECT * FROM [master].[sys].[databases] WHERE [name] = N'Lab-DQS')
BEGIN
	PRINT N'Create Lab-DQS database';
	CREATE DATABASE [Lab-DQS];
END;
GO

--Create the DimOffice table
IF NOT EXISTS(SELECT * FROM [Lab-DQS].[sys].[tables] WHERE [name] = N'DimOffice')
BEGIN
	PRINT N'Create dbo.DimOffice table';
	CREATE TABLE [Lab-DQS].[dbo].[DimOffice]
	(
		[OfficeKey] INT IDENTITY(1, 1) PRIMARY KEY
		,[Office] NVARCHAR(100) NOT NULL
		,[District] NVARCHAR(100) NOT NULL
		,[Address1] NVARCHAR(100) NOT NULL
		,[Address2] NVARCHAR(100) NULL
		,[City] NVARCHAR(50) NOT NULL
		,[StateOrProvince] NVARCHAR(50) NOT NULL
		,[PostalCode] NVARCHAR(50) NOT NULL
		,[Country] NVARCHAR(50) NOT NULL
		,[Phone] NVARCHAR(50) NOT NULL
		,[ManagerFirstName] NVARCHAR(50) NOT NULL
		,[ManagerLastName] NVARCHAR(50) NOT NULL
		,[ManagerTitle] NVARCHAR(50) NOT NULL
		,[ManagerEmail] NVARCHAR(100) NOT NULL
	);
END;
GO

--Import DimOffice records
PRINT N'Insert dbo.DimOffice data';
SET NOCOUNT ON;
GO
BULK INSERT [Lab-DQS].[dbo].[DimOffice] FROM N'D:\SQLServer2017EIM\Lab04\Assets\Setup\DimOffice.txt'
WITH
(
	DATAFILETYPE = 'widechar'
	,FIRSTROW = 2
	,FIELDTERMINATOR = '\t'
	,ROWTERMINATOR = '\n'
	,TABLOCK
	,KEEPIDENTITY
);
GO
SET NOCOUNT OFF;
GO