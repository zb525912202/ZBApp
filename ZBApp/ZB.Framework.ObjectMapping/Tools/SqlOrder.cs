using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    public enum EnumOrderMode : int
    {
        ASC = 0,
        DESC = 1,
        NONE = 2
    }

    [DataContract(IsReference=true)]
    public class OrderItem
    {
        public OrderItem()
        {
        }

        public OrderItem(string column, EnumOrderMode ordermode)
        {
            this.Column = column;
            this.OrderMode = ordermode;
        }

        [DataMember]
        public string Column {get;set;}

        [DataMember]
        public EnumOrderMode OrderMode {get;set;}
    }

    [DataContract(IsReference=true)]
    public class SqlOrder
    {
        public SqlOrder()
        {
            OrderItems = new ObservableCollection<OrderItem>();
        }

        [DataMember]
        public ObservableCollection<OrderItem> OrderItems { get; set; }

        public SqlOrder Clone()
        {
            SqlOrder obj = new SqlOrder();
            foreach (var item in this.OrderItems)
                obj.OrderItems.Add(item);
            return obj;
        }

        public void Clear()
        {
            this.OrderItems.Clear();
        }

        public void AddColumn(string columnname, EnumOrderMode ordermode)
        {
            this.OrderItems.Add(new OrderItem(columnname, ordermode));
        }
    }
}
