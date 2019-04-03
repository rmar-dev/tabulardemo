IF NOT EXISTS(SELECT * FROM [master].[sys].[databases] WHERE [name] = N'Lab-DQS')
BEGIN
	PRINT N'Create Lab-DQS database';
	CREATE DATABASE [Lab-DQS];
END;
GO

--Create the table if it doesn't exist, otherwise truncate the table data
SET NOCOUNT ON;
GO
IF NOT EXISTS(SELECT * FROM [Lab-DQS].[sys].[tables] WHERE [name] = N'MSFTOffice_NorthAmerica')
BEGIN
	PRINT N'Create dbo.MSFTOffice_NorthAmerica table';
	CREATE TABLE [Lab-DQS].[dbo].[MSFTOffice_NorthAmerica]
	(
		[Office] NVARCHAR(100) NULL
		,[District] NVARCHAR(100) NULL
		,[Address1] NVARCHAR(100) NULL
		,[Address2] NVARCHAR(100) NULL
		,[City] NVARCHAR(50) NULL
		,[StateOrProvince] NVARCHAR(50) NULL
		,[PostalCode] NVARCHAR(50) NULL
		,[Country] NVARCHAR(50) NULL
		,[Phone] NVARCHAR(50) NULL
		,[ManagerFirstName] NVARCHAR(50) NULL
		,[ManagerLastName] NVARCHAR(50) NULL
		,[ManagerTitle] NVARCHAR(50) NULL
		,[ManagerEmail] NVARCHAR(100) NULL
	);
END;
ELSE
BEGIN
	--Delete any existing data
	PRINT N'Truncate dbo.MSFTOffice_NorthAmerica table';
	TRUNCATE TABLE [Lab-DQS].[dbo].[MSFTOffice_NorthAmerica];
END;

IF NOT EXISTS(SELECT * FROM [Lab-DQS].[sys].[tables] WHERE [name] = N'Reference_CA_ProvinceOrTerritoryCode')
BEGIN
	PRINT N'Create dbo.Reference_CA_ProvinceOrTerritoryCode table';
	CREATE TABLE [Lab-DQS].[dbo].[Reference_CA_ProvinceOrTerritoryCode]
	(
		[ProvinceOrTerritoryCode] NCHAR(2) NOT NULL
	);
END;
ELSE
BEGIN
	--Delete any existing data
	PRINT N'Truncate dbo.Reference_CA_ProvinceOrTerritoryCode table';
	TRUNCATE TABLE [Lab-DQS].[dbo].[Reference_CA_ProvinceOrTerritoryCode];
END;
GO
SET NOCOUNT OFF;
GO

IF NOT EXISTS(SELECT * FROM [Lab-DQS].[sys].[tables] WHERE [name] = N'Reference_US_StateCode')
BEGIN
	PRINT N'Create dbo.Reference_US_StateCode table';
	CREATE TABLE [Lab-DQS].[dbo].[Reference_US_StateCode]
	(
		[StateCode] NCHAR(2) NOT NULL
	);
END;
ELSE
BEGIN
	--Delete any existing data
	PRINT N'Truncate dbo.Reference_US_StateCode table';
	TRUNCATE TABLE [Lab-DQS].[dbo].[Reference_US_StateCode];
END;
GO
SET NOCOUNT OFF;
GO

--Import the North America Microsoft office records
PRINT N'Insert dbo.MSFTOffice_NorthAmerica data';
SET NOCOUNT ON;
GO
BULK INSERT [Lab-DQS].[dbo].[MSFTOffice_NorthAmerica] FROM N'D:\SQLServer2017EIM\Lab03\Assets\Setup\MSFTOffice_NorthAmerica.txt'
WITH
(
	DATAFILETYPE = 'widechar'
	,FIRSTROW = 2
	,FIELDTERMINATOR = '\t'
	,ROWTERMINATOR = '\n'
	,TABLOCK
);
GO
SET NOCOUNT OFF;
GO

--Import Canadian province and territory codes
PRINT N'Insert dbo.Reference_CA_ProvinceOrTerritoryCode data';
SET NOCOUNT ON;
GO
INSERT [Lab-DQS].[dbo].[Reference_CA_ProvinceOrTerritoryCode] VALUES (N'AB'), (N'BC'), (N'MB'), (N'NB'), (N'NL'), (N'NT'), (N'NS'), (N'NU'), (N'ON'), (N'PE'), (N'QC'), (N'SK'), (N'YT');
GO
SET NOCOUNT OFF;
GO

--Import US state codes
PRINT N'Insert dbo.Reference_US_StateCode data';
SET NOCOUNT ON;
GO
INSERT [Lab-DQS].[dbo].[Reference_US_StateCode] VALUES (N'AL'), (N'AK'), (N'AZ'), (N'AR'), (N'CA'), (N'CO'), (N'CT'), (N'DE'), (N'DC'), (N'FL'), (N'GA'), (N'HI'), (N'ID'), (N'IL'), (N'IN'), (N'IA'), (N'KS'), (N'KY'), (N'LA'), (N'ME'), (N'MD'), (N'MA'), (N'MI'), (N'MN'), (N'MS'), (N'MO'), (N'MT'), (N'NE'), (N'NV'), (N'NH'), (N'NJ'), (N'NM'), (N'NY'), (N'NC'), (N'ND'), (N'OH'), (N'OK'), (N'OR'), (N'PA'), (N'RI'), (N'SC'), (N'SD'), (N'TN'), (N'TX'), (N'UT'), (N'VT'), (N'VA'), (N'WA'), (N'WV'), (N'WI'), (N'WY');
GO
SET NOCOUNT OFF;
GO

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

IF NOT EXISTS(SELECT * FROM [Lab-DQS].[sys].[tables] WHERE [name] = N'DimOffice_Error')
BEGIN
	PRINT N'Create dbo.DimOffice_Error table';
	CREATE TABLE [Lab-DQS].[dbo].[DimOffice_Error]
	(
		[Office_Source] NVARCHAR(100)
		,[Office_Output] NVARCHAR(100)
		,[Office_Status] NVARCHAR(100)
		,[Office_Reason] NVARCHAR(4000)
		,[District_Source] NVARCHAR(100)
		,[District_Output] NVARCHAR(100)
		,[District_Status] NVARCHAR(100)
		,[District_Reason] NVARCHAR(4000)
		,[Address1_Source] NVARCHAR(100)
		,[Address1_Output] NVARCHAR(100)
		,[Address1_Status] NVARCHAR(100)
		,[Address1_Reason] NVARCHAR(4000)
		,[Address2_Source] NVARCHAR(100)
		,[Address2_Output] NVARCHAR(100)
		,[Address2_Status] NVARCHAR(100)
		,[Address2_Reason] NVARCHAR(4000)
		,[City_Source] NVARCHAR(50)
		,[City_Output] NVARCHAR(50)
		,[City_Status] NVARCHAR(100)
		,[City_Reason] NVARCHAR(4000)
		,[StateOrProvince_Source] NVARCHAR(50)
		,[StateOrProvince_Output] NVARCHAR(50)
		,[StateOrProvince_Status] NVARCHAR(100)
		,[StateOrProvince_Reason] NVARCHAR(4000)
		,[PostalCode_Source] NVARCHAR(50)
		,[PostalCode_Output] NVARCHAR(50)
		,[PostalCode_Status] NVARCHAR(100)
		,[PostalCode_Reason] NVARCHAR(4000)
		,[Country_Source] NVARCHAR(50)
		,[Country_Output] NVARCHAR(50)
		,[Country_Status] NVARCHAR(100)
		,[Country_Reason] NVARCHAR(4000)
		,[Phone_Source] NVARCHAR(50)
		,[Phone_Output] NVARCHAR(50)
		,[Phone_Status] NVARCHAR(100)
		,[Phone_Reason] NVARCHAR(4000)
		,[ManagerFirstName_Source] NVARCHAR(50)
		,[ManagerFirstName_Output] NVARCHAR(50)
		,[ManagerFirstName_Status] NVARCHAR(100)
		,[ManagerFirstName_Reason] NVARCHAR(4000)
		,[ManagerLastName_Source] NVARCHAR(50)
		,[ManagerLastName_Output] NVARCHAR(50)
		,[ManagerLastName_Status] NVARCHAR(100)
		,[ManagerLastName_Reason] NVARCHAR(4000)
		,[ManagerTitle_Source] NVARCHAR(50)
		,[ManagerTitle_Output] NVARCHAR(50)
		,[ManagerTitle_Status] NVARCHAR(100)
		,[ManagerTitle_Reason] NVARCHAR(4000)
		,[ManagerEmail_Source] NVARCHAR(100)
		,[ManagerEmail_Output] NVARCHAR(100)
		,[ManagerEmail_Status] NVARCHAR(100)
		,[ManagerEmail_Reason] NVARCHAR(4000)
		,[Address] NVARCHAR(714)
		,[Record Status] NVARCHAR(100)
	);
END;
GO