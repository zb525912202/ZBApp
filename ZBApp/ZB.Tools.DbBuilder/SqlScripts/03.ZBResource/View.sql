print '--------------------��ⲿ����ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptBaseInfoView]'))
DROP VIEW [dbo].[DeptBaseInfoView]
GO
CREATE VIEW [dbo].[DeptBaseInfoView]
AS
SELECT				Id,																			--Id
					ObjectName,																	--����
					ParentId,																	--������Id
					FullPath,																	--����ȫ·��
					FullPath + '/' AS DeptFullPath_Search,										--��ѯ�Ӳ�����
					SortIndex,																	--����
					Depth,																		--�������ڵ����
					DeptType																	--��������
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

------------------ƽʱ�ؽ���ͼ�����Ժ�ʼ--------------------

print '--------------------��ѯ��Դ�ļ��б���ͼ(�����ŵ����),����ͼ�ѷ���------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_RFileListView]'))
DROP VIEW [dbo].[SQ_RFileListView]
GO

print '--------------------��ѯ��Դ�ļ��б���ͼ(�������Ż��ļ��е����)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_RFileListView_Simple]'))
DROP VIEW [dbo].[SQ_RFileListView_Simple]
GO
CREATE VIEW [dbo].[SQ_RFileListView_Simple]
AS
SELECT				RFile.Id,																	--Id
					RFile.ObjectName,															--����
					LastUpdateTime,																--�޸�����
					RFile.[GUID],																--GUID
					FileType,																	--����
					FileTypeExt,																--�ļ���չ��
					ISNULL((select SUM(AFile.FileSize) FROM AFile WHERE AFile.ParentId=RFile.Id),FileSize)
					AS FileSize,																--��С
					RFile.CreatorName,															--������
					RFile.IsDownloadEnabled,													--�Ƿ���������
					RFile.SourceName,															--ԭʼ�ļ���
					RFile.UploadPathIndex, 														--�ϴ�����������
					RFile.ContentLength,														--����
					RecommendCount,																--�Ƽ�����
					UnRecommendCount,															--���Ƽ�����
					RFolder.FullPath AS FolderFullPath,											--�ļ�����Ŀ¼��ȫ·��
					RFolder.DeptId,																--�ļ���������
					RFolder.FullPath + '/' AS FullPath_Search,									--��ѯ��Ŀ¼��
					RFile.Md5,
					RFile.ConvertName,
					RFile.IsSupportApp
					FROM RFolder
					INNER JOIN RFile ON RFolder.Id = RFile.ParentId
					WHERE ResourceState=4
GO

print '--------------------��ѯ��Դ����ļ��б���ͼ------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_AuditRFileListView]'))
DROP VIEW [dbo].[SQ_AuditRFileListView]
GO
CREATE VIEW [dbo].[SQ_AuditRFileListView]
AS
	SELECT				
	RFile.Id,																	--Id
	RFile.ObjectName,															--����
	FileType,																	--����
	RFile.[GUID],																--GUID		
	RFile.UploadPathIndex, 														--�ϴ�����������
	FileTypeExt,																--�ļ���չ��
	ISNULL((SELECT SUM(AFile.FileSize) FROM AFile WHERE AFile.ParentId=RFile.Id),FileSize)
	AS FileSize,																--��С
	ResourceState,																--��Դ״̬
	RFile.CreatorName,															--������
	RFile.CreateTime,															--��������
	RFolder.FullPath AS FolderFullPath,										--�ļ�����Ŀ¼��ȫ·��
	RFolder.DeptId																--�ļ���������(�����ļ������Ĳ���)
	FROM RFile 
	INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
	WHERE ResourceState<>4
GO

print '--------------------��ѯ�Ծ��ļ��б���ͼ(�����ŵ����),����ͼ�ѷ���------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperPackageListView]'))
DROP VIEW [dbo].[SQ_PaperPackageListView]
GO

