using System;
using System.Data;
using System.Data.SqlClient;
using System.EnterpriseServices;
using System.Web.UI;
using System.Data.SqlClient;

namespace Taxi_Project
{
    public partial class Register : Page
    {
        private string cs = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\miraw\OneDrive\Documents\Taxi_db.mdf;Integrated Security=True;Connect Timeout=30;Encrypt=False";
        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSignInTab_Click(object sender, EventArgs e)
        {
            Response.Redirect("login.aspx");
        }

        protected void btnRegisterTab_Click(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {

            using (SqlConnection conn = GetConnection())
            {

                try
                { 
                    if (string.IsNullOrWhiteSpace(txtFullName.Text))
                    {

                        Response.Write("<script>alert('name should be not emtpy ')</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtEmail.Text) || //email have specific condition
                    !txtEmail.Text.Contains("@") ||
                    !txtEmail.Text.Contains(".") ||
                    txtEmail.Text.IndexOf("@") > txtEmail.Text.LastIndexOf("."))
                    {
                        Response.Write("<script>alert('Please enter a valid email address containing @ and .')</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        Response.Write("<script>alert('pass should be not emtpy ')</script>");
                        return;
                    }
                    string password = txtPassword.Text;

                    if (password.Length < 8 ||
                        !System.Text.RegularExpressions.Regex.IsMatch(password, @"[A-Z]") ||
                        !System.Text.RegularExpressions.Regex.IsMatch(password, @"[0-9]") ||
                        !System.Text.RegularExpressions.Regex.IsMatch(password, @"[!@#$%^&*()_+\-=\[\]{}]"))
                    {
                        Response.Write("<script>alert('Password must be at least 8 characters, contain one uppercase, one number, and one special character')</script>");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(txtConfirmPassword.Text) || txtConfirmPassword.Text != password)
                    {
                        Response.Write("<script>alert('Passwords do not match')</script>");
                        return;
                    }

                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "INSERT INTO Users (FullName, Email, PasswordHash, Role) VALUES (@FullName, @Email, @PasswordHash, @Role)"; // insert sql command 

                    cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@PasswordHash", txtPassword.Text);
                    cmd.Parameters.AddWithValue("@Role", "Client");
                    cmd.ExecuteNonQuery();
                    cmd.Dispose();
                    conn.Close();
                    txtFullName.Text = ""; // hon rj3t 5lt ma7al ma 3aba info trj3 empty
                    Response.Write("<script>alert('Successfully Input')</script>");
                    Response.Redirect("Home.aspx");


                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('An error occurred: " + ex.Message + "')</script>");
                }
            }

        }

        protected void lnkLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("login.aspx");
        }
    }
}