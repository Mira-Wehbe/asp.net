<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profit.aspx.cs" Inherits="Taxi_Project.Admin.Profit" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Profit</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
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
        .main { margin-left:240px; padding:2.5rem; min-height:100vh; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem; }
        .page-header h1 { font-size:26px; font-weight:700; }
        .page-header h1 span { color:#F5C300; }
        .btn-back { height:38px; padding:0 20px; background:transparent; border:1.5px solid rgba(255,255,255,0.1); border-radius:8px; color:#555; font-size:13px; font-family:'Inter',sans-serif; cursor:pointer; }
        .btn-back:hover { border-color:rgba(245,195,0,0.4); color:#F5C300; }

        /* TOTAL PROFIT CARDS */
        .profit-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:1rem; margin-bottom:2rem; }
        .profit-card { background:#1a1a1a; border:1px solid rgba(255,255,255,0.07); border-radius:16px; padding:1.5rem; display:flex; flex-direction:column; gap:10px; }
        .profit-card.yellow { border-left:3px solid #F5C300; }
        .profit-card.blue   { border-left:3px solid #60a5fa; }
        .profit-card.green  { border-left:3px solid #4ade80; }
        .profit-card.purple { border-left:3px solid #c084fc; }
        .profit-icon  { font-size:22px; }
        .profit-label { font-size:11px; color:#555; text-transform:uppercase; letter-spacing:1px; }
        .profit-value { font-family:'Bebas Neue',sans-serif; font-size:42px; color:#F5C300; letter-spacing:1px; line-height:1; }
        .profit-sub   { font-size:11px; color:#444; }

        /* CAR TYPE CARDS */
        .section-title { font-size:16px; font-weight:700; color:#fff; margin-bottom:1rem; }
        .section-title span { color:#F5C300; }
        .car-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; }
        .car-card { background:#1a1a1a; border:1px solid rgba(255,255,255,0.07); border-radius:16px; padding:1.8rem; display:flex; flex-direction:column; gap:14px; }
        .car-type-icon { font-size:32px; }
        .car-type-name { font-size:18px; font-weight:700; color:#fff; }
        .car-divider { height:1px; background:rgba(255,255,255,0.05); }
        .car-stat-row { display:flex; justify-content:space-between; align-items:center; }
        .car-stat-label { font-size:12px; color:#444; }
        .car-stat-value { font-size:14px; color:#aaa; font-weight:600; }
        .car-stat-value.yellow { color:#F5C300; font-weight:700; }
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
            <h1>💰 <span>Profit</span> Report</h1>
            <asp:Button ID="btnBack" runat="server" Text="← Back" CssClass="btn-back" OnClick="btnBack_Click" CausesValidation="false" />
        </div>

        <div class="profit-grid">
            <div class="profit-card yellow">
                <span class="profit-icon">📅</span>
                <div class="profit-label">Today</div>
                <div class="profit-value">$<asp:Label ID="lblToday" runat="server" Text="0.00" /></div>
                <div class="profit-sub">Completed trips only</div>
            </div>
            <div class="profit-card blue">
                <span class="profit-icon">📆</span>
                <div class="profit-label">This Week</div>
                <div class="profit-value">$<asp:Label ID="lblWeek" runat="server" Text="0.00" /></div>
                <div class="profit-sub">Last 7 days</div>
            </div>
            <div class="profit-card green">
                <span class="profit-icon">🗓️</span>
                <div class="profit-label">This Month</div>
                <div class="profit-value">$<asp:Label ID="lblMonth" runat="server" Text="0.00" /></div>
                <div class="profit-sub">Last 30 days</div>
            </div>
            <div class="profit-card purple">
                <span class="profit-icon">💎</span>
                <div class="profit-label">All Time</div>
                <div class="profit-value">$<asp:Label ID="lblAllTime" runat="server" Text="0.00" /></div>
                <div class="profit-sub">Total since launch</div>
            </div>
        </div>

        <div class="section-title">Profit by <span>Car Type</span></div>
        <div class="car-grid">

            <div class="car-card">
                <div class="car-type-icon">🚗</div>
                <div class="car-type-name">Standard</div>
                <div class="car-divider"></div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Trips</span>
                    <span class="car-stat-value"><asp:Label ID="lblStandardTrips" runat="server" Text="0" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Profit</span>
                    <span class="car-stat-value yellow">$<asp:Label ID="lblStandardProfit" runat="server" Text="0.00" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Rate / km</span>
                    <span class="car-stat-value">$0.50</span>
                </div>
            </div>

            <div class="car-card">
                <div class="car-type-icon">🚙</div>
                <div class="car-type-name">Business</div>
                <div class="car-divider"></div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Trips</span>
                    <span class="car-stat-value"><asp:Label ID="lblBusinessTrips" runat="server" Text="0" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Profit</span>
                    <span class="car-stat-value yellow">$<asp:Label ID="lblBusinessProfit" runat="server" Text="0.00" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Rate / km</span>
                    <span class="car-stat-value">$1.00</span>
                </div>
            </div>

            <div class="car-card">
                <div class="car-type-icon">🚐</div>
                <div class="car-type-name">Van</div>
                <div class="car-divider"></div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Trips</span>
                    <span class="car-stat-value"><asp:Label ID="lblVanTrips" runat="server" Text="0" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Total Profit</span>
                    <span class="car-stat-value yellow">$<asp:Label ID="lblVanProfit" runat="server" Text="0.00" /></span>
                </div>
                <div class="car-stat-row">
                    <span class="car-stat-label">Rate / km</span>
                    <span class="car-stat-value">$2.00</span>
                </div>
            </div>

        </div>
    </div>
</form>
</body>
</html>