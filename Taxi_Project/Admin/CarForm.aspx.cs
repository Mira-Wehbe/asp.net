using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace Taxi_Project
{
    public partial class CarForm : System.Web.UI.Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=D:\LEBNESE UNI\PROJECT I3332\PART 2\ASP.NET\ASP.NET\TAXI_DB.MDF;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // optional
        }

        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
            try
            {
                string plate = txtPlateNumber.Text.Trim();

                // ✅ better plate validation
                if (!Regex.IsMatch(plate, @"^[A-Za-z]{1,3}[0-9]{2,6}$"))
                {
                    ShowAlert("Invalid Plate Number");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtModel.Text))
                {
                    ShowAlert("Model is required");
                    return;
                }

                if (!decimal.TryParse(txtRatePerKm.Text, out decimal rate))
                {
                    ShowAlert("Invalid Rate Per KM");
                    return;
                }

                string carType = ddlCarType.SelectedValue;

                if (string.IsNullOrEmpty(carType))
                {
                    ShowAlert("Please select Car Type");
                    return;
                }

                int seats = carType == "Van" ? 7 : 4;

                using (SqlConnection conn = GetConnection())
                {
                    conn.Open();

                    string query = @"INSERT INTO Cars 
                                    (PlateNumber, Model, CarType, Seats, RatePerKm, IsActive)
                                    VALUES 
                                    (@PlateNumber, @Model, @CarType, @Seats, @RatePerKm, @IsActive)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PlateNumber", plate);
                        cmd.Parameters.AddWithValue("@Model", txtModel.Text.Trim());
                        cmd.Parameters.AddWithValue("@CarType", carType);
                        cmd.Parameters.AddWithValue("@Seats", seats);
                        cmd.Parameters.AddWithValue("@RatePerKm", rate);
                        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            ShowAlert("Car added successfully ✔");

                            ClearForm();
                        }
                        else
                        {
                            ShowAlert("Insert failed ❌");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            txtPlateNumber.Text = "";
            txtModel.Text = "";
            txtRatePerKm.Text = "";
            ddlCarType.SelectedIndex = 0;
            chkIsActive.Checked = true;
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(),
                "alert", $"alert('{message}');", true);
        }
    }
}