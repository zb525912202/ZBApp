USE [$(DatabaseName)]
GO
BEGIN TRANSACTION

PRINT '------培训费用------'
CREATE TABLE [dbo].[TrainingWorkBill](
	[Id]					INT PRIMARY KEY NOT NULL,
	[WorkId]				INT NOT NULL,					--培训事务ID
	[BillType]				INT NOT NULL,					--费用类型(支出、收入)
	[BillCategory1]			INT NOT NULL,					--费用大类
	[BillCategory2]			INT NOT NULL,					--费用细类
	[UseDate]				DATETIME NOT NULL,				--费用产生日期
	[Amount]				DECIMAL(18,5) NOT NULL,			--金额
	[UseName]				NVARCHAR(50) NOT NULL,			--经手人
	[Remark]				NVARCHAR(500),					--备注
	[Month]					INT NOT NULL,					--费用产生时的月份
	[Quarter]				INT NOT NULL,					--费用产生时的季度
	[HalfYear]				INT NOT NULL,					--费用产生时的半年
	[Year]					INT NOT NULL,					--费用产生的年度
)

ALTER TABLE [TrainingWorkBill] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWorkBill_BillCategory1] FOREIGN KEY ([BillCategory1]) REFERENCES [TrainingBillCategory](Id),
	CONSTRAINT [FK_TrainingWorkBill_BillCategory2] FOREIGN KEY ([BillCategory2]) REFERENCES [TrainingBillCategory](Id),
	CONSTRAINT [FK_TrainingWorkBill_TrainingOnWork] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork](Id)
GO


PRINT '-------------培训费用拆分表-------------------'
CREATE TABLE [dbo].[TrainingWorkBillSplit](
	[Id]				INT PRIMARY KEY NOT NULL,
	[BillId]			INT NOT NULL,								--培训费用ID
	[Amount]			DECIMAL(18,5) NOT NULL,						--金额
	[EmployeeId]		INT NOT NULL,								--人员ID
	[EmployeeNO]		NVARCHAR(50) NOT NULL,						--人员编号
	[EmployeeName]		NVARCHAR(50) NOT NULL,						--人员姓名
	[Age]				INT,										--人员年龄
	[Sex]				INT NOT NULL,								--性别
	[DeptId]			INT NOT NULL,								--部门ID
	[DeptFullPath]		NVARCHAR(260) NOT NULL,						--部门名称
	[PostId]			INT NOT NULL,								--岗位ID
	[PostName]			NVARCHAR(50),								--岗位名称
)

ALTER TABLE [TrainingWorkBillSplit] WITH CHECK ADD
	CONSTRAINT [FK_TrainingWorkBillSplit_TrainingWorkBill] FOREIGN KEY ([BillId]) REFERENCES [TrainingWorkBill](Id)
GO


PRINT '-------------人员培训费用详细表-------------------'
CREATE TABLE [dbo].[EmployeeTrainingBillDetail](
	[Id]				INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[WorkId]			INT NOT NULL,								--培训事务ID
	[BillId]			INT NOT NULL,								--费用ID
	[Amount]			DECIMAL(18,5) NOT NULL,						--金额
	[EmployeeId]		INT NOT NULL,								--人员ID
	[EmployeeNO]		NVARCHAR(50) NOT NULL,						--人员编号
	[EmployeeName]		NVARCHAR(50) NOT NULL,						--人员姓名
	[Age]				INT,										--人员年龄
	[Sex]				INT NOT NULL,								--性别
	[DeptId]			INT NOT NULL,								--部门ID
	[DeptFullPath]		NVARCHAR(260) NOT NULL,						--部门名称
	[PostId]			INT NOT NULL,								--岗位ID
	[PostName]			NVARCHAR(50),								--岗位名称
)

ALTER TABLE [EmployeeTrainingBillDetail] WITH CHECK ADD
	CONSTRAINT [FK_EmployeeTrainingBillDetail_TrainingWorkBill] FOREIGN KEY ([BillId]) REFERENCES [TrainingWorkBill](Id),
	CONSTRAINT [FK_EmployeeTrainingBillDetail_TrainingOnWork] FOREIGN KEY ([WorkId]) REFERENCES [TrainingOnWork](Id)
GO


COMMIT TRANSACTION