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
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
        }

        private void LoadBookings()
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = @"
                        SELECT t.TripID, t.PickupLocation, t.DropoffLocation,
                               t.PickupTime, t.Price, t.Status,
                               ISNULL(t.DriverGender, 'No Preference') AS DriverGender,
                               u.FullName                         AS Client,
                               c.Model                            AS Car,
                               ISNULL(d.FullName, 'Not Assigned') AS Driver
                        FROM Trips t
                        JOIN Users   u ON t.ClientID = u.UserID
                        JOIN Cars    c ON t.CarID    = c.CarID
                        LEFT JOIN Drivers d ON t.DriverID = d.DriverID
                        ORDER BY t.TripID DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                System.Data.DataTable dt = new System.Data.DataTable();
                da.Fill(dt);
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            Button clicked = (Button)sender;

            if (clicked.CommandArgument == "Calendar")
            {
                Response.Redirect("~/Admin/Calendar.aspx");
            }
            else
            {
                pnlListView.CssClass = "view-panel shown";
                pnlCalendarView.CssClass = "view-panel";
                btnViewList.CssClass = "view-tab active";
                btnViewCalendar.CssClass = "view-tab";
                LoadBookings();
            }
        }
        protected void btnCalNav_Click(object sender, EventArgs e)
        {
        }
        
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string kw = "%" + txtSearch.Text.Trim() + "%";
                string sql = @"
            SELECT t.TripID, t.PickupLocation, t.DropoffLocation,
                   t.PickupTime, t.Price, t.Status,
                   ISNULL(u.FullName, 'Unknown')      AS Client,
                   ISNULL(c.Model,    'No Car')        AS Car,
                   ISNULL(t.DriverGender, 'No Preference') AS DriverGender,
                   ISNULL(d.FullName, 'Not Assigned')  AS Driver
            FROM Trips t
            JOIN  Users   u ON t.ClientID = u.UserID
            JOIN  Cars    c ON t.CarID    = c.CarID
            LEFT JOIN Drivers d ON t.DriverID = d.DriverID
            WHERE (
                u.FullName    LIKE @kw OR
                c.Model       LIKE @kw OR
                c.PlateNumber LIKE @kw OR
                d.FullName    LIKE @kw OR
                CAST(t.TripID   AS NVARCHAR) LIKE @kw OR
                CAST(t.ClientID AS NVARCHAR) LIKE @kw
            )
            ORDER BY t.TripID DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@kw", kw);
                System.Data.DataTable dt = new System.Data.DataTable();
                da.Fill(dt);
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            }
        }
        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditTrip")
            {
                int rowIndex = int.Parse(e.CommandArgument.ToString());
                string tripID = gvBookings.DataKeys[rowIndex].Value.ToString();
                Response.Redirect("~/Admin/EditBooking.aspx?id=" + tripID);
            }
        }
        
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}