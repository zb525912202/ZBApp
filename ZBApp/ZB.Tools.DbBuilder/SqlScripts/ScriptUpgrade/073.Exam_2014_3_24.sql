--IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='GraderId')
--BEGIN
--	declare @constraintName varchar(200);
--	declare @dropConstraintSql varchar(200);
--	--DF为约束名称前缀
--	select @constraintName=b.name from syscolumns a,sysobjects b where a.id=object_id('WebExamineePaperDetail') and b.id=a.cdefault and a.name='GraderId' and b.name like 'DF%';
--	--删除约束
--	SET @dropConstraintSql = 'ALTER TABLE WebExamineePaperDetail DROP CONSTRAINT ' + @constraintName;
--	execute (@dropConstraintSql);

--	ALTER TABLE WebExamineePaperDetail DROP Column GraderId;
--	PRINT '删除WebExamineePaperDetail内的GraderId成功';
--END

--IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('WebExamineePaperDetail') AND name='GraderName')
--BEGIN
--	declare @constraintName1 varchar(200);
--	declare @dropConstraintSql1 varchar(200);
--	--DF为约束名称前缀
--	select @constraintName1=b.name from syscolumns a,sysobjects b where a.id=object_id('WebExamineePaperDetail') and b.id=a.cdefault and a.name='GraderName' and b.name like 'DF%';
--	--删除约束
--	SET @dropConstraintSql1 = 'ALTER TABLE WebExamineePaperDetail DROP CONSTRAINT ' + @constraintName1;
--	execute (@dropConstraintSql1);

--	ALTER TABLE WebExamineePaperDetail DROP Column GraderName;
--	PRINT '删除WebExamineePaperDetail内的GraderName成功';
--END