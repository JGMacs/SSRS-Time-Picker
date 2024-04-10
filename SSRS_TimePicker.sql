-- Time Picker stored procedure, to be used to create a dropdown "Time Picker" parameter in SSRS

CREATE PROCEDURE dbo.usp_getListOfHoursIn12hrFormat
	@DefaultStartTime VARCHAR(5),
	@DefaultEndTime VARCHAR(5)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @StartTime TIME(0) = '12:00 AM'
	DECLARE @EndTime TIME(0) = '11:00 PM'
	
	DROP TABLE IF EXISTS #temphours
	DROP TABLE IF EXISTS #temphours2
	DROP TABLE IF EXISTS #tempmerge
	DROP TABLE IF EXISTS #hours
	
	-- Create hour table with 00 minute intervals (ie, 1:00, 2:00, 3:00, etc.) and an ID that increases by 2 starting from 0 (to make room in the rows for the half hours we'll make next)
	CREATE TABLE #temphours (ID int IDENTITY(0,2), T TIME);
	
	WITH X(n) AS
	(
		SELECT TOP (DATEDIFF(HOUR, @StartTime, @EndTime) + 1)
		rn = ROW_NUMBER() OVER (ORDER BY [object_id])
		FROM sys.all_columns ORDER BY [object_id]
	)
	INSERT INTO #temphours
	SELECT t = DATEADD(HOUR, n-1, @StartTime)
	FROM x ORDER BY t;
	
	-- Create a second hour table, this time with 30 minute intervals (ie, 1:30, 2:30, 3:30, etc.) and an ID that increases by 2 starting from 1 
	
	CREATE TABLE #temphours2 (ID int IDENTITY(1,2), T TIME);
	
	WITH X(n) AS
	(
		SELECT TOP (DATEDIFF(HOUR, @StartTime, @EndTime) + 1)
		rn = ROW_NUMBER() OVER (ORDER BY [object_id])
		FROM sys.all_columns ORDER BY [object_id]
	)
	INSERT INTO #temphours2
	SELECT t = DATEADD(HOUR, n-1, DATEADD(MI, 30, @StartTime))
	FROM X ORDER BY t;
	
	-- Merge both temps to get list of times with half-hour intervals. I'm sure there's a prettier way to do this, but it works
	CREATE TABLE #tempmerge (ID int IDENTITY, T TIME);
	SET IDENTITY_INSERT #tempmerge ON
	
	INSERT INTO #tempmerge([ID], [T])
	SELECT [ID], [T] FROM #temphours
	UNION ALL
	SELECT [ID], [T] FROM #temphours2
	ORDER BY ID
	
	SET IDENTITY_INSERT #tempmerge OFF
	
	SELECT CONVERT(VARCHAR(15), t, 100) h,
	(SELECT CONVERT(VARCHAR(15), t, 100) FROM #tempmerge WHERE SUBSTRING(CAST(T AS VARCHAR),1,5) = ISNULL(@DefaultStartTime, '12:00')) DefaultStartTime,
	(SELECT CONVERT(VARCHAR(15), t, 100) FROM #tempmerge WHERE SUBSTRING(CAST(T AS VARCHAR),1,5) = ISNULL(@DefaultEndTime, '12:00')) DefaultEndTime
	INTO #hours
	FROM #tempmerge
	
	SELECT * FROM #hours
	
	DROP TABLE IF EXISTS #temphours
	DROP TABLE IF EXISTS #temphours2
	DROP TABLE IF EXISTS #tempmerge
	DROP TABLE IF EXISTS #hours
END
GO