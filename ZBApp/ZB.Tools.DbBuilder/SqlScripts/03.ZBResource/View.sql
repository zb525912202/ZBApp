print '--------------------跨库部门视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeptBaseInfoView]'))
DROP VIEW [dbo].[DeptBaseInfoView]
GO
CREATE VIEW [dbo].[DeptBaseInfoView]
AS
SELECT				Id,																			--Id
					ObjectName,																	--名称
					ParentId,																	--父部门Id
					FullPath,																	--部门全路径
					FullPath + '/' AS DeptFullPath_Search,										--查询子部门用
					SortIndex,																	--排序
					Depth,																		--部门树节点深度
					DeptType																	--部门类型
					FROM [$(ZBCommonDatabaseName)].[dbo].[Dept]
GO

------------------平时重建视图从这以后开始--------------------

print '--------------------查询资源文件列表视图(管理部门点击用),该视图已废弃------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_RFileListView]'))
DROP VIEW [dbo].[SQ_RFileListView]
GO

print '--------------------查询资源文件列表视图(其他部门或文件夹点击用)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_RFileListView_Simple]'))
DROP VIEW [dbo].[SQ_RFileListView_Simple]
GO
CREATE VIEW [dbo].[SQ_RFileListView_Simple]
AS
SELECT				RFile.Id,																	--Id
					RFile.ObjectName,															--名称
					LastUpdateTime,																--修改日期
					RFile.[GUID],																--GUID
					FileType,																	--类型
					FileTypeExt,																--文件扩展名
					ISNULL((select SUM(AFile.FileSize) FROM AFile WHERE AFile.ParentId=RFile.Id),FileSize)
					AS FileSize,																--大小
					RFile.CreatorName,															--创建人
					RFile.IsDownloadEnabled,													--是否允许下载
					RFile.SourceName,															--原始文件名
					RFile.UploadPathIndex, 														--上传服务器索引
					RFile.ContentLength,														--长度
					RecommendCount,																--推荐次数
					UnRecommendCount,															--不推荐次数
					RFolder.FullPath AS FolderFullPath,											--文件所属目录的全路径
					RFolder.DeptId,																--文件所属部门
					RFolder.FullPath + '/' AS FullPath_Search,									--查询子目录用
					RFile.Md5,
					RFile.ConvertName,
					RFile.IsSupportApp
					FROM RFolder
					INNER JOIN RFile ON RFolder.Id = RFile.ParentId
					WHERE ResourceState=4
GO

print '--------------------查询资源审核文件列表视图------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_AuditRFileListView]'))
DROP VIEW [dbo].[SQ_AuditRFileListView]
GO
CREATE VIEW [dbo].[SQ_AuditRFileListView]
AS
	SELECT				
	RFile.Id,																	--Id
	RFile.ObjectName,															--名称
	FileType,																	--类型
	RFile.[GUID],																--GUID		
	RFile.UploadPathIndex, 														--上传服务器索引
	FileTypeExt,																--文件扩展名
	ISNULL((SELECT SUM(AFile.FileSize) FROM AFile WHERE AFile.ParentId=RFile.Id),FileSize)
	AS FileSize,																--大小
	ResourceState,																--资源状态
	RFile.CreatorName,															--创建人
	RFile.CreateTime,															--创建日期
	RFolder.FullPath AS FolderFullPath,										--文件所属目录的全路径
	RFolder.DeptId																--文件所属部门(或者文件共享到的部门)
	FROM RFile 
	INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
	WHERE ResourceState<>4
GO

print '--------------------查询试卷文件列表视图(管理部门点击用),该视图已废弃------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperPackageListView]'))
DROP VIEW [dbo].[SQ_PaperPackageListView]
GO

print '--------------------查询试卷文件列表视图(其他部门或文件夹点击用)------------------------------------'
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_PaperPackageListView_Simple]'))
DROP VIEW [dbo].[SQ_PaperPackageListView_Simple]
GO
CREATE VIEW [dbo].[SQ_PaperPackageListView_Simple]
AS
SELECT				PaperPackage.Id,															--Id
					PaperPackage.ObjectName,													--名称
					PaperPackage.IsLocalPaperPackage,                                           --是否本地卷
					PFolder.FullPath AS FullPath,											    --试卷所属目录的全路径(避免在网考选取试卷时调用出错)
					LastUpdateTime,																--修改日期
					IsImpersonal,																--是否客观卷
					PaperPackage.IsRandomPaper,													--是否随机卷
					HardRate,																	--难度系数
					IsElecPaperPackage,
					Describe,																	--描述(知识点)
					PaperPackage.CreatorId,														--创建人ID
					PaperPackage.CreatorName,													--创建人
					PaperPackage.FolderId,														--试卷所属目录Id
					PaperPackage.IsPrivate,														--试卷是否私有
					PaperPackage.PaperPackageQuestionCount,										--试卷的试题总量
					PFolder.FullPath AS FolderFullPath,											--试卷所属目录的全路径
					PFolder.DeptId,																--试卷所属部门
					PFolder.FullPath + '/' AS FullPath_Search									--查询子目录用
					FROM PFolder
					INNER JOIN PaperPackage ON PFolder.Id = PaperPackage.FolderId
GO

