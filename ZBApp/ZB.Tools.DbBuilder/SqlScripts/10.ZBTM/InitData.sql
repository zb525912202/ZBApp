PRINT '------ 向培训项目形式表插入数据 ------'
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('',0)
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('内部',1)
insert into [TrainingMode] ([ObjectName],[SortIndex]) VALUES('外部',2)
GO

--PRINT '------ 向培训项目形式表插入数据 ------'
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('年度计划',1)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('半年度计划',2)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('季度计划',3)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('月度计划',4)
--insert into [TrainingPlanType] ([ObjectName],[SortIndex]) VALUES('临时计划',5)
--GO

PRINT '------ 向培训事务类型表插入数据 ------'
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-1,'培训班',3,1)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-2,'考试',3,2)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-3,'学历',3,3)
insert into [TrainingWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-4,'网络自主学习',3,4)

GO

PRINT '------ 向培训班类型插入数据 ------'
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'岗位适应性培训',0,'岗位适应性培训',1)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'其他培训',0,'其他培训',2)

insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'岗前培训(资格培训)',1,'岗位适应性培训/岗前培训(资格培训)',1)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'岗位培训',1,'岗位适应性培训/岗位培训',2)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'技能等级培训',1,'岗位适应性培训/技能等级培训',3)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1004,'专业技术人员继续教育',1,'岗位适应性培训/专业技术人员继续教育',4)
insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1005,'离岗培训',1,'岗位适应性培训/离岗培训',5)

insert into [TcType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'国际合作培训',2,'其他培训/国际合作培训',1)
GO

PRINT '------ 向课程类型插入数据 ------'
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'岗位适应性课程',0,'岗位适应性课程',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'专业技术课程',0,'专业技术课程',2)

insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'岗位主修课程',1,'岗位适应性课程/岗位主修课程',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'岗位必修课程',1,'岗位适应性课程/岗位必修课程',2)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'岗位选修课程',1,'岗位适应性课程/岗位选修课程',3)

insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'专业主修课程',2,'专业技术课程/专业主修课程',1)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2002,'专业必修课程',2,'专业技术课程/专业必修课程',2)
insert into [TcCourseType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2003,'专业选修课程',2,'专业技术课程/专业选修课程',3)
GO

PRINT '------ 向培训班结果类型表插入数据 ------'
SET IDENTITY_INSERT TcResultType ON
insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,0)

insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'结业',0,1)
insert into [TcResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'未结业',0,2)
SET IDENTITY_INSERT TcResultType OFF
GO

PRINT '------ 向费用类型表插入数据 ------'
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('学历',1)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('执证费',2)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('评定项费',3)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('教材费',4)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('交通费',5)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('食宿费',6)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('授课费',7)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('场地租赁费',8)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('培训师聘请',9)
insert into [TrainingBillType] ([ObjectName],[SortIndex]) VALUES('其他',10)
GO

PRINT '------ 向考试类型插入数据 ------'
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1,'考试',0,'考试',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2,'竞赛',0,'竞赛',2)

insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1001,'普通考试',1,'考试/普通考试',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1002,'技能鉴定考试',1,'考试/技能鉴定考试',2)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1003,'抽考',1,'考试/抽考',3)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(1004,'调考',1,'考试/调考',4)

insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2001,'技术比武',2,'竞赛/技术比武',1)
insert into [TeType] ([Id],[ObjectName],[ParentId],[FullPath],[SortIndex]) VALUES(2002,'技能竞赛',2,'竞赛/技能竞赛',2)
GO

PRINT '------ 向考试结果表插入数据 ------'
SET IDENTITY_INSERT TeResultType ON
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,1)

insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'优',0,1)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'良',0,2)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(3,'及格',0,3)
insert into [TeResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(4,'不及格',0,4)
SET IDENTITY_INSERT TeResultType OFF
GO

PRINT '------ 评定项类型 ------'
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('在岗学习',1)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('脱产集中学习',2)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('自主学习',3)
insert into [TrainingKind] ([ObjectName],[SortIndex]) VALUES('学分奖励',4)
GO

--PRINT '------ 向学历结果类型表插入数据 ------'
--SET IDENTITY_INSERT EduResultType ON
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(0,'',3,0)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(1,'毕业',0,1)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(2,'结业',0,2)
--insert into [EduResultType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(3,'肄业',0,3)
--SET IDENTITY_INSERT EduResultType OFF
--GO