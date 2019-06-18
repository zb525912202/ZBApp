

--为部门表添加人事数据同步标记
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Dept') AND name='IsSync')
BEGIN
	ALTER TABLE Dept ALTER COLUMN IsSync INT NOT NULL;
	PRINT '修改部门表内的同步标记成功';
END
ELSE
BEGIN
	ALTER TABLE Dept ADD IsSync INT NOT NULL DEFAULT 0;
	PRINT '添加部门表内的同步标记成功';
END

GO


--为岗位表添加人事数据同步标记
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Post') AND name='IsSync')
BEGIN
	ALTER TABLE Post ALTER COLUMN IsSync INT NOT NULL;
	PRINT '修改岗位表内的同步标记成功';
END
ELSE
BEGIN
	ALTER TABLE Post ADD IsSync INT NOT NULL DEFAULT 0;
	PRINT '添加岗位表内的同步标记成功';
END


--为人员表添加人事数据同步标记
IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Employee') AND name='IsSync')
BEGIN
	ALTER TABLE Employee ALTER COLUMN IsSync INT NOT NULL;
	PRINT '修改人员表内的同步标记成功';
END
ELSE
BEGIN
	ALTER TABLE Employee ADD IsSync INT NOT NULL DEFAULT 0;
	PRINT '添加人员表内的同步标记成功';
END


