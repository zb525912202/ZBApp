

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='EmployeeNO' AND prec<>50)
BEGIN
	--存在该字段，则修改，使用 ALTER 语句
	ALTER TABLE Employee ALTER COLUMN EmployeeNO nvarchar(50) NOT NULL;
	PRINT '修改‘Employee’内的‘EmployeeNO’成功';
END

