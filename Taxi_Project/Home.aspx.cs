using System;
using System.Web.UI;

namespace Taxi_Project
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }

        protected void btnStandard_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Session["SelectedCarType"] = "Standard"; 
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnBusiness_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Session["SelectedCarType"] = "Business";  
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnVan_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Session["SelectedCarType"] = "Van";      
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnMyTrips_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Response.Redirect("History.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}