

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeePaperStudyDetail') AND name='PaperName')
BEGIN
	ALTER TABLE EmployeePaperStudyDetail ALTER COLUMN PaperName NVARCHAR(300);
	PRINT '修改人员试卷学习记录的PaperName字段长度成功';
END