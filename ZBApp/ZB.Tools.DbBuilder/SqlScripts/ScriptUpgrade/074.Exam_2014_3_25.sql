IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebGradeTask]') AND type in (N'U'))
BEGIN
PRINT '------删除阅卷任务表------'
DROP TABLE [dbo].[WebGradeTask]
ENd