<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Drivers.aspx.cs" Inherits="Taxi_Project.Admin.Drivers" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Drivers</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>

        *{margin:0;padding:0;box-sizing:border-box;}

        body{
            background:#0f0f0f;
            color:#fff;
            font-family:'Inter',sans-serif;
            display:flex;
        }

        /* SIDEBAR */
        .sidebar {
    width: 240px; background: #1a1a1a;
    border-right: 1px solid rgba(245,195,0,0.1);
    display: flex; flex-direction: column;
    padding: 2rem 1.5rem; position: fixed;
    top: 0; left: 0; bottom: 0; z-index: 100;
       }
        .logo-badge { background: #F5C300; border-radius: 8px; padding: 5px 12px; display: inline-flex; align-items: center; gap: 6px; margin-bottom: 2.5rem; }
        .logo-badge span { font-family: 'Bebas Neue', sans-serif; font-size: 18px; color: #111; letter-spacing: 2px; }
        .logo-sep { width: 2px; height: 18px; background: #111; opacity: 0.3; }
        .nav-label { font-size: 10px; color: #333; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 0.8rem; margin-top: 1.5rem; }
        .nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; font-size: 14px; color: #555; text-decoration: none; font-weight: 500; margin-bottom: 4px; transition: all .2s; }
        .nav-item:hover { background: rgba(245,195,0,0.05); color: #fff; }
        .nav-item.active { background: rgba(245,195,0,0.1); color: #F5C300; }
        .nav-icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-bottom { margin-top: auto; }
        .admin-info { display: flex; align-items: center; gap: 10px; padding: 12px; background: #111; border-radius: 10px; margin-bottom: 1rem; }
        .admin-avatar { width: 36px; height: 36px; background: #F5C300; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #111; font-size: 14px; }
        .admin-name { font-size: 13px; color: #fff; font-weight: 500; }
        .admin-role { font-size: 11px; color: #555; }
        .btn-logout { width: 100%; height: 40px; background: transparent; border: 1px solid rgba(245,195,0,0.2); color: #F5C300; border-radius: 10px; font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif; }
       
        /* MAIN */
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

        .btn-add{
            background:#F5C300;
            border:none;
            padding:10px 18px;
            font-weight:700;
            cursor:pointer;
        }

        /* FILTER */
        .filter-bar{
            display:flex;
            gap:10px;
            margin-bottom:1.5rem;
        }

        .filter-btn{
            background:#1a1a1a;
            border:1px solid rgba(255,255,255,0.1);
            color:#777;
            padding:8px 16px;
            cursor:pointer;
        }

        /* TABLE STYLE (same as Cars) */
        .table-wrap{
            background:#1a1a1a;
            border-radius:22px;
            overflow:hidden;
            border:1px solid rgba(255,255,255,0.06);
        }

        .modern-grid{
            width:100%;
            border-collapse:collapse;
        }

        .modern-grid th{
            background:#151515;
            padding:16px;
            color:#666;
            text-transform:uppercase;
            font-size:11px;
        }

        .modern-grid td{
            padding:16px;
            border-bottom:1px solid rgba(255,255,255,0.05);
            color:#ddd;
        }

        .modern-grid tr:hover td{
            background:rgba(245,195,0,0.04);
        }

        .id-badge{
            background:rgba(245,195,0,0.15);
            color:#F5C300;
            padding:6px 10px;
            border-radius:20px;
            font-size:11px;
        }

        .status-active{
            background:rgba(34,197,94,0.1);
            color:#4ade80;
            padding:6px 12px;
            border-radius:20px;
            font-size:11px;
        }

        .status-inactive{
            background:rgba(255,80,80,0.1);
            color:#ff6b6b;
            padding:6px 12px;
            border-radius:20px;
            font-size:11px;
        }

        .msg-error{
            color:#ff6b6b;
            margin-bottom:10px;
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
    <div class="nav-label">Main Menu</div>
    <a href="Dashboard.aspx"  class="nav-item"><span class="nav-icon">📊</span> Dashboard</a>
    <a href="AIInsights.aspx" class="nav-item"><span class="nav-icon">🤖</span> AI Insights</a>
    <div class="sidebar-bottom">
        <div class="admin-info">
            <div class="admin-avatar">A</div>
            <div>
                <asp:Label ID="lblAdminName" runat="server" CssClass="admin-name" Text="Admin" />
                <div class="admin-role">Administrator</div>
            </div>
        </div>
        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout"
            OnClick="btnLogout_Click" CausesValidation="false" />
    </div>
</div>

<!-- MAIN -->
<div class="main">

    <div class="page-header">
        <div>
            <h1>Drivers</h1>
            <p>Manage all drivers</p>
        </div>

        <asp:Button ID="btnAddDriver" runat="server" Text="+ Add Driver"
            CssClass="btn-add" OnClick="btnAddDriver_Click" />
    </div>

    <!-- ERROR -->
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

    <!-- FILTER -->
    <div class="filter-bar">
        <asp:Button runat="server" Text="All" CommandArgument="All"
            CssClass="filter-btn" OnClick="btnFilter_Click" />

        <asp:Button runat="server" Text="Available" CommandArgument="Available"
            CssClass="filter-btn" OnClick="btnFilter_Click" />

        <asp:Button runat="server" Text="Busy" CommandArgument="Busy"
            CssClass="filter-btn" OnClick="btnFilter_Click" />
    </div>

    <!-- GRID -->
    <div class="table-wrap">

        <asp:GridView ID="gvDrivers" runat="server"
            AutoGenerateColumns="False"
            CssClass="modern-grid">

            <Columns>

                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <span class="id-badge"><%# Eval("DriverID") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <%# Eval("FullName") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Phone" HeaderText="Phone" />
                <asp:BoundField DataField="Gender" HeaderText="Gender" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>

                        <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-active" : "status-inactive" %>'>
                            <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available" : "Busy" %>
                        </span>

                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>

        <asp:Button ID="btnEdit"
            runat="server"
            Text="Edit"
            CommandName="EditDriver"
            CommandArgument='<%# Eval("DriverID") %>'
            OnCommand="GridCommand"
            CssClass="filter-btn" />

        &nbsp;

        <asp:Button ID="btnDelete"
            runat="server"
            Text="Delete"
            CommandName="DeleteDriver"
            CommandArgument='<%# Eval("DriverID") %>'
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