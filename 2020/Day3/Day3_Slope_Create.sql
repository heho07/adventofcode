USE [master]
GO
/****** Object:  StoredProcedure [dbo].[Slope_Create]    Script Date: 2020-12-06 19:45:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[Slope_Create]
	@InputString varchar(MAX)
AS
BEGIN
	DECLARE 
		@CurrentIndex int = 1,
		@iterator int = 1,
		@CurrentRow varchar(max);

	IF OBJECT_ID('dbo.Slope') IS NOT NULL
	BEGIN
		DROP TABLE dbo.Slope;
	END;

	CREATE TABLE dbo.Slope
	(
		Id int not null,
		Value varchar(max) not null
	);

	SELECT 
		@CurrentIndex = CHARINDEX(char(10), @inputstring, 1);


	SELECT @CurrentIndex;

	WHILE @CurrentIndex <> 0 -- @iterator < 4 
	BEGIN
	
		SELECT
			@CurrentRow = LEFT(@inputstring, @CurrentIndex - 1);
		

		SELECT
			@inputstring = SUBSTRING(@inputstring, @CurrentIndex + 1, LEN(@inputstring) - @CurrentIndex);



		INSERT dbo.Slope
		(
			Id,
			Value
		)
		VALUES
		(
			@iterator,
			REPLACE(REPLACE(@CurrentRow, char(10), ''), char(13), '')
		);

		SELECT
			@iterator = @iterator + 1;

		SELECT 
			@CurrentIndex = CHARINDEX(char(10), @inputstring, 1);
	
	END;

	INSERT dbo.Slope
	(
		Id,
		Value
	)
	VALUES
	(
		@iterator,
		REPLACE(REPLACE(@inputstring, char(10), ''), char(13), '')
	);

	RETURN 0;
END;