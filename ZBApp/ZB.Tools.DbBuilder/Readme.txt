

1,调试时修改FrmDbBuilder代码内的
//发布模式
DirectoryInfo dir = new DirectoryInfo(System.Windows.Forms.Application.ExecutablePath);
this.tbScriptDir.Text = dir.Parent.FullName;

//调试模式
//DirectoryInfo dir = new DirectoryInfo(System.AppDomain.CurrentDomain.BaseDirectory);
//this.tbScriptDir.Text = Path.Combine(dir.Parent.Parent.FullName, "SqlScripts");



2,修改完成后，编译程序，将ZB.Tools.DbBuilder.exe文件覆盖到ZB.AppShell.Startup.WebHost/SqlScripts


3,增加自定义的更新处理逻辑时（非数据库脚本），将UpgradeScript内定义的处理程序添加到ZB.AppShell.Startup.WebHost/ScriptUpgrade/0.UpgradeConfig.xml中
例如：（日结数据库数据迁移自定义处理程序）
<LearningToDailyLogScript ZBDb="ZBLearning"/>
