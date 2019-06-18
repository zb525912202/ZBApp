
PRINT '------ 学员专辑学习位置表 ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AlbumStudyPosition]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[AlbumStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--人员Id
	[StudyMode]				INT NOT NULL,									--学习模式
	[AlbumId]               INT NOT NULL,									--专辑Id
	[Md5]					NVARCHAR(50) NOT NULL							--Md5	
)
CREATE UNIQUE NONCLUSTERED INDEX [IDX_EmployeeId_StudyMode_AlbumId] ON [dbo].[AlbumStudyPosition] 
(
	[EmployeeId] ASC,
	[StudyMode] ASC,
	[AlbumId] ASC
)
END
GO

