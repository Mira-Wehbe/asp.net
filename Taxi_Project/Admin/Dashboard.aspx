<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Taxi_Project.Admin.Dashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }

        /* ── SIDEBAR ─────────────────────────────────── */
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
            font-weight: 500; margin-bottom: 4px; transition: all .2s;
        }
        .nav-item:hover { background: rgba(245,195,0,0.05); color: #fff; }
        .nav-item.active { background: rgba(245,195,0,0.1); color: #F5C300; }
        .nav-icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-bottom { margin-top: auto; }
        .admin-info { display: flex; align-items: center; gap: 10px; padding: 12px; background: #111; border-radius: 10px; margin-bottom: 1rem; }
        .admin-avatar { width: 36px; height: 36px; background: #F5C300; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #111; font-size: 14px; }
        .admin-name { font-size: 13px; color: #fff; font-weight: 500; }
        .admin-role { font-size: 11px; color: #555; }
        .btn-logout { width: 100%; height: 40px; background: transparent; border: 1px solid rgba(245,195,0,0.2); color: #F5C300; border-radius: 10px; font-size: 13px; cursor: pointer; font-family: 'Inter', sans-serif; }

        /* ── MAIN ────────────────────────────────────── */
        .main { margin-left: 240px; padding: 2.5rem; min-height: 100vh; overflow-y: auto;min-width: 0; }
        .page-header { margin-bottom: 2rem; }
        .page-header h1 { font-size: 26px; font-weight: 700; }
        .page-header h1 span { color: #F5C300; }
        .page-header p { font-size: 14px; color: #555; margin-top: 4px; }

        /* ── STAT CARDS ──────────────────────────────── */
        .stats-grid { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 1.5rem; 
            margin-bottom: 2.5rem;
            max-width: 900px;
            
        }
        .stat-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; 
            padding: 1.8rem 2rem;  /* ← bigger padding */
            display: flex; flex-direction: column; gap: 12px;
            transition: border-color 0.2s;
            min-height: 220px;  /* ← add minimum height */
        }
       
        .stat-card:hover { border-color: rgba(245,195,0,0.3); }
        .stat-card.yellow { border-left: 3px solid #F5C300; }
        .stat-card.blue   { border-left: 3px solid #60a5fa; }
        .stat-card.green  { border-left: 3px solid #4ade80; }
        .stat-card.red    { border-left: 3px solid #f87171; }
        .stat-icon  { font-size: 33px; }
        .stat-label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .stat-value { 
            font-family: 'Bebas Neue', sans-serif; 
            font-size: 54px;  /* ← bigger number */
            color: #fff; letter-spacing: 1px; line-height: 1; 
         }
        .stat-btn {
            background: none; border: none; color: #555;
            font-size: 12px; font-family: 'Inter', sans-serif;
            cursor: pointer; padding: 0; text-align: left;
            transition: color .2s; width: 100%;
        }
        .stat-btn:hover { color: #F5C300; }

        /* ── SECTION HEADER ──────────────────────────── */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .section-title  { font-size: 16px; font-weight: 600; color: #fff; }

        /* ── RECENT BOOKINGS ─────────────────────────── */
        .bookings-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
        }
        .search-wrap {
            display: flex; align-items: center;
            background: #111; border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 10px; padding: 0 14px;
            margin-bottom: 1.2rem; height: 42px; gap: 8px;
        }
        .search-icon { font-size: 14px; color: #444; }
        .search-input {
            flex: 1; background: none; border: none; outline: none;
            color: #fff; font-size: 13px; font-family: 'Inter', sans-serif;
        }
        .search-input::placeholder { color: #333; }
        .btn-search {
            height: 30px; padding: 0 14px;
            background: #F5C300; border: none; border-radius: 7px;
            color: #111; font-size: 12px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer;
        }

        /* Booking item card */
        .booking-item {
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 1.2rem;
            margin-bottom: 1rem; border-left: 3px solid #F5C300;
        }
        .booking-item:last-child { margin-bottom: 0; }
        .booking-id { font-size: 15px; font-weight: 700; color: #fff; margin-bottom: 10px; }
        .booking-client { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .client-avatar {
            width: 36px; height: 36px; background: #F5C300;
            border-radius: 10px; display: flex; align-items: center;
            justify-content: center; font-weight: 700; color: #111; font-size: 14px;
        }
        .client-name { font-size: 14px; font-weight: 600; color: #fff; }
        .client-car  { font-size: 12px; color: #555; }
        .booking-route { display: flex; flex-direction: column; gap: 8px; margin-bottom: 14px; padding-left: 4px; }
        .route-row { display: flex; align-items: flex-start; gap: 10px; }
        .route-dot-yellow { width: 10px; height: 10px; border-radius: 50%; background: #F5C300; flex-shrink: 0; margin-top: 3px; }
        .route-dot-green  { width: 10px; height: 10px; border-radius: 50%; background: #4ade80; flex-shrink: 0; margin-top: 3px; }
        .route-label { font-size: 10px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .route-place { font-size: 13px; font-weight: 600; color: #fff; }
        .booking-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 10px; padding-top: 10px; border-top: 1px solid rgba(255,255,255,0.05); }
        .booking-price-wrap .booking-price-label { font-size: 10px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .booking-price { font-family: 'Bebas Neue', sans-serif; font-size: 22px; color: #F5C300; }

        .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; }
        .badge-pending   { background: rgba(245,195,0,0.1);  color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-active    { background: rgba(34,197,94,0.1);  color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-completed { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-cancelled { background: rgba(255,80,80,0.1);  color: #f87171; border: 1px solid rgba(255,80,80,0.3); }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- SIDEBAR — only Dashboard + AI Insights -->
    <div class="sidebar">
        <div class="logo-badge">
            <span>YALLA</span>
            <div class="logo-sep"></div>
            <span>TAXI</span>
        </div>
        <div class="nav-label">Main Menu</div>
        <a href="Dashboard.aspx"  class="nav-item active"><span class="nav-icon">📊</span> Dashboard</a>
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
            <h1>Admin <span>Dashboard</span></h1>
            <p>Welcome back! Here's what's happening today.</p>
        </div>

        <!-- STAT CARDS -->
        <div class="stats-grid">

            <!-- TRIPS TODAY → Bookings.aspx -->
            <div class="stat-card yellow">
                <span class="stat-icon">🚕</span>
                <div class="stat-label">Profit</div>
                <div class="stat-value"><asp:Label ID="lblTripsToday" runat="server" Text="" /></div>
                <asp:Button ID="btnTripsToday" runat="server" Text="Click to view →"
                    CssClass="stat-btn" OnClick="btnTripsToday_Click" CausesValidation="false" />
            </div>

            <!-- NEW BOOKINGS → Bookings.aspx -->
            <div class="stat-card blue">
                <span class="stat-icon">📋</span>
                <div class="stat-label">New Bookings</div>
                <div class="stat-value"><asp:Label ID="lblNewBookings" runat="server" Text="" /></div>
                <asp:Button ID="btnNewBookings" runat="server" Text="More info →"
                    CssClass="stat-btn" OnClick="btnNewBookings_Click" CausesValidation="false" />
            </div>

            <!-- TOTAL CARS → Cars.aspx -->
            <div class="stat-card green">
                <span class="stat-icon">🚗</span>
                <div class="stat-label">Total Cars</div>
                <div class="stat-value"><asp:Label ID="lblTotalCars" runat="server" Text="" /></div>
                <asp:Button ID="btnTotalCars" runat="server" Text="More info →"
                    CssClass="stat-btn" OnClick="btnTotalCars_Click" CausesValidation="false" />
            </div>

            <!-- DRIVERS REGISTERED → Drivers.aspx -->
            <div class="stat-card red">
                <span class="stat-icon">👨‍✈️</span>
                <div class="stat-label">Drivers Registered</div>
                <div class="stat-value"><asp:Label ID="lblDriversRegistered" runat="server" Text="" /></div>
                <asp:Button ID="btnDriversRegistered" runat="server" Text="More info →"
                    CssClass="stat-btn" OnClick="btnDriversRegistered_Click" CausesValidation="false" />
            </div>

        </div>

            <!-- BOOKINGS LIST — filled by C# -->
            <asp:Panel ID="pnlBookings" runat="server" />
        </div>

    </div>

</form>
</body>
</html>
