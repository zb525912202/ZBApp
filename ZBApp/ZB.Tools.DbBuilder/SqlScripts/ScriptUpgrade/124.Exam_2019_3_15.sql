
IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='GraderId')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD GraderId INT NOT NULL DEFAULT 0;
	PRINT '添加WebExamineePaperDetail内的GraderId成功';
END

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='GraderName')
BEGIN
	ALTER TABLE WebExamineePaperDetail ADD GraderName NVARCHAR(50) NOT NULL DEFAULT '';
	PRINT '添加WebExamineePaperDetail内的GraderName成功';
END
GO

DECLARE @table sysname; --数据库名称变量

DECLARE My_Cursor CURSOR --定义游标
FOR (SELECT name FROM sysobjects WHERE xtype='u' AND name LIKE 'WebPaperPackageQuestion_%') --查出所有的表名称的集合放到游标中
OPEN My_Cursor; --打开游标
FETCH NEXT FROM My_Cursor INTO @table; --读取下一行/第一行数据并存放在变量值中
WHILE @@FETCH_STATUS = 0 --是否可继续执行循环状态
    BEGIN
        DECLARE @sql NVARCHAR(MAX); --sql命令字符串
		
		 
		 SET @sql='IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('''+@table+''') AND name=''CanGradeId'')
					BEGIN
						ALTER TABLE '+@table+' ADD CanGradeId INT NOT NULL DEFAULT 0;
					END;'
				+'IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('''+@table+''') AND name=''CanGradeName'')
					BEGIN
						ALTER TABLE '+@table+' ADD CanGradeName NVARCHAR(50) NOT NULL DEFAULT '''';
					END;';
							
		DECLARE @tranError INT -- 定义变量
		SET @tranError=0
		BEGIN TRANSACTION
			EXEC(@sql); --执行字符串sql
			 Set @tranError = @tranError + @@Error
		IF @tranError = 0
			BEGIN
				PRINT '添加'+@table+'内的CanGradeId成功';
				PRINT '添加'+@table+'内的CanGradeName成功';
				COMMIT TRANSACTION	
			END	
		ELSE
			ROLLBACK TRANSACTION
        FETCH NEXT FROM My_Cursor INTO @table; --读取下一行数据并存放在变量值中
    END
CLOSE My_Cursor; --关闭游标
DEALLOCATE My_Cursor; --释放游标
GO


