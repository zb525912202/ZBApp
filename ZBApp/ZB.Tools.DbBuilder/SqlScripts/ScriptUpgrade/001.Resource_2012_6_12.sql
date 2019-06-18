

--print '�޸��Ծ��б���ͼ�����FolderFullPath�ֶ�';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_PaperListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_PaperListView_LearningOnline]
--AS
--SELECT				PaperPackage.Id,														--�Ծ�Id
--					200 AS FileType,														--��Դ����
--					PaperPackage.ObjectName,												--����
--					PaperPackage.HardRate,													--���׶�
--					PFolder.DeptId,															--����Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
--					PFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
--					FROM PaperPackage INNER JOIN PFolder ON PaperPackage.FolderId = PFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = PFolder.DeptId
--					WHERE (PaperPackage.IsPrivate = 'FALSE')
--GO

--print '�޸������б���ͼ�����FolderFullPath�ֶ�';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_QFolderListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_QFolderListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_QFolderListView_LearningOnline]
--AS
--SELECT				QFolder.Id,																--�����ļ���Id
--					100 AS FileType,														--��Դ����
--					QFolder.FullPath,														--�����ļ���ȫ·��
--					FolderQuestionCountView.QuestionCount,									--�����ļ���ͳ��������Ϣ
--					QFolder.DeptId,															--����Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
--					QFolder.CreateTime,														--����ʱ��
--					QFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
--					FROM QFolder INNER JOIN
--					(SELECT DISTINCT FolderId,COUNT(1) AS QuestionCount FROM Question GROUP BY Question.FolderId)
--					 AS FolderQuestionCountView ON FolderQuestionCountView.FolderId = QFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = QFolder.DeptId
--GO

--print '�޸�ý���б���ͼ�����FolderFullPath�ֶ�';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ResourceListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_ResourceListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_ResourceListView_LearningOnline]
--AS
--SELECT				RFile.Id,																--��ԴId
--					RFile.[GUID],															--GUID,��ʾ����ͼ��Ҫ
--					RFile.UploadPathIndex,													--UploadPathIndex,��ʾ����ͼ��Ҫ
--					FileType,																--��Դ����
--					RFile.ObjectName,														--����
--					RFile.ContentLength,													--��Դͳ��������Ϣ
--					RFolder.DeptId,															--����Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
--					RFile.CreateTime,														--����ʱ��
--					RFile.LastUpdateTime,													--����ʱ��
--					RFile.StudyTimes,														--ѧϰ�˴�
--					RFile.Md5,																--MD5
--					RFile.RecommendCount,													--�Ƽ�����
--					RFile.UnRecommendCount,													--���Ƽ�����
--					RFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
--					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
--					WHERE RFile.ResourceState = 4
--GO

