IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
BEGIN
	DROP TABLE #tmp;
END;

CREATE TABLE #tmp
(
	idval int IDENTITY(1, 1) NOT NULL,
	value varchar(max) not null,
	stringindex int null,
	rn int null
);

DECLARE
	@inputstring varchar(MAX) = '1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,6,19,23,1,10,23,27,2,27,13,31,1,31,6,35,2,6,35,39,1,39,5,43,1,6,43,47,2,6,47,51,1,51,5,55,2,55,9,59,1,6,59,63,1,9,63,67,1,67,10,71,2,9,71,75,1,6,75,79,1,5,79,83,2,83,10,87,1,87,5,91,1,91,9,95,1,6,95,99,2,99,10,103,1,103,5,107,2,107,6,111,1,111,5,115,1,9,115,119,2,119,10,123,1,6,123,127,2,13,127,131,1,131,6,135,1,135,10,139,1,13,139,143,1,143,13,147,1,5,147,151,1,151,2,155,1,155,5,0,99,2,0,14,0';


INSERT #tmp (value)
SELECT
	X.value
FROM
	string_split(@inputstring, ',') X;

SELECT
	@inputstring = ',' + @inputstring + ',';

DECLARE
	@value varchar(max),
	@stringindex int,
	@stringindexTaken bit = 0;

DECLARE cur CURSOR
FOR SELECT 
	T.value
FROM
	#tmp T
WHERE
	T.stringindex IS NULL;


OPEN cur;

	FETCH NEXT FROM cur INTO
		@value;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT 
			@stringindex = CHARINDEX(',' + @value + ',', @inputstring);
		
		IF EXISTS
		(
			SELECT
				1
			FROM
				#tmp T
			WHERE
				T.stringindex = @stringindex
		)
		BEGIN
			SELECT
				@stringindexTaken = 1;
		END;

		WHILE @stringindexTaken = 1
		BEGIN
			SELECT 
				@stringindex = CHARINDEX(',' + @value + ',', @inputstring, @stringindex + 1);
		
			IF EXISTS
			(
				SELECT
					1
				FROM
					#tmp T
				WHERE
					T.stringindex = @stringindex
			)
			BEGIN
				SELECT
					@stringindexTaken = 1;
			END;
			ELSE
			BEGIN
				SELECT
					@stringindexTaken = 0;
			END;
		END;



		;WITH cte AS 
		(
			SELECT top 1
				T.*
			FROM
				#tmp T
			WHERE
				T.value = @value AND
				T.stringindex IS NULL
		)	
		UPDATE
			T
		SET
			T.stringindex = COALESCE(@stringindex, -1)
		FROM
			#tmp T
			JOIN cte ON
				cte.idval = T.idval;

		IF @inputstring IS NULL
		begin
			break
		end
	
		FETCH NEXT FROM cur INTO
			@value;
	END;

CLOSE cur;
DEALLOCATE cur;

;WITH cte AS
(
	SELECT
		T.*,
		ROW_NUMBER() OVER (ORDER BY T.stringindex ASC) - 1 AS [rowno]	-- 0-indexerat
	FROM
		#tmp T
)
UPDATE 
	T
SET
	T.rn = cte.rowno
FROM
	cte
	JOIN #tmp T ON
		T.idval = cte.idval;

-- change starting values according to specification:
UPDATE
	T
SET
	T.value = '12'
FROM
	#tmp T
WHERE
	T.rn = 1;

UPDATE
	T
SET
	T.value = 2
FROM
	#tmp T
WHERE
	T.rn = 3;



SELECT
	'starting opcode program with',
	*
FROM
	#tmp;

DECLARE
	@currentstep int = 0,
	@opCode int,
	@inputval1 int,
	@inputval2 int;

SELECT
	@opcode = T.value
FROM
	#tmp T
WHERE
	T.rn = @currentstep;

PRINT @opcode;


WHILE @opCode <> 99 OR @opCode IS NULL
BEGIN
	
	SELECT
		@inputval1 = T2.value
	FROM
		#tmp T
		JOIN #tmp T2 ON
			T2.rn = T.value
	WHERE
		T.rn = @currentstep + 1;

	SELECT
		@inputval2 = T2.value
	FROM
		#tmp T
		JOIN #tmp T2 ON
			T2.rn = T.value
	WHERE
		T.rn = @currentstep + 2;

	PRINT @inputval1; PRINT @inputval2;

	UPDATE
		T2
	SET
		T2.value =	
			CASE @opCode
				WHEN 1
					THEN @inputval1 + @inputval2
				WHEN 2
					THEN @inputval1 * @inputval2
				ELSE
					-1
			END
	FROM
		#tmp T 
		JOIN #tmp T2 ON
			T2.rn = T.value
	WHERE
		T.rn = @currentstep + 3;

	SELECT
		@opcode = T.value
	FROM
		#tmp T
	WHERE
		T.rn = @currentstep + 4;

	PRINT @opcode;

	SELECT
		@currentstep = @currentstep + 4;
END;

-- view temp table with results
SELECT
	*
FROM
	#tmp;

-- get the whole result as string
SELECT
	STRING_AGG(T.value, ',') WITHIN GROUP (ORDER BY T.rn ASC)
FROM
	#tmp T;

-- value at position zero
SELECT
	T.value
FROM
	#tmp T
WHERE
	T.rn = 0