<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cars.aspx.cs" Inherits="Taxi_Project.Admin.Cars" %>

<!DOCTYPE html>
<html>
<head runat="server">

    <title>Yalla Taxi – Cars</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            background:#0f0f0f;
            color:#fff;
            font-family:'Inter',sans-serif;
            min-height:100vh;
            display:flex;
        }

        /* ───────── SIDEBAR ───────── */

        .sidebar{
            width:240px;
            background:#1a1a1a;
            border-right:1px solid rgba(255,255,255,0.05);
            position:fixed;
            top:0;
            left:0;
            bottom:0;
            padding:2rem 1.5rem;
            display:flex;
            flex-direction:column;
        }

        .logo-badge{
            background:#F5C300;
            padding:6px 14px;
            border-radius:10px;
            display:inline-flex;
            align-items:center;
            gap:8px;
            margin-bottom:2rem;
        }

        .logo-badge span{
            font-family:'Bebas Neue',sans-serif;
            font-size:20px;
            color:#111;
            letter-spacing:2px;
        }

        .logo-sep{
            width:2px;
            height:18px;
            background:#111;
            opacity:.3;
        }

        .nav-label{
            color:#444;
            font-size:11px;
            text-transform:uppercase;
            letter-spacing:2px;
            margin-bottom:1rem;
        }

        .nav-item{
            display:flex;
            align-items:center;
            gap:10px;
            padding:12px;
            border-radius:10px;
            text-decoration:none;
            color:#666;
            transition:.2s;
            margin-bottom:6px;
            font-size:14px;
            font-weight:500;
        }

        .nav-item:hover{
            background:rgba(245,195,0,0.05);
            color:#fff;
        }

        .nav-item.active{
            background:rgba(245,195,0,0.10);
            color:#F5C300;
        }

        .sidebar-bottom{
            margin-top:auto;
        }

        .admin-info{
            background:#111;
            border-radius:12px;
            padding:12px;
            display:flex;
            align-items:center;
            gap:10px;
            margin-bottom:1rem;
        }

        .admin-avatar{
            width:40px;
            height:40px;
            border-radius:50%;
            background:#F5C300;
            color:#111;
            display:flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
        }

        .admin-name{
            font-size:13px;
            font-weight:600;
        }

        .admin-role{
            color:#666;
            font-size:11px;
        }

        .btn-logout{
            width:100%;
            height:42px;
            border-radius:10px;
            border:1px solid rgba(245,195,0,0.2);
            background:transparent;
            color:#F5C300;
            cursor:pointer;
            font-family:'Inter',sans-serif;
        }

        /* ───────── MAIN ───────── */

        .main{
            margin-left:240px;
            width:100%;
            padding:2.5rem;
        }

        .page-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:2rem;
        }

        .page-header h1{
            font-size:30px;
        }

        .page-header h1 span{
            color:#F5C300;
        }

        .page-header p{
            color:#666;
            margin-top:5px;
            font-size:14px;
        }

        .btn-add{
            height:44px;
            padding:0 22px;
            border:none;
            border-radius:12px;
            background:#F5C300;
            color:#111;
            font-weight:700;
            cursor:pointer;
            font-family:'Inter',sans-serif;
            transition:.2s;
        }

        .btn-add:hover{
            background:#ffd500;
        }

        /* ───────── FILTERS ───────── */

        .filter-bar{
            display:flex;
            gap:10px;
            margin-bottom:1.5rem;
        }

        .filter-btn{
            height:38px;
            padding:0 18px;
            background:#1a1a1a;
            border:1px solid rgba(255,255,255,0.06);
            border-radius:10px;
            color:#777;
            cursor:pointer;
            font-weight:600;
            font-family:'Inter',sans-serif;
            transition:.2s;
        }

        .filter-btn:hover{
            color:#fff;
            border-color:rgba(245,195,0,0.25);
        }

        /* ───────── TABLE ───────── */

        .table-wrap{
            background:#1a1a1a;
            border-radius:22px;
            overflow:hidden;
            border:1px solid rgba(255,255,255,0.06);
            box-shadow:0 10px 30px rgba(0,0,0,0.25);
        }

        .modern-grid{
            width:100%;
            border-collapse:collapse;
        }

        .modern-grid th{
            background:#151515;
            color:#666;
            padding:18px;
            text-align:left;
            font-size:11px;
            text-transform:uppercase;
            letter-spacing:1px;
            border-bottom:1px solid rgba(255,255,255,0.06);
        }

        .modern-grid td{
            padding:18px;
            border-bottom:1px solid rgba(255,255,255,0.04);
            color:#ddd;
            font-size:13px;
            transition:.2s;
        }

        .modern-grid tr:hover td{
            background:rgba(245,195,0,0.04);
        }

        .id-badge{
            background:rgba(245,195,0,0.12);
            color:#F5C300;
            padding:6px 12px;
            border-radius:30px;
            font-size:11px;
            font-weight:700;
        }

        .car-info{
            display:flex;
            align-items:center;
            gap:14px;
        }

        .car-icon{
            width:50px;
            height:50px;
            border-radius:14px;
            background:rgba(245,195,0,0.08);
            border:1px solid rgba(245,195,0,0.2);
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:22px;
        }

        .car-model{
            color:#fff;
            font-weight:700;
            font-size:14px;
        }

        .car-plate{
            color:#666;
            font-size:12px;
            margin-top:4px;
        }

        .rate-price{
            color:#F5C300;
            font-weight:700;
        }

        .status-active{
            background:rgba(34,197,94,0.1);
            color:#4ade80;
            border:1px solid rgba(34,197,94,0.3);
            padding:6px 14px;
            border-radius:30px;
            font-size:11px;
            font-weight:700;
        }

        .status-inactive{
            background:rgba(255,80,80,0.1);
            color:#ff6b6b;
            border:1px solid rgba(255,80,80,0.3);
            padding:6px 14px;
            border-radius:30px;
            font-size:11px;
            font-weight:700;
        }

        .msg-box{
            padding:12px;
            border-radius:10px;
            margin-bottom:1rem;
            display:block;
        }

        .msg-error{
            background:#2a1010;
            color:#ff6b6b;
        }

    </style>

