PRINT N'Create the dbo.uspDimDateExtend stored procedure';
GO
CREATE PROC [dbo].[uspDimDateExtend]
	@DateTo DATE
AS
	SET NOCOUNT ON;

	DECLARE @DateFrom DATE;

	SELECT @DateFrom = DATEADD(d, 1, MAX([FullDateAlternateKey])) FROM [dbo].[DimDate];
	
	WHILE (@DateFrom <= @DateTo)
	BEGIN
		INSERT [dbo].[DimDate]
		(
			[DateKey]
			,[FullDateAlternateKey]
			,[DayNumberOfWeek]
			,[EnglishDayNameOfWeek]
			,[SpanishDayNameOfWeek]
			,[FrenchDayNameOfWeek]
			,[DayNumberOfMonth]
			,[DayNumberOfYear]
			,[WeekNumberOfYear]
			,[EnglishMonthName]
			,[SpanishMonthName]
			,[FrenchMonthName]
			,[MonthNumberOfYear]
			,[CalendarQuarter]
			,[CalendarYear]
			,[CalendarSemester]
			,[FiscalQuarter]
			,[FiscalYear]
			,[FiscalSemester]
		)
		SELECT
			((YEAR(@DateFrom) * 10000) + (MONTH(@DateFrom) * 100) + DAY(@DateFrom)) AS [DateKey]
			,@DateFrom AS [FullDateAlternateKey]
			,DATEPART(dw, @DateFrom) AS [DayNumberOfWeek]
			,CASE DATEPART(dw, @DateFrom)
				WHEN 1 THEN 'Sunday'
				WHEN 2 THEN 'Monday'
				WHEN 3 THEN 'Tuesday'
				WHEN 4 THEN 'Wednesday'
				WHEN 5 THEN 'Thursday'
				WHEN 6 THEN 'Friday'
				WHEN 7 THEN 'Saturday'
			END AS [EnglishDayNameOfWeek]
			,CASE DATEPART(dw, @DateFrom)
				WHEN 1 THEN 'Domingo'
				WHEN 2 THEN 'Lunes'
				WHEN 3 THEN 'Martes'
				WHEN 4 THEN 'Mi�rcoles'
				WHEN 5 THEN 'Jueves'
				WHEN 6 THEN 'Viernes'
				WHEN 7 THEN 'S�bado'
			END AS [SpanishDayNameOfWeek]
			,CASE DATEPART(dw, @DateFrom)
				WHEN 1 THEN 'Dimanche'
				WHEN 2 THEN 'Lundi'
				WHEN 3 THEN 'Mardi'
				WHEN 4 THEN 'Mercredi'
				WHEN 5 THEN 'Jeudi'
				WHEN 6 THEN 'Vendredi'
				WHEN 7 THEN 'Samedi'
			END AS [FrenchDayNameOfWeek]
			,DATEPART(d, @DateFrom) AS [DayNumberOfMonth]
			,DATEPART(dy, @DateFrom) AS [DayNumberOfYear]
			,DATEPART(wk, @DateFrom) AS [WeekNumberOfYear]
			,CASE DATEPART(m, @DateFrom)
				WHEN 1 THEN 'January'
				WHEN 2 THEN 'February'
				WHEN 3 THEN 'March'
				WHEN 4 THEN 'April'
				WHEN 5 THEN 'May'
				WHEN 6 THEN 'June'
				WHEN 7 THEN 'July'
				WHEN 8 THEN 'August'
				WHEN 9 THEN 'September'
				WHEN 10 THEN 'October'
				WHEN 11 THEN 'November'
				WHEN 12 THEN 'December'
			END AS [EnglishMonthName]
			,CASE DATEPART(m, @DateFrom)
				WHEN 1 THEN 'Enero'
				WHEN 2 THEN 'Febrero'
				WHEN 3 THEN 'Marzo'
				WHEN 4 THEN 'Abril'
				WHEN 5 THEN 'Mayo'
				WHEN 6 THEN 'Junio'
				WHEN 7 THEN 'Julio'
				WHEN 8 THEN 'Agosto'
				WHEN 9 THEN 'Septiembre'
				WHEN 10 THEN 'Octubre'
				WHEN 11 THEN 'Noviembre'
				WHEN 12 THEN 'Diciembre'
			END AS [SpanishMonthName]
			,CASE DATEPART(m, @DateFrom)
				WHEN 1 THEN 'Janvier'
				WHEN 2 THEN 'F�vrier'
				WHEN 3 THEN 'Mars'
				WHEN 4 THEN 'Avril'
				WHEN 5 THEN 'Mai'
				WHEN 6 THEN 'Juin'
				WHEN 7 THEN 'Juillet'
				WHEN 8 THEN 'Ao�t'
				WHEN 9 THEN 'Septembre'
				WHEN 10 THEN 'Octobre'
				WHEN 11 THEN 'Novembre'
				WHEN 12 THEN 'D�cembre'
			END AS [FrenchMonthName]
			,DATEPART(m, @DateFrom) AS [MonthNumberOfYear]
			,DATEPART(q, @DateFrom) AS [CalendarQuarter]
			,DATEPART(yyyy, @DateFrom) AS [CalendarYear]
			,((DATEPART(q, @DateFrom) + 1) / 2) AS [CalendarSemester]
			,DATEPART(q, DATEADD(m, 6, @DateFrom)) AS [FiscalQuarter]
			,DATEPART(yyyy, DATEADD(m, 6, @DateFrom)) AS [FiscalYear]
			,((DATEPART(q, DATEADD(m, 6, @DateFrom)) + 1) / 2) AS [FiscalSemester];

		SET @DateFrom = DATEADD(d, 1, @DateFrom);
	END;
