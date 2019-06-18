USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------ 向证书驳回提示表插入数据 ------'
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('非本人证书影印件',1)
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('证书影印件不清晰',2)
insert into [CertRejectInfo] ([ObjectName],[SortIndex]) VALUES('证书基本信息填写有误',3)


PRINT '------ 向证书类型、级别表插入数据 ------'
insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(1,'职业资格',1,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(101,1,'初级工',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(102,1,'中级工',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(103,1,'高级工',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(104,1,'技师',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(105,1,'高级技师',5)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(2,'专业技术资格',2,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(201,2,'初级',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(202,2,'中级',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(203,2,'高级',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(204,2,'副高',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(205,2,'正高',5)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(3,'学历',3,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(301,3,'小学',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(302,3,'初中',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(303,3,'高中(中专)',3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(304,3,'大专',4)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(305,3,'本科',5)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(306,3,'硕士研究生',6)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(307,3,'博士研究生',7)

insert into [CertType] ([Id],[ObjectName],[SortIndex],[LockStatus]) VALUES(4,'学位',4,3)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(401,4,'学士',1)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(402,4,'硕士',2)
insert into [CertTypeLevel] ([Id],[CertTypeId],[ObjectName],[SortIndex]) VALUES(403,4,'博士',3)
GO

COMMIT TRANSACTION