print '--------------------��ѯ�Ծ��ļ��б���ͼ(�������Ż��ļ��е����)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperPackageListView_Simple]'))
DROP VIEW [dbo].[SQ_PaperPackageListView_Simple]
GO
CREATE VIEW [dbo].[SQ_PaperPackageListView_Simple]
AS
SELECT				PaperPackage.Id,															--Id
					PaperPackage.ObjectName,													--����
					PaperPackage.IsLocalPaperPackage,                                           --�Ƿ񱾵ؾ�
					PFolder.FullPath AS FullPath,											    --�Ծ�����Ŀ¼��ȫ·��(����������ѡȡ�Ծ�ʱ���ó���)
					LastUpdateTime,																--�޸�����
					IsImpersonal,																--�Ƿ�͹۾�
					PaperPackage.IsRandomPaper,													--�Ƿ������
					HardRate,																	--�Ѷ�ϵ��
					IsElecPaperPackage,
					Describe,																	--����(֪ʶ��)
					PaperPackage.CreatorId,														--������ID
					PaperPackage.CreatorName,													--������
					PaperPackage.FolderId,														--�Ծ�����Ŀ¼Id
					PaperPackage.IsPrivate,														--�Ծ��Ƿ�˽��
					PaperPackage.PaperPackageQuestionCount,										--�Ծ����������
					PFolder.FullPath AS FolderFullPath,											--�Ծ�����Ŀ¼��ȫ·��
					PFolder.DeptId,																--�Ծ���������
					PFolder.FullPath + '/' AS FullPath_Search									--��ѯ��Ŀ¼��
					FROM PFolder
					INNER JOIN PaperPackage ON PFolder.Id = PaperPackage.FolderId
GO

print '--------------------��ѯLearningOnline��Դ�б�ר����ͼ------------------------------------'
GO
--ר�������Ƿ��ĵ�������Դ���������ͳ����Ϣ��ͼ
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AlbumFileContentLengthView]'))
DROP VIEW [dbo].[AlbumFileContentLengthView]
GO
CREATE VIEW [dbo].[AlbumFileContentLengthView]
AS
SELECT				a.ParentId,														--ר����Ӧ��RFile��¼��Id
					b.ContentLength_Doc,											--ר�����ĵ�����Դ����ͳ����Ϣ(�ĵ���ӦֵΪ500,�ɿ�)
					c.ContentLength_Other											--ר���з��ĵ�����Դ����ͳ����Ϣ(�ɿ�)
					FROM(SELECT DISTINCT ParentId FROM AFile) a 
					LEFT JOIN (SELECT ParentId,Sum(ContentLength) AS ContentLength_Doc from AFile WHERE FileType = 500 GROUP BY ParentId) b ON
					a.ParentId = b.ParentId
					LEFT JOIN (SELECT ParentId,Sum(ContentLength) AS ContentLength_Other from AFile WHERE FileType <> 500 GROUP BY ParentId) c ON
					a.ParentId = c.ParentId
GO			

--LearningOnline��Դ�б�ר����ͼ(ֻȡ����������Դ��ר��,������INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_AlbumListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_AlbumListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_AlbumListView_LearningOnline]
AS
SELECT				RFile.Id,																--ר��Id
					600 AS FileType,														--��Դ����
					RFile.ObjectName,														--����
					RFile.[GUID],															--GUID,��ʾ����ͼ��Ҫ
					RFile.UploadPathIndex,													--UploadPathIndex,��ʾ����ͼ��Ҫ
					AlbumFileContentLengthView.ContentLength_Doc,							--ר�����ĵ�����Դ����ͳ����Ϣ(�ĵ���ӦֵΪ500,�ɿ�)
					AlbumFileContentLengthView.ContentLength_Other,							--ר���з��ĵ�����Դ����ͳ����Ϣ(�ɿ�)
					RFolder.DeptId,															--����Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
					RFile.CreateTime,														--����ʱ��
					RFile.LastUpdateTime,													--����ʱ��
					RFile.StudyTimes,														--ѧϰ�˴�
					RFile.RecommendCount,													--�Ƽ�����
					RFile.UnRecommendCount													--���Ƽ�����
					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
					INNER JOIN AlbumFileContentLengthView ON AlbumFileContentLengthView.ParentId = RFile.Id
					WHERE RFile.ResourceState = 4 AND RFile.FileType = 600
