USE [$(DatabaseName)]
GO
BEGIN TRANSACTION
PRINT '------ 向职岗类型体系表中表插入数据 ------'
insert into [ProfessionCategorySystem] ([Id],[ObjectName],CanUse) VALUES(1,'大唐托克托发电有限公司',1)
insert into [ProfessionCategorySystem] ([Id],[ObjectName],CanUse) VALUES(2,'华能体系',0)
insert into [ProfessionCategorySystem] ([Id],[ObjectName],CanUse) VALUES(3,'华电体系',0)
GO
PRINT '------ 向岗职岗类型表插入数据 ------'
insert into [ProfessionCategory] ([Id],[ObjectName],[LockStatus],[SortIndex],[Level]) VALUES(1,'默认',3,4,0)
insert into [ProfessionCategory] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'管理',1,1)
insert into [ProfessionCategory] ([[Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(3,'技术',1,2)
insert into [ProfessionCategory] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(4,'技能',1,3)
GO

PRINT '----------向岗位标准类型表插入默认数据（其他）---------------------'
IF((SELECT COUNT(*) FROM ProfessionCategory WHERE ObjectName = '默认')=0)
BEGIN
	INSERT INTO ProfessionCategory(Id, ObjectName, SortIndex, LockStatus,[Level])
	SELECT ISNULL(MAX(Id)+1,1), '默认', 0, 3,0 FROM ProfessionCategory
END
GO

PRINT '------ 向掌握程度表插入数据 ------'
insert into [MasteryLevel] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'默认',3,0)
GO

PRINT '------ 向岗位标准表插入数据 ------'
insert into [PostCategory] ([ObjectName],[LockStatus],[SortIndex]) VALUES('其他',3,4)
insert into [PostCategory] ([ObjectName],[LockStatus],[SortIndex]) VALUES('管理',1,1)
insert into [PostCategory] ([ObjectName],[LockStatus],[SortIndex]) VALUES('技术',1,2)
insert into [PostCategory] ([ObjectName],[LockStatus],[SortIndex]) VALUES('技能',1,3)
GO


PRINT '----------向岗位标准类型表插入默认数据（其他）---------------------'
IF((SELECT COUNT(*) FROM StandardCategory WHERE ObjectName = '其他')=0)
BEGIN
	INSERT INTO StandardCategory(Id, ObjectName, SortIndex, LockStatus)
	SELECT ISNULL(MAX(Id)+1,1), '其他', 0, 3 FROM StandardCategory
END
GO

PRINT '------ 向人员状态表插入数据 ------'
insert into [EmployeeStatus] ([ObjectName],[IsDefault],[LockStatus]) VALUES('在岗',1,3)
GO

PRINT '------ 角色表 ------'
INSERT INTO [Role] ([ObjectName],[RoleDesc],[IsDefault],[IsSystem]) VALUES ('系统管理员','系统管理员（一级培训员）','False','True');
INSERT INTO [Role] ([ObjectName],[RoleDesc],[IsDefault],[IsSystem]) VALUES ('培训员','培训员','False','True');

-------------------------------

PRINT '------ 向培训师级别表插入数据 ------'
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('初级',1)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('中级',2)
insert into [TeacherLevel] ([ObjectName],[SortIndex]) VALUES('高级',3)
GO

PRINT '------ 向专属类型表插入数据 ------'
insert into [ManageType] ([ObjectName],LockStatus,IsDefault,[SortIndex]) VALUES('培训专属',1,1,1)
GO

COMMIT TRANSACTION