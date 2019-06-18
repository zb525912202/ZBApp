PRINT '------ 向培训事务类型表插入数据 ------'
INSERT INTO [TrainingOnWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-10, '培训班', 3, 1);
INSERT INTO [TrainingOnWorkType] ([Id],[ObjectName],[LockStatus],[SortIndex]) VALUES(-20, '考试', 3, 2);

PRINT '------ 内置培训事务属性及值 ------'
PRINT '----------培训方式 Start--------------'
INSERT INTO [TrainingAttribute]([Id],[ParentId],[ObjectName],[FullPath],[LockStatus],[SortIndex]) VALUES(-10,0,'培训方式','培训方式',3,1);
INSERT INTO [TrainingAttributeValue]([Id],[AttrId],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex])VALUES(-1001,-10,'线下培训',0,'线下培训',3,1);
INSERT INTO [TrainingAttributeValue]([Id],[AttrId],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex])VALUES(-1002,-10,'网上培训',0,'网上培训',3,1);
PRINT '----------培训方式 End--------------'


PRINT '------ 培训事务类型对应的属性(内置) ------'
INSERT INTO [TrainingAttributeInType]([Id],[WorkTypeId],[AttrId],[LockStatus],[SortIndex])VALUES(1,-10,-10,3,1);	
INSERT INTO [TrainingAttributeInType]([Id],[WorkTypeId],[AttrId],[LockStatus],[SortIndex])VALUES(2,-20,-10,3,1);


PRINT '培训事务类型对应的单位(内置)'
INSERT INTO [dbo].[TrainingUnitInType]([Id],[WorkTypeId],[ObjectName],[LockStatus],[SortIndex])VALUES(1,-10,'课时',3,1);
INSERT INTO [dbo].[TrainingUnitInType]([Id],[WorkTypeId],[ObjectName],[LockStatus],[SortIndex])VALUES(2,-20,'分',3,1);


PRINT '------培训事务级别-------'
SET IDENTITY_INSERT TrainingOnWorkLevel ON
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(0,'',1,0,3,0)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(1,'国家级',0,0,0,1)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(2,'集团公司级',0,0,0,2)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(3,'省公司级',0,0,0,3)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(4,'地市公司级',0,1,0,4)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(5,'工区级',0,0,0,5)
INSERT INTO [TrainingOnWorkLevel] ([Id],[ObjectName],[IsDefault],[IsRootLevel],[LockStatus],[SortIndex]) VALUES(6,'班组级',0,0,0,6)
SET IDENTITY_INSERT TrainingOnWorkLevel OFF


PRINT '------按是否在岗划分------'
INSERT INTO TrainingCategory VALUES(1, '岗前培训', 0, '岗前培训', 0, 0, 1);
INSERT INTO TrainingCategory VALUES(2, '岗位培训', 0, '岗位培训', 0, 0, 2);
INSERT INTO TrainingCategory VALUES(3, '离岗培训', 0, '离岗培训', 0, 0, 3);

PRINT '------按专业划分-------'
INSERT INTO TrainingCategory VALUES(4, '管理培训', 0, '管理培训', 1, 0, 1);
INSERT INTO TrainingCategory VALUES(5, '生产培训', 0, '生产培训', 1, 0, 2);
INSERT INTO TrainingCategory VALUES(6, '安全培训', 0, '安全培训', 1, 0, 3);
INSERT INTO TrainingCategory VALUES(7, '锅炉专业', 5, '生产培训/锅炉专业', 1, 0, 1);
INSERT INTO TrainingCategory VALUES(8, '锅炉运行', 7, '生产培训/锅炉专业/锅炉运行', 1, 0, 1);
INSERT INTO TrainingCategory VALUES(9, '电除尘值班', 7, '生产培训/锅炉专业/电除尘值班', 1, 0, 2);
INSERT INTO TrainingCategory VALUES(10, '除灰值班', 7, '生产培训/锅炉专业/除灰值班', 1, 0, 3);
INSERT INTO TrainingCategory VALUES(11, '脱硫值班', 7, '生产培训/锅炉专业/脱硫值班', 1, 0, 4);

PRINT '------按人员类型划分--------'
INSERT INTO TrainingCategory VALUES(12, '基层管理人员培训', 0, '基层管理人员培训', 2, 0, 1);
INSERT INTO TrainingCategory VALUES(13, '人力资源培训', 12, '基层管理人员培训/人力资源培训', 2, 0, 1);
INSERT INTO TrainingCategory VALUES(14, '财务审计培训', 12, '基层管理人员培训/财务审计培训', 2, 0, 1);
INSERT INTO TrainingCategory VALUES(15, '经济法律培训', 12, '基层管理人员培训/经济法律培训', 2, 0, 1);
INSERT INTO TrainingCategory VALUES(16, '综合类培训', 12, '基层管理人员培训/综合类培训', 2, 0, 1);
INSERT INTO TrainingCategory VALUES(17, '其他培训', 12, '基层管理人员培训/其他培训', 2, 0, 1);

