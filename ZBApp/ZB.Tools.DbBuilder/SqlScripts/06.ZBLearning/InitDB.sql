USE [$(DatabaseName)]
GO

PRINT '------ 存储过程 ------'

BEGIN TRANSACTION

GO
/* in 语句优化函数 */
CREATE FUNCTION SplitFn(
    @Ids NVARCHAR(MAX)
)
RETURNS @t_id TABLE (id INT)
AS
BEGIN
    DECLARE @i INT,@j INT,@l INT,@v INT;
    SET @i = 0;
    SET @j = 0;
    SET @l = len(@Ids);
    WHILE(@j < @l)
    BEGIN
       SET @j = CHARINDEX(',',@Ids,@i+1);
       IF(@j = 0) SET @j = @l+1;
       SET @v = CAST(SUBSTRING(@Ids,@i+1,@j-@i-1) AS INT);
       INSERT INTO @t_id VALUES(@v)
       SET @i = @j;
    END
    RETURN;
END

GO

CREATE FUNCTION CorrectLikeFn(
	@Str NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN 
	return Replace(Replace(Replace(Replace(@Str,'~','~~'),'%','~%'),'[','~['),']','~]')
END
GO

PRINT '------ TableSeed ------'
CREATE TABLE [dbo].[TableSeed](
	[TableName] [nvarchar](50) PRIMARY KEY NOT NULL,
	[Seed] [int] NOT NULL
) 
GO

PRINT '------ 资源必修项达标率计算 ------'
GO
CREATE FUNCTION [dbo].[EmployeeResourceRequiredFn](
	@RequiredStr NVARCHAR(MAX)
)
RETURNS @RequiredTb TABLE(
	TaskId	INT, 
	ItemId INT, 
	TimeSpan INT
)
AS
BEGIN
	DECLARE @AIndex INT, @ANext INT, @ALen INT, @Item NVARCHAR(MAX);
	SET @AIndex = 0;
	SET @ANext = 0;
	SET @ALen = LEN(@RequiredStr);
	
	WHILE(@ANext < @ALen)
	BEGIN
		SET @ANext = CHARINDEX(';',@RequiredStr,@AIndex+1);
		IF(@ANext = 0) SET @ANext = @ALen + 1;
		SET @Item = SUBSTRING(@RequiredStr,@AIndex+1,@ANext-@AIndex-1);
		
		DECLARE @TaskId INT, @ItemId INT, @TimeSpan INT;
		
		DECLARE session_cursor CURSOR
		FORWARD_ONLY READ_ONLY
		FOR SELECT Id FROM dbo.SplitFn(@Item)
		
		OPEN session_cursor
		
		FETCH NEXT FROM session_cursor INTO @TaskId
		
		FETCH NEXT FROM session_cursor INTO @ItemId
		
		FETCH NEXT FROM session_cursor INTO @TimeSpan
		
		INSERT INTO @RequiredTb (TaskId, ItemId, TimeSpan)
		VALUES(@TaskId, @ItemId, @TimeSpan)
		
		CLOSE session_cursor
		DEALLOCATE  session_cursor
		
		SET @AIndex = @ANext;
	END
	RETURN;
END
GO

PRINT '------ 题型题量达标要求计算 ------'
GO
CREATE FUNCTION [dbo].[EmployeeQuesRequiredFn](
	@RequiredStr NVARCHAR(MAX)
)
RETURNS @RequiredTb TABLE(
	TaskId	INT, 
	ItemId INT, 
	QtId INT, 
	QCount INT,
	RightQCount INT, 
	MinRightQcount INT
)
AS
BEGIN
	DECLARE @AIndex INT, @ANext INT, @ALen INT, @Item NVARCHAR(MAX);
	SET @AIndex = 0;
	SET @ANext = 0;
	SET @ALen = LEN(@RequiredStr);
	
	WHILE(@ANext < @ALen)
	BEGIN
		SET @ANext = CHARINDEX(';',@RequiredStr,@AIndex+1);
		IF(@ANext = 0) SET @ANext = @ALen + 1;
		SET @Item = SUBSTRING(@RequiredStr,@AIndex+1,@ANext-@AIndex-1);
		
		DECLARE @TaskId INT, @ItemId INT, @QtId INT, @QCount INT, @RightQCount INT, @MinRightQCount INT;
		
		DECLARE session_cursor CURSOR
		FORWARD_ONLY READ_ONLY
		FOR SELECT Id FROM dbo.SplitFn(@Item)
		
		OPEN session_cursor
		
		FETCH NEXT FROM session_cursor INTO @TaskId
		
		FETCH NEXT FROM session_cursor INTO @ItemId
		
		FETCH NEXT FROM session_cursor INTO @QtId
		
		FETCH NEXT FROM session_cursor INTO @QCount
		
		FETCH NEXT FROM session_cursor INTO @RightQCount
		
		FETCH NEXT FROM session_cursor INTO @MinRightQCount	
		
		INSERT INTO @RequiredTb (TaskId, ItemId, QtId, QCount, RightQCount, MinRightQcount)
		VALUES(@TaskId, @ItemId, @QtId, @QCount, @RightQCount, @MinRightQCount)
		
		CLOSE session_cursor
		DEALLOCATE  session_cursor
		
		SET @AIndex = @ANext;
	END
	RETURN;
END
GO

COMMIT TRANSACTION