GO

PRINT N'Extend dbo.DimDate records';
GO
EXEC [dbo].[uspDimDateExtend] '20171231';
GO

PRINT N'Drop the dbo.uspDimDateExtend stored procedure';
GO
DROP PROC [dbo].[uspDimDateExtend];
GO

PRINT N'Repair dbo.FactResellerSales.OrderDateKey values';
GO
SET NOCOUNT ON;
GO
UPDATE
	[dbo].[FactResellerSales]
SET
	[OrderDateKey] = CASE
		WHEN [OrderDateKey] = 20101229 THEN 20140101
		WHEN [OrderDateKey] = 20110129 THEN 20140201
		WHEN [OrderDateKey] = 20110301 THEN 20140301
		WHEN [OrderDateKey] = 20110331 THEN 20140401
		WHEN [OrderDateKey] = 20110501 THEN 20140501
		WHEN [OrderDateKey] = 20110531 THEN 20140601
		WHEN [OrderDateKey] = 20110701 THEN 20140701
		WHEN [OrderDateKey] = 20110801 THEN 20140801
		WHEN [OrderDateKey] = 20110829 THEN 20140901
		WHEN [OrderDateKey] = 20110929 THEN 20141001
		WHEN [OrderDateKey] = 20111029 THEN 20141101
		WHEN [OrderDateKey] = 20111129 THEN 20141201
		WHEN [OrderDateKey] = 20111229 THEN 20150101
		WHEN [OrderDateKey] = 20120129 THEN 20150201
		WHEN [OrderDateKey] = 20120229 THEN 20150301
		WHEN [OrderDateKey] = 20120330 THEN 20150401
		WHEN [OrderDateKey] = 20120430 THEN 20150501
		WHEN [OrderDateKey] = 20120530 THEN 20150601
		WHEN [OrderDateKey] = 20120630 THEN 20150701
		WHEN [OrderDateKey] = 20120731 THEN 20150801
		WHEN [OrderDateKey] = 20120828 THEN 20150901
		WHEN [OrderDateKey] = 20120928 THEN 20151001
		WHEN [OrderDateKey] = 20121028 THEN 20151101
		WHEN [OrderDateKey] = 20121128 THEN 20151201
		WHEN [OrderDateKey] = 20121228 THEN 20160101
		WHEN [OrderDateKey] = 20130128 THEN 20160201
		WHEN [OrderDateKey] = 20130228 THEN 20160301
		WHEN [OrderDateKey] = 20130330 THEN 20160401
		WHEN [OrderDateKey] = 20130430 THEN 20160501
		WHEN [OrderDateKey] = 20130530 THEN 20160601
		WHEN [OrderDateKey] = 20130630 THEN 20160701
		WHEN [OrderDateKey] = 20130731 THEN 20160801
		WHEN [OrderDateKey] = 20130828 THEN 20160901
		WHEN [OrderDateKey] = 20130829 THEN 20160901
		WHEN [OrderDateKey] = 20130928 THEN 20161001
		WHEN [OrderDateKey] = 20130929 THEN 20161001
		WHEN [OrderDateKey] = 20131028 THEN 20161101
		WHEN [OrderDateKey] = 20131029 THEN 20161101
		WHEN [OrderDateKey] = 20131128 THEN 20161201
		WHEN [OrderDateKey] = 20131129 THEN 20161201
		ELSE [OrderDateKey]
	END;
GO
SET NOCOUNT OFF;
GO

PRINT N'Update dbo.FactResellerSales.OrderDate values';
GO
SET NOCOUNT ON;
GO
UPDATE
	[f]
SET
	[OrderDate] = [d].[FullDateAlternateKey]
FROM
	[dbo].[FactResellerSales] AS [f]
	INNER JOIN [dbo].[DimDate] AS [d]
		ON [d].[DateKey] = [f].[OrderDateKey];
GO
SET NOCOUNT OFF;
GO

PRINT N'Delete dbo.FactResellerSales rows';
GO
SET NOCOUNT ON;
GO
DELETE [dbo].[FactResellerSales] WHERE [OrderDateKey] = 20161201;
GO
SET NOCOUNT OFF;
GO