using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Taxi_Project
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("login.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }

        protected void btnStandard_Click(object sender, EventArgs e)
        {
            Response.Write("CLICKED VAN");
            if (Session["UserId"] != null)
            {
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void btnBusiness_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void btnVan_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("Reserve.aspx");
            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void btnMyTrips_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                Response.Redirect("History.aspx");
            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }
    }
}