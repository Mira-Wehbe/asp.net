using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Taxi_Project
{
    public partial class History : Page
    {

        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\user\OneDrive\Desktop\I3332\asp.net\Taxi_Project\App_Data\Taxi_DB.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e) {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTrips(null); // show all trips on first load
            }
        }

        // =============================================
        // Core method — fetches trips from DB
        // statusFilter = null   → All trips
        // statusFilter = "Pending" → Pending only, etc.
        // =============================================
        private void LoadTrips(string statusFilter)
        {
            int clientID = int.Parse(Session["UserID"].ToString());

            string query = @"
                SELECT TripID, PickupLocation, DropoffLocation,
                       PickupTime, Status, Price, DistanceKm
                FROM Trips
                WHERE ClientID = @ClientID";

            if (!string.IsNullOrEmpty(statusFilter))
                query += " AND Status = @Status";

            query += " ORDER BY CreatedAt DESC"; // newest first

            pnlTrips.Controls.Clear(); // clear old cards

            using (SqlConnection con = GetConnection())
            {
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ClientID", clientID);

                if (!string.IsNullOrEmpty(statusFilter))
                    cmd.Parameters.AddWithValue("@Status", statusFilter);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                bool hasTrips = false;

                while (reader.Read())
                {
                    hasTrips = true;

                    int tripID = Convert.ToInt32(reader["TripID"]);
                    string pickup = reader["PickupLocation"].ToString();
                    string dropoff = reader["DropoffLocation"].ToString();
                    string status = reader["Status"].ToString();
                    string price = Convert.ToDecimal(reader["Price"]).ToString("F2");
                    string dist = Convert.ToDecimal(reader["DistanceKm"]).ToString("F1");
                    string time = Convert.ToDateTime(reader["PickupTime"]).ToString("MMM dd, yyyy  HH:mm");

                    // pick badge color based on status
                    string badgeClass = "badge-pending";
                    if (status == "Active") badgeClass = "badge-active";
                    if (status == "Completed") badgeClass = "badge-completed";
                    if (status == "Cancelled") badgeClass = "badge-cancelled";

                    // build the HTML card
                    string cardHtml = $@"
                        <div class='trip-card'>
                            <div>
                                <span class='badge {badgeClass}'>{status}</span>
                                <p style='margin-top:10px; font-weight:600;'>📍 {pickup}</p>
                                <p style='color:#555; font-size:13px;'>⬇</p>
                                <p style='font-weight:600;'>🏁 {dropoff}</p>
                                <p style='color:#555; font-size:12px; margin-top:8px;'>
                                    🕐 {time} &nbsp;|&nbsp; 📏 {dist} km
                                </p>
                            </div>
                            <div style='text-align:right;'>
                                <p class='trip-price'>${price}</p>
                            </div>
                        </div>";

                    pnlTrips.Controls.Add(new LiteralControl(cardHtml));
                }

                reader.Close();

                if (!hasTrips)
                {
                    pnlTrips.Controls.Add(new LiteralControl(
                        "<p style='color:#555; text-align:center; margin-top:2rem;'>No trips found.</p>"
                    ));
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e) {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnAll_Click(object sender, EventArgs e) { LoadTrips(null); }
        protected void btnPending_Click(object sender, EventArgs e) { LoadTrips("Pending"); }
        protected void btnActive_Click(object sender, EventArgs e) { LoadTrips("Active"); }
        protected void btnCompleted_Click(object sender, EventArgs e) { LoadTrips("Completed"); }
        protected void btnCancelled_Click(object sender, EventArgs e) { LoadTrips("Cancelled"); }
        protected void btnSubmitFeedback_Click(object sender, EventArgs e) { }
        protected void lnkReserve_Click(object sender, EventArgs e) {
            Response.Redirect("Reserve.aspx");
        }
    }
}
