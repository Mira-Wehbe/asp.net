using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
//using Taxi_Project.Models;

namespace Taxi_Project.Admin
{
    public partial class EditBooking : Page
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
                string idParam = Request.QueryString["id"];
                //LoadDropdowns();
                LoadTrip(int.Parse(idParam));
            }
        }

        private void LoadDropdowns(string preferredGender)
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql;

                if (string.IsNullOrEmpty(preferredGender))
                {
        
                    sql = "SELECT DriverID, FullName, Gender FROM Drivers";
                }
                else
                {

                    sql = "SELECT DriverID, FullName, Gender FROM Drivers WHERE Gender = @Gender";
                }

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {

                    if (!string.IsNullOrEmpty(preferredGender))
                        cmd.Parameters.AddWithValue("@Gender", preferredGender);

                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlDriver.Items.Clear();
                    ddlDriver.Items.Add(new ListItem("-- Not Assigned --", "0"));
                    while (reader.Read())
                    {
                        string name = reader["FullName"].ToString() + " (" + reader["Gender"].ToString() + ")";
                        ddlDriver.Items.Add(new ListItem(name, reader["DriverID"].ToString()));
                    }
                    reader.Close();
                }
            }
        }

        private void LoadTrip(int tripID)//am n3bi form wkhli l admin yamel assign lal driver
        {
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = @"
                    SELECT t.TripID, t.PickupLocation, t.DropoffLocation,
                           t.PickupTime, t.Price, t.Status,
                           t.DriverID, t.DriverGender,
                           u.FullName AS ClientName,
                           c.Model    AS CarModel,
                           c.CarType  AS CarType
                    FROM Trips t
                    JOIN Users u ON t.ClientID = u.UserID
                    JOIN Cars  c ON t.CarID    = c.CarID
                    WHERE t.TripID = @TripID";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@TripID", tripID);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        lblTripID.Text = "#" + reader["TripID"].ToString();
                        lblClient.Text = reader["ClientName"].ToString();
                        lblCar.Text = reader["CarType"].ToString() + " — " + reader["CarModel"].ToString();
                        txtPickup.Text = reader["PickupLocation"].ToString();
                        txtDropoff.Text = reader["DropoffLocation"].ToString();
                        txtPickupTime.Text = Convert.ToDateTime(reader["PickupTime"]).ToString("yyyy-MM-ddTHH:mm");
                        txtPrice.Text = Convert.ToDecimal(reader["Price"]).ToString("F2");
                        ddlStatus.SelectedValue = reader["Status"].ToString();
                        string gender;

                        if (reader["DriverGender"] == DBNull.Value)
                        {
                            gender = "";
                        }
                        else
                        {
                            gender = reader["DriverGender"].ToString();
                        }

                        if (string.IsNullOrEmpty(gender))
                        {
                            lblGender.Text = "No preference";
                        }
                        else
                        {
                            lblGender.Text = gender;
                        }

                        LoadDropdowns(gender);
                        string driverID;
                        if (reader["DriverID"] == DBNull.Value)
                        {
                            driverID = "0";
                        }
                        else
                        {
                            driverID = reader["DriverID"].ToString();
                        }
                        if (ddlDriver.Items.FindByValue(driverID) != null)
                            ddlDriver.SelectedValue = driverID;
                    }
                    else
                    {
                        Response.Redirect("~/Admin/Bookings.aspx");
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(txtPickup.Text) ||
                string.IsNullOrWhiteSpace(txtDropoff.Text) ||
                string.IsNullOrWhiteSpace(txtPrice.Text))
            {
                lblError.Text = "Pickup, Dropoff and Price are required.";
                lblError.Visible = true;
                return;
            }

            decimal price;
            if (!decimal.TryParse(txtPrice.Text, out price))
            {
                lblError.Text = "Price must be a valid number.";
                lblError.Visible = true;
                return;
            }

            DateTime pickupTime;
            if (!DateTime.TryParse(txtPickupTime.Text, out pickupTime))
            {
                lblError.Text = "Invalid pickup time.";
                lblError.Visible = true;
                return;
            }

            int tripID = int.Parse(Request.QueryString["id"]);
            int driverID;
            if (ddlDriver.SelectedValue == "0")
            {
                driverID = 0;
            }
            else
            {
                driverID = int.Parse(ddlDriver.SelectedValue);
            }
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    con.Open();
                    string sql = @"
                UPDATE Trips SET
                    DriverID        = @DriverID,
                    PickupLocation  = @Pickup,
                    DropoffLocation = @Dropoff,
                    PickupTime      = @PickupTime,
                    Price           = @Price,
                    Status          = @Status
                WHERE TripID = @TripID";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@DriverID", (object)driverID ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Pickup", txtPickup.Text.Trim());
                        cmd.Parameters.AddWithValue("@Dropoff", txtDropoff.Text.Trim());
                        cmd.Parameters.AddWithValue("@PickupTime", pickupTime);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                        cmd.Parameters.AddWithValue("@TripID", tripID);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "Booking updated successfully.";
                lblSuccess.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "Error: " + ex.Message;
                lblError.Visible = true;
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