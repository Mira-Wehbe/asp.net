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

        protected void Page_Load(object sender, EventArgs e)
        {
            // Cancel trip logic
            if (Request.QueryString["cancelTrip"] != null)
            {
                int tripId = Convert.ToInt32(Request.QueryString["cancelTrip"]);

                using (SqlConnection con = GetConnection())
                {
                    string q = "UPDATE Trips SET Status='Cancelled' WHERE TripID=@TripID AND Status='Pending'";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@TripID", tripId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect("History.aspx");
            }

            // Feedback submit logic
            if (Request.QueryString["submitFeedback"] != null)
            {
                int tripId = Convert.ToInt32(Request.QueryString["tripID"]);
                int clientID = Convert.ToInt32(Session["UserID"]);
                int rating = Convert.ToInt32(Request.QueryString["rating"]);
                string comment = Request.QueryString["comment"] ?? "";

                using (SqlConnection con = GetConnection())
                {
                    string q = @"
                        INSERT INTO Feedback (TripID, ClientID, Rating, Comment)
                        VALUES (@TripID, @ClientID, @Rating, @Comment)";

                    SqlCommand cmd = new SqlCommand(q, con);

                    cmd.Parameters.AddWithValue("@TripID", tripId);
                    cmd.Parameters.AddWithValue("@ClientID", clientID);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Comment", comment);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect("History.aspx");
            }

            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTrips(null);
            }
        }

        private void LoadTrips(string statusFilter)
        {
            int clientID = int.Parse(Session["UserID"].ToString());

            string query = @"
                SELECT TripID, PickupLocation, DropoffLocation,
                       PickupTime, Status, Price, DistanceKm
                FROM Trips
                WHERE ClientID = @ClientID
                AND Status != 'Cancelled'
                AND TripID NOT IN (SELECT TripID FROM Feedback)";

            if (!string.IsNullOrEmpty(statusFilter))
                query += " AND Status = @Status";

            query += " ORDER BY CreatedAt DESC";

            pnlTrips.Controls.Clear();

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
                    string time = Convert.ToDateTime(reader["PickupTime"]).ToString("MMM dd, yyyy HH:mm");

                    string badgeClass = "badge-pending";
                    if (status == "Active") badgeClass = "badge-active";
                    if (status == "Completed") badgeClass = "badge-completed";
                    if (status == "Cancelled") badgeClass = "badge-cancelled";

                    string cardHtml = $@"
<div class='trip-card'>

    <div>

        <span class='badge {badgeClass}'>{status}</span>

        <p style='margin-top:10px; font-weight:600;'>📍 {pickup}</p>

        <p style='color:#555; font-size:13px;'>⬇</p>

        <p style='font-weight:600;'>🏁 {dropoff}</p>

        <p style='color:#555; font-size:12px; margin-top:8px;'>
            🕐 {time} | 📏 {dist} km
        </p>

    </div>

    <div style='text-align:right;'>

        <p class='trip-price'>${price}</p>

        {(status == "Pending"
            ? $@"<a href='History.aspx?cancelTrip={tripID}' 
                    class='btn-cancel'
                    style='display:inline-block;margin-top:10px;padding:7px 16px;text-decoration:none;'>
                    Cancel
                 </a>"
            : "")}

        {(status == "Completed"
            ? $@"<button type='button'
                    class='btn-feedback'
                    style='margin-top:10px;'
                    onclick='openFeedback({tripID})'>
                    Leave Feedback
                 </button>"
            : "")}

    </div>

</div>";

                    pnlTrips.Controls.Add(new LiteralControl(cardHtml));
                }

                reader.Close();

                if (!hasTrips)
                {
                    pnlTrips.Controls.Add(new LiteralControl(
                        "<p style='color:#555;text-align:center;margin-top:2rem;'>No trips found.</p>"
                    ));
                }
            }
        }

        protected void btnSubmitFeedback_Click(object sender, EventArgs e)
        {
            string tripID = hdnTripID.Value;
            string rating = hdnRating.Value;
            string comment = Server.UrlEncode(txtComment.Text);

            Response.Redirect($"History.aspx?submitFeedback=1&tripID={tripID}&rating={rating}&comment={comment}");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnAll_Click(object sender, EventArgs e) => LoadTrips(null);
        protected void btnPending_Click(object sender, EventArgs e) => LoadTrips("Pending");
        protected void btnActive_Click(object sender, EventArgs e) => LoadTrips("Active");
        protected void btnCompleted_Click(object sender, EventArgs e) => LoadTrips("Completed");
        protected void btnCancelled_Click(object sender, EventArgs e) => LoadTrips("Cancelled");

        protected void lnkReserve_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reserve.aspx");
        }
    }
}

