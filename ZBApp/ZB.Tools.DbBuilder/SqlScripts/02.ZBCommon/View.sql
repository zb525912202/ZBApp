USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

print '--------------------��ѯ���Ų�����Ա��ͼ------------------------------------'
GO
--���ܲ�ѯ��Ա��ͼ
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeView]'))
DROP VIEW [SQ_EmployeeView]
GO
CREATE VIEW [SQ_EmployeeView]
AS
	SELECT
		Employee.Id,															--��ԱId			
		Employee.EmployeeNO,													--��Ա���
		Employee.ObjectName,													--����
		Employee.Sex,															--�Ա�
		ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age,			--����
		Employee.StatusId,														--״̬
		Employee.DeptId,														--��������Id
		Employee.PostRank,														--�ڼ�
		Employee.ManageEmployeeGroupId,										--��Ա��������id
		Employee.SortIndex AS EmployeeSortIndex,

		ISNULL(Dept.FullPath, '') AS DeptFullPath,								--��������ȫ·��
		ISNULL(Dept.FullPath, '') + '/' AS FullPath_Search,					--��������ȫ·��(��ѯ��)
		ISNULL(Dept.Depth, 0) AS Depth,										--�����������
		Dept.SortIndex  AS DeptSortIndex,
		Dept.DeptIndex,

		ISNULL(Post.Id, 0) as PostId,											--��λId
		ISNULL(Post.ObjectName, '') AS PostName,								--��λ����
		ISNULL(PostStandard.CategoryId,0) AS CategoryId,						--��λ��׼Id
		Post.SortIndex AS PostSortIndex
				 				 
	FROM Employee 			 
	LEFT OUTER JOIN Post ON Employee.PostId = Post.Id 
	LEFT OUTER JOIN PostInStandard ON PostInStandard.PostId = Post.Id
	LEFT OUTER JOIN PostStandard ON PostStandard.Id = PostInStandard.StandardId
	LEFT OUTER JOIN Dept ON Employee.DeptId = Dept.Id
GO

--���ܲ�ѯ��Ա����Ա��ͼ
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeGroupView]'))
DROP VIEW[SQ_EmployeeGroupView]
GO
CREATE VIEW [SQ_EmployeeGroupView]
AS
			SELECT
				DISTINCT(Employee.Id),													--��ԱId			
				Employee.EmployeeNO,													--��Ա���
				Employee.ObjectName,													--����
				Employee.Sex,															--�Ա�
				Employee.StatusId,														--״̬
				Employee.ManageEmployeeGroupId,											--������Id
				Employee.PostRank,														--�ڼ�
				A.GroupName,															--����������Ƽ���
				ISNULL(Post.Id, 0) as PostId,											--��λId
				ISNULL(Post.ObjectName, '') AS PostName,								--��λ����
				ISNULL(Post.CategoryId,0) AS CategoryId,								--��λ��׼Id
				ISNULL(dbo.GetAge(Employee.Birthday, GETDATE()), 0) AS Age				--����
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

--���ܲ�ѯ��Ա����ѵԱ��Ϣ��ͼ
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeWithTrainerInfoView]'))
DROP VIEW [SQ_EmployeeWithTrainerInfoView]
GO
CREATE VIEW [dbo].[SQ_EmployeeWithTrainerInfoView]
AS
SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
(
SELECT
		[SQ_EmployeeView].*,
		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--��Ա���(��ӦLeaderTypeEnum,0Ϊ���쵼)
		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--��Ա�Ƿ���ѵԱ(0Ϊ����ѵԱ)
		Dept.Depth AS ManagerDepth											--�����ŵļ���
FROM    SQ_EmployeeView
		LEFT OUTER JOIN Trainer ON SQ_EmployeeView.Id = Trainer.EmployeeId
		LEFT OUTER JOIN Dept ON Trainer.DeptId = Dept.Id
) AS A
GO

--���ܲ�ѯ��Ա����Ա����ѵԱ��Ϣ��ͼ
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeGroupWithTrainerInfoView]'))
DROP VIEW [SQ_EmployeeGroupWithTrainerInfoView]
GO
CREATE VIEW [dbo].[SQ_EmployeeGroupWithTrainerInfoView]
AS
SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
(
SELECT
		[SQ_EmployeeGroupView].*,
		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--��Ա���(��ӦLeaderTypeEnum,0Ϊ���쵼)
		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--��Ա�Ƿ���ѵԱ(0Ϊ����ѵԱ)
		EmployeeGroup.Depth AS ManagerDepth									--������ļ���
FROM    SQ_EmployeeGroupView
		LEFT OUTER JOIN Trainer ON SQ_EmployeeGroupView.Id = Trainer.EmployeeId
		LEFT OUTER JOIN EmployeeGroup ON Trainer.DeptId = EmployeeGroup.Id
) AS A
GO

