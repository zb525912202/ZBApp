USE [$(DatabaseName)]
GO

BEGIN TRANSACTION
print '--------------------��̨����ͶƱ�б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_BallotView]'))
DROP VIEW [SQ_BallotView]
GO
CREATE VIEW [SQ_BallotView]
AS
SELECT				Ballot.Id,																		--����Id
					Ballot.ObjectName,																--��������
					Ballot.DeptId,																	--����Id					
					Ballot.DeptFullPath,															--����ȫ·��
					Ballot.StartTime,																--��ʼʱ��
					Ballot.EndTime,																	--����ʱ��					
					Ballot.CreateTime,																--����ʱ��					
					Ballot.CreatorId,																--������Id
					Ballot.CreatorName,																--������
					Ballot.BallotState,																--ͶƱ����״̬(��������ͣ)
					a.TotalVoteTimes																--ͶƱ����
FROM				Ballot LEFT JOIN
					(SELECT BallotId,COUNT(*) AS TotalVoteTimes FROM EmployeeBallot GROUP BY BallotId) AS a 
					ON Ballot.Id=a.BallotId
GO

print '--------------------��̨�����ʾ�����б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_SurveyView]'))
DROP VIEW [SQ_SurveyView]
GO
CREATE VIEW [SQ_SurveyView]
AS
SELECT				Survey.Id,																		--����Id
					Survey.ObjectName,																--��������
					Survey.DeptId,																	--����Id					
					Survey.DeptFullPath,															--����ȫ·��
					Survey.StartTime,																--��ʼʱ��
					Survey.EndTime,																	--����ʱ��					
					Survey.CreateTime,																--����ʱ��					
					Survey.CreatorId,																--������Id
					Survey.CreatorName,																--������
					Survey.SurveyState,																--�ʾ����״̬(��������ͣ)
					a.TotalVoteTimes																--ͶƱ����
FROM				Survey LEFT JOIN
					(SELECT SurveyId,COUNT(*) AS TotalVoteTimes FROM EmployeeSurvey GROUP BY SurveyId) AS a 
					ON Survey.Id=a.SurveyId
GO

print '--------------------����ѧϰͶƱ�б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningOnline_BallotView]'))
DROP VIEW [SQ_LearningOnline_BallotView]
GO
CREATE VIEW [SQ_LearningOnline_BallotView]
AS
SELECT				Ballot.Id,																		--����Id
					Ballot.ObjectName,																--��������
					Ballot.DeptId,																	--����Id					
					Ballot.DeptFullPath,															--����ȫ·��
					Ballot.StartTime,																--��ʼʱ��
					Ballot.EndTime,																	--����ʱ��					
					Ballot.CreateTime,																--����ʱ��					
					Ballot.BallotState,																--ͶƱ����״̬(��������ͣ)
					a.TotalVoteTimes																--ͶƱ����
FROM				Ballot LEFT JOIN
					(SELECT BallotId,COUNT(*) AS TotalVoteTimes FROM EmployeeBallot GROUP BY BallotId) AS a 
					ON Ballot.Id=a.BallotId
GO

print '--------------------����ѧϰ�ʾ�����б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LearningOnline_SurveyView]'))
DROP VIEW [SQ_LearningOnline_SurveyView]
GO
CREATE VIEW [SQ_LearningOnline_SurveyView]
AS
SELECT				Survey.Id,																		--����Id
					Survey.ObjectName,																--��������
					Survey.DeptId,																	--����Id					
					Survey.DeptFullPath,															--����ȫ·��
					Survey.StartTime,																--��ʼʱ��
					Survey.EndTime,																	--����ʱ��					
					Survey.CreateTime,																--����ʱ��					
					Survey.SurveyState,																--�ʾ����״̬(��������ͣ)
					a.TotalVoteTimes																--ͶƱ����
FROM				Survey LEFT JOIN
					(SELECT SurveyId,COUNT(*) AS TotalVoteTimes FROM EmployeeSurvey GROUP BY SurveyId) AS a 
					ON Survey.Id=a.SurveyId
GO

COMMIT TRANSACTION

