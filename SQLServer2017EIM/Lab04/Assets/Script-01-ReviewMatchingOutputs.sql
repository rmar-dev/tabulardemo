--Execute INDIVIDUAL batches as directed

--Review the matching results
--Notice that pivot records have a null MATCHING_RULE and null SCORE
--Notice that duplicate rows have a MATCHING_RULE and SCORE value
SELECT * FROM [Lab-DQS].[dbo].[MatchingResults];
GO

--Review the de-duplicated records (filtered by MATCHING_RULE)
--Take note of the row count
SELECT * FROM [Lab-DQS].[dbo].[MatchingResults] WHERE [MATCHING_RULE] IS NULL;
GO

--Review the survivorship results
--Take note of the row count, that is the same of the previous query result
--Congratulations! You have arrived at a cleansed and de-duplicated list of Microsoft offices! :-)
SELECT * FROM [Lab-DQS].[dbo].[SurvivorshipResults];
GO
