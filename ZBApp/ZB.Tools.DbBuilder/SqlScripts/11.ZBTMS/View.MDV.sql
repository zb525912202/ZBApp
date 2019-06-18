PRINT '--------------------培训班表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingOnWork_TrainingWorkClass]'))
DROP VIEW [MDV_TrainingOnWork_TrainingWorkClass];
GO
CREATE VIEW [MDV_TrainingOnWork_TrainingWorkClass]
AS
	SELECT TW.*, TWC.* FROM TrainingOnWork TW
	JOIN TrainingWorkClass TWC 
	ON TWC.WorkId = TW.Id
GO


PRINT '--------------------考试表视图------------------------------------'
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingOnWork_TrainingWorkExam]'))
DROP VIEW [MDV_TrainingOnWork_TrainingWorkExam];
GO
CREATE VIEW [MDV_TrainingOnWork_TrainingWorkExam]
AS
	SELECT TW.*, TWE.* FROM TrainingOnWork TW
	JOIN TrainingWorkExam TWE 
	ON TWE.WorkId = TW.Id
GO