
DECLARE @table sysname; --数据库名称变量

DECLARE My_Cursor CURSOR --定义游标
FOR (SELECT name FROM sysobjects WHERE xtype='u' AND name LIKE 'WebPaperPackageQuestion_%') --查出所有的表名称的集合放到游标中
OPEN My_Cursor; --打开游标
FETCH NEXT FROM My_Cursor INTO @table; --读取下一行/第一行数据并存放在变量值中
WHILE @@FETCH_STATUS = 0 --是否可继续执行循环状态
    BEGIN
        DECLARE @sql NVARCHAR(MAX); --sql命令字符串
		declare @graderid VARCHAR(20) SET @graderid=(SELECT name FROM syscolumns WHERE id = object_id(''+@table+'') AND name='GraderId')
		declare @gradername VARCHAR(20) SET @gradername=(SELECT name FROM syscolumns WHERE id = object_id(''+@table+'') AND name='GraderName')

		 SET @sql='IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('''+@table+''') AND name=''GraderId'')
				  BEGIN
					  
					  UPDATE '+@table+' SET CanGradeId = '+@graderid+',CanGradeName = '+@gradername+' WHERE '+@graderid+'>0 AND CanGradeId=0;
					  UPDATE WebExamineePaperDetail SET GraderId=WPQ.'+@graderid+',GraderName=WPQ.'+@gradername+'
					  FROM '+@table+' AS WPQ
					  WHERE WPQ.'+@graderid+'>0 
					  AND WPQ.PaperPackageId = (SELECT PaperPackageId FROM WebExamineePaper WHERE Id=WebExamineePaperDetail.PaperId)
					  AND WPQ.Id = WebExamineePaperDetail.PaperPackageQuestionId
					  AND WebExamineePaperDetail.GraderId=0;
				  END';						
		DECLARE @tranError INT -- 定义变量
		SET @tranError=0
		BEGIN TRANSACTION
			EXEC(@sql); --执行字符串sql
			 Set @tranError = @tranError + @@Error
		IF @tranError = 0
			BEGIN
				PRINT '修复'+@table+'内的CanGradeId内容成功';
				PRINT '修复'+@table+'内的CanGradeName内容成功';
				COMMIT TRANSACTION	
			END	
		ELSE
			ROLLBACK TRANSACTION
        FETCH NEXT FROM My_Cursor INTO @table; --读取下一行数据并存放在变量值中
    END
CLOSE My_Cursor; --关闭游标
DEALLOCATE My_Cursor; --释放游标
GO

