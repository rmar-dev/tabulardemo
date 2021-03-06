--Execute INDIVIDUAL batches as directed

--Review all cleansed office records loaded into the dbo.DimOffice table
SELECT * FROM [Lab-DQS].[dbo].[DimOffice];
GO

--Review all office records that could not be cleansed
SELECT * FROM [Lab-DQS].[dbo].[DimOffice_Error];
GO

--Review all office records that could not be cleansed, filtered and pivoted to produce a convenient 
--summary of the data issues by office, and describing each invalid domain value and reason
SELECT [Office_Output] AS [Office], N'Office' AS [Domain], [Office_Source] AS [Value], [Office_Reason] AS [Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [Office_Status] = N'Invalid' 
UNION ALL SELECT [Office_Output], N'District' AS [Domain], [District_Source], [District_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [District_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'Address1' AS [Domain], [Address1_Source], [Address1_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [Address1_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'Address2' AS [Domain], [Address2_Source], [Address2_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [Address2_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'City' AS [Domain], [City_Source], [City_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [City_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'PostalCode' AS [Domain], [PostalCode_Source], [PostalCode_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [PostalCode_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'Country' AS [Domain], [Country_Source], [Country_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [Country_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'Phone' AS [Domain], [Phone_Source], [Phone_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [Phone_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'ManagerFirstName' AS [Domain], [ManagerFirstName_Source],  [ManagerFirstName_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [ManagerFirstName_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'ManagerLastName' AS [Domain], [ManagerLastName_Source],  [ManagerLastName_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [ManagerLastName_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'ManagerTitle' AS [Domain], [ManagerTitle_Source], [ManagerTitle_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [ManagerTitle_Status] = N'Invalid'
UNION ALL SELECT [Office_Output], N'ManagerEmail' AS [Domain], [ManagerEmail_Source], [ManagerEmail_Reason] FROM [Lab-DQS].[dbo].[DimOffice_Error] WHERE [ManagerEmail_Status] = N'Invalid'
ORDER BY 1, 2;
GO
