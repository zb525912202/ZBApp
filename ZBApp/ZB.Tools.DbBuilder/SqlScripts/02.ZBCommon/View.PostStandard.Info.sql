USE [$(DatabaseName)]
GO

BEGIN TRANSACTION

PRINT '--------------------------需求调差相关视图--------------------'

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[AbilityItemLevelView]'))
DROP VIEW [AbilityItemLevelView]
GO
CREATE VIEW [dbo].[AbilityItemLevelView]
			AS
			SELECT AIL.Id
			,AIL.ItemId
			,AIL.LevelId
			,AIC.Number AS AbilityItemCategoryNumber
			,AI.Number AS AbilityItemNumber
			,PSL.ObjectName AS LevelName
			,AIC.StandardId
			 FROM   AbilityItemLevel AIL 
			JOIN AbilityItem AI ON AIL.ItemId = AI.Id
			JOIN AbilityItemCategory AIC ON AIC.Id = AI.AICategoryId
			JOIN PostStandardLevel PSL ON PSL.Id = AIL.LevelId
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainingRequIncludeDeptView]'))
DROP VIEW [TrainingRequIncludeDeptView]
GO
CREATE VIEW [dbo].[TrainingRequIncludeDeptView] 
	AS 
	SELECT D.*,RID.RequId FROM TrainingRequIncludeDept RID
	JOIN Dept D On D.Id=RID.DeptId
GO
				
			
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainingRequIncludeStandardView]'))
DROP VIEW [TrainingRequIncludeStandardView]
GO	
CREATE VIEW [dbo].[TrainingRequIncludeStandardView] 
	AS 
	SELECT RIS.*
	,SC.ObjectName AS CategoryName
	,PS.ObjectName AS SubjectName
	,PST.ObjectName AS StandardName
	FROM TrainingRequIncludeStandard RIS
	JOIN StandardCategory SC ON SC.Id = RIS.CategoryId
	LEFT JOIN PostSubject PS ON PS.Id = RIS.SubjectId
	LEFT JOIN PostStandard PST ON PST.Id = RIS.StandardId
GO




IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[PostStandardCertDemandView]'))
DROP VIEW [PostStandardCertDemandView]
GO
CREATE VIEW [dbo].[PostStandardCertDemandView]
AS
	SELECT PS.*
	,CT.ObjectName AS CertTypeName
	,CTL.ObjectName AS CertTypeLevelName
	,CTK.ObjectName AS CertTypeKindName
	,CTK.FullPath AS CertTypeKindFullPath
	FROM PostStandardCertDemand PS
	JOIN CertType CT ON PS.CertTypeId = CT.Id
	LEFT JOIN CertTypeLevel CTL ON CTL.Id = PS.CertTypeLevelId
	JOIN CertTypeKind CTK ON CTK.Id = PS.CertTypeKindId
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[StandardLevelInCertTypeLevelView]'))
DROP VIEW [StandardLevelInCertTypeLevelView]
GO
CREATE VIEW [dbo].[StandardLevelInCertTypeLevelView]
	AS
	SELECT SL.*,CT.ObjectName AS CertTypeName, CTL.ObjectName AS CertTypeLevelName 
	FROM StandardLevelInCertTypeLevel SL
	JOIN CertType CT ON SL.CertTypeId = CT.Id
	JOIN CertTypeLevel CTL ON SL.CertTypeLevel=CTL.Id
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EmployeePostStandardView]'))
DROP VIEW [EmployeePostStandardView]
GO
--人员岗位标准视图
CREATE VIEW [dbo].[EmployeePostStandardView]
AS
	SELECT E.Id AS EmployeeId, PS.* FROM Employee E
	JOIN PostInStandard PIS ON E.PostId = PIS.PostId
	JOIN PostStandard PS ON PIS.StandardId = PS.Id
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeCertGroupView]'))
DROP VIEW [SQ_EmployeeCertGroupView]
GO
--人员持证信息分组视图(取每个证书分类下级别最大的证书)
CREATE VIEW [dbo].[SQ_EmployeeCertGroupView]
AS
SELECT * FROM
(
SELECT EC.EmployeeId, EC.CertTypeId, EC.CertTypeLevelId, EC.CertTypeKindId, LV.SortIndex FROM EmployeeCert EC
JOIN CertTypeLevel LV ON LV.Id = EC.CertTypeLevelId
) 
A WHERE A.SortIndex =
(
	SELECT MAX(LV.SortIndex) FROM EmployeeCert EC
	JOIN CertTypeLevel LV ON LV.Id = EC.CertTypeLevelId
	WHERE A.CertTypeId = EC.CertTypeId AND A.CertTypeKindId = EC.CertTypeKindId AND A.EmployeeId = EC.EmployeeId
)

GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[TrainingSectionInAbilityItemView]'))
DROP VIEW [TrainingSectionInAbilityItemView]
GO
--需求调查中能力总表对应的所有模块视图
CREATE VIEW [dbo].[TrainingSectionInAbilityItemView]
AS
SELECT TS.*,AIL.ItemId,AIL.LevelId FROM TrainingSection TS
JOIN TrainingSectionInSubject TSS ON TS.Id = TSS.SectionId
JOIN AbilityItemInSubject AIS ON AIS.SubjectId = TSS.SubjectId
JOIN AbilityItemLevel AIL ON AIL.Id = AIS.ItemLevelId
GO


--人员对应的岗位标准视图
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SQ_EmployeeInStandardView]'))
DROP VIEW [SQ_EmployeeInStandardView]
GO
CREATE VIEW SQ_EmployeeInStandardView
AS
SELECT ES.* 
,PS.ObjectName AS StandardName
,PS.CategoryId
,PL.ObjectName AS LevelName
,SC.ObjectName AS CategoryName
FROM EmployeeInStandard ES
JOIN PostStandard PS ON ES.StandardId = PS.Id
JOIN PostStandardLevel PL ON ES.LevelId = PL.Id
JOIN StandardCategory SC ON PS.CategoryId = SC.Id
GO

COMMIT TRANSACTION