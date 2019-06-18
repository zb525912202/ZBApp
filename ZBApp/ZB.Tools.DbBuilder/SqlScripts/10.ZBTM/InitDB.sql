PRINT '------ 存储过程 ------'
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








IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddTableColumn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddTableColumn]
GO

CREATE PROC AddTableColumn(@TableName NVARCHAR(MAX),@ColumnName NVARCHAR(MAX),@DataType NVARCHAR(MAX))
AS
BEGIN 
	DECLARE @sql nvarchar(1000);
	IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id(@TableName) AND name=@ColumnName)
	BEGIN
		SET @sql = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' ' + @DataType + ';';
	END
	ELSE
	BEGIN
		SET @sql = 'ALTER TABLE ' + @TableName + ' ADD ' + @ColumnName + ' ' + @DataType + ';';
	END
	execute (@sql);
END
GO








--删除自定义外键约束（EXEC DelCustomerFK 'tablename','columnname','checkname',''）
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DelCustomerFK]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DelCustomerFK]
GO

CREATE PROC DelCustomerFK
(
	@SourceTableName NVARCHAR(50),	--FK所在表名
	@SourceColName NVARCHAR(50),	--FK所在表的列名
	@CheckName NVARCHAR(50),		--FK约束的名字	
	@IndexName NVARCHAR(50) OUTPUT	--索引名称
)
AS
SET @IndexName = 'Idx_'+@SourceTableName+'_'+@SourceColName;

EXEC('IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].['+@SourceTableName+']'') AND name = N'''+@IndexName+''')
DROP INDEX ['+@IndexName+'] ON [dbo].['+@SourceTableName+'] WITH ( ONLINE = OFF )');

EXEC('IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N''[dbo].['+@CheckName+']'') AND parent_object_id = OBJECT_ID(N'''+@SourceTableName+'''))
ALTER TABLE '+ @SourceTableName +' DROP CONSTRAINT ['+@CheckName+']');

EXEC ('IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[' + @CheckName + '_FunctionHelper]'') AND TYPE IN (N''FN'', N''IF'', N''TF'', N''FS'', N''FT''))
DROP FUNCTION [dbo].[' + @CheckName + '_FunctionHelper]');

GO


--添加自定义外键约束（EXEC AddCustomerFK 'checkname','sourcetablename','sourcecolumnname', 'targettablename', 'targetcolumnname', '-1,-2,-3'）
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddCustomerFK]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddCustomerFK]
GO

CREATE PROC AddCustomerFK
(
	@CheckName NVARCHAR(50),		--FK约束的名字
	@SourceTableName NVARCHAR(50),	--FK所在表名
	@SourceColName NVARCHAR(50),	--FK所在表的列名
	@TargetTableName NVARCHAR(50),	--FK依赖表的表名
	@TargetColName NVARCHAR(50),	--FK依赖表的列名
	@Include NVARCHAR(MAX)			--排除的值，格式'1,2,3,4,5'	
)
AS

BEGIN TRY
	EXEC('SELECT TOP 0 * FROM '+@SourceTableName);
	EXEC('SELECT TOP 0 * FROM '+@TargetTableName);
END TRY
BEGIN CATCH
	PRINT (@SourceTableName + '或' +  @TargetTableName + '表不存在，请核对后重新执行!')
	RETURN;
END CATCH


DECLARE @IX_IndexName NVARCHAR(50);
EXEC dbo.DelCustomerFK @SourceTableName,@SourceColName,@CheckName,@IX_IndexName OUTPUT

DECLARE @SqlStr1 NVARCHAR(500);
SET @SqlStr1 ='CREATE FUNCTION dbo.' + @CheckName + '_FunctionHelper
				(
					@CheckKey INT
				)
				RETURNS INT
				AS
				BEGIN
				   DECLARE @retval INT;
				   SELECT @retval = COUNT(*) FROM ' + @TargetTableName + ' WHERE ' + @TargetColName + '=@CheckKey'+';
				   RETURN @retval
				END';
EXEC(@SqlStr1);

DECLARE @SqlStr2 NVARCHAR(500);

IF(@Include ='' OR @Include IS NULL)
BEGIN
	SET @SqlStr2 =' ALTER TABLE ' + @SourceTableName +
					' ADD CONSTRAINT ' + @CheckName + ' CHECK( dbo.' + @CheckName + '_FunctionHelper('+@SourceTableName+'.'+@SourceColName+')>= 1);'	
END
ELSE
BEGIN
	SET @SqlStr2 =' ALTER TABLE ' + @SourceTableName +
				' ADD CONSTRAINT ' + @CheckName + ' CHECK( dbo.' + @CheckName + '_FunctionHelper('+@SourceTableName+'.'+@SourceColName+')>= 1 OR ' +
				@SourceTableName+'.'+@SourceColName+ ' IN ' + '('+@Include+'));'	
END

EXEC(@SqlStr2);

EXEC('CREATE NONCLUSTERED INDEX ['+@IX_IndexName+'] ON [dbo].['+@SourceTableName+'] 
(
	['+@SourceColName+'] ASC
)');

GO


PRINT '------ TableSeed ------'
CREATE TABLE [dbo].[TableSeed](
	[TableName] [nvarchar](50) PRIMARY KEY NOT NULL,
	[Seed] [int] NOT NULL
) 
GO