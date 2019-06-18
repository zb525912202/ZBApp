

IF  NOT EXISTS (SELECT * FROM RoleInPrivilege WHERE RoleId=2 AND PrvgName='PlanApprove')
BEGIN
PRINT '------ 普通学员添加【计划审核】权限------'
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PlanApprove');
END
GO