</head>

<body>

<form id="form1" runat="server">

    <!-- SIDEBAR -->

    <div class="sidebar">

        <div class="logo-badge">
            <span>YALLA</span>
            <div class="logo-sep"></div>
            <span>TAXI</span>
        </div>

        <div class="nav-label">
            Main Menu
        </div>

        <a href="Dashboard.aspx" class="nav-item">
            📊 Dashboard
        </a>

        <a href="AIInsights.aspx" class="nav-item">
            🤖 AI Insights
        </a>

        <div class="sidebar-bottom">

            <div class="admin-info">

                <div class="admin-avatar">
                    A
                </div>

                <div>
                    <div class="admin-name">
                        Admin
                    </div>

                    <div class="admin-role">
                        Administrator
                    </div>
                </div>

            </div>

            <asp:Button ID="btnLogout"
                runat="server"
                Text="Logout"
                CssClass="btn-logout"
                OnClick="btnLogout_Click" />

        </div>

    </div>

    <!-- MAIN -->

    <div class="main">

        <div class="page-header">

            <div>

                <h1>
                    Fleet <span>Cars</span>
                </h1>

                <p>
                    Manage all cars in the system
                </p>

            </div>

            <asp:Button ID="btnAddCar"
                runat="server"
                Text="+ Add Car"
                CssClass="btn-add"
                OnClick="btnAddCar_Click" />

        </div>

        <!-- ERROR -->

        <asp:Label ID="lblError"
            runat="server"
            Visible="false"
            CssClass="msg-box msg-error" />

        <!-- FILTERS -->

        <div class="filter-bar">

            <asp:Button ID="btnFilterAll"
                runat="server"
                Text="All"
                CssClass="filter-btn"
                CommandArgument="All"
                OnClick="btnFilter_Click" />

            <asp:Button ID="btnFilterStandard"
                runat="server"
                Text="Standard"
                CssClass="filter-btn"
                CommandArgument="Standard"
                OnClick="btnFilter_Click" />

            <asp:Button ID="btnFilterBusiness"
                runat="server"
                Text="Business"
                CssClass="filter-btn"
                CommandArgument="Business"
                OnClick="btnFilter_Click" />

            <asp:Button ID="btnFilterVan"
                runat="server"
                Text="Van"
                CssClass="filter-btn"
                CommandArgument="Van"
                OnClick="btnFilter_Click" />

        </div>

        <!-- TABLE -->

        <div class="table-wrap">

           <asp:GridView ID="gvCars"
    runat="server"
    AutoGenerateColumns="False"
    CssClass="modern-grid"
    GridLines="None">

    <Columns>

        <asp:TemplateField HeaderText="ID">
            <ItemTemplate>
                <span class="id-badge">
                    <%# Eval("CarID") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Car">
            <ItemTemplate>
                <div class="car-info">
                    <div class="car-icon">🚗</div>
                    <div>
                        <div class="car-model"><%# Eval("Model") %></div>
                        <div class="car-plate"><%# Eval("PlateNumber") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="CarType" HeaderText="Type" />

        <asp:BoundField DataField="Seats" HeaderText="Seats" />

        <asp:TemplateField HeaderText="Rate">
            <ItemTemplate>
                <span class="rate-price">$ <%# Eval("RatePerKm") %></span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Status">
            <ItemTemplate>
                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                    <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>

        <asp:Button ID="btnEdit"
            runat="server"
            Text="Edit"
            CommandName="EditCar"
            CommandArgument='<%# Eval("CarID") %>'
            OnCommand="GridCommand"
            CssClass="filter-btn" />

        &nbsp;

        <asp:Button ID="btnDelete"
            runat="server"
            Text="Delete"
            CommandName="DeleteCar"
            CommandArgument='<%# Eval("CarID") %>'
            OnCommand="GridCommand"
            OnClientClick="return confirm('Are you sure?');"
            CssClass="filter-btn" />

    </ItemTemplate>
</asp:TemplateField>

    </Columns>

</asp:GridView>

        </div>

    </div>

</form>

</body>
</html>