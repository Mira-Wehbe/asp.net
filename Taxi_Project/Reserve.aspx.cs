using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace Taxi_Project
{
    public partial class ReservePage : System.Web.UI.Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConnStr);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
        }

        protected void btnReserve_Click(object sender, EventArgs e)
        {
        }

        protected void btnMyTrips_Click(object sender, EventArgs e)
        {
            Response.Redirect("History.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}