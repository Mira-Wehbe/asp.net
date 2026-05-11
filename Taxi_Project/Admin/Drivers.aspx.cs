using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class Drivers : Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadDrivers("All");
            }
        }

        private void LoadDrivers(string filter)
        {
            using (SqlConnection conn = GetConnection())
            {
                try
                {
                    conn.Open();

                    string query = "SELECT DriverID, FullName, Phone, Gender, IsAvailable FROM Drivers";

                    if (filter == "Available")
                        query += " WHERE IsAvailable = 1";
                    else if (filter == "Busy")
                        query += " WHERE IsAvailable = 0";

                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvDrivers.DataSource = dt;
                    gvDrivers.DataBind();
                }
                catch (Exception ex)
                {
                    lblError.Visible = true;
                    lblError.Text = ex.Message;
                }
            }
        }

        protected void btnAddDriver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/DriverForm.aspx");
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            LoadDrivers(btn.CommandArgument);
        }

        protected void btnSaveDriver_Click(object sender, EventArgs e) { }
        protected void btnCancelModal_Click(object sender, EventArgs e) { }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }

        //delete function
        private void DeleteDriver(int id)
        {
            using (SqlConnection conn = new SqlConnection(cs))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Drivers WHERE DriverID=@id", conn);

                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
        }
        //grid view

        protected void GridCommand(object sender, CommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditDriver")
            {
                Response.Redirect("~/Admin/EditDriver.aspx?DriverID=" + id);
            }
            else if (e.CommandName == "DeleteDriver")
            {
                DeleteDriver(id);
                LoadDrivers("All"); // refresh grid
            }
        }
    }
}