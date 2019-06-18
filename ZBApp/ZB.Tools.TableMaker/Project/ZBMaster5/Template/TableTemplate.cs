using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;


namespace %Namespace%
{
    [Table]
    public partial class %ClassName% : ObjectMappingBase<%ClassName%, %pkType%>
    {
        %Properties%

        #region ColumnName
        %Hide%
        #endregion
    }
}
