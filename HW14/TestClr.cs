using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;

public class CalcExpression
    {

        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void GetUserName() 
        {
            using (SqlConnection connection = new SqlConnection("context connection=true"))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("select user_name()", connection);
                SqlDataReader r = command.ExecuteReader();
                SqlContext.Pipe.Send(r);
            }
          
        }
        [Microsoft.SqlServer.Server.SqlFunction]
        public static SqlString Calculate(SqlString expression)  
        {
            SqlString RetValue = new DataTable().Compute(expression.ToString(), null).ToString();
            return RetValue;
        }

   

}

