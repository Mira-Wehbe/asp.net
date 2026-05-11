using System;
using System.Data.SqlClient;
using System.Linq;

namespace Taxi_Project.Admin
{
    public partial class EditDriver : System.Web.UI.Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["DriverID"] != null)
                {
                    LoadDriver(Convert.ToInt32(Request.QueryString["DriverID"]));
                }
            }
        }

        private void LoadDriver(int id)
        {
            using (SqlConnection conn = new SqlConnection(cs))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("SELECT * FROM Drivers WHERE DriverID=@id", conn);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtFullName.Text = dr["FullName"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();
                    ddlGender.SelectedValue = dr["Gender"].ToString();
                    chkIsAvailable.Checked = Convert.ToBoolean(dr["IsAvailable"]);
                }
            }
        }

        protected void btnSaveDriver_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["DriverID"]);

            using (SqlConnection conn = new SqlConnection(cs))
            {
                try
                {
                    // ───────── VALIDATION ─────────

                    if (string.IsNullOrWhiteSpace(txtFullName.Text))
                    {
                        Response.Write("<script>alert('Name should not be empty');</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtPhone.Text))
                    {
                        Response.Write("<script>alert('Phone cannot be empty');</script>");
                        return;
                    }

                    string phone = txtPhone.Text.Trim();

                    if (phone.Length != 8 || !phone.All(char.IsDigit))
                    {
                        Response.Write("<script>alert('Phone must be exactly 8 digits');</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(ddlGender.SelectedValue))
                    {
                        Response.Write("<script>alert('Please select gender');</script>");
                        return;
                    }

                    // ───────── UPDATE ─────────
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(@"
                UPDATE Drivers
                SET FullName=@FullName,
                    Phone=@Phone,
                    Gender=@Gender,
                    IsAvailable=@IsAvailable
                WHERE DriverID=@id", conn);

                    cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@IsAvailable", chkIsAvailable.Checked);
                    cmd.Parameters.AddWithValue("@id", id);

                    cmd.ExecuteNonQuery();

                    // ───────── SUCCESS ─────────
                    Response.Write("<script>alert('Driver Updated Successfully'); window.location='Drivers.aspx';</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }
    }
}