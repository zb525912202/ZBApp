IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Character]') AND type in (N'U'))
BEGIN
PRINT '------删除特殊符号表------'
DROP TABLE [dbo].[Character]
ENd

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CharacterType]') AND type in (N'U'))
BEGIN
PRINT '------删除特殊符号表------'
DROP TABLE [dbo].[CharacterType]
ENd