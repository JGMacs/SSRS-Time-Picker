-- Example sproc to show how the time picker might be implemented in queries used by reports, using the times picked by the users
--
-- In this case, the "exampleImplementation" sproc is being used by a report, which sends both StartDate and EndDate to the procedure, 
-- as well as the StartTime and EndTime parameters chosen by the users. For this query, we want to create a DATETIME value with the dates and times,
-- so the StartDate/EndDate parameters must be DATE datatypes to avoid having to needlessly replace existing times.

CREATE PROCEDURE dbo.usp_exampleImplementation
	@StartDate DATE,
	@EndDate DATE,
	@StartTime NVARCHAR(12),
	@EndTime NVARCHAR(12)

-- Combining both the dates and times to create DATETIME values
DECLARE @StartDateTime DATETIME = CONVERT(DATETIME, CONVERT(NVARCHAR, @StartDate) + 
	' ' + CONVERT(NVARCHAR(12), @StartTime))
	
DECLARE @EndDateTime DATETIME = CONVERT(DATETIME, CONVERT(NVARCHAR, @EndDate) + 
	' ' + CONVERT(NVARCHAR(12), @EndTime))