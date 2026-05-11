using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace Taxi_Project.Admin
{
    public partial class DriverForm : System.Web.UI.Page
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

        protected void btnSaveDriver_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = GetConnection())
            {
                try
                {
                    // VALIDATION FULL NAME
                    if (string.IsNullOrWhiteSpace(txtFullName.Text))
                    {
                        Response.Write("<script>alert('name should not empty');</script>");
                        return;
                    }

                    // VALIDATION PHONE
                    if (string.IsNullOrWhiteSpace(txtPhone.Text))
                    {
                        Response.Write("<script>alert('phone nb can not be empty');</script>");
                        return;
                    }

                    string phone = txtPhone.Text.Trim();

                    if (phone.Length != 8 || !phone.All(char.IsDigit))
                    {
                        Response.Write("<script>alert('number must be exaclty 8 digite');</script>");
                        return;
                    }

                    // VALIDATION GENDER
                    if (string.IsNullOrWhiteSpace(ddlGender.SelectedValue))
                    {
                        Response.Write("<script>alert('please select gender');</script>");
                        return;
                    }

                    conn.Open();

                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText = @"
                        INSERT INTO Drivers
                        (FullName, Phone, Gender, IsAvailable)
                        VALUES
                        (@FullName, @Phone, @Gender, @IsAvailable)
                    ";

                    cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
                    cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@IsAvailable", chkIsAvailable.Checked);

                    cmd.ExecuteNonQuery();
                    Response.Redirect("~/Admin/Drivers.aspx");
                    conn.Close();

                    txtFullName.Text = "";
                    txtPhone.Text = "";
                    ddlGender.SelectedIndex = 0;
                    chkIsAvailable.Checked = true;

                    Response.Write("<script>alert('Driver Added Successfully');</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }
    }
}