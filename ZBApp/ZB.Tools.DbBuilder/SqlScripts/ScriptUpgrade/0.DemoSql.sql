
--创建新表相关语句DEMO

--判断数据库内是否存在指定表的语句
--EXISTS 语句判断存在
--NOT EXISTS 语句判断不存在
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[表名]') AND type in (N'U'))
BEGIN
	/*******************************
	这里写创建表相关的SQL
	*******************************/
END

--DEMO：新创建一张Person表
/*
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[Person]
		(
			[Id]	INT IDENTITY(1,1) PRIMARY KEY
		)
	END
*/


/****************************************************************************************************************/
--创建或修改视图相关语句

--判断数据库内是否存在指定视图的语句
--不管是新建视图还是修改视图，统一逻辑处理为先删除指定视图，后创建该视图
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[视图名]'))
	DROP VIEW [dbo].[视图名]
GO
	/*******************************
	这里写创建视图相关的SQL
	*******************************/
GO

--DEMO：新创或修改一个视图PersonView
/*
	IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PersonView]'))
	BEGIN
		DROP VIEW [dbo].[PersonView]
	END
	GO

	CREATE VIEW [dbo].[PersonView]
	AS
	SELECT * FROM Person

	GO
*/

/****************************************************************************************************************/

--创建或修改表的指定列的相关SQL

--判断表内是否存在指定列
/*
	如果被添加或修改的列不允许为空，则该字段需要设置默认值，否则对旧有数据会产生影响，导致操作该列失败
*/
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('表名') AND name='列名')
BEGIN
	--存在该字段，则修改，使用 ALTER 语句
	ALTER TABLE 表名 ALTER COLUMN 列名 INT NOT NULL;
	PRINT '修改‘表名’内的‘列名’成功';
END
ELSE
BEGIN
	--不存在该字段，测添加，使用 ADD 语句
	ALTER TABLE 表名 ADD 列名 INT NOT NULL DEFAULT 0;
	PRINT '添加‘表名’内的‘列名’成功';
END
GO

/*
	DEMO: 像Person表增加一个Age字段
	
	IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Person') AND name='Age')
	BEGIN
		ALTER TABLE Person ALTER COLUMN Age INT NOT NULL DEFAULT 0;
		PRINT '修改‘Person’内的‘Age’成功';
	END
	ELSE
	BEGIN
		--不存在该字段，测添加，使用 ADD 语句
		ALTER TABLE Person ADD Age INT NOT NULL DEFAULT 0;
		PRINT '添加‘Person’内的‘Age’成功';
	END
	GO
*/



/****************************************************************************************************************/

-- 添加修改 主键，外键相关SQL

--主键
--判断指定表的主键是否存在，如果存在，则先删除，后创建
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[表名]') AND name = N'主键名')
ALTER TABLE [dbo].[表名] DROP CONSTRAINT [主键名]
GO
--创建主键
ALTER TABLE [dbo].[表名] ADD PRIMARY KEY CLUSTERED 
(
	[列名] ASC
)WITH (PAD_INDEX  = OFF) ON [PRIMARY]
GO


--外键
--判断该外键是否存在，如果存在，先删除，后创建
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[外键名]') AND parent_object_id = OBJECT_ID(N'[dbo].[表名]'))
ALTER TABLE [dbo].[表名] DROP CONSTRAINT [外键名]
GO
--创建外键
ALTER TABLE [表名] WITH CHECK ADD
CONSTRAINT [外键名] FOREIGN KEY([列名]) REFERENCES [关联表名]([关联列名])

GO




PRINT'-----删除EmployeeStudyDetailStat表的所有非聚集索引-----'
DECLARE indexCursor CURSOR LOCAL FOR
SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeStudyDetailStat]') AND is_unique='FALSE'

OPEN indexCursor
DECLARE @indexName nvarchar(1000);
DECLARE @dropIndexSql nvarchar(1000);

FETCH NEXT FROM indexCursor INTO @indexName;
WHILE @@FETCH_STATUS=0
BEGIN
SET @dropIndexSql = 'DROP INDEX ' + @indexName + ' ON EmployeeStudyDetailStat';
execute (@dropIndexSql);
FETCH NEXT FROM indexCursor INTO @indexName;
END

CLOSE indexCursor
DEALLOCATE indexCursor