USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

print '--------------------查询部门操作人员视图------------------------------------'
GO
--智能查询人员视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeView]'))
DROP VIEW [SQ_EmployeeView]
GO
CREATE VIEW [SQ_EmployeeView]
AS
	SELECT
		Employee.Id,															--人员Id			
		Employee.EmployeeNO,													--人员编号
		Employee.ObjectName,													--姓名
		Employee.Sex,															--性别
		ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age,			--年龄
		Employee.StatusId,														--状态
		Employee.DeptId,														--所属部门Id
		Employee.PostRank,														--岗级
		Employee.ManageEmployeeGroupId,										--人员管理的组的id
		Employee.SortIndex AS EmployeeSortIndex,

		ISNULL(Dept.FullPath, '') AS DeptFullPath,								--所属部门全路径
		ISNULL(Dept.FullPath, '') + '/' AS FullPath_Search,					--所属部门全路径(查询用)
		ISNULL(Dept.Depth, 0) AS Depth,										--所属部门深度
		Dept.SortIndex  AS DeptSortIndex,
		Dept.DeptIndex,

		ISNULL(Post.Id, 0) as PostId,											--岗位Id
		ISNULL(Post.ObjectName, '') AS PostName,								--岗位名称
		ISNULL(PostStandard.CategoryId,0) AS CategoryId,						--岗位标准Id
		Post.SortIndex AS PostSortIndex
				 				 
	FROM Employee 			 
	LEFT OUTER JOIN Post ON Employee.PostId = Post.Id 
	LEFT OUTER JOIN PostInStandard ON PostInStandard.PostId = Post.Id
	LEFT OUTER JOIN PostStandard ON PostStandard.Id = PostInStandard.StandardId
	LEFT OUTER JOIN Dept ON Employee.DeptId = Dept.Id
GO

--智能查询人员组人员视图
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeGroupView]'))
DROP VIEW[SQ_EmployeeGroupView]
GO
CREATE VIEW [SQ_EmployeeGroupView]
AS
			SELECT
				DISTINCT(Employee.Id),													--人员Id			
				Employee.EmployeeNO,													--人员编号
				Employee.ObjectName,													--姓名
				Employee.Sex,															--性别
				Employee.StatusId,														--状态
				Employee.ManageEmployeeGroupId,											--管理组Id
				Employee.PostRank,														--岗级
				A.GroupName,															--所在组的名称集合
				ISNULL(Post.Id, 0) as PostId,											--岗位Id
				ISNULL(Post.ObjectName, '') AS PostName,								--岗位名称
				ISNULL(Post.CategoryId,0) AS CategoryId,								--岗位标准Id
				ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age				--年龄
FROM		EmployeeInEmployeeGroup
			LEFT JOIN (SELECT DISTINCT EmployeeId,
								STUFF(
								(SELECT ','+ObjectName FROM EmployeeInEmployeeGroup EIG 
								 JOIN EmployeeGroup EG ON EIG.EmployeeGroupId = EG.Id 
								 WHERE EIG.EmployeeId = EmployeeInEmployeeGroup.EmployeeId
								 FOR XML PATH('')),1,1,'')
								 AS GroupName FROM EmployeeInEmployeeGroup) AS A ON A.EmployeeId = EmployeeInEmployeeGroup.EmployeeId
			LEFT JOIN Employee ON Employee.Id=EmployeeInEmployeeGroup.EmployeeId 			 
			LEFT OUTER JOIN Post ON Employee.PostId = Post.Id 
			LEFT OUTER JOIN EmployeeGroup ON EmployeeInEmployeeGroup.EmployeeGroupId = EmployeeGroup.Id

GO

--智能查询人员带培训员信息视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeWithTrainerInfoView]'))
DROP VIEW [SQ_EmployeeWithTrainerInfoView]
GO
CREATE VIEW [dbo].[SQ_EmployeeWithTrainerInfoView]
AS
SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
(
SELECT
		[SQ_EmployeeView].*,
		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--人员身份(对应LeaderTypeEnum,0为非领导)
		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--人员是否培训员(0为非培训员)
		Dept.Depth AS ManagerDepth											--管理部门的级别
FROM    SQ_EmployeeView
		LEFT OUTER JOIN Trainer ON SQ_EmployeeView.Id = Trainer.EmployeeId
		LEFT OUTER JOIN Dept ON Trainer.DeptId = Dept.Id
) AS A
GO

