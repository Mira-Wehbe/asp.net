using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace Taxi_Project
{
    public partial class CarForm : System.Web.UI.Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
        }

        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
            try
            {
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

                string carType = ddlCarType.SelectedValue;

                if (string.IsNullOrEmpty(carType))
                {
                    Response.Write("<script>alert('Please select Car Type');</script>");
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
                            Response.Write("<script>alert('Car added successfully ');</script>");
                            //ClearForm();
                            Response.Redirect("~/Admin/Cars.aspx");
                            return;
                        }
                        else
                        {
                            Response.Write("<script>alert('Insert failed ');</script>");
                            return;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                return;
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
    }
}