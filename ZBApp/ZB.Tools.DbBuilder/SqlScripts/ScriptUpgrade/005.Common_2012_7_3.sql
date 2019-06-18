

--修改人员学历学位信息表内的学制为decimal类型，以支持2.5年
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeEdu') AND name='EduLength')
BEGIN
	ALTER TABLE EmployeeEdu ALTER COLUMN EduLength DECIMAL(18,1);
	PRINT '修改‘EmployeeEdu’内的‘EduLength’为Decimal类型成功';
END

