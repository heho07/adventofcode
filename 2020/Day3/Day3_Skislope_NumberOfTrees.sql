USE [master]
GO
/****** Object:  UserDefinedFunction [dbo].[Day3_Skislope_NumberOfTrees]    Script Date: 2020-12-06 19:45:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   FUNCTION [dbo].[Day3_Skislope_NumberOfTrees]
(
	@StartingPositionRow int = 1,
	@StartingPositionColumn int = 1,
	@StepsVertically int = 1,
	@StepsHorizontally int = 3
)
RETURNS INT
AS 
BEGIN
	
	Declare @NumberOfTrees int;

	;WITH cte AS
	(
		SELECT
			S.Id,
			IIF(SUBSTRING(S.Value, IIF(@StartingPositionColumn % LEN(S.value) = 0, LEN(S.Value), @StartingPositionColumn % LEN(S.value)), 1) = '#', 1, 0) AS [trees],
			@StartingPositionRow + @StepsVertically AS [NextRow],
			@StartingPositionColumn + @StepsHorizontally AS [NextColumn],

			SUBSTRING(S.Value, IIF(@StartingPositionColumn % LEN(S.value) = 0, LEN(S.Value), @StartingPositionColumn % LEN(S.value)), 1) AS [CompVal],
			(@StartingPositionColumn % LEN(S.value)) + 1 AS [CurrentColumn],
			LEN(S.value) AS Lenvalue,
			S.Value,

			IIF(@StartingPositionColumn % LEN(S.value) = 0, LEN(S.Value), @StartingPositionColumn % LEN(S.value)) AS [ColumnToUse]

		FROM
			dbo.Slope S
		WHERE
			S.Id = @StartingPositionRow

		UNION ALL

		SELECT
			S.Id,
			cte.trees + IIF(SUBSTRING(S.Value, IIF(cte.NextColumn % LEN(S.value) = 0, LEN(S.Value), cte.NextColumn % LEN(S.value)), 1) = '#', 1, 0) AS [trees],
			cte.NextRow + @StepsVertically AS [NextRow],
			cte.NextColumn + @StepsHorizontally AS [NextColumn],
		
			SUBSTRING(S.Value, IIF(cte.NextColumn % LEN(S.value) = 0, LEN(S.Value), cte.NextColumn % LEN(S.value)), 1) AS [CompVal],
			(cte.NextColumn % LEN(S.value)) + 1 AS [CurrentColumn],
			LEN(S.value) AS Lenvalue,
			S.Value,

			IIF(cte.NextColumn % LEN(S.value) = 0, LEN(S.Value), cte.NextColumn % LEN(S.value)) AS [ColumnToUse]

		FROM
			dbo.Slope S
			JOIN cte ON
				S.Id = cte.NextRow
	)
	SELECT
		@NumberOfTrees = MAX(cte.Trees)
	FROM
		cte
	OPTION(MAXRECURSION 400);

	RETURN @NumberOfTrees;
END;