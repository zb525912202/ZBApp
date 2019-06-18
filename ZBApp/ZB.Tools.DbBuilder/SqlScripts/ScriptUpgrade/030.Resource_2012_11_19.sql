

PRINT '����ֶε�[Comment]��'

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='SourceName')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [SourceName] NVARCHAR(255);
	PRINT '�޸ġ�[Comment]���ڵġ�SourceName���ɹ�';
END
ELSE
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE [Comment] ADD [SourceName] NVARCHAR(255);
	PRINT '��ӡ�[Comment]���ڵġ�[SourceName]���ɹ�';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='EmployeeNO')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [EmployeeNO] NVARCHAR(50);
	PRINT '�޸ġ�[Comment]���ڵġ�EmployeeNO���ɹ�';
END
ELSE
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE [Comment] ADD [EmployeeNO] NVARCHAR(50);
	PRINT '��ӡ�[Comment]���ڵġ�[EmployeeNO]���ɹ�';
END
GO

IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='DeptFullPath')
BEGIN
	ALTER TABLE [Comment] ALTER COLUMN [DeptFullPath] NVARCHAR(260);
	PRINT '�޸ġ�[Comment]���ڵġ�DeptFullPath���ɹ�';
END
ELSE
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE [Comment] ADD [DeptFullPath] NVARCHAR(260);
	PRINT '��ӡ�[Comment]���ڵġ�[DeptFullPath]���ɹ�';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Comment') AND name='IsIgnore')
BEGIN
	--�����ڸ��ֶΣ�����ӣ�ʹ�� ADD ���
	ALTER TABLE [Comment] ADD [IsIgnore] BIT NOT NULL DEFAULT(0);
	PRINT '��ӡ�[Comment]���ڵġ�IsIgnore���ɹ�';
END
GO
