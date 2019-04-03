IF EXISTS(SELECT * FROM [master].[sys].[databases] WHERE [name] = N'Lab-DQS')
BEGIN
	PRINT N'Drop Lab-DQS database';

	ALTER DATABASE [Lab-DQS]
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	DROP DATABASE [Lab-DQS];
END;
GO