--智能查询人员组人员带培训员信息视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeGroupWithTrainerInfoView]'))
DROP VIEW [SQ_EmployeeGroupWithTrainerInfoView]
GO
CREATE VIEW [dbo].[SQ_EmployeeGroupWithTrainerInfoView]
AS
SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
(
SELECT
		[SQ_EmployeeGroupView].*,
		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--人员身份(对应LeaderTypeEnum,0为非领导)
		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--人员是否培训员(0为非培训员)
		EmployeeGroup.Depth AS ManagerDepth									--管理组的级别
FROM    SQ_EmployeeGroupView
		LEFT OUTER JOIN Trainer ON SQ_EmployeeGroupView.Id = Trainer.EmployeeId
		LEFT OUTER JOIN EmployeeGroup ON Trainer.DeptId = EmployeeGroup.Id
) AS A
GO

--智能查询学习任务人员列表视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainerDepthView]'))
DROP VIEW [TrainerDepthView]
GO
CREATE VIEW [TrainerDepthView]
AS
			SELECT
			     Trainer.EmployeeId,													--人员Id
				 Dept.Depth,															--人员管理部门的部门深度
				 Trainer.LeaderType,													--领导类型
				 Trainer.IsTrainer														--培训员
FROM         Trainer INNER JOIN Dept ON Trainer.DeptId = Dept.Id
GO		

print '--------------------修改人员任务信息视图------------------------------------'
GO
/*智能查询人员任务信息视图,增加管理部门深度字段
  CertTypeId=1 职业资格
  CertTypeId=2 专业技术资格
*/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TaskEmployeeListView]'))
DROP VIEW [SQ_TaskEmployeeListView]
GO
CREATE VIEW [SQ_TaskEmployeeListView]
AS
SELECT
	[SQ_EmployeeView].Id AS EmployeeId,										--人员Id			
	[SQ_EmployeeView].EmployeeNO,											--人员编号
	[SQ_EmployeeView].ObjectName AS EmployeeName,							--姓名
	[SQ_EmployeeView].Sex,													--性别
	[SQ_EmployeeView].StatusId,												--状态
	[SQ_EmployeeView].DeptId,												--所属部门Id
	[SQ_EmployeeView].PostRank,												--岗级
	[SQ_EmployeeView].DeptFullPath,											--所属部门全路径
	[SQ_EmployeeView].FullPath_Search,										--所属部门全路径(查询用)
	[SQ_EmployeeView].PostId,												--岗位Id
	[SQ_EmployeeView].PostName,												--岗位名称
	[SQ_EmployeeView].CategoryId,											--岗位标准Id
	[SQ_EmployeeView].Age,													--年龄
	[SQ_EmployeeView].Depth,												--所属部门深度
	ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,						--人员管理部门的部门深度
	ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,					--领导类型
	ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,						--培训员
	TrainerDepthView.Depth AS ManagerDepth,									--管理部门的深度

	ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
	LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
	WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
	ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--最大职业资格级别Id

	ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
	LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
	WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
	ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId						--最大职称级别Id

	FROM SQ_EmployeeView LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EGTaskEmployeeListView]'))
