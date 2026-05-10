using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Taxi_Project
{
    public partial class Login : Page
    {

        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";
        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSignInTab_Click(object sender, EventArgs e) { }

        protected void btnRegisterTab_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = GetConnection())
            {
                try
                {
                    // 1. check input
                    if (string.IsNullOrWhiteSpace(txtPhone.Text) ||
                        !txtPhone.Text.Contains("@") ||
                        !txtPhone.Text.Contains("."))
                    {
                        Response.Write("<script>alert('Enter valid email')</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        Response.Write("<script>alert('Password required')</script>");
                        return;
                    }

                    conn.Open();

                    // 2. get user + role
                    string query = "SELECT UserID, FullName, Role FROM Users WHERE Email=@Email AND PasswordHash=@Password";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@Email", txtPhone.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        Session["UserID"] = reader["UserID"].ToString();
                        Session["FullName"] = reader["FullName"].ToString();
                        Session["Role"] = reader["Role"].ToString();
                        string role = reader["Role"].ToString();

                        Response.Write("<script>alert('Login Success')</script>");

                        // 3. redirect based on role
                        if (role == "Admin")
                        {
                            Response.Redirect("Register.aspx");
                        }
                        else if (role == "Client")
                        {
                            Response.Redirect("Home.aspx");
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('Wrong email or password')</script>");
                    }

                    reader.Close();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('" + ex.Message + "')</script>");
                }
            }
        }

        protected void btnForgotPassword_Click(object sender, EventArgs e) { }

        protected void lnkRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }
    }
}
