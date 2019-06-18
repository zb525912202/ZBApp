

--修改人员表内的岗级为decimal类型，以支持1.50
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='PostRank')
BEGIN
	--select	
	DECLARE @CONSTRAINT NVARCHAR(100);
	SELECT @CONSTRAINT = name FROM sys.default_constraints
	WHERE sys.default_constraints.parent_object_id=OBJECT_ID('Employee') 
	AND object_id = (SELECT cdefault FROM syscolumns WHERE id = object_id('Employee') AND name='PostRank')
	EXEC('ALTER TABLE Employee DROP CONSTRAINT ' + @CONSTRAINT)

	--alter
	ALTER TABLE Employee ALTER COLUMN PostRank DECIMAL(18,2);

	--add
	ALTER TABLE Employee ADD CONSTRAINT DF_Employee_PostRank DEFAULT 0 FOR PostRank;
	PRINT '修改‘Employee’内的‘PostRank’为Decimal类型成功';
END