DROP VIEW [SQ_EGTaskEmployeeListView]
GO
CREATE VIEW [SQ_EGTaskEmployeeListView]
AS
			SELECT
								 [SQ_EmployeeView].Id AS EmployeeId,											--人员Id			
								 [SQ_EmployeeView].EmployeeNO,													--人员编号
								 [SQ_EmployeeView].ObjectName AS EmployeeName,									--姓名
								 [SQ_EmployeeView].Sex,															--性别
								 [SQ_EmployeeView].StatusId,													--状态
								 [SQ_EmployeeView].DeptId,														--所属部门Id
								 [SQ_EmployeeView].PostRank,													--岗级
								 [SQ_EmployeeView].DeptFullPath,												--所属部门全路径
								 [SQ_EmployeeView].FullPath_Search,												--所属部门全路径(查询用)
								 [SQ_EmployeeView].PostId,														--岗位Id
								 [SQ_EmployeeView].PostName,													--岗位名称
								 [SQ_EmployeeView].CategoryId,													--岗位标准Id
								 [SQ_EmployeeView].Age,															--年龄
								 [SQ_EmployeeView].Depth,														--所属部门深度
								 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,								--人员管理部门的部门深度
								 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,							--领导类型
								 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,								--培训员

								  ISNULL([SQ_EmployeeView].ManageEmployeeGroupId,0) AS EmployeeManageEmployeeGroupId,
								 CASE 
								 WHEN [SQ_EmployeeView].ManageEmployeeGroupId=0 THEN '2'
								 ELSE '1' END AS ManageLeaderType,

								 TrainerDepthView.Depth AS ManagerDepth,										--管理部门的深度
								 
								 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
								 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
								 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
								 ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--最大职业资格级别Id

 								 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
								 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
								 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
								 ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId,						--最大职称级别Id

								 A.GroupName,																	--组名
								 A.MinDepth																
			FROM				 SQ_EmployeeView
								 LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
								 LEFT JOIN (SELECT DISTINCT EmployeeId,MIN(EmployeeGroup.Depth) AS MinDepth,
								STUFF(
								(SELECT ','+ObjectName FROM EmployeeInEmployeeGroup EIG 
								 JOIN EmployeeGroup EG ON EIG.EmployeeGroupId = EG.Id 
								 WHERE EIG.EmployeeId = EmployeeInEmployeeGroup.EmployeeId
								 FOR XML PATH('')),1,1,'')
								 AS GroupName FROM EmployeeInEmployeeGroup
								 LEFT JOIN EmployeeGroup	ON EmployeeInEmployeeGroup.EmployeeGroupId=EmployeeGroup.Id
								 GROUP BY EmployeeInEmployeeGroup.EmployeeId) AS A ON A.EmployeeId = SQ_EmployeeView.Id
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_LoginEmployeeListView]'))
DROP VIEW [SQ_LoginEmployeeListView]
GO
CREATE VIEW [SQ_LoginEmployeeListView]
AS
			SELECT
				 [SQ_EmployeeView].*,
				 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,							--人员管理部门的部门深度
				 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,						--领导类型
				 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,							--培训员
				 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
				 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
				 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
				 ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--最大职业资格级别Id

 				 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
				 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
				 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
				 ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId						--最大职称级别Id
FROM         SQ_EmployeeView
			 LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[PostView]'))
DROP VIEW [PostView]
GO
CREATE VIEW [PostView]
AS
		SELECT			Post.Id, 
						Post.DeptId, 
						Post.ObjectName, 
						Post.SortIndex, 						
						Dept.Depth, 
						Dept.FullPath + '/' AS FullPath_Search
		FROM     Dept RIGHT OUTER JOIN
                      Post ON Dept.Id = Post.DeptId					  
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EmployeeIdRoleNameView]'))
DROP VIEW [EmployeeIdRoleNameView]
GO
CREATE VIEW [EmployeeIdRoleNameView]
AS
		SELECT			UserInRole.EmployeeId, 
						[Role].Id,
						[Role].ObjectName
		FROM     UserInRole INNER JOIN
					[Role] ON UserInRole.RoleId = Role.Id					  
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EmployeeIdRoleListStringView]'))
DROP VIEW [EmployeeIdRoleListStringView]
GO
CREATE VIEW [EmployeeIdRoleListStringView]
AS
		SELECT			B.EmployeeId,
						LEFT(UserList,LEN(UserList)-1) as RoleListString
						FROM (SELECT EmployeeId,(SELECT ObjectName+',' FROM EmployeeIdRoleNameView WHERE EmployeeId=A.EmployeeId ORDER BY ID FOR XML PATH('')) AS UserList
						FROM EmployeeIdRoleNameView A GROUP BY EmployeeId) B
GO

