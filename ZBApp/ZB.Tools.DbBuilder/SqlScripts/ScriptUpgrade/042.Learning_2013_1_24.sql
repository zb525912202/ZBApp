


PRINT '------ ���ֲ����޸� ------'

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LearningRateRuleGroup') AND name='CalcMode')
BEGIN
	ALTER TABLE LearningRateRuleGroup ADD CalcMode INT NOT NULL DEFAULT 0;
	PRINT '��ӻ��ֲ��Ա��ڵ�CalcMode�����㷽ʽ���ɹ�';
END

GO

DELETE LearningRateRuleItem;
DELETE LearningRateRuleGroup;

PRINT '------ �����ϵ������������������ ------'
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(1,'��ʽ',1.2,0.1,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(2,'���׶�',1.2,0.8,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(3,'����',1,0,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(4,'Сʱ',1.2,0,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(5,'����',1.2,1,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(6,'��������',1500,0,1)

PRINT '------ �����ϵ���������������� ------'
--ѧϰ��ʽ��ϵ��
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(1,1,'����',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(1,2,'�վ�',0,0,1.1,1.1)
																   																		   
--���׶���ϵ��													 																		   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,1,'��',0,1,0.8,0.8)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,2,'����',0,1,0.9,0.9)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,3,'�е�',0,1,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,4,'����',0,1,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,5,'��',0,1,1.2,1.2)
																   																		   
--�����ظ�ѧϰ��Դ������ϵ��									 																		   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,1,'1',0,1,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,2,'2',0,1,0.5,0.5)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,3,'3',0,1,0.2,0.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,4,'����3',2,1,0,0)
																   																		   
--ÿ��ѧϰ�ۼ�ʱ����ϵ��																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,1,'1',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,2,'2',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,3,'3',0,0,1.2,1.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,4,'4',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,5,'5',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,6,'����5',2,0,1,1)
																   																		   
--����ѧϰ���������ϵ��																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,1,'1',0,0,1.2,1.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,2,'2',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,3,'����2',2,1,1,1)

--������������趨																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(6,1,'����ѧϰ',0,0,50,50)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(6,2,'�վ�ѧϰ',0,0,50,50)





IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeResourceStudyDetail]') AND name = N'dta_index_EmployeeResourceStudyDetail_upper')
BEGIN
	DROP INDEX [dta_index_EmployeeResourceStudyDetail_upper] ON [dbo].[EmployeeResourceStudyDetail];
	PRINT 'ɾ��[dta_index_EmployeeResourceStudyDetail_upper]�����ɹ�'
END
GO
CREATE NONCLUSTERED INDEX [dta_index_EmployeeResourceStudyDetail_upper] ON [dbo].[EmployeeResourceStudyDetail] 
(
	[StudyType] ASC,
	[EmployeeId] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC,
	[StudyDate] ASC
)
GO
PRINT '�ؽ�[dta_index_EmployeeResourceStudyDetail_upper]�����ɹ�'


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesStudyDetail]') AND name = N'_dta_index_EmployeeQuesStudyDetail_upper')
BEGIN
	DROP INDEX [_dta_index_EmployeeQuesStudyDetail_upper] ON [dbo].[EmployeeQuesStudyDetail];
	PRINT 'ɾ��[_dta_index_EmployeeQuesStudyDetail_upper]�����ɹ�'
END
GO
CREATE NONCLUSTERED INDEX [_dta_index_EmployeeQuesStudyDetail_upper] ON [dbo].[EmployeeQuesStudyDetail] 
(
	[StudyType] ASC,
	[EmployeeId] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC,
	[StudyDate] ASC
)
GO
PRINT '�ؽ�[_dta_index_EmployeeQuesStudyDetail_upper]�����ɹ�'


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaperStudyDetail]') AND name = N'_dta_index_EmployeePaperStudyDetail_upper')
BEGIN
	DROP INDEX [_dta_index_EmployeePaperStudyDetail_upper] ON [dbo].[EmployeePaperStudyDetail];
	PRINT 'ɾ��[_dta_index_EmployeePaperStudyDetail_upper]�����ɹ�'
END
GO
CREATE NONCLUSTERED INDEX [_dta_index_EmployeePaperStudyDetail_upper] ON [dbo].[EmployeePaperStudyDetail] 
(
	[StudyType] ASC,
	[EmployeeId] ASC,
	[StudyTimeSpan] ASC,
	[LearningPoint] ASC,
	[StudyDate] ASC
)
GO
PRINT '�ؽ�[_dta_index_EmployeePaperStudyDetail_upper]�����ɹ�'

