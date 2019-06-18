print '--------------------培训班表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingWork_TrainingClass]'))
DROP VIEW [MDV_TrainingWork_TrainingClass]
GO
CREATE VIEW [MDV_TrainingWork_TrainingClass]
AS
SELECT				TrainingWork.*,
					TrainingClass.*
FROM				TrainingWork INNER JOIN TrainingClass 
					ON TrainingWork.Id=TrainingClass.TrainingWorkId
GO

print '--------------------培训班培训师视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingEmployee_TcTeacher]'))
DROP VIEW [MDV_TrainingEmployee_TcTeacher]
GO
CREATE VIEW [MDV_TrainingEmployee_TcTeacher]
AS
SELECT				TrainingEmployee.*,
					TcTeacher.*
FROM				TrainingEmployee INNER JOIN TcTeacher 
					ON TrainingEmployee.Id=TcTeacher.TrainingEmployeeId
GO

print '--------------------学员表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingEmployee_TcTrainee]'))
DROP VIEW [MDV_TrainingEmployee_TcTrainee]
GO
CREATE VIEW [MDV_TrainingEmployee_TcTrainee]
AS
SELECT				TrainingEmployee.*,
					TcTrainee.*
FROM				TrainingEmployee INNER JOIN TcTrainee 
					ON TrainingEmployee.Id=TcTrainee.TrainingEmployeeId
GO

print '--------------------考试表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingWork_TrainingExam]'))
DROP VIEW [MDV_TrainingWork_TrainingExam]
GO
CREATE VIEW [MDV_TrainingWork_TrainingExam]
AS
SELECT				TrainingWork.*,
					TrainingExam.*
FROM				TrainingWork INNER JOIN TrainingExam 
					ON TrainingWork.Id=TrainingExam.TrainingWorkId
GO


print '--------------------考试考生表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingEmployee_TeTrainee]'))
DROP VIEW [MDV_TrainingEmployee_TeTrainee]
GO
CREATE VIEW [MDV_TrainingEmployee_TeTrainee]
AS
SELECT				TrainingEmployee.*,
					TeTrainee.*
FROM				TrainingEmployee INNER JOIN TeTrainee 
					ON TrainingEmployee.Id=TeTrainee.TrainingEmployeeId
GO

--print '--------------------学历学员表视图------------------------------------'
--GO
--IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingEmployee_EduTrainee]'))
--DROP VIEW [MDV_TrainingEmployee_EduTrainee]
--GO
--CREATE VIEW [MDV_TrainingEmployee_EduTrainee]
--AS
--SELECT				TrainingEmployee.*,
--					EduTrainee.*
--FROM				TrainingEmployee INNER JOIN EduTrainee 
--					ON TrainingEmployee.Id=EduTrainee.TrainingEmployeeId
--GO

print '--------------------评定项学员表视图------------------------------------'
GO
IF EXISTS (SELECT * FROM sys.views WHERE object_id=OBJECT_ID(N'[MDV_TrainingEmployee_JudgeTrainee]'))
DROP VIEW [MDV_TrainingEmployee_JudgeTrainee]
GO
CREATE VIEW [MDV_TrainingEmployee_JudgeTrainee]
AS
SELECT				TrainingEmployee.*,
					JudgeTrainee.*,
					TrainingWork.DeptId AS JudgeDeptId,
					TrainingWork.DeptFullPath AS JudgeDeptFullPath,
					TrainingBill.Amount
FROM				TrainingEmployee INNER JOIN JudgeTrainee 
					ON TrainingEmployee.Id=JudgeTrainee.TrainingEmployeeId
					LEFT JOIN TrainingWork ON TrainingEmployee.TrainingWorkId=TrainingWork.Id
					LEFT JOIN TrainingBill on TrainingWork.Id =TrainingBill.TrainingWorkId
GO

