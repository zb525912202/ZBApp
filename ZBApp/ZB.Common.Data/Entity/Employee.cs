using System;
using System.Collections.Generic;
using System.Text;

using System.Runtime.Serialization;
using ZB.Framework.ObjectMapping;
using ZB.Framework.Business;

namespace ZB.Common.Data
{
    [Table]
    [DataContract]
    public partial class Employee : ObjectMappingBase<Employee, int>, IObjectName
    {
        [Column(IsPK = true, IsAutoIncrement = true)]
        [DataMember]
        public int Id { get; set; }

        private int _StatusId;
        [Column]
        [DataMember]
        public int StatusId
        {
            get { return _StatusId; }
            set
            {
                if (_StatusId != value)
                {
                    _StatusId = value;

                }
            }
        }

        private int _DeptId;
        [Column]
        [DataMember]
        public int DeptId
        {
            get { return _DeptId; }
            set
            {
                if (_DeptId != value)
                {
                    _DeptId = value;

                }
            }
        }

        private string _EmployeeNO;
        [Column]
        [DataMember]
        public string EmployeeNO
        {
            get
            {
                return this._EmployeeNO;
            }
            set
            {
                if (!object.ReferenceEquals(this._EmployeeNO, value))
                {
                    this._EmployeeNO = value;

                }
            }
        }

        private string _ObjectName;
        [Column]
        [DataMember]
        public string ObjectName
        {
            get
            {
                return this._ObjectName;
            }
            set
            {
                if (!object.ReferenceEquals(this._ObjectName, value))
                {
                    this._ObjectName = value;

                }
            }
        }

        private int _PostId;
        [Column]
        [DataMember]
        public int PostId
        {
            get { return _PostId; }
            set
            {
                if (_PostId != value)
                {
                    _PostId = value;

                }
            }
        }
        private decimal _PostRank;
        [Column]
        [DataMember]
        public decimal PostRank
        {
            get { return _PostRank; }
            set
            {
                if (_PostRank != value)
                {
                    _PostRank = value;

                }
            }
        }
        private int _Sex;
        [Column]
        [DataMember]
        public int Sex
        {
            get { return _Sex; }
            set
            {
                if (_Sex != value)
                {
                    _Sex = value;

                }
            }
        }
        private DateTime? _Birthday;
        [Column]
        [DataMember]
        public DateTime? Birthday
        {
            get { return _Birthday; }
            set
            {
                if (_Birthday != value)
                {
                    _Birthday = value;

                }
            }
        }

        private string _IdCard;
        [Column]
        [DataMember]
        public string IdCard
        {
            get
            {
                return this._IdCard;
            }
            set
            {
                if (!object.ReferenceEquals(this._IdCard, value))
                {
                    this._IdCard = value;

                }
            }
        }

        private DateTime _JoinTime;
        [Column]
        [DataMember]
        public DateTime JoinTime
        {
            get { return _JoinTime; }
            set
            {
                if (_JoinTime != value)
                {
                    _JoinTime = value;

                }
            }
        }

        private int _EmployeeType;
        [Column]
        [DataMember]
        public int EmployeeType
        {
            get { return _EmployeeType; }
            set
            {
                if (_EmployeeType != value)
                {
                    _EmployeeType = value;

                }
            }
        }

        private string _OutsideDeptFullPath;
        [Column]
        [DataMember]
        public string OutsideDeptFullPath
        {
            get
            {
                return this._OutsideDeptFullPath;
            }
            set
            {
                if (!object.ReferenceEquals(this._OutsideDeptFullPath, value))
                {
                    this._OutsideDeptFullPath = value;

                }
            }
        }

        private int _ManageEmployeeGroupId;
        [Column]
        [DataMember]
        public int ManageEmployeeGroupId
        {
            get { return _ManageEmployeeGroupId; }
            set
            {
                if (_ManageEmployeeGroupId != value)
                {
                    _ManageEmployeeGroupId = value;

                }
            }
        }

        private string _Mobile;
        [Column]
        [DataMember]
        public string Mobile
        {
            get { return _Mobile; }
            set
            {
                if (_Mobile != value)
                {
                    _Mobile = value;

                }
            }
        }

        private string _Email;
        [Column]
        [DataMember]
        public string Email
        {
            get { return _Email; }
            set
            {
                if (_Email != value)
                {
                    _Email = value;

                }
            }
        }

        private int _IsSync;
        [Column]
        public int IsSync
        {
            get
            {
                return _IsSync;
            }
            set
            {
                if (!object.ReferenceEquals(this._IsSync, value))
                {
                    _IsSync = value;

                }
            }
        }

        private int _SortIndex;
        [Column]
        [DataMember]
        public int SortIndex
        {
            get { return _SortIndex; }
            set
            {
                if (_SortIndex != value)
                {
                    _SortIndex = value;

                }
            }
        }


        private string _PMSUserId;
        [Column]
        [DataMember]
        public string PMSUserId
        {
            get
            {
                return this._PMSUserId;
            }
            set
            {
                if (!object.ReferenceEquals(this._PMSUserId, value))
                {
                    this._PMSUserId = value;

                }
            }
        }

        //数据同步时使用,表示同步时，该条数据是否需要同步
        public bool IsSyncUsed { get; set; }

        public const string __IsSync = "IsSync";

        public const string __Id = "Id";
        public const string __EmployeeNO = "EmployeeNO";
        public const string __ObjectName = "ObjectName";
        public const string __Sex = "Sex";
        public const string __Birthday = "Birthday";
        public const string __DeptFullPath = "DeptFullPath";
        public const string __PostName = "PostName";
        public const string __DeptId = "DeptId";
        public const string __PostId = "PostId";
        public const string __StatusId = "StatusId";
        public const string __PostRank = "PostRank";
        public const string __JoinTime = "JoinTime";
        public const string __OutsideDeptFullPath = "OutsideDeptFullPath";
        public const string __ManageEmployeeGroupId = "ManageEmployeeGroupId";
        public const string __Mobile = "Mobile";
        public const string __Email = "Email";
        public const string __SortIndex = "SortIndex";
    }
}
