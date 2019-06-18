using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ZB.Tools.TableMaker
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        public Action<string> ShowMessageWriter;

        DBManager dbmgr = null;
        CodeWriter_ZBMaster5 writer_ZBMaster5 = null;
        CodeWriter_ZBWebSite writer_ZBWebSite = null;

        public event PropertyChangedEventHandler PropertyChanged;
        public virtual void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        private ObservableCollection<ZBTable> _TableList;
        public ObservableCollection<ZBTable> TableList
        {
            get { return (_TableList ?? new ObservableCollection<ZBTable>()); }
            set
            {
                if (!object.Equals(_TableList, value))
                {
                    _TableList = value;
                    this.RaisePropertyChanged("TableList");
                }
            }
        }

        public MainWindow()
        {
            InitializeComponent();
            

            this.Loaded += (s, e) =>
            {
                this.DataContext = this;
            };

            this.ShowMessageWriter = new Action<string>(WriteConsoleMsg);
            this.cboDatabaseName.SelectionChanged += (s, e) =>
            {
                if (e.AddedItems.Count > 0)
                {
                    ZBDatabase db = (ZBDatabase)e.AddedItems[0];
                    this.TableList = db.TableList;
                    txtNamespacePrefix.Text = string.Format("ZB.{0}.Data", db.ObjectName.Replace("ZB", "").Replace("_D", "").Replace("_A", ""));
                }
            };
            this.btnConnect.Click += (s, e) =>
            {
                this.Connect();
            };
            this.btnStartBuild.Click += (s, e) =>
            {
                this.Build();
            };
        }

        private void Connect()
        {
            string connString = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}",
                this.txtServerAddress.Text, this.txtUserName.Text, this.txtPassword.Text);

            Thread t = new Thread(new ParameterizedThreadStart(delegate
            {
                dbmgr = new DBManager()
                {
                    ConnectionString = connString,
                    MsgWriter = this.ShowMessageWriter
                };

                System.Windows.Application.Current.Dispatcher.BeginInvoke(new Action(() =>
                {
                    //this.cboDatabaseName.Items.Clear();
                    this.cboDatabaseName.IsEnabled = false;
                    this.btnStartBuild.IsEnabled = false;
                }));

                dbmgr.LoadDatabaseList();

                System.Windows.Application.Current.Dispatcher.BeginInvoke(new Action(() =>
                {
                    this.cboDatabaseName.ItemsSource = dbmgr.DatabaseList;
                    this.cboDatabaseName.SelectedIndex = 0;
                    this.cboDatabaseName.IsEnabled = true;

                    this.btnStartBuild.IsEnabled = true;

                }));
            }));
            t.Start();
        }

        private void Build()
        {
            ZBDatabase db = (ZBDatabase)cboDatabaseName.SelectedItem;

            FolderBrowserDialog fbd = new FolderBrowserDialog() { ShowNewFolderButton = true };
            fbd.RootFolder = System.Environment.SpecialFolder.Desktop;
            if (fbd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                btnStartBuild.IsEnabled = false;

                //DeleteDirAllFile(fbd.SelectedPath);

                if (this.ZBmaster5.IsChecked == true)
                {
                    writer_ZBMaster5 = new CodeWriter_ZBMaster5();
                    writer_ZBMaster5.WriteCodeFile(dbmgr, db.ObjectName, fbd.SelectedPath, txtNamespacePrefix.Text);
                }
                else if (this.ZBwebsite.IsChecked == true)
                {
                    writer_ZBWebSite = new CodeWriter_ZBWebSite();
                    writer_ZBWebSite.WriteCodeFile(dbmgr, db.ObjectName, fbd.SelectedPath, txtNamespacePrefix.Text);
                }
             
                btnStartBuild.IsEnabled = true;
                System.Diagnostics.Process.Start(fbd.SelectedPath);
            }

        }

        public void DeleteDirAllFile(string dirRoot)
        {
            DirectoryInfo aDirectoryInfo = new DirectoryInfo(System.IO.Path.GetDirectoryName(dirRoot));
            FileInfo[] files = aDirectoryInfo.GetFiles("*.*", SearchOption.AllDirectories);
            foreach (FileInfo f in files)
            {
                File.Delete(f.FullName);
            }
        }

        private void WriteConsoleMsg(string s)
        {
            System.Windows.Application.Current.Dispatcher.BeginInvoke(new Action(() =>
            {
                this.txtConsole.Text = s;
            }));
        }
    }

    public class BoolToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return ((bool)value) ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            return ((Visibility)value) == Visibility.Visible;
        }
    }
}
