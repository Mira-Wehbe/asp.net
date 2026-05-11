using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Taxi_Project.Admin
{
    public partial class Profit : Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection() => new SqlConnection(ConnStr);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblAdminName.Text = Session["FullName"]?.ToString() ?? "Admin";
                LoadProfit();
                LoadCarTypeProfit();
            }
        }

        private void LoadProfit()
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();

                string sql = "SELECT ISNULL(SUM(Price),0) FROM Trips WHERE CAST(PickupTime AS DATE) = CAST(GETDATE() AS DATE) AND Status='Completed'";
                lblToday.Text = Convert.ToDecimal(new SqlCommand(sql, con).ExecuteScalar()).ToString("F2");

                sql = "SELECT ISNULL(SUM(Price),0) FROM Trips WHERE PickupTime >= DATEADD(DAY,-7,GETDATE()) AND Status='Completed'";
                lblWeek.Text = Convert.ToDecimal(new SqlCommand(sql, con).ExecuteScalar()).ToString("F2");

                sql = "SELECT ISNULL(SUM(Price),0) FROM Trips WHERE PickupTime >= DATEADD(DAY,-30,GETDATE()) AND Status='Completed'";
                lblMonth.Text = Convert.ToDecimal(new SqlCommand(sql, con).ExecuteScalar()).ToString("F2");

                sql = "SELECT ISNULL(SUM(Price),0) FROM Trips WHERE Status='Completed'";
                lblAllTime.Text = Convert.ToDecimal(new SqlCommand(sql, con).ExecuteScalar()).ToString("F2");
            }
        }

        private void LoadCarTypeProfit()
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();

                foreach (string carType in new[] { "Standard", "Business", "Van" })
                {
                    string sqlTrips = "SELECT COUNT(*) FROM Trips t JOIN Cars c ON t.CarID=c.CarID WHERE c.CarType=@CarType AND t.Status='Completed'";
                    string sqlProfit = "SELECT ISNULL(SUM(t.Price),0) FROM Trips t JOIN Cars c ON t.CarID=c.CarID WHERE c.CarType=@CarType AND t.Status='Completed'";

                    using (SqlCommand cmd = new SqlCommand(sqlTrips, con))
                    {
                        cmd.Parameters.AddWithValue("@CarType", carType);
                        int trips = (int)cmd.ExecuteScalar();

                        if (carType == "Standard") lblStandardTrips.Text = trips.ToString();
                        else if (carType == "Business") lblBusinessTrips.Text = trips.ToString();
                        else lblVanTrips.Text = trips.ToString();
                    }

                    using (SqlCommand cmd = new SqlCommand(sqlProfit, con))
                    {
                        cmd.Parameters.AddWithValue("@CarType", carType);
                        decimal profit = Convert.ToDecimal(cmd.ExecuteScalar());

                        if (carType == "Standard") lblStandardProfit.Text = profit.ToString("F2");
                        else if (carType == "Business") lblBusinessProfit.Text = profit.ToString("F2");
                        else lblVanProfit.Text = profit.ToString("F2");
                    }
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Dashboard.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}