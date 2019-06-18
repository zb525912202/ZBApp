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

CREATE Function [dbo].[GetAge]
(
@birthday datetime,
@now datetime
)
Returns int
As
Begin
Declare @Age int, @month int, @Day int
Set @Age = DatePart(Year,@Now) - DatePart(Year, @BirthDay)
Set @month = DatePart(Month,@Now) - DatePart(Month, @BirthDay)
Set @Day = DatePart(Day,@Now) - DatePart(Day, @BirthDay)
if(@month < 0 or (@month = 0 and @Day < 0))
	set @Age = @Age - 1
Return(@Age)
End

GO

PRINT '------ TableSeed ------'
CREATE TABLE [dbo].[TableSeed](
	[TableName] [nvarchar](50) PRIMARY KEY NOT NULL,
	[Seed] [int] NOT NULL
) 
GO

COMMIT TRANSACTION