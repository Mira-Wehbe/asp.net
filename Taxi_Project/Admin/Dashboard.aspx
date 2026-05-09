<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Taxi_Project.Admin.Dashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; display: flex; }

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
        .nav-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 10px;
            font-size: 14px; color: #555; text-decoration: none;
            font-weight: 500; margin-bottom: 4px;
        }
        .nav-item:hover { background: rgba(245,195,0,0.05); color: #fff; }
        .nav-item.active { background: rgba(245,195,0,0.1); color: #F5C300; }
        .nav-icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-bottom { margin-top: auto; }
        .admin-info { display: flex; align-items: center; gap: 10px; padding: 12px; background: #111; border-radius: 10px; margin-bottom: 1rem; }
        .admin-avatar { width: 36px; height: 36px; background: #F5C300; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #111; font-size: 14px; }
        .admin-name { font-size: 13px; color: #fff; font-weight: 500; }
        .admin-role { font-size: 11px; color: #555; }
        .btn-logout { width: 100%; height: 40px; background: transparent; border: 1px solid rgba(245,195,0,0.2); color: #F5C300; border-radius: 10px; font-size: 13px; cursor: pointer; }

        /* MAIN */
        .main { margin-left: 240px; flex: 1; padding: 2.5rem; min-height: 100vh; }
        .page-header { margin-bottom: 2rem; }
        .page-header h1 { font-size: 26px; font-weight: 700; }
        .page-header h1 span { color: #F5C300; }
        .page-header p { font-size: 14px; color: #555; margin-top: 4px; }

        /* STAT CARDS */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 2rem; }
        .stat-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
            display: flex; flex-direction: column; gap: 12px;
            cursor: pointer; transition: border-color 0.2s;
        }
        .stat-card:hover { border-color: rgba(245,195,0,0.3); }
        .stat-card.yellow { border-left: 3px solid #F5C300; }
        .stat-card.blue { border-left: 3px solid #60a5fa; }
        .stat-card.green { border-left: 3px solid #4ade80; }
        .stat-card.red { border-left: 3px solid #f87171; }
        .stat-icon { font-size: 22px; }
        .stat-label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .stat-value { font-family: 'Bebas Neue', sans-serif; font-size: 38px; color: #fff; letter-spacing: 1px; line-height: 1; }
        .stat-value span { color: #F5C300; }
        .stat-sub { font-size: 12px; color: #555; }

        /* PROFIT TABS */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .section-title { font-size: 16px; font-weight: 600; color: #fff; }
        .profit-tabs { display: flex; background: #111; border-radius: 10px; padding: 3px; }
        .profit-tab { padding: 6px 16px; border-radius: 8px; font-size: 13px; color: #555; cursor: pointer; border: none; background: transparent; font-weight: 500; }
        .profit-tab.active { background: #F5C300; color: #111; font-weight: 700; }

        /* PROFIT CARD */
        .profit-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .profit-amount { font-family: 'Bebas Neue', sans-serif; font-size: 52px; color: #F5C300; letter-spacing: 2px; }
        .profit-sub { font-size: 13px; color: #555; margin-top: 4px; }

        /* BOTTOM GRID */
        .bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .list-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
        }
        .list-item {
            display: flex; justify-content: space-between;
            align-items: center; padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .list-item:last-child { border-bottom: none; }
        .list-item-left { display: flex; align-items: center; gap: 10px; }
        .list-avatar { width: 36px; height: 36px; background: #111; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .list-name { font-size: 14px; color: #fff; font-weight: 500; }
        .list-sub { font-size: 12px; color: #555; }
        .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; }
        .badge-active { background: rgba(34,197,94,0.1); color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-busy { background: rgba(245,195,0,0.1); color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-available { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
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
        <a href="Dashboard.aspx" class="nav-item active"><span class="nav-icon">📊</span> Dashboard</a>
        <a href="Calendar.aspx" class="nav-item"><span class="nav-icon">📅</span> Calendar</a>
        <a href="AIInsights.aspx" class="nav-item"><span class="nav-icon">🤖</span> AI Insights</a>

        <div class="sidebar-bottom">
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <%-- ID: lblAdminName | USE: lblAdminName.Text --%>
                    <asp:Label ID="lblAdminName" runat="server" CssClass="admin-name" Text="Admin" />
                    <div class="admin-role">Administrator</div>
                </div>
            </div>
            <%-- ID: btnLogout | USE: btnLogout_Click --%>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">

        <div class="page-header">
            <h1>Admin <span>Dashboard</span></h1>
            <p>Welcome back! Here's what's happening today.</p>
        </div>

        <!-- STAT CARDS -->
        <div class="stats-grid">

            <div class="stat-card yellow" onclick="window.location='Calendar.aspx'">
                <span class="stat-icon">🚕</span>
                <div class="stat-label">Trips Today</div>
                <%-- ID: lblTripsToday | USE: lblTripsToday.Text --%>
                <div class="stat-value"><asp:Label ID="lblTripsToday" runat="server" Text="0" /></div>
                <div class="stat-sub">Click to view →</div>
            </div>

            <div class="stat-card blue">
                <span class="stat-icon">💰</span>
                <div class="stat-label">Profit Today</div>
                <%-- ID: lblProfitToday | USE: lblProfitToday.Text --%>
                <div class="stat-value">$<asp:Label ID="lblProfitToday" runat="server" Text="0" /></div>
                <div class="stat-sub">Updated live</div>
            </div>

            <div class="stat-card green">
                <span class="stat-icon">🚗</span>
                <div class="stat-label">Active Cars</div>
                <%-- ID: lblActiveCars | USE: lblActiveCars.Text --%>
                <div class="stat-value"><asp:Label ID="lblActiveCars" runat="server" Text="0" /></div>
                <div class="stat-sub">Currently on road</div>
            </div>

            <div class="stat-card red">
                <span class="stat-icon">👨‍✈️</span>
                <div class="stat-label">Drivers Available</div>
                <%-- ID: lblDriversAvailable | USE: lblDriversAvailable.Text --%>
                <div class="stat-value"><asp:Label ID="lblDriversAvailable" runat="server" Text="0" /></div>
                <div class="stat-sub">Ready to assign</div>
            </div>

        </div>

        <!-- PROFIT SECTION -->
        <div class="section-header">
            <div class="section-title">💰 Total Profit</div>
            <div class="profit-tabs">
                <button type="button" class="profit-tab active" onclick="switchProfit('day', this)">Day</button>
                <button type="button" class="profit-tab" onclick="switchProfit('week', this)">Week</button>
                <button type="button" class="profit-tab" onclick="switchProfit('month', this)">Month</button>
            </div>
        </div>

        <div class="profit-card">
            <%-- ID: lblProfit | USE: lblProfit.Text --%>
            <div class="profit-amount">$<asp:Label ID="lblProfit" runat="server" Text="0.00" /></div>
            <%-- ID: lblProfitLabel | USE: lblProfitLabel.Text --%>
            <asp:Label ID="lblProfitLabel" runat="server" CssClass="profit-sub" Text="Total profit for today" />
            <%-- ID: hdnProfitPeriod | USE: hdnProfitPeriod.Value --%>
            <asp:HiddenField ID="hdnProfitPeriod" runat="server" Value="day" />
        </div>

        <!-- BOTTOM: CARS + DRIVERS -->
        <div class="bottom-grid">

            <!-- ACTIVE CARS -->
            <div class="list-card">
                <div class="section-header">
                    <div class="section-title">🚗 Cars On Road</div>
                </div>
                <%-- ID: pnlCars | USE: pnlCars to add car items dynamically --%>
                <asp:Panel ID="pnlCars" runat="server">
                    <div class="list-item">
                        <div class="list-item-left">
                            <div class="list-avatar">🚗</div>
                            <div>
                                <div class="list-name">Sedan — ABC 123</div>
                                <div class="list-sub">4 Seats · Standard</div>
                            </div>
                        </div>
                        <span class="badge badge-active">Active</span>
                    </div>
                </asp:Panel>
            </div>

            <!-- AVAILABLE DRIVERS -->
            <div class="list-card">
                <div class="section-header">
                    <div class="section-title">👨‍✈️ Available Drivers</div>
                </div>
                <%-- ID: pnlDrivers | USE: pnlDrivers to add driver items dynamically --%>
                <asp:Panel ID="pnlDrivers" runat="server">
                    <div class="list-item">
                        <div class="list-item-left">
                            <div class="list-avatar">👤</div>
                            <div>
                                <div class="list-name">John Doe</div>
                                <div class="list-sub">Male · Sedan</div>
                            </div>
                        </div>
                        <span class="badge badge-available">Available</span>
                    </div>
                </asp:Panel>
            </div>

        </div>

    </div>

</form>

<script>
    function switchProfit(period, btn) {
        document.querySelectorAll('.profit-tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById('<%= hdnProfitPeriod.ClientID %>').value = period;
        // Backend will handle actual value update via postback
    }
</script>

</body>
</html>