--培训员视图 TrainerView
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainerView]'))
DROP VIEW TrainerView
GO
CREATE VIEW TrainerView
AS
	SELECT	Employee.Id,																	--人员ID
			Employee.DeptId,																--人员所在部门的部门Id
			Employee.PostId,																--人员岗位ID
			Employee.Sex,																	--人员性别
			Employee.EmployeeNO,															--人员工号
			Employee.ObjectName,															--人员姓名
			Trainer.LeaderType,																--领导类型(0:无 1:正职 2:副职 3:普通)
			Trainer.IsTrainer,																--是否是培训员
			Trainer.IsManageTrain,															--是否培训专属
			Trainer.ManageType,																--专属类型(培训专属，证书专属)
			Trainer.DeptId AS ManageDeptId,													--人员管理部门的Id
			Dept.SortIndex AS DeptSortIndex,												--所在部门的顺序
			Post.SortIndex AS PostSortIndex,												--岗位顺序
			Employee.SortIndex AS EmployeeSortIndex,										--人员排序号
			Dept.FullPath AS DeptFullPath,													--人员所在部门的全路径
			Dept1.FullPath AS ManageDeptFullPath,											--人员所管理部门的全路径
			Dept1.FullPath + '/' AS FullPath_Search,										--检索子级部门时用到的必要查询字段
			CASE Dept1.DeptType WHEN 0 THEN Dept1.Depth ELSE Dept1.Depth+1 END AS Depth,	--部门的真实深度，如果管理部门类型为部门组时，该培训员管理部门的深度应该+1级，如:管理本部的应该是2级部门的培训员																--人员管理部门的部门深度
			Dept1.SortIndex,																--部门位置
			ISNULL(Post.ObjectName, '') AS PostName,										--岗位名称
			ISNULL(EmployeeIdRoleListStringView.RoleListString,'') AS RoleListString,		--角色名称列表(逗号分隔)
			Trainer.IsTrainer * 100 + Trainer.LeaderType AS TrainerType,						--对应TrainerTypeEnum
			ManageType.ObjectName AS ManageTypeName
	FROM	Employee 
	INNER JOIN Trainer ON Employee.Id = Trainer.EmployeeId
	INNER JOIN Dept ON Employee.DeptId = Dept.Id
	INNER JOIN Dept AS Dept1 ON Trainer.DeptId = Dept1.Id
	LEFT OUTER JOIN Post ON Employee.PostId = Post.Id
	LEFT OUTER JOIN EmployeeIdRoleListStringView ON Employee.Id = EmployeeIdRoleListStringView.EmployeeId
	LEFT JOIN ManageType ON ManageType.Id=Trainer.ManageType
GO

--人员基本信息导出视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EmployeeBaseInfoExportView]'))
DROP VIEW [EmployeeBaseInfoExportView]
GO
CREATE VIEW [EmployeeBaseInfoExportView]
AS
	SELECT E.EmployeeNO,
	E.ObjectName,
	D.Depth,
	D.FullPath AS DeptFullPath,
	ISNULL(P.ObjectName,'') AS PostName,
	ISNULL(PC.ObjectName,'') AS PostCategory,
	E.PostRank,
	ISNULL(ES.ObjectName,'') AS EmployeeStatus,
	E.Sex,
	E.Birthday AS Birthday,
	ISNULL(E.IdCard,'') AS IdCard
	FROM Employee E
	JOIN Dept D ON D.Id = E.DeptId
	LEFT JOIN Post P ON P.Id = E.PostId
	LEFT JOIN PostCategory PC ON PC.Id = P.CategoryId
	LEFT JOIN EmployeeStatus ES ON ES.Id = E.StatusId
GO

print '--------------------查询培训师的视图-----------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TEACHERVIEW]'))
DROP VIEW [SQ_TEACHERVIEW]
GO
CREATE VIEW [SQ_TEACHERVIEW]
AS
SELECT 
		Teacher.EmployeeId,
		Teacher.TeacherLevelId,	
		Teacher.IsOutSideTeacher,
		TeacherLevel.ObjectName AS TeacherLevelName,													
        Employee.EmployeeNO,													
        Employee.ObjectName,													
        Employee.Sex,	
        ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age,																					 
        Employee.DeptId,	
        Employee.PostId,
        ISNULL((CASE WHEN Employee.DeptId<0 THEN Employee.OutsideDeptFullPath ELSE Dept.FullPath END), '') AS DeptFullPath,
        Post.ObjectName as PostName     								
