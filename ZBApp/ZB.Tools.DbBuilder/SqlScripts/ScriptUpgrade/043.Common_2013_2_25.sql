

IF  NOT EXISTS (SELECT * FROM RoleInPrivilege WHERE RoleId=2 AND PrvgName='PlanApprove')
BEGIN
PRINT '------ ��ͨѧԱ��ӡ��ƻ���ˡ�Ȩ��------'
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PlanApprove');
END
GO

