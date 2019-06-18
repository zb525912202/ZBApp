


PRINT '------ 积分策略修改 ------'

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('LearningRateRuleGroup') AND name='CalcMode')
BEGIN
	ALTER TABLE LearningRateRuleGroup ADD CalcMode INT NOT NULL DEFAULT 0;
	PRINT '添加积分策略表内的CalcMode（计算方式）成功';
END

GO

DELETE LearningRateRuleItem;
DELETE LearningRateRuleGroup;

PRINT '------ 向积分系数规则项组表插入数据 ------'
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(1,'方式',1.2,0.1,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(2,'难易度',1.2,0.8,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(3,'次数',1,0,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(4,'小时',1.2,0,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(5,'天数',1.2,1,0)
INSERT INTO [LearningRateRuleGroup]([Id],[XTitle],[MaxRate],[MinRate],[CalcMode]) VALUES(6,'积分上限',1500,0,1)

PRINT '------ 向积分系数规则项表插入数据 ------'
--学习方式与系数
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(1,1,'开卷',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(1,2,'闭卷',0,0,1.1,1.1)
																   																		   
--难易度与系数													 																		   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,1,'易',0,1,0.8,0.8)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,2,'较易',0,1,0.9,0.9)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,3,'中等',0,1,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,4,'较难',0,1,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(2,5,'难',0,1,1.2,1.2)
																   																		   
--月内重复学习资源次数与系数									 																		   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,1,'1',0,1,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,2,'2',0,1,0.5,0.5)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,3,'3',0,1,0.2,0.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(3,4,'大于3',2,1,0,0)
																   																		   
--每天学习累计时间与系数																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,1,'1',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,2,'2',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,3,'3',0,0,1.2,1.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,4,'4',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,5,'5',0,0,1,1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(4,6,'大于5',2,0,1,1)
																   																		   
--连续学习间隔周期与系数																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,1,'1',0,0,1.2,1.2)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,2,'2',0,0,1.1,1.1)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(5,3,'大于2',2,1,1,1)

--各项积分上限设定																												   
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(6,1,'开卷学习',0,0,50,50)
INSERT INTO [LearningRateRuleItem]([LearningGroupRuleId],[RuleKey],[ObjectName],[ComputeType],[IsReadOnly],[DefaultRate],[Rate])VALUES(6,2,'闭卷学习',0,0,50,50)





IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeResourceStudyDetail]') AND name = N'dta_index_EmployeeResourceStudyDetail_upper')
BEGIN
	DROP INDEX [dta_index_EmployeeResourceStudyDetail_upper] ON [dbo].[EmployeeResourceStudyDetail];
	PRINT '删除[dta_index_EmployeeResourceStudyDetail_upper]索引成功'
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
PRINT '重建[dta_index_EmployeeResourceStudyDetail_upper]索引成功'


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeQuesStudyDetail]') AND name = N'_dta_index_EmployeeQuesStudyDetail_upper')
BEGIN
	DROP INDEX [_dta_index_EmployeeQuesStudyDetail_upper] ON [dbo].[EmployeeQuesStudyDetail];
	PRINT '删除[_dta_index_EmployeeQuesStudyDetail_upper]索引成功'
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
PRINT '重建[_dta_index_EmployeeQuesStudyDetail_upper]索引成功'


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeePaperStudyDetail]') AND name = N'_dta_index_EmployeePaperStudyDetail_upper')
BEGIN
	DROP INDEX [_dta_index_EmployeePaperStudyDetail_upper] ON [dbo].[EmployeePaperStudyDetail];
	PRINT '删除[_dta_index_EmployeePaperStudyDetail_upper]索引成功'
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
PRINT '重建[_dta_index_EmployeePaperStudyDetail_upper]索引成功'