FROM    Teacher
		LEFT JOIN TeacherLevel ON Teacher.TeacherLevelId=TeacherLevel.Id
		LEFT JOIN Employee ON Teacher.EmployeeId=Employee.Id
        LEFT JOIN Dept ON Employee.DeptId = Dept.Id
        LEFT JOIN Post ON Employee.PostId=Post.Id
			                                         

GO

--------------------------------------------------人员组视图--------------------------------------------------------
print '--------------------查询人员组的所有信息的视图--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeGroupMainView]'))
DROP VIEW [SQ_EmployeeGroupMainView]
GO
CREATE VIEW [SQ_EmployeeGroupMainView]
AS
SELECT 
			Employee.*,
			ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age,
			Dept.FullPath AS DeptFullPath,
			Post.ObjectName AS PostName,
			ISNULL(Trainer.IsTrainer,0) AS IsTrainer,	
			ISNULL(Employee.ManageEmployeeGroupId,0) AS EmployeeManageEmployeeGroupId,
			CASE 
			WHEN Employee.ManageEmployeeGroupId=0 THEN '2'
			ELSE '1' END AS LeaderType,
			A.GroupName AS GroupNameList,
			A.MinDepth
FROM		Employee			
			LEFT JOIN Dept ON Dept.Id=Employee.DeptId			
			LEFT JOIN (SELECT DISTINCT EmployeeId,MIN(EmployeeGroup.Depth) AS MinDepth,
					STUFF(
					(SELECT ','+ObjectName FROM EmployeeInEmployeeGroup EIG 
					 JOIN EmployeeGroup EG ON EIG.EmployeeGroupId = EG.Id 
					 WHERE EIG.EmployeeId = EmployeeInEmployeeGroup.EmployeeId
					 FOR XML PATH('')),1,1,'')
					 AS GroupName FROM EmployeeInEmployeeGroup 
					 LEFT JOIN EmployeeGroup ON EmployeeInEmployeeGroup.EmployeeGroupId=EmployeeGroup.Id 
					 GROUP BY EmployeeInEmployeeGroup.EmployeeId) AS A 
					 ON Employee.Id=A.EmployeeId
			LEFT JOIN Post ON Employee.PostId=Post.Id
			LEFT JOIN Trainer ON Employee.Id=Trainer.EmployeeId
			
GO


print '--------------------查询人员组的管理人员的视图--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_ManagerGroupView]'))
DROP VIEW [SQ_ManagerGroupView]
GO
CREATE VIEW [SQ_ManagerGroupView]
AS
SELECT 
			Employee.Id,
			Employee.EmployeeNO,
			Employee.ObjectName,
			Dept.FullPath AS DeptFullPath,
			EmployeeGroup.Id AS GroupId,
			EmployeeGroup.Depth,
			EmployeeGroup.FullPath AS GroupFullPath,
			A.GroupName AS GroupNameList 
FROM		Employee 
			LEFT JOIN Dept ON Employee.DeptId =Dept.Id
			LEFT JOIN EmployeeGroup ON Employee.ManageEmployeeGroupId=EmployeeGroup.Id
			LEFT JOIN (SELECT DISTINCT EmployeeId,MIN(EmployeeGroup.Depth) AS MinDepth,
					STUFF(
					(SELECT ','+ObjectName FROM EmployeeInEmployeeGroup EIG 
					 JOIN EmployeeGroup EG ON EIG.EmployeeGroupId = EG.Id 
					 WHERE EIG.EmployeeId = EmployeeInEmployeeGroup.EmployeeId
					 FOR XML PATH('')),1,1,'')
					 AS GroupName FROM EmployeeInEmployeeGroup 
					 LEFT JOIN EmployeeGroup ON EmployeeInEmployeeGroup.EmployeeGroupId=EmployeeGroup.Id 
					 GROUP BY EmployeeInEmployeeGroup.EmployeeId) AS A 
					 ON Employee.Id=A.EmployeeId
GO

