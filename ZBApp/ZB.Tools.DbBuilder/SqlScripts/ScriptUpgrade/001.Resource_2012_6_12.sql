

--print '修改试卷列表视图，添加FolderFullPath字段';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_PaperListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_PaperListView_LearningOnline]
--AS
--SELECT				PaperPackage.Id,														--试卷Id
--					200 AS FileType,														--资源类型
--					PaperPackage.ObjectName,												--名称
--					PaperPackage.HardRate,													--难易度
--					PFolder.DeptId,															--部门Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
--					PFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
--					FROM PaperPackage INNER JOIN PFolder ON PaperPackage.FolderId = PFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = PFolder.DeptId
--					WHERE (PaperPackage.IsPrivate = 'FALSE')
--GO

--print '修改试题列表视图，添加FolderFullPath字段';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_QFolderListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_QFolderListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_QFolderListView_LearningOnline]
--AS
--SELECT				QFolder.Id,																--试题文件夹Id
--					100 AS FileType,														--资源类型
--					QFolder.FullPath,														--试题文件夹全路径
--					FolderQuestionCountView.QuestionCount,									--试题文件夹统计描述信息
--					QFolder.DeptId,															--部门Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
--					QFolder.CreateTime,														--发布时间
--					QFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
--					FROM QFolder INNER JOIN
--					(SELECT DISTINCT FolderId,COUNT(1) AS QuestionCount FROM Question GROUP BY Question.FolderId)
--					 AS FolderQuestionCountView ON FolderQuestionCountView.FolderId = QFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = QFolder.DeptId
--GO

--print '修改媒体列表视图，添加FolderFullPath字段';

--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ResourceListView_LearningOnline]'))
--DROP VIEW [dbo].[SQ_ResourceListView_LearningOnline]
--GO
--CREATE VIEW [dbo].[SQ_ResourceListView_LearningOnline]
--AS
--SELECT				RFile.Id,																--资源Id
--					RFile.[GUID],															--GUID,显示缩略图需要
--					RFile.UploadPathIndex,													--UploadPathIndex,显示缩略图需要
--					FileType,																--资源类型
--					RFile.ObjectName,														--名称
--					RFile.ContentLength,													--资源统计描述信息
--					RFolder.DeptId,															--部门Id
--					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
--					RFile.CreateTime,														--创建时间
--					RFile.LastUpdateTime,													--发布时间
--					RFile.StudyTimes,														--学习人次
--					RFile.Md5,																--MD5
--					RFile.RecommendCount,													--推荐次数
--					RFile.UnRecommendCount,													--不推荐次数
--					RFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
--					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
--					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
--					WHERE RFile.ResourceState = 4
--GO

