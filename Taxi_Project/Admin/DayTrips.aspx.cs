using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class DayTrips : Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConnStr);
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
                lblAdminName.Text = Session["FullName"]?.ToString() ?? "Admin";

                string dateParam = Request.QueryString["date"];
                if (string.IsNullOrEmpty(dateParam))
                {
                    Response.Redirect("~/Admin/Calendar.aspx");
                    return;
                }

                DateTime date = DateTime.Parse(dateParam);
                lblDate.Text = date.ToString("dddd, MMMM dd yyyy");
                LoadTrips(date);
            }
            string editVal = Request.Form["btnEditTrip"];
            if (!string.IsNullOrEmpty(editVal))
                Response.Redirect("~/Admin/EditBooking.aspx?id=" + editVal);
        }

        private void LoadTrips(DateTime date)
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = @"
                    SELECT t.TripID, t.PickupTime, t.PickupLocation, t.DropoffLocation,
                           t.Price, t.Status,
                           ISNULL(u.FullName, 'Unknown')     AS Client,
                           ISNULL(c.Model,    'No Car')       AS Car,
                           ISNULL(d.FullName, 'Not Assigned') AS Driver
                    FROM Trips t
                    LEFT JOIN Users   u ON t.ClientID = u.UserID
                    LEFT JOIN Cars    c ON t.CarID    = c.CarID
                    LEFT JOIN Drivers d ON t.DriverID = d.DriverID
                    WHERE CAST(t.PickupTime AS DATE) = @Date
                    ORDER BY t.PickupTime ASC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@Date", date.Date);
                System.Data.DataTable dt = new System.Data.DataTable();
                da.Fill(dt);
                gvTrips.DataSource = dt;
                gvTrips.DataBind();
            }
        }

        protected void gvTrips_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTrip")
            {
                int rowIndex = int.Parse(e.CommandArgument.ToString());
                string tripID = gvTrips.DataKeys[rowIndex].Value.ToString();
                Response.Redirect("~/Admin/EditBooking.aspx?id=" + tripID);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Calendar.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}