--���ܲ�ѯѧϰ������Ա�б���ͼ
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainerDepthView]'))
DROP VIEW [TrainerDepthView]
GO
CREATE VIEW [TrainerDepthView]
AS
			SELECT
			     Trainer.EmployeeId,													--��ԱId
				 Dept.Depth,															--��Ա�����ŵĲ������
				 Trainer.LeaderType,													--�쵼����
				 Trainer.IsTrainer														--��ѵԱ
FROM         Trainer INNER JOIN Dept ON Trainer.DeptId = Dept.Id
GO		

print '--------------------�޸���Ա������Ϣ��ͼ------------------------------------'
GO
/*���ܲ�ѯ��Ա������Ϣ��ͼ,���ӹ���������ֶ�
  CertTypeId=1 ְҵ�ʸ�
  CertTypeId=2 רҵ�����ʸ�
*/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TaskEmployeeListView]'))
DROP VIEW [SQ_TaskEmployeeListView]
GO
CREATE VIEW [SQ_TaskEmployeeListView]
AS
SELECT
	[SQ_EmployeeView].Id AS EmployeeId,										--��ԱId			
	[SQ_EmployeeView].EmployeeNO,											--��Ա���
	[SQ_EmployeeView].ObjectName AS EmployeeName,							--����
	[SQ_EmployeeView].Sex,													--�Ա�
	[SQ_EmployeeView].StatusId,												--״̬
	[SQ_EmployeeView].DeptId,												--��������Id
	[SQ_EmployeeView].PostRank,												--�ڼ�
	[SQ_EmployeeView].DeptFullPath,											--��������ȫ·��
	[SQ_EmployeeView].FullPath_Search,										--��������ȫ·��(��ѯ��)
	[SQ_EmployeeView].PostId,												--��λId
	[SQ_EmployeeView].PostName,												--��λ����
	[SQ_EmployeeView].CategoryId,											--��λ��׼Id
	[SQ_EmployeeView].Age,													--����
	[SQ_EmployeeView].Depth,												--�����������
	ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,						--��Ա�����ŵĲ������
	ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,					--�쵼����
	ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,						--��ѵԱ
	TrainerDepthView.Depth AS ManagerDepth,									--�����ŵ����

	ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
	LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
	WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
	ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--���ְҵ�ʸ񼶱�Id

	ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
	LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
	WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
	ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId						--���ְ�Ƽ���Id

	FROM SQ_EmployeeView LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EGTaskEmployeeListView]'))
DROP VIEW [SQ_EGTaskEmployeeListView]
GO
CREATE VIEW [SQ_EGTaskEmployeeListView]
AS
			SELECT
								 [SQ_EmployeeView].Id AS EmployeeId,											--��ԱId			
								 [SQ_EmployeeView].EmployeeNO,													--��Ա���
								 [SQ_EmployeeView].ObjectName AS EmployeeName,									--����
								 [SQ_EmployeeView].Sex,															--�Ա�
								 [SQ_EmployeeView].StatusId,													--״̬
								 [SQ_EmployeeView].DeptId,														--��������Id
								 [SQ_EmployeeView].PostRank,													--�ڼ�
								 [SQ_EmployeeView].DeptFullPath,												--��������ȫ·��
								 [SQ_EmployeeView].FullPath_Search,												--��������ȫ·��(��ѯ��)
								 [SQ_EmployeeView].PostId,														--��λId
								 [SQ_EmployeeView].PostName,													--��λ����
								 [SQ_EmployeeView].CategoryId,													--��λ��׼Id
								 [SQ_EmployeeView].Age,															--����
								 [SQ_EmployeeView].Depth,														--�����������
								 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,								--��Ա�����ŵĲ������
								 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,							--�쵼����
								 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,								--��ѵԱ

								  ISNULL([SQ_EmployeeView].ManageEmployeeGroupId,0) AS EmployeeManageEmployeeGroupId,
								 CASE 
								 WHEN [SQ_EmployeeView].ManageEmployeeGroupId=0 THEN '2'
								 ELSE '1' END AS ManageLeaderType,

								 TrainerDepthView.Depth AS ManagerDepth,										--�����ŵ����
								 
								 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
								 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
								 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
								 ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--���ְҵ�ʸ񼶱�Id

 								 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
								 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
								 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
								 ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId,						--���ְ�Ƽ���Id

								 A.GroupName,																	--����
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
				 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,							--��Ա�����ŵĲ������
				 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,						--�쵼����
				 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,							--��ѵԱ
				 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
				 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
				 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 1
				 ORDER BY CT.SortIndex DESC),0) AS JiNengStdLevelId,						--���ְҵ�ʸ񼶱�Id

 				 ISNULL((SELECT TOP 1 EC.CertTypeLevelId FROM EmployeeCert EC
				 LEFT JOIN CertTypeLevel CT ON EC.CertTypeLevelId = CT.Id 
				 WHERE EC.EmployeeId = SQ_EmployeeView.Id AND EC.CertTypeId = 2
				 ORDER BY CT.SortIndex DESC),0) AS JiShuStdLevelId						--���ְ�Ƽ���Id
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

