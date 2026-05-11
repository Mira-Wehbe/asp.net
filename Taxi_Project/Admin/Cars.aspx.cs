using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class Cars : Page
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
                LoadCars("All");
            }
        }

        // LOAD CARS
        private void LoadCars(string type)
        {
            using (SqlConnection conn = GetConnection())
            {
                try
                {
                    conn.Open();

                    string query;
                    if (type == "All")
                    {
                        query = "SELECT * FROM Cars";
                    }
                    else
                    {
                        query = "SELECT * FROM Cars WHERE CarType=@CarType";
                    }

                    SqlCommand cmd = new SqlCommand(query, conn);

                    if (type != "All")
                    {
                        cmd.Parameters.AddWithValue("@CarType", type);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvCars.DataSource = dt;
                    gvCars.DataBind();
                }
                catch (Exception ex)
                {
                    lblError.Visible = true;
                    lblError.Text = ex.Message;
                }
            }
        }

        protected void btnAddCar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/CarForm.aspx");
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;

            string type = btn.CommandArgument;

            LoadCars(type);
        }

        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
        }

        protected void btnCancelModal_Click(object sender, EventArgs e)
        {
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }

        //function delet car 

        private void DeleteCar(int carId)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                SqlCommand cmd1 = new SqlCommand(
                    "SELECT COUNT(*) FROM Drivers WHERE CarID=@CarID", conn);
                cmd1.Parameters.AddWithValue("@CarID", carId);
                int drivers = (int)cmd1.ExecuteScalar();
                SqlCommand cmd2 = new SqlCommand(
                    "SELECT COUNT(*) FROM Trips WHERE CarID=@CarID", conn);
                cmd2.Parameters.AddWithValue("@CarID", carId);
                int trips = (int)cmd2.ExecuteScalar();

                if (drivers > 0 || trips > 0)
                {

                    Response.Write("<script>alert('This car is used in Drivers or Trips, cannot delete.');</script>");

                    return;
                }

                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM Cars WHERE CarID=@CarID", conn);

                cmd.Parameters.AddWithValue("@CarID", carId);
                cmd.ExecuteNonQuery();
            }
        }

        protected void GridCommand(object sender, CommandEventArgs e)
        {
            int carId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCar")
            {
                Response.Redirect("~/Admin/EditCar.aspx?CarID=" + carId);
            }

            else if (e.CommandName == "DeleteCar")
            {
                DeleteCar(carId);
                LoadCars("All");
            }
        }
    }
}