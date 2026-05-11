<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DayTrips.aspx.cs" Inherits="Taxi_Project.Admin.DayTrips" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Day Trips</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        /* same sidebar + grid CSS as Bookings.aspx */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }
        .sidebar { width:240px; background:#1a1a1a; border-right:1px solid rgba(245,195,0,0.1); display:flex; flex-direction:column; padding:2rem 1.5rem; position:fixed; top:0; left:0; bottom:0; z-index:100; }
        .logo-badge { background:#F5C300; border-radius:8px; padding:5px 12px; display:inline-flex; align-items:center; gap:6px; margin-bottom:2.5rem; }
        .logo-badge span { font-family:'Bebas Neue',sans-serif; font-size:18px; color:#111; letter-spacing:2px; }
        .logo-sep { width:2px; height:18px; background:#111; opacity:0.3; }
        .nav-label { font-size:10px; color:#333; letter-spacing:2px; text-transform:uppercase; margin-bottom:0.8rem; margin-top:1.5rem; }
        .nav-item { display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; font-size:14px; color:#555; text-decoration:none; font-weight:500; margin-bottom:4px; }
        .nav-item:hover { background:rgba(245,195,0,0.05); color:#fff; }
        .nav-icon { font-size:16px; width:20px; text-align:center; }
        .sidebar-bottom { margin-top:auto; }
        .admin-info { display:flex; align-items:center; gap:10px; padding:12px; background:#111; border-radius:10px; margin-bottom:1rem; }
        .admin-avatar { width:36px; height:36px; background:#F5C300; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:700; color:#111; font-size:14px; }
        .admin-name { font-size:13px; color:#fff; font-weight:500; }
        .admin-role { font-size:11px; color:#555; }
        .btn-logout { width:100%; height:40px; background:transparent; border:1px solid rgba(245,195,0,0.2); color:#F5C300; border-radius:10px; font-size:13px; cursor:pointer; font-family:'Inter',sans-serif; }
        .main { margin-left:240px; padding:2.5rem; min-height:100vh; overflow-y:auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem; }
        .page-header h1 { font-size:26px; font-weight:700; }
        .page-header h1 span { color:#F5C300; }
        .date-sub { font-size:14px; color:#555; margin-top:4px; }
        .btn-back { height:38px; padding:0 20px; background:transparent; border:1.5px solid rgba(255,255,255,0.1); border-radius:8px; color:#555; font-size:13px; font-family:'Inter',sans-serif; cursor:pointer; }
        .btn-back:hover { border-color:rgba(245,195,0,0.4); color:#F5C300; }
        .bookings-grid { width:100%; border-collapse:collapse; font-size:13px; font-family:'Inter',sans-serif; }
        .bookings-grid th { background:#111; color:#555; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:1px; padding:12px 14px; text-align:left; border-bottom:1px solid rgba(255,255,255,0.07); }
        .bookings-grid td { padding:14px; color:#ccc; border-bottom:1px solid rgba(255,255,255,0.05); vertical-align:middle; }
        .bookings-grid tr:hover td { background:rgba(245,195,0,0.04); }
        .bookings-grid input[type="submit"] { background:transparent; border:1px solid rgba(245,195,0,0.3); color:#F5C300; border-radius:7px; padding:5px 12px; font-size:11px; font-weight:600; cursor:pointer; font-family:'Inter',sans-serif; }
        .bookings-grid input[type="submit"]:hover { background:rgba(245,195,0,0.08); }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="sidebar">
        <div class="logo-badge"><span>YALLA</span><div class="logo-sep"></div><span>TAXI</span></div>
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
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="main">
        <div class="page-header">
            <div>
                <h1>Trips on <span><asp:Label ID="lblDate" runat="server" /></span></h1>
            </div>
            <asp:Button ID="btnBack" runat="server" Text="← Back to Calendar" CssClass="btn-back" OnClick="btnBack_Click" CausesValidation="false" />
        </div>

        <asp:GridView ID="gvTrips" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="TripID"
            OnRowCommand="gvTrips_RowCommand"
            CssClass="bookings-grid" CellPadding="12">
            <Columns>
                <asp:BoundField DataField="TripID"          HeaderText="#" />
                <asp:BoundField DataField="Client"          HeaderText="Client" />
                <asp:BoundField DataField="Car"             HeaderText="Car" />
                <asp:BoundField DataField="Driver"          HeaderText="Driver" />
                <asp:BoundField DataField="PickupLocation"  HeaderText="Pickup" />
                <asp:BoundField DataField="DropoffLocation" HeaderText="Dropoff" />
                <asp:BoundField DataField="PickupTime"      HeaderText="Time" />
                <asp:BoundField DataField="Price"           HeaderText="Price" />
                <asp:BoundField DataField="Status"          HeaderText="Status" />
                <asp:ButtonField CommandName="EditTrip" Text="✏ Edit" ButtonType="Button" />
            </Columns>
        </asp:GridView>
    </div>
</form>
</body>
</html>