


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeQuesStudyDetail') AND name='AppStudyTimeSpan')
BEGIN
	ALTER TABLE EmployeeQuesStudyDetail ADD AppStudyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeQuesStudyDetail’的‘AppStudyTimeSpan’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeQuesStudyDetail') AND name='AppLearningPoint')
BEGIN
	ALTER TABLE EmployeeQuesStudyDetail ADD AppLearningPoint DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeQuesStudyDetail’的‘AppLearningPoint’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeQuesStudyDetail') AND name='AppRightCount')
BEGIN
	ALTER TABLE EmployeeQuesStudyDetail ADD AppRightCount INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeQuesStudyDetail’的‘AppRightCount’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeQuesStudyDetail') AND name='AppWrongCount')
BEGIN
	ALTER TABLE EmployeeQuesStudyDetail ADD AppWrongCount INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeQuesStudyDetail’的‘AppWrongCount’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeePaperStudyDetail') AND name='AppStudyTimeSpan')
BEGIN
	ALTER TABLE EmployeePaperStudyDetail ADD AppStudyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeePaperStudyDetail’的‘AppStudyTimeSpan’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeePaperStudyDetail') AND name='AppLearningPoint')
BEGIN
	ALTER TABLE EmployeePaperStudyDetail ADD AppLearningPoint DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeePaperStudyDetail’的‘AppLearningPoint’成功';
END
GO



IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeResourceStudyDetail') AND name='AppStudyTimeSpan')
BEGIN
	ALTER TABLE EmployeeResourceStudyDetail ADD AppStudyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeResourceStudyDetail’的‘AppStudyTimeSpan’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeResourceStudyDetail') AND name='AppLearningPoint')
BEGIN
	ALTER TABLE EmployeeResourceStudyDetail ADD AppLearningPoint DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeResourceStudyDetail’的‘AppLearningPoint’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeNetClassStudyDetail') AND name='AppStudyTimeSpan')
BEGIN
	ALTER TABLE EmployeeNetClassStudyDetail ADD AppStudyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeNetClassStudyDetail’的‘AppStudyTimeSpan’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeNetClassStudyDetail') AND name='AppLearningPoint')
BEGIN
	ALTER TABLE EmployeeNetClassStudyDetail ADD AppLearningPoint DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeNetClassStudyDetail’的‘AppLearningPoint’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeLessonStudyDetail') AND name='AppStudyTimeSpan')
BEGIN
	ALTER TABLE EmployeeLessonStudyDetail ADD AppStudyTimeSpan INT NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeLessonStudyDetail’的‘AppStudyTimeSpan’成功';
END
GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('EmployeeLessonStudyDetail') AND name='AppLearningPoint')
BEGIN
	ALTER TABLE EmployeeLessonStudyDetail ADD AppLearningPoint DECIMAL(18,1) NOT NULL DEFAULT 0;
	PRINT '添加‘EmployeeLessonStudyDetail’的‘AppLearningPoint’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('QuesStudyPosition') AND name='LastUpdateDate')
BEGIN
	ALTER TABLE QuesStudyPosition ADD LastUpdateDate DATETIME NOT NULL DEFAULT GETDATE();
	PRINT '添加‘QuesStudyPosition’的‘LastUpdateDate’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('ResourceStudyPosition') AND name='LastUpdateDate')
BEGIN
	ALTER TABLE ResourceStudyPosition ADD LastUpdateDate DATETIME NOT NULL DEFAULT GETDATE();
	PRINT '添加‘ResourceStudyPosition’的‘LastUpdateDate’成功';
END
GO


IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('AlbumStudyPosition') AND name='LastUpdateDate')
BEGIN
	ALTER TABLE AlbumStudyPosition ADD LastUpdateDate DATETIME NOT NULL DEFAULT GETDATE();
	PRINT '添加‘AlbumStudyPosition’的‘LastUpdateDate’成功';
END
GO
