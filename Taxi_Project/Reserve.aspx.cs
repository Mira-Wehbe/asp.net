using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.AccessControl;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project
{
    public partial class ReservePage : System.Web.UI.Page
    {
        private string ConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\user\OneDrive\Desktop\I3332\asp.net\Taxi_Project\App_Data\Taxi_DB.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(ConnStr);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtTime.Text = DateTime.Now.ToString("HH:00");
                lblError.Visible = false;
                lblSuccess.Visible = false;
                string carType;

                if (Session["SelectedCarType"] != null)
                {
                    carType = Session["SelectedCarType"].ToString();
                }
                else
                {
                    carType = "Standard";
                }

                lblSelectedCar.Text = "Selected: " + carType;
            }
        }
        private decimal GetRateByCarType(string carType)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT RatePerKm
                         FROM Cars
                         WHERE CarType = @CarType
                         AND IsActive = 1";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CarType", carType);

                con.Open();

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return Convert.ToDecimal(result);
                }
                else
                {
                    return 0.50m;
                }
            }
        }

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(hdnDistance.Value) || hdnDistance.Value == "0")
            {
                lblError.Text = "Please select pickup and dropoff on the map first.";
                lblError.Visible = true;
                return;
            }

            string carType;
            if (Session["SelectedCarType"] != null)
            {
                carType = Session["SelectedCarType"].ToString();
            }
            else
            {
                carType = "Standard";
            }

            double distKm = double.Parse(hdnDistance.Value);
            decimal rate = GetRateByCarType(carType);
            decimal price = (decimal)distKm * rate;

            lblPrice.Text = "$" + price.ToString("F2");
            lblError.Visible = false;
        }

        protected void btnReserve_Click(object sender, EventArgs e)
        {
            lblError.Visible = false; 
            lblSuccess.Visible = false;
            if (string.IsNullOrWhiteSpace(hdnPickupLat.Value) ||
                string.IsNullOrWhiteSpace(hdnDropoffLat.Value))//malezm ykun pickup wpickoff fadyin
            {
                lblError.Text = "Please select both pickup and dropoff on the map.";
                lblError.Visible = true;
                return;
            }
            if (string.IsNullOrWhiteSpace(txtDate.Text) ||
                string.IsNullOrWhiteSpace(txtTime.Text))//malezm ykun time w date fayin
            {
                lblError.Text = "Please choose a pickup date and time.";
                lblError.Visible = true;
                return;
            }
            DateTime pickupTime;//shayek ize mdkhl date-time sah
            if (!DateTime.TryParse(txtDate.Text + " " + txtTime.Text, out pickupTime))
            {
                lblError.Text = "Invalid date or time.";
                lblError.Visible = true;
                return;
            }
            if (pickupTime < DateTime.Now)//ize user hatet waet 8lt yani waet mbrh manu mntbh
            {
                lblError.Text = "Pickup time cannot be in the past.";
                lblError.Visible = true;
                return;
            }
            double distKm;
            if (!double.TryParse(hdnDistance.Value, out distKm) || distKm <= 0)
            {
                lblError.Text = "Route distance missing. Please select locations on the map.";
                lblError.Visible = true;
                return;
            }
            string carType;

            if (Session["SelectedCarType"] != null)
            {
                carType = Session["SelectedCarType"].ToString();
            }
            else
            {
                carType = "Standard";
            }
            decimal rate = GetRateByCarType(carType);
            decimal price = (decimal)distKm * rate;

            //bde emlun insert bl trips table 
            //trip table bi albe(carid,clientid,pickup,dropout,price,statuis)

            int carID = 0;
            using (SqlConnection con = GetConnection())
            {
                con.Open();
                string sql = "SELECT TOP 1 CarID FROM Cars WHERE CarType = @CarType AND IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@CarType", carType);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                        carID = Convert.ToInt32(result);
                }
            }

            int clientID = int.Parse(Session["UserID"].ToString());
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    con.Open();
                    string sql = @"
                        INSERT INTO Trips
                            (ClientID, CarID, PickupLocation, DropoffLocation, PickupTime, Price, Status, DistanceKm)
                        VALUES
                            (@ClientID, @CarID, @Pickup, @Dropoff, @PickupTime, @Price, 'Pending', @DistanceKm)";
                          
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@ClientID", clientID);
                        cmd.Parameters.AddWithValue("@CarID", carID);
                        cmd.Parameters.AddWithValue("@Pickup", txtPickup.Text.Trim());
                        cmd.Parameters.AddWithValue("@Dropoff", txtDropoff.Text.Trim());
                        cmd.Parameters.AddWithValue("@PickupTime", pickupTime);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@DistanceKm", (decimal)distKm);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "Booking done ! Yalla Taxi  reserve your trip <3.";
                lblSuccess.Visible = true;
                txtPickup.Text = "";
                txtDropoff.Text = "";
                txtDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtTime.Text = DateTime.Now.ToString("HH:00");
                ddlDriverGender.SelectedIndex = 0;
                lblPrice.Text = "—";
                hdnPickupLat.Value = "";
                hdnPickupLng.Value = "";
                hdnDropoffLat.Value = "";
                hdnDropoffLng.Value = "";
                hdnDistance.Value = "";
            }
            catch (Exception ex)
            {
                lblError.Text = "Booking failed: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnMyTrips_Click(object sender, EventArgs e)
        {
            Response.Redirect("History.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}