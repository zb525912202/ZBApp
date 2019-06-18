

--print '--------------------查询部门操作人员视图------------------------------------'
--GO

----智能查询人员带培训员信息视图,增加管理部门级别字段,管理人员类型字段LeaderType，该字段值与TrainerView视图LeaderType值相等
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeWithTrainerInfoView]'))
--DROP VIEW [SQ_EmployeeWithTrainerInfoView]
--GO
--CREATE VIEW [dbo].[SQ_EmployeeWithTrainerInfoView]
--AS
--SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
--(
--SELECT
--		[SQ_EmployeeView].*,
--		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--人员身份(对应LeaderTypeEnum,0为非领导)
--		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--人员是否培训员(0为非培训员)
--		Dept.Depth AS ManagerDepth											--管理部门的级别
--FROM    SQ_EmployeeView
--		LEFT OUTER JOIN Trainer ON SQ_EmployeeView.Id = Trainer.EmployeeId
--		LEFT OUTER JOIN Dept ON Trainer.DeptId = Dept.Id
--) AS A
--GO


--print '--------------------人员任务信息视图------------------------------------'
--GO

----智能查询人员任务信息视图,增加管理部门深度字段
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TaskEmployeeListView]'))
--DROP VIEW [SQ_TaskEmployeeListView]
--GO
--CREATE VIEW [SQ_TaskEmployeeListView]
--AS
--			SELECT
--				 [SQ_EmployeeView].Id AS EmployeeId,										--人员Id			
--				 [SQ_EmployeeView].EmployeeNO,												--人员编号
--				 [SQ_EmployeeView].ObjectName AS EmployeeName,								--姓名
--				 [SQ_EmployeeView].Sex,														--性别
--				 [SQ_EmployeeView].StatusId,												--状态
--				 [SQ_EmployeeView].DeptId,													--所属部门Id
--				 [SQ_EmployeeView].PostRank,												--岗级
--				 [SQ_EmployeeView].DeptFullPath,											--所属部门全路径
--				 [SQ_EmployeeView].FullPath_Search,											--所属部门全路径(查询用)
--				 [SQ_EmployeeView].PostId,													--岗位Id
--				 [SQ_EmployeeView].PostName,												--岗位名称
--				 [SQ_EmployeeView].CategoryId,												--岗位标准Id
--				 [SQ_EmployeeView].Age,														--年龄
--				 [SQ_EmployeeView].Depth,													--所属部门深度
--				 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,							--人员管理部门的部门深度
--				 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,						--领导类型
--				 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,							--培训员
--				 TrainerDepthView.Depth AS ManagerDepth,									--管理部门的深度
--				 ISNULL((SELECT MAX(StdLevelId) FROM EmployeeStdSort 
--				 WHERE EmployeeId=SQ_EmployeeView.Id AND StdKind=1),0) AS JiShuStdLevelId,	--最大职称级别Id
--				 ISNULL((SELECT MAX(StdLevelId) FROM EmployeeStdSort 
--				 WHERE EmployeeId=SQ_EmployeeView.Id AND StdKind=2),0) AS JiNengStdLevelId	--最大职业资格级别Id
--FROM         SQ_EmployeeView
--			 LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
--GO




