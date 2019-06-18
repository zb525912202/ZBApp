USE [$(DatabaseName)]
GO

PRINT '------  ------'
BEGIN TRANSACTION

PRINT '------ 向培训内容表插入数据 电网公司培训内容分类   ------'
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(0,'',0,'',3,1)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1,'党校理论及经营者培训',0,'党校理论及经营者培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2,'管理人员培训',0,'管理人员培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3,'技能人员培训',0,'技能人员培训',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4,'技术人员培训',0,'技术人员培训',0,4)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1001,'党校政治理论',1,'党校理论及经营者培训/党校政治理论',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1002,'经营能力培训',1,'党校理论及经营者培训/经营能力培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1003,'中青年后备干部培训',1,'党校理论及经营者培训/中青年后备干部培训',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1004,'外语培训',1,'党校理论及经营者培训/外语培训',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1005,'其他培训',1,'党校理论及经营者培训/其他培训',0,5)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2001,'电网规划培训',2,'管理人员培训/电网规划培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2002,'财务审计培训',2,'管理人员培训/财务审计培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2003,'经济法律培训',2,'管理人员培训/经济法律培训',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2004,'人力资源培训',2,'管理人员培训/人力资源培训',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2005,'电力营销培训',2,'管理人员培训/电力营销培训',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2006,'生产技术培训',2,'管理人员培训/生产技术培训',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2007,'工程建设培训',2,'管理人员培训/工程建设培训',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2008,'党政工团培训',2,'管理人员培训/党政工团培训',0,8)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2009,'外语培训',2,'管理人员培训/外语培训',0,9)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2010,'综合类培训',2,'管理人员培训/综合类培训',0,10)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2011,'其他培训',2,'管理人员培训/其他培训',0,11)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3001,'变电人员培训',3,'技能人员培训/变电人员培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3002,'配电人员培训',3,'技能人员培训/配电人员培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3003,'输电人员培训',3,'技能人员培训/输电人员培训',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3004,'继电保护培训',3,'技能人员培训/继电保护培训',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3005,'调度自动化培训',3,'技能人员培训/调度自动化培训',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3006,'电力通讯培训',3,'技能人员培训/电力通讯培训',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3007,'电力营销培训',3,'技能人员培训/电力营销培训',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3008,'新人员培训',3,'技能人员培训/新人员培训',0,8)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3009,'外语培训',3,'技能人员培训/外语培训',0,9)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3010,'班组长培训',3,'技能人员培训/班组长培训',0,10)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3011,'农村供电所长培训',3,'技能人员培训/农村供电所长培训',0,11)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3012,'农电工培训',3,'技能人员培训/农电工培训',0,12)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(3013,'其他技能培训',3,'技能人员培训/其他技能培训',0,13)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4001,'特高压电网知识培训',4,'技术人员培训/特高压电网知识培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4002,'电力生产新技术培训',4,'技术人员培训/电力生产新技术培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4003,'技术规程与规范宣贯',4,'技术人员培训/技术规程与规范宣贯',0,3)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4004,'信息化技术培训',4,'技术人员培训/信息化技术培训',0,4)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4005,'环境保护培训',4,'技术人员培训/环境保护培训',0,5)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4006,'调度与继电保护培训',4,'技术人员培训/调度与继电保护培训',0,6)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4007,'外语培训',4,'技术人员培训/外语培训',0,7)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(4008,'其他技术培训',4,'技术人员培训/其他技术培训',0,8)

GO


PRINT '------ 向培训级别表插入数据 ------'
SET IDENTITY_INSERT TrainingLevel ON
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(0,'',1,3,0)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(1,'国家级',0,0,1)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(2,'国网公司级',0,0,2)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(3,'省公司级',0,0,3)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(4,'地市公司级',0,0,4)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(5,'工区级',0,0,5)
insert into [TrainingLevel] ([Id],[ObjectName],[IsDefault],[LockStatus],[SortIndex]) VALUES(6,'班组级',0,0,6)
SET IDENTITY_INSERT TrainingLevel OFF
GO






















COMMIT TRANSACTION