print '--------------------查询LearningOnline资源列表专辑视图------------------------------------'
GO
--专辑中以是否文档进行资源分组的类型统计信息视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AlbumFileContentLengthView]'))
DROP VIEW [dbo].[AlbumFileContentLengthView]
GO
CREATE VIEW [dbo].[AlbumFileContentLengthView]
AS
SELECT				a.ParentId,														--专辑对应的RFile记录的Id
					b.ContentLength_Doc,											--专辑中文档类资源分组统计信息(文档对应值为500,可空)
					c.ContentLength_Other											--专辑中非文档类资源分组统计信息(可空)
					FROM(SELECT DISTINCT ParentId FROM AFile) a 
					LEFT JOIN (SELECT ParentId,Sum(ContentLength) AS ContentLength_Doc from AFile WHERE FileType = 500 GROUP BY ParentId) b ON
					a.ParentId = b.ParentId
					LEFT JOIN (SELECT ParentId,Sum(ContentLength) AS ContentLength_Other from AFile WHERE FileType <> 500 GROUP BY ParentId) c ON
					a.ParentId = c.ParentId
GO			

--LearningOnline资源列表专辑视图(只取其下有子资源的专辑,所以用INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_AlbumListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_AlbumListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_AlbumListView_LearningOnline]
AS
SELECT				RFile.Id,																--专辑Id
					600 AS FileType,														--资源类型
					RFile.ObjectName,														--名称
					RFile.[GUID],															--GUID,显示缩略图需要
					RFile.UploadPathIndex,													--UploadPathIndex,显示缩略图需要
					AlbumFileContentLengthView.ContentLength_Doc,							--专辑中文档类资源分组统计信息(文档对应值为500,可空)
					AlbumFileContentLengthView.ContentLength_Other,							--专辑中非文档类资源分组统计信息(可空)
					RFolder.DeptId,															--部门Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
					RFile.CreateTime,														--创建时间
					RFile.LastUpdateTime,													--发布时间
					RFile.StudyTimes,														--学习人次
					RFile.RecommendCount,													--推荐次数
					RFile.UnRecommendCount													--不推荐次数
					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
					INNER JOIN AlbumFileContentLengthView ON AlbumFileContentLengthView.ParentId = RFile.Id
					WHERE RFile.ResourceState = 4 AND RFile.FileType = 600
GO

--LearningOnline专辑部门分组统计视图(只取其下有子资源的专辑,所以用INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AlbumGroupByDeptTotalView_LearningOnline]'))
DROP VIEW [dbo].[AlbumGroupByDeptTotalView_LearningOnline]
GO
CREATE VIEW [dbo].[AlbumGroupByDeptTotalView_LearningOnline]
AS
SELECT				DeptId,																	--部门Id
					COUNT(*) AS ResourceCount												--部门下直属专辑(其下有子资源的非空专辑)数量
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
SELECT				PaperPackage.Id,														--试卷Id
					IsElecPaperPackage,
					200 AS FileType,														--资源类型
					PaperPackage.ObjectName,												--名称
					PaperPackage.HardRate,													--难易度
					PFolder.DeptId,															--部门Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
					PFolder.Id AS FolderId,													--文件夹ID
					PFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
					FROM PaperPackage INNER JOIN PFolder ON PaperPackage.FolderId = PFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = PFolder.DeptId
					WHERE (PaperPackage.IsPrivate = 'FALSE')
GO

--LearningOnline资源列表试题文件夹视图(只取其下有题的试题文件夹,所以用INNER JOIN)
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_QFolderListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_QFolderListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_QFolderListView_LearningOnline]
AS
SELECT				QFolder.Id,																--试题文件夹Id
					100 AS FileType,														--资源类型
					QFolder.FullPath,														--试题文件夹全路径
					FolderQuestionCountView.QuestionCount,									--试题文件夹统计描述信息
					QFolder.DeptId,															--部门Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
					QFolder.CreateTime,														--发布时间
					QFolder.Id AS FolderId,													--文件夹ID
					QFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
					FROM QFolder INNER JOIN
					(SELECT DISTINCT FolderId,COUNT(1) AS QuestionCount FROM Question GROUP BY Question.FolderId)
					 AS FolderQuestionCountView ON FolderQuestionCountView.FolderId = QFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = QFolder.DeptId
GO

--LearningOnline资源列表通用资源(视频，音频，文档)视图

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SQ_ResourceListView_LearningOnline]'))
DROP VIEW [dbo].[SQ_ResourceListView_LearningOnline]
GO
CREATE VIEW [dbo].[SQ_ResourceListView_LearningOnline]
AS
SELECT				RFile.Id,																--资源Id
					RFile.[GUID],															--GUID,显示缩略图需要
					RFile.UploadPathIndex,													--UploadPathIndex,显示缩略图需要
					FileType,																--资源类型
					RFile.ObjectName,														--名称
					RFile.ContentLength,													--资源统计描述信息
					RFolder.DeptId,															--部门Id
					DeptBaseInfoView.FullPath AS DeptFullPath,								--部门全路径
					RFile.CreateTime,														--创建时间
					RFile.LastUpdateTime,													--发布时间
					RFile.StudyTimes,														--学习人次
					RFile.Md5,																--MD5
					RFile.RecommendCount,													--推荐次数
					RFile.UnRecommendCount,													--不推荐次数
					RFolder.Id AS FolderId,													--文件夹ID
					RFolder.FullPath + '/' AS FolderFullPath								--文件夹全路径
					FROM RFile INNER JOIN RFolder ON RFile.ParentId = RFolder.Id
					INNER JOIN DeptBaseInfoView ON DeptBaseInfoView.Id = RFolder.DeptId 
					WHERE RFile.ResourceState = 4
GO
