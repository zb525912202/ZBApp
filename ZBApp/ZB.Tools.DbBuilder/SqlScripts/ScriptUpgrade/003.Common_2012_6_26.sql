

--print '--------------------��ѯ���Ų�����Ա��ͼ------------------------------------'
--GO

----���ܲ�ѯ��Ա����ѵԱ��Ϣ��ͼ,���ӹ����ż����ֶ�,������Ա�����ֶ�LeaderType�����ֶ�ֵ��TrainerView��ͼLeaderTypeֵ���
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeWithTrainerInfoView]'))
--DROP VIEW [SQ_EmployeeWithTrainerInfoView]
--GO
--CREATE VIEW [dbo].[SQ_EmployeeWithTrainerInfoView]
--AS
--SELECT *, IsTrainer * 100 + LeaderType AS TrainerType FROM
--(
--SELECT
--		[SQ_EmployeeView].*,
--		ISNULL(Trainer.LeaderType,0) AS LeaderType,							--��Ա���(��ӦLeaderTypeEnum,0Ϊ���쵼)
--		ISNULL(Trainer.IsTrainer,0) AS IsTrainer,							--��Ա�Ƿ���ѵԱ(0Ϊ����ѵԱ)
--		Dept.Depth AS ManagerDepth											--�����ŵļ���
--FROM    SQ_EmployeeView
--		LEFT OUTER JOIN Trainer ON SQ_EmployeeView.Id = Trainer.EmployeeId
--		LEFT OUTER JOIN Dept ON Trainer.DeptId = Dept.Id
--) AS A
--GO


--print '--------------------��Ա������Ϣ��ͼ------------------------------------'
--GO

----���ܲ�ѯ��Ա������Ϣ��ͼ,���ӹ���������ֶ�
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_TaskEmployeeListView]'))
--DROP VIEW [SQ_TaskEmployeeListView]
--GO
--CREATE VIEW [SQ_TaskEmployeeListView]
--AS
--			SELECT
--				 [SQ_EmployeeView].Id AS EmployeeId,										--��ԱId			
--				 [SQ_EmployeeView].EmployeeNO,												--��Ա���
--				 [SQ_EmployeeView].ObjectName AS EmployeeName,								--����
--				 [SQ_EmployeeView].Sex,														--�Ա�
--				 [SQ_EmployeeView].StatusId,												--״̬
--				 [SQ_EmployeeView].DeptId,													--��������Id
--				 [SQ_EmployeeView].PostRank,												--�ڼ�
--				 [SQ_EmployeeView].DeptFullPath,											--��������ȫ·��
--				 [SQ_EmployeeView].FullPath_Search,											--��������ȫ·��(��ѯ��)
--				 [SQ_EmployeeView].PostId,													--��λId
--				 [SQ_EmployeeView].PostName,												--��λ����
--				 [SQ_EmployeeView].CategoryId,												--��λ��׼Id
--				 [SQ_EmployeeView].Age,														--����
--				 [SQ_EmployeeView].Depth,													--�����������
--				 ISNULL(TrainerDepthView.Depth,0) AS TrainerDepth,							--��Ա�����ŵĲ������
--				 ISNULL(TrainerDepthView.LeaderType,0) AS LeaderType,						--�쵼����
--				 ISNULL(TrainerDepthView.IsTrainer,0) AS IsTrainer,							--��ѵԱ
--				 TrainerDepthView.Depth AS ManagerDepth,									--�����ŵ����
--				 ISNULL((SELECT MAX(StdLevelId) FROM EmployeeStdSort 
--				 WHERE EmployeeId=SQ_EmployeeView.Id AND StdKind=1),0) AS JiShuStdLevelId,	--���ְ�Ƽ���Id
--				 ISNULL((SELECT MAX(StdLevelId) FROM EmployeeStdSort 
--				 WHERE EmployeeId=SQ_EmployeeView.Id AND StdKind=2),0) AS JiNengStdLevelId	--���ְҵ�ʸ񼶱�Id
--FROM         SQ_EmployeeView
--			 LEFT OUTER JOIN TrainerDepthView ON SQ_EmployeeView.Id = TrainerDepthView.EmployeeId
--GO




