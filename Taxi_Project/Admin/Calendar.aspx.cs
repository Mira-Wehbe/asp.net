using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project.Admin
{
    public partial class Calendar : Page
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
            }
        }


        protected void calTrips_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.IsOtherMonth) return;

            int count = GetTripCountForDay(e.Day.Date);//bt3tine date klu e obj,day lyom date klu 12/5/2026
            //ana bi hajte la 22dr jib mn db inform
            if (count > 0)
            {
                string dateStr = e.Day.Date.ToString("yyyy-MM-dd");//am hawlu la date string ken obj ta hata eb3tu bl link 

                Label badge = new Label();
                badge.Text = $"<br/><a href='DayTrips.aspx?date={dateStr}' class='trip-count'>{count} trip{(count > 1 ? "s" : "")}</a>"; //by3mle shkl button li ha 2f2se
                e.Cell.Controls.Add(badge);//e,cell mtl <td>
            }
        }//dayrender is event bl calender byntnfz la kl yom
        protected void calTrips_SelectionChanged(object sender, EventArgs e)
        {
            DateTime selected = calTrips.SelectedDate;
            lblSelectedDate.Text = selected.ToString("dddd, MMMM dd yyyy");
            LoadTripsForDay(selected);
            pnlTrips.Visible = true;
        }//he bs 2f2s al day 

        private int GetTripCountForDay(DateTime date)//3aded ltrip ta ybynu bl calendd bi hed ldate:))))
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = "SELECT COUNT(*) FROM Trips WHERE CAST(PickupTime AS DATE) = @Date";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Date", date.Date);
                    return (int)cmd.ExecuteScalar();//bt3te nb trip bl day 
                }
            }
        }

        private void LoadTripsForDay(DateTime date)
        {
            pnlTripsList.Controls.Clear();

            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = @"
                    SELECT t.TripID, t.PickupTime, t.PickupLocation, t.DropoffLocation,
                           t.Price, t.Status,
                           ISNULL(u.FullName, 'Unknown')     AS ClientName,
                           ISNULL(c.Model,    'No Car')       AS CarModel,
                           ISNULL(d.FullName, 'Not Assigned') AS DriverName
                    FROM Trips t
                    LEFT JOIN Users   u ON t.ClientID = u.UserID
                    LEFT JOIN Cars    c ON t.CarID    = c.CarID
                    LEFT JOIN Drivers d ON t.DriverID = d.DriverID
                    WHERE CAST(t.PickupTime AS DATE) = @Date
                    ORDER BY t.PickupTime ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Date", date.Date);
                    SqlDataReader reader = cmd.ExecuteReader();
                    bool any = false;//wala wehde exist

                    while (reader.Read())
                    {
                        any = true;//atleast weghdd exist

                        int tripID = Convert.ToInt32(reader["TripID"]);
                        string client = reader["ClientName"].ToString();
                        string car = reader["CarModel"].ToString();
                        string driver = reader["DriverName"].ToString();
                        string pickup = reader["PickupLocation"].ToString();
                        string dropoff = reader["DropoffLocation"].ToString();
                        string price = Convert.ToDecimal(reader["Price"]).ToString("F2");
                        string status = reader["Status"].ToString();
                        string time = Convert.ToDateTime(reader["PickupTime"]).ToString("h:mm tt");//hwel waet
                       char initial = client.Length > 0 ? char.ToUpper(client[0]) : '?';

                        string badgeClass = status == "Active" ? "badge badge-active"
                                          : status == "Completed" ? "badge badge-completed"
                                          : status == "Cancelled" ? "badge badge-cancelled"
                                          : "badge badge-pending";

                        string html = $@"
                            <div class='trip-row'>
                                <div class='trip-row-left'>
                                    <div class='trip-avatar'>{initial}</div>
                                    <div>
                                        <div class='trip-client'>{client}</div>
                                        <div class='trip-route'>🚗 {car} · {driver}</div>
                                        <div class='trip-route'>📍 {pickup} → {dropoff}</div>
                                    </div>
                                </div>
                                <div style='display:flex;align-items:center;gap:12px;'>
                                    <div class='trip-time'>{time}</div>
                                    <span class='{badgeClass}'>{status}</span>
                                    <span class='trip-time'>${price}</span>
                                    <button type='button' class='btn-edit-trip'
                                        onclick=""window.location='EditBooking.aspx?id={tripID}'"">✏ Edit</button>
                                </div>
                            </div>";

                        pnlTripsList.Controls.Add(new LiteralControl(html));
                    }

                    if (!any)
                        pnlTripsList.Controls.Add(new LiteralControl(
                            "<div class='empty-state'>No trips on this day.</div>"));
                }
            }
        }


        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/Bookings.aspx");
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}