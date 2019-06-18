
IF EXISTS(SELECT * FROM [Role] WHERE Id=2)
BEGIN
UPDATE [Role] SET ObjectName='≈‡—µ‘±',IsDefault=0 WHERE Id=2;
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingLessonManage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingLessonManage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingRequMainCommand')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingRequMainCommand');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='NoticeManage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'NoticeManage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='VoteManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'VoteManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='OrgManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'OrgManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='GroupManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'GroupManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CertManage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CertManage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TeacherManager')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TeacherManager');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='ReportManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'ReportManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CustomerManage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CustomerManage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='EmployeeSurfeyManage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'EmployeeSurfeyManage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='cepingmanage')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'cepingmanage');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='SystemHelpCert')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'SystemHelpCert');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='QuestionManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'QuestionManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='QuesFilter')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'QuesFilter');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='PaperManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PaperManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='ResourceManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'ResourceManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='LessonManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'LessonManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='LearningTask')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'LearningTask');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='EGLearningTask')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'EGLearningTask');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='ExamManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'ExamManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='NetClassManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'NetClassManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='PostStandardStudyContentManagement')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PostStandardStudyContentManagement');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingPlan')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingPlan');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingProject')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingProject');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingWorkQuery')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingWorkQuery');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingClass')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingClass');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingExam')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingExam');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='JudgeTrainee')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'JudgeTrainee');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingCredit')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingCredit');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingEmployeeHistory')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingEmployeeHistory');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='NetWorkLearningCredit')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'NetWorkLearningCredit');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='PostCertDemand')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PostCertDemand');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CertAudit')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CertAudit');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CertExpiredDate')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CertExpiredDate');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CertTask')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CertTask');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='Examming')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'Examming');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='PlanApprove')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PlanApprove');
END

IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingRelatedWork')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingRelatedWork');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingRelatedProject')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingRelatedProject');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingEmloyeeJudge')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingEmloyeeJudge');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='CertSendup')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'CertSendup');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TrainingArchives')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TrainingArchives');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TMSProjectList')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TMSProjectList');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TMSProjectLibrary')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TMSProjectLibrary');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='TMSNormalTrainingOnWork')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'TMSNormalTrainingOnWork');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='PostAbilityTraining')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'PostAbilityTraining');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='EmployeeInStandard')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'EmployeeInStandard');
END


IF NOT EXISTS(SELECT * FROM [RoleInPrivilege] WHERE [RoleId]=2 AND [PrvgName]='ChaoHuTrainingWorkResult')
BEGIN
INSERT INTO [RoleInPrivilege] ([RoleId],[PrvgName]) VALUES (2,'ChaoHuTrainingWorkResult');
END


