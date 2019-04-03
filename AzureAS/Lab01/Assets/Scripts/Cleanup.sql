PRINT N'Drop AdventureWorksDW2016-Lite database';
IF EXISTS(SELECT * FROM [sys].[databases] WHERE [name] = N'AdventureWorksDW2016-Lite')
BEGIN
	DROP DATABASE [AdventureWorksDW2016-Lite];
END;
GO