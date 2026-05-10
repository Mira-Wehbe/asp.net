using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class Bookings : Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConnStr);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

     
        protected void btnView_Click(object sender, EventArgs e)
        {
        }

        
        protected void btnNewBooking_Click(object sender, EventArgs e)
        {
        }

       
        protected void btnFilter_Click(object sender, EventArgs e)
        {
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
        }


        protected void btnCalNav_Click(object sender, EventArgs e)
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}