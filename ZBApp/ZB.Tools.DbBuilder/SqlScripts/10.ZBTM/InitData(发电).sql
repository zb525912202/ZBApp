PRINT '------ 向培训内容表插入数据 其他培训内容分类   ------'
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(0,'',0,'',3,1)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1,'管理人员培训',0,'管理人员培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2,'一般人员培训',0,'一般人员培训',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1001,'创新能力培训',1,'管理人员培训/创新能力培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1002,'管理知识培训',1,'管理人员培训/管理知识培训',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2001,'专业知识培训',2,'一般人员培训/专业知识培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2002,'工作技能培训',2,'一般人员培训/工作技能培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2003,'态度意识培训',2,'一般人员培训/态度意识培训',0,3)

GO


PRINT '------ 向培训级别表插入数据 ------'
SET IDENTITY_INSERT TrainingLevel ON
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(0,'',1,3,0)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(1,'国家级',0,0,1)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(2,'集团公司级',0,0,2)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(3,'省公司级',0,0,3)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(4,'地市公司级',0,0,4)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(5,'工区级',0,0,5)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(6,'班组级',0,0,6)
SET IDENTITY_INSERT TrainingLevel OFF
GO