IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('PaperPackage') AND name='Remark')
BEGIN
	ALTER TABLE PaperPackage ADD Remark NVARCHAR(400) NULL;
	PRINT '添加PaperPackage的Remark成功';
END
GO