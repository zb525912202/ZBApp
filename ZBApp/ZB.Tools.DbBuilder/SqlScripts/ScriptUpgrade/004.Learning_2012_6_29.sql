
PRINT '------ ѧԱר��ѧϰλ�ñ� ------'

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AlbumStudyPosition]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[AlbumStudyPosition]
(
	[Id]					INT IDENTITY(1,1) PRIMARY KEY,
	[EmployeeId]			INT NOT NULL,									--��ԱId
	[StudyMode]				INT NOT NULL,									--ѧϰģʽ
	[AlbumId]               INT NOT NULL,									--ר��Id
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

