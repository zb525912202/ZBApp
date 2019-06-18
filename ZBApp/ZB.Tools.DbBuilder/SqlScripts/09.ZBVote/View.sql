USE [$(DatabaseName)]
GO

BEGIN TRANSACTION
print '--------------------后台管理投票列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_BallotView]'))
DROP VIEW [SQ_BallotView]
GO
CREATE VIEW [SQ_BallotView]
AS
SELECT				Ballot.Id,																		--任务Id
					Ballot.ObjectName,																--任务名称
					Ballot.DeptId,																	--部门Id					
					Ballot.DeptFullPath,															--部门全路径
					Ballot.StartTime,																--开始时间
					Ballot.EndTime,																	--结束时间					
					Ballot.CreateTime,																--创建时间					
					Ballot.CreatorId,																--创建人Id
					Ballot.CreatorName,																--创建人
					Ballot.BallotState,																--投票调查状态(发布、暂停)
					a.TotalVoteTimes																--投票次数
FROM				Ballot LEFT JOIN
					(SELECT BallotId,COUNT(*) AS TotalVoteTimes FROM EmployeeBallot GROUP BY BallotId) AS a 
					ON Ballot.Id=a.BallotId
GO

print '--------------------后台管理问卷调查列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_SurveyView]'))
DROP VIEW [SQ_SurveyView]
GO
CREATE VIEW [SQ_SurveyView]
AS
SELECT				Survey.Id,																		--任务Id
					Survey.ObjectName,																--任务名称
					Survey.DeptId,																	--部门Id					
					Survey.DeptFullPath,															--部门全路径
					Survey.StartTime,																--开始时间
					Survey.EndTime,																	--结束时间					
					Survey.CreateTime,																--创建时间					
					Survey.CreatorId,																--创建人Id
					Survey.CreatorName,																--创建人
					Survey.SurveyState,																--问卷调查状态(发布、暂停)
					a.TotalVoteTimes																--投票次数
FROM				Survey LEFT JOIN
					(SELECT SurveyId,COUNT(*) AS TotalVoteTimes FROM EmployeeSurvey GROUP BY SurveyId) AS a 
					ON Survey.Id=a.SurveyId
GO

print '--------------------网络学习投票列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningOnline_BallotView]'))
DROP VIEW [SQ_LearningOnline_BallotView]
GO
CREATE VIEW [SQ_LearningOnline_BallotView]
AS
SELECT				Ballot.Id,																		--任务Id
					Ballot.ObjectName,																--任务名称
					Ballot.DeptId,																	--部门Id					
					Ballot.DeptFullPath,															--部门全路径
					Ballot.StartTime,																--开始时间
					Ballot.EndTime,																	--结束时间					
					Ballot.CreateTime,																--创建时间					
					Ballot.BallotState,																--投票调查状态(发布、暂停)
					a.TotalVoteTimes																--投票次数
FROM				Ballot LEFT JOIN
					(SELECT BallotId,COUNT(*) AS TotalVoteTimes FROM EmployeeBallot GROUP BY BallotId) AS a 
					ON Ballot.Id=a.BallotId
GO

print '--------------------网络学习问卷调查列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningOnline_SurveyView]'))
DROP VIEW [SQ_LearningOnline_SurveyView]
GO
CREATE VIEW [SQ_LearningOnline_SurveyView]
AS
SELECT				Survey.Id,																		--任务Id
					Survey.ObjectName,																--任务名称
					Survey.DeptId,																	--部门Id					
					Survey.DeptFullPath,															--部门全路径
					Survey.StartTime,																--开始时间
					Survey.EndTime,																	--结束时间					
					Survey.CreateTime,																--创建时间					
					Survey.SurveyState,																--问卷调查状态(发布、暂停)
					a.TotalVoteTimes																--投票次数
FROM				Survey LEFT JOIN
					(SELECT SurveyId,COUNT(*) AS TotalVoteTimes FROM EmployeeSurvey GROUP BY SurveyId) AS a 
					ON Survey.Id=a.SurveyId
GO

COMMIT TRANSACTION