--��ѵԱ��ͼ TrainerView
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainerView]'))
DROP VIEW TrainerView
GO
CREATE VIEW TrainerView
AS
	SELECT	Employee.Id,																	--��ԱID
			Employee.DeptId,																--��Ա���ڲ��ŵĲ���Id
			Employee.PostId,																--��Ա��λID
			Employee.Sex,																	--��Ա�Ա�
			Employee.EmployeeNO,															--��Ա����
			Employee.ObjectName,															--��Ա����
			Trainer.LeaderType,																--�쵼����(0:�� 1:��ְ 2:��ְ 3:��ͨ)
			Trainer.IsTrainer,																--�Ƿ�����ѵԱ
			Trainer.IsManageTrain,															--�Ƿ���ѵר��
			Trainer.ManageType,																--ר������(��ѵר����֤��ר��)
			Trainer.DeptId AS ManageDeptId,													--��Ա�����ŵ�Id
			Dept.SortIndex AS DeptSortIndex,												--���ڲ��ŵ�˳��
			Post.SortIndex AS PostSortIndex,												--��λ˳��
			Employee.SortIndex AS EmployeeSortIndex,										--��Ա�����
			Dept.FullPath AS DeptFullPath,													--��Ա���ڲ��ŵ�ȫ·��
			Dept1.FullPath AS ManageDeptFullPath,											--��Ա�������ŵ�ȫ·��
			Dept1.FullPath + '/' AS FullPath_Search,										--�����Ӽ�����ʱ�õ��ı�Ҫ��ѯ�ֶ�
			CASE Dept1.DeptType WHEN 0 THEN Dept1.Depth ELSE Dept1.Depth+1 END AS Depth,	--���ŵ���ʵ��ȣ��������������Ϊ������ʱ������ѵԱ�����ŵ����Ӧ��+1������:��������Ӧ����2�����ŵ���ѵԱ																--��Ա�����ŵĲ������
			Dept1.SortIndex,																--����λ��
			ISNULL(Post.ObjectName, '') AS PostName,										--��λ����
			ISNULL(EmployeeIdRoleListStringView.RoleListString,'') AS RoleListString,		--��ɫ�����б�(���ŷָ�)
			Trainer.IsTrainer * 100 + Trainer.LeaderType AS TrainerType,						--��ӦTrainerTypeEnum
			ManageType.ObjectName AS ManageTypeName
	FROM	Employee 
	INNER JOIN Trainer ON Employee.Id = Trainer.EmployeeId
	INNER JOIN Dept ON Employee.DeptId = Dept.Id
	INNER JOIN Dept AS Dept1 ON Trainer.DeptId = Dept1.Id
	LEFT OUTER JOIN Post ON Employee.PostId = Post.Id
	LEFT OUTER JOIN EmployeeIdRoleListStringView ON Employee.Id = EmployeeIdRoleListStringView.EmployeeId
	LEFT JOIN ManageType ON ManageType.Id=Trainer.ManageType
GO

--��Ա������Ϣ������ͼ
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

print '--------------------��ѯ��ѵʦ����ͼ-----------------------------------'
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

--------------------------------------------------��Ա����ͼ--------------------------------------------------------
print '--------------------��ѯ��Ա���������Ϣ����ͼ--------------------------------'
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


print '--------------------��ѯ��Ա��Ĺ�����Ա����ͼ--------------------------------'
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

print '--------------------2014/4/3��ѯ��Ա֤��������ͼ SK--------------------------------'
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

print '--------------------2014/4/15��ѯ֤���ϱ�����ͼ CTG--------------------------------'
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

print '--------------------2014/4/24��ѯ֤�������ʷ��ͼ YHX--------------------------------'
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

print '--------------------2014/7/9 ��Ա����Աѡ��ؼ� --------------------------------'
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



print '--------------------2015/6/3 ��λ��׼��ͼ --------------------------------'
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