GO

--LearningOnlineר�����ŷ���ͳ����ͼ(ֻȡ����������Դ��ר��,������INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AlbumGroupByDeptTotalView_LearningOnline]'))
DROP VIEW [dbo].[AlbumGroupByDeptTotalView_LearningOnline]
GO
CREATE VIEW [dbo].[AlbumGroupByDeptTotalView_LearningOnline]
AS
SELECT				DeptId,																	--����Id
					COUNT(*) AS ResourceCount												--������ֱ��ר��(����������Դ�ķǿ�ר��)����
					FROM RFile
					INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
					INNER JOIN (SELECT DISTINCT ParentId FROM AFile) a ON a.ParentId = RFile.Id
					WHERE RFile.ResourceState = 4 AND RFile.FileType = 600
					GROUP BY DeptId
GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_PaperListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_PaperListView_LearningOnline]
AS
SELECT				PaperPackage.Id,														--�Ծ�Id
					IsElecPaperPackage,
					200 AS FileType,														--��Դ����
					PaperPackage.ObjectName,												--����
					PaperPackage.HardRate,													--���׶�
					PFolder.DeptId,															--����Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
					PFolder.Id AS FolderId,													--�ļ���ID
					PFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
					FROM PaperPackage INNER JOIN PFolder ON PaperPackage.FolderId = PFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = PFolder.DeptId
					WHERE (PaperPackage.IsPrivate = 'FALSE')
GO

--LearningOnline��Դ�б������ļ�����ͼ(ֻȡ��������������ļ���,������INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_QFolderListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_QFolderListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_QFolderListView_LearningOnline]
AS
SELECT				QFolder.Id,																--�����ļ���Id
					100 AS FileType,														--��Դ����
					QFolder.FullPath,														--�����ļ���ȫ·��
					FolderQuestionCountView.QuestionCount,									--�����ļ���ͳ��������Ϣ
					QFolder.DeptId,															--����Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
					QFolder.CreateTime,														--����ʱ��
					QFolder.Id AS FolderId,													--�ļ���ID
					QFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
					FROM QFolder INNER JOIN
					(SELECT DISTINCT FolderId,COUNT(1) AS QuestionCount FROM Question GROUP BY Question.FolderId)
					 AS FolderQuestionCountView ON FolderQuestionCountView.FolderId = QFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = QFolder.DeptId
GO

--LearningOnline��Դ�б�ͨ����Դ(��Ƶ����Ƶ���ĵ�)��ͼ

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ResourceListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_ResourceListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_ResourceListView_LearningOnline]
AS
SELECT				RFile.Id,																--��ԴId
					RFile.[GUID],															--GUID,��ʾ����ͼ��Ҫ
					RFile.UploadPathIndex,													--UploadPathIndex,��ʾ����ͼ��Ҫ
					FileType,																--��Դ����
					RFile.ObjectName,														--����
					RFile.ContentLength,													--��Դͳ��������Ϣ
					RFolder.DeptId,															--����Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--����ȫ·��
					RFile.CreateTime,														--����ʱ��
					RFile.LastUpdateTime,													--����ʱ��
					RFile.StudyTimes,														--ѧϰ�˴�
					RFile.Md5,																--MD5
					RFile.RecommendCount,													--�Ƽ�����
					RFile.UnRecommendCount,													--���Ƽ�����
					RFolder.Id AS FolderId,													--�ļ���ID
					RFolder.FullPath + '/' AS FolderFullPath								--�ļ���ȫ·��
					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
					WHERE RFile.ResourceState = 4
GO
