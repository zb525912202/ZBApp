USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

GO
/* in ����Ż����� */
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

COMMIT TRANSACTION