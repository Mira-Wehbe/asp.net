using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class Drivers : Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConnStr);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnAddDriver_Click(object sender, EventArgs e)
        {
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
        }

        protected void btnSaveDriver_Click(object sender, EventArgs e)
        {
        }

        protected void btnCancelModal_Click(object sender, EventArgs e)
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
        }
    }
}
