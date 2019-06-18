--IF EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Notice') AND name='DeptId')
--BEGIN	
--	declare @name varchar(50) --列对应约束名 
--	select @name =b.name from sysobjects b join syscolumns a on b.id = a.cdefault 
--	where a.id = object_id('Notice')  --表名称 
--	and a.name ='DeptId'  --列名称
--	exec('ALTER TABLE Notice DROP CONSTRAINT ' + @name) 
--	exec('ALTER TABLE Notice DROP Column DeptId')
		
--	PRINT '删除Notice表内的DeptId字段';
--END
--GO

IF NOT EXISTS(SELECT * FROM syscolumns WHERE id = object_id('Notice') AND name='DeptId')
BEGIN
	ALTER TABLE Notice ADD DeptId INT NOT NULL DEFAULT 0;
	execute ('UPDATE Notice SET DeptId=1');
	PRINT '添加公告表内的部门Id字段';
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NoticeDept]') AND type in (N'U'))
BEGIN
PRINT '------ 公告部门 ------'
CREATE TABLE [dbo].[NoticeDept](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY,				-- 唯一标识
	[NoticeId]			INT NOT NULL,								-- 公告Id
	[DeptId]			INT NOT NULL,								-- 部门Id
)
ALTER TABLE [NoticeDept]  WITH CHECK ADD  
	CONSTRAINT [FK_NoticeDept_Notice] FOREIGN KEY([NoticeId]) REFERENCES [Notice] ([Id])
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NoticeDept_NoticeId_DeptId] ON [dbo].[NoticeDept] 
(
	[NoticeId] ASC,
	[DeptId] ASC
)

PRINT '为已有公告添加默认部门';
INSERT NoticeDept(NoticeId,DeptId) SELECT Id,1 FROM Notice
END
GO