print '--------------------2014/4/3查询人员证书分类的视图 SK--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeCertView]'))
DROP VIEW [SQ_EmployeeCertView]
GO
CREATE VIEW [SQ_EmployeeCertView]
AS
SELECT		EmployeeCert.*,
			CertType.ObjectName AS CertTypeName,
			CertTypeLevel.ObjectName AS CertTypeLevelName,
			CertTypeKind.FullPath AS CertTypeKindFullPath,
			Employee.EmployeeNO,
			Employee.ObjectName AS EmployeeName,
			CertPublisher.FullPath AS CertPublisherFullPath
FROM		EmployeeCert
			LEFT JOIN CertType ON EmployeeCert.CertTypeId = CertType.Id
			LEFT JOIN CertTypeLevel ON EmployeeCert.CertTypeLevelId = CertTypeLevel.Id
			LEFT JOIN CertTypeKind ON EmployeeCert.CertTypeKindId = CertTypeKind.Id
			LEFT JOIN Employee ON EmployeeCert.EmployeeId = Employee.Id
			LEFT JOIN CertPublisher ON EmployeeCert.CertPublisherId = CertPublisher.Id
GO

print '--------------------2014/4/15查询证书上报的视图 CTG--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_CertSendupView]'))
DROP VIEW [SQ_CertSendupView]
GO
CREATE VIEW [SQ_CertSendupView]
AS
SELECT		EmployeeCert.*,
			Employee.ObjectName AS EmployeeName,
			Employee.Mobile AS EmployeeMobile,
            Employee.Email AS EmployeeEmail,
			CertType.ObjectName AS CertTypeName,
			CertTypeLevel.ObjectName AS CertTypeLevelName,
			CertTypeKind.FullPath AS CertTypeKindFullPath,
			CertPublisher.FullPath AS CertPublisherFullPath,
			CertTypeKind.ParentId AS CertTypeKindParentId,
			CertTypeKind.SortIndex AS CertTypeKindSortIndex,
			CertTypeLevel.SortIndex AS CertTypeLevelSortIndex,
			a.OperateInfo
FROM		EmployeeCert
			INNER JOIN Employee ON  EmployeeCert.EmployeeId = Employee.Id
			INNER JOIN (SELECT * FROM EmployeeCertFlow WHERE Id IN (SELECT MAX(Id) FROM EmployeeCertFlow GROUP BY EmployeeCertId)) AS a ON  EmployeeCert.Id=a.EmployeeCertId
			INNER JOIN CertType ON EmployeeCert.CertTypeId=CertType.Id
			LEFT JOIN CertTypeLevel ON EmployeeCert.CertTypeLevelId=CertTypeLevel.Id
			INNER JOIN CertTypeKind ON EmployeeCert.CertTypeKindId=CertTypeKind.Id
			LEFT JOIN CertPublisher ON EmployeeCert.CertPublisherId=CertPublisher.Id   
GO

print '--------------------2014/4/24查询证书审核历史视图 YHX--------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeCertFlowList]'))
DROP VIEW [SQ_EmployeeCertFlowList]
GO
CREATE VIEW [SQ_EmployeeCertFlowList]
AS
SELECT		employeeCertId,
			OperateTime,
			OperaterName,
			AuditState,
			OperateInfo			
FROM		EmployeeCertFlow		
GO

print '--------------------2014/7/9 人员管理员选择控件 --------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_SelectTrainerInfoView]'))
DROP VIEW [SQ_SelectTrainerInfoView]
GO
CREATE VIEW [SQ_SelectTrainerInfoView]
AS
SELECT		SQ_EmployeeWithTrainerInfoView.*,
			TrainerView.FullPath_Search AS TrainerFullPath_Search 
FROM		TrainerView 
LEFT JOIN	SQ_EmployeeWithTrainerInfoView ON TrainerView.Id = SQ_EmployeeWithTrainerInfoView.Id	
GO



print '--------------------2015/6/3 岗位标准视图 --------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[PostStandardView]'))
DROP VIEW [PostStandardView]
GO
CREATE VIEW [PostStandardView]
AS
	SELECT PostStandard.*,PostSubject.ObjectName AS SubjectName,StandardCategory.ObjectName AS CategoryName
	FROM PostStandard
	LEFT JOIN PostSubject ON PostStandard.SubjectId =PostSubject.Id
	LEFT JOIN StandardCategory ON StandardCategory.Id = PostStandard.CategoryId
GO		

COMMIT TRANSACTION