INSERT INTO TrainingCategory VALUES(18, '生产管理人员培训', 0, '生产管理人员培训', 2, 0, 2);
INSERT INTO TrainingCategory VALUES(19, '班组长培训', 0, '班组长培训', 2, 0, 3);
INSERT INTO TrainingCategory VALUES(20, '新人员培训', 0, '新人员培训', 2, 0, 3);

INSERT INTO TrainingCategory VALUES(21, '技术人员培训', 0, '技术人员培训', 2, 0, 3);
INSERT INTO TrainingCategory VALUES(22, '电力生产新技术培训', 21, '技术人员培训/电力生产新技术培训', 2, 0, 3);
INSERT INTO TrainingCategory VALUES(23, '信息化技术培训', 21, '技术人员培训/信息化技术培训', 2, 0, 3);
INSERT INTO TrainingCategory VALUES(24, '技术规程与规范宣贯', 21, '技术人员培训/技术规程与规范宣贯', 2, 0, 3);
INSERT INTO TrainingCategory VALUES(25, '其他技术培训', 21, '技术人员培训/其他技术培训', 2, 0, 3);


PRINT '------按培训方式划分--------'
INSERT INTO TrainingCategory VALUES(29, '脱产培训', 0, '脱产培训', 3, 0, 1);
INSERT INTO TrainingCategory VALUES(30, '现场培训', 0, '现场培训', 3, 0, 2);


PRINT '------按取证类型划分--------'
INSERT INTO TrainingCategory VALUES(26, '职业资格取证培训（技能鉴定培训）', 0, '职业资格取证培训（技能鉴定培训）', 4, 0, 1);
INSERT INTO TrainingCategory VALUES(27, '特种作业取证培训', 0, '特种作业取证培训', 4, 0, 2);
INSERT INTO TrainingCategory VALUES(28, '学历教育', 0, '学历教育', 4, 0, 3);


PRINT '------按考试类型划分--------'
INSERT INTO TrainingCategory VALUES(31, '考试', 0, '考试', 5, 0, 1);
INSERT INTO TrainingCategory VALUES(32, '技能鉴定考试', 31, '考试/技能鉴定考试', 5, 0, 1);
INSERT INTO TrainingCategory VALUES(33, '抽考', 31, '考试/抽考', 5, 0, 2);
INSERT INTO TrainingCategory VALUES(34, '调考', 31, '考试/调考', 5, 0, 3);
INSERT INTO TrainingCategory VALUES(35, '竞赛', 0, '竞赛', 5, 0, 1);
INSERT INTO TrainingCategory VALUES(36, '技术比武', 35, '竞赛/技术比武', 5, 0, 3);
INSERT INTO TrainingCategory VALUES(37, '技能竞赛', 35, '竞赛/技能竞赛', 5, 0, 3);



PRINT '------培训费用--------'

INSERT INTO TrainingBillCategory VALUES(1, '公务费',		0, '',				0, 0);
INSERT INTO TrainingBillCategory VALUES(2, '',			1, '公务费/',		0, 0);

INSERT INTO TrainingBillCategory VALUES(3, '交通费',		1, '公务费/交通费',	0, 0);
INSERT INTO TrainingBillCategory VALUES(4, '',			3, '公务费/交通费/', 0, 0);

INSERT INTO TrainingBillCategory VALUES(5, '食宿费',		1, '公务费/食宿费',	0, 0);
INSERT INTO TrainingBillCategory VALUES(6, '',			5, '公务费/食宿费/', 0, 0);



PRINT '------ 向培训内容表插入数据 其他培训内容分类   ------'
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(0,'',0,'',3,1)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1,'管理人员培训',0,'管理人员培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2,'一般人员培训',0,'一般人员培训',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1001,'创新能力培训',1,'管理人员培训/创新能力培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(1002,'管理知识培训',1,'管理人员培训/管理知识培训',0,2)

insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2001,'专业知识培训',2,'一般人员培训/专业知识培训',0,1)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2002,'工作技能培训',2,'一般人员培训/工作技能培训',0,2)
insert into [TrainingContentType] ([Id],[ObjectName],[ParentId],[FullPath],[LockStatus],[SortIndex]) VALUES(2003,'态度意识培训',2,'一般人员培训/态度意识培训',0,3)
