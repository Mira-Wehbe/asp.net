using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace Taxi_Project.Admin
{
    public partial class EditCar : System.Web.UI.Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["CarID"] != null)
                {
                    LoadCar(Convert.ToInt32(Request.QueryString["CarID"]));
                }
            }
        }
        private void LoadCar(int id)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("SELECT * FROM Cars WHERE CarID=@CarID", conn);
                cmd.Parameters.AddWithValue("@CarID", id);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtPlateNumber.Text = dr["PlateNumber"].ToString();
                    txtModel.Text = dr["Model"].ToString();
                    ddlCarType.SelectedValue = dr["CarType"].ToString();
                    txtRatePerKm.Text = dr["RatePerKm"].ToString();
                    chkIsActive.Checked = Convert.ToBoolean(dr["IsActive"]);
                }
            }
        }

        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
            try
            {
                int carId = Convert.ToInt32(Request.QueryString["CarID"]);
                string plate = txtPlateNumber.Text.Trim();

                if (string.IsNullOrWhiteSpace(plate))
                {
                    Response.Write("<script>alert('Plate Number is required');</script>");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtModel.Text))
                {
                    Response.Write("<script>alert('Model is required');</script>");
                    return;
                }

                if (!decimal.TryParse(txtRatePerKm.Text, out decimal rate))
                {
                    Response.Write("<script>alert('Invalid Rate Per KM');</script>");
                    return;
                }

                if (string.IsNullOrEmpty(ddlCarType.SelectedValue))
                {
                    Response.Write("<script>alert('Please select Car Type');</script>");
                    return;
                }

                int seats = ddlCarType.SelectedValue == "Van" ? 7 : 4;

                using (SqlConnection conn = GetConnection())
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Cars
                        SET 
                            PlateNumber = @PlateNumber,
                            Model = @Model,
                            CarType = @CarType,
                            Seats = @Seats,
                            RatePerKm = @RatePerKm,
                            IsActive = @IsActive
                        WHERE CarID = @CarID
                    ", conn);

                    cmd.Parameters.AddWithValue("@PlateNumber", plate);
                    cmd.Parameters.AddWithValue("@Model", txtModel.Text.Trim());
                    cmd.Parameters.AddWithValue("@CarType", ddlCarType.SelectedValue);
                    cmd.Parameters.AddWithValue("@Seats", seats);
                    cmd.Parameters.AddWithValue("@RatePerKm", rate);
                    cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                    cmd.Parameters.AddWithValue("@CarID", carId);

                    cmd.ExecuteNonQuery();
                }

                //Response.Write("<script>alert('Car Updated Successfully');</script>");
                Response.Redirect("~/Admin/Cars.aspx");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }
    }
}