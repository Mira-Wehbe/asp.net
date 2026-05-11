<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Bookings.aspx.cs" Inherits="Taxi_Project.Admin.Bookings" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; display: flex; }

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
        .main { margin-left: 240px; flex: 1; padding: 2.5rem; min-height: 100vh; overflow-y: auto; }

        /* ── PAGE HEADER ─────────────────────────────── */
        .page-header { margin-bottom: 1.5rem; }
        .page-header-top { display: flex; align-items: center; gap: 14px; margin-bottom: 1rem; }
        .page-header-top h1 { font-size: 26px; font-weight: 700; }
        .page-header-top h1 span { color: #F5C300; }
        .live-badge {
            background: rgba(239,68,68,0.15); border: 1px solid rgba(239,68,68,0.3);
            color: #f87171; border-radius: 50px; padding: 4px 12px;
            font-size: 11px; font-weight: 700; letter-spacing: 1px;
            display: flex; align-items: center; gap: 5px;
        }
        .live-dot {
            width: 7px; height: 7px; border-radius: 50%;
            background: #f87171;
        }

        /* ── VIEW TABS (List / Calendar) ─────────────── */
        .view-tabs { display: flex; gap: 8px; margin-bottom: 1.2rem; }
        .view-tab {
            height: 43px; padding: 0 28px;
            border-radius: 10px; font-size: 13px; font-weight: 600;
            font-family: 'Inter', sans-serif; cursor: pointer;
            border: 1.5px solid rgba(255,255,255,0.1);
            background: transparent; color: #555; transition: all .2s;
            display: flex; align-items: center; gap: 7px;
        }
        .view-tab:hover { border-color: rgba(245,195,0,0.3); color: #fff; }
        .view-tab.active { background: rgba(245,195,0,0.1); border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* ── NEW BOOKING BUTTON ──────────────────────── */
        .btn-new-booking {
            height: 42px; padding: 0 20px;
            background: #F5C300; border: none; border-radius: 10px;
            color: #111; font-size: 13px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: background .2s; margin-bottom: 1.5rem;
            display: inline-flex; align-items: center; gap: 7px;
        }
        .btn-new-booking:hover { background: #ffd500; }

        /* ── STATUS FILTER TABS ──────────────────────── */
        .status-tabs { display: flex; gap: 8px; margin-bottom: 1.5rem; flex-wrap: wrap; }
        .status-tab {
            height: 34px; padding: 0 16px;
            border-radius: 8px; font-size: 12px; font-weight: 600;
            font-family: 'Inter', sans-serif; cursor: pointer;
            border: 1.5px solid rgba(255,255,255,0.07);
            background: #1a1a1a; color: #555; transition: all .2s;
        }
        .status-tab:hover { border-color: rgba(245,195,0,0.3); color: #fff; }
        .status-tab.active { background: rgba(245,195,0,0.1); border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* ── SEARCH BAR ──────────────────────────────── */
        .search-wrap {
            display: flex; align-items: center;
            background: #1a1a1a; border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 12px; padding: 0 16px;
            margin-bottom: 1.5rem; height: 46px; gap: 10px;
        }
        .search-icon { font-size: 14px; color: #444; }
        .search-input {
            flex: 1; background: none; border: none; outline: none;
            color: #fff; font-size: 13px; font-family: 'Inter', sans-serif;
        }
        .search-input::placeholder { color: #333; }
        .btn-search {
            height: 32px; padding: 0 16px;
            background: #F5C300; border: none; border-radius: 8px;
            color: #111; font-size: 12px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer;
        }

        /* ── LIST VIEW ───────────────────────────────── */
        .bookings-list { display: flex; flex-direction: column; gap: 1rem; }

        .booking-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 14px; padding: 1.4rem;
            border-left: 3px solid #F5C300;
            transition: border-color .2s;
        }
        .booking-card:hover { border-color: rgba(245,195,0,0.4); }
        .booking-card.active-card    { border-left-color: #4ade80; }
        .booking-card.completed-card { border-left-color: #60a5fa; }
        .booking-card.cancelled-card { border-left-color: #f87171; }

        .booking-card-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .booking-id { font-size: 16px; font-weight: 700; color: #fff; }

        .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; }
        .badge-pending   { background: rgba(245,195,0,0.1);  color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-active    { background: rgba(34,197,94,0.1);  color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-completed { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-cancelled { background: rgba(255,80,80,0.1);  color: #f87171; border: 1px solid rgba(255,80,80,0.3); }

        .booking-client { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
        .client-avatar {
            width: 38px; height: 38px; background: #F5C300;
            border-radius: 10px; display: flex; align-items: center;
            justify-content: center; font-weight: 700; color: #111; font-size: 15px;
            flex-shrink: 0;
        }
        .client-name { font-size: 14px; font-weight: 600; color: #fff; }
        .client-car  { font-size: 12px; color: #555; margin-top: 2px; }

        .booking-route { display: flex; flex-direction: column; gap: 10px; margin-bottom: 14px; padding-left: 2px; }
        .route-row { display: flex; align-items: flex-start; gap: 12px; }
        .route-dot-yellow { width: 10px; height: 10px; border-radius: 50%; background: #F5C300; flex-shrink: 0; margin-top: 4px; }
        .route-dot-green  { width: 10px; height: 10px; border-radius: 50%; background: #4ade80; flex-shrink: 0; margin-top: 4px; }
        .route-info .route-label { font-size: 10px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .route-info .route-place { font-size: 13px; font-weight: 600; color: #fff; }

        .booking-footer {
            display: flex; justify-content: space-between; align-items: center;
            padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.05);
        }
        .price-wrap .price-label { font-size: 10px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .price-value { font-family: 'Bebas Neue', sans-serif; font-size: 24px; color: #F5C300; }

        .booking-actions { display: flex; gap: 8px; }
        .btn-action {
            height: 34px; padding: 0 14px; border-radius: 8px;
            font-size: 12px; font-weight: 600; cursor: pointer;
            font-family: 'Inter', sans-serif; border: none; transition: all .2s;
        }
        .btn-assign  { background: #F5C300; color: #111; }
        .btn-assign:hover  { background: #ffd500; }
        .btn-cancel  { background: transparent; border: 1px solid rgba(255,80,80,0.3); color: #f87171; }
        .btn-cancel:hover  { background: rgba(255,80,80,0.08); }
        .btn-complete { background: transparent; border: 1px solid rgba(59,130,246,0.3); color: #60a5fa; }
        .btn-complete:hover { background: rgba(59,130,246,0.08); }

        /* ── GRIDVIEW ────────────────────────────────── */
        .bookings-grid {
            width: 100%; border-collapse: collapse;
            font-size: 13px; font-family: 'Inter', sans-serif;
        }
        .bookings-grid th {
            background: #111; color: #555;
            font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            padding: 12px 14px; text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .bookings-grid td {
            padding: 14px; color: #ccc;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
        }
        .bookings-grid tr:hover td { background: rgba(245,195,0,0.04); }
        .bookings-grid input[type="submit"] {
            background: transparent;
            border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 7px;
            padding: 5px 12px; font-size: 11px;
            font-weight: 600; cursor: pointer;
            font-family: 'Inter', sans-serif;
            transition: background .2s;
        }
        .bookings-grid input[type="submit"]:hover {
            background: rgba(245,195,0,0.08);
        }
        /* ── GRIDVIEW ────────────────────────────────── */
        .bookings-grid {
            width: 100%; border-collapse: collapse;
            font-size: 13px; font-family: 'Inter', sans-serif;
        }
        .bookings-grid th {
            background: #111; color: #555;
            font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            padding: 12px 14px; text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .bookings-grid td {
            padding: 14px; color: #ccc;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
        }
        .bookings-grid tr:hover td { background: rgba(245,195,0,0.04); }
        .bookings-grid input[type="submit"] {
            background: transparent;
            border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 7px;
            padding: 5px 12px; font-size: 11px;
            font-weight: 600; cursor: pointer;
            font-family: 'Inter', sans-serif;
            transition: background .2s;
        }
        .bookings-grid input[type="submit"]:hover {
            background: rgba(245,195,0,0.08);
        }

        /* ── CALENDAR VIEW ───────────────────────────── */
        .calendar-wrap {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
        }
        .calendar-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.2rem; }
        .calendar-month { font-family: 'Bebas Neue', sans-serif; font-size: 24px; color: #F5C300; letter-spacing: 1px; }
        .cal-nav { display: flex; gap: 8px; }
        .btn-cal-nav {
            width: 34px; height: 34px; border-radius: 8px;
            background: #111; border: 1px solid rgba(255,255,255,0.07);
            color: #555; font-size: 14px; cursor: pointer;
            font-family: 'Inter', sans-serif; transition: all .2s;
        }
        .btn-cal-nav:hover { border-color: rgba(245,195,0,0.3); color: #F5C300; }

        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; }
        .cal-day-header { text-align: center; font-size: 11px; color: #444; font-weight: 700; padding: 8px 0; text-transform: uppercase; letter-spacing: 1px; }
        .cal-day {
            aspect-ratio: 1; border-radius: 8px; display: flex;
            flex-direction: column; align-items: center; justify-content: center;
            font-size: 13px; color: #555; cursor: pointer;
            position: relative; transition: all .2s; padding: 4px;
        }
        .cal-day:hover { background: rgba(245,195,0,0.07); color: #fff; }
        .cal-day.today { background: rgba(245,195,0,0.12); color: #F5C300; font-weight: 700; border: 1px solid rgba(245,195,0,0.3); }
        .cal-day.has-trips { color: #fff; }
        .cal-day.empty { cursor: default; }
        .trip-dot { width: 5px; height: 5px; border-radius: 50%; background: #F5C300; margin-top: 2px; }

        /* ── EMPTY STATE ─────────────────────────────── */
        .empty-state { text-align: center; padding: 3rem; color: #333; }
        .empty-state span { font-size: 40px; display: block; margin-bottom: 1rem; }
        .empty-state p { font-size: 14px; }

        /* hidden panel */
        .view-panel { display: none; }
        .view-panel.shown { display: block; }
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

    <div class="main">

        <div class="page-header">
            <div class="page-header-top">
                <h1>All <span>Bookings</span></h1>
                <div class="live-badge">
                    <div class="live-dot"></div>
                </div>
            </div>
        </div>

        <div class="view-tabs">
            <asp:Button ID="btnViewList"     runat="server" Text="☰ List"     CssClass="view-tab active" OnClick="btnView_Click" CommandArgument="List"     CausesValidation="false" />
            <asp:Button ID="btnViewCalendar" runat="server" Text="📅 Calendar" CssClass="view-tab"        OnClick="btnView_Click" CommandArgument="Calendar" CausesValidation="false" />
        </div>

        <asp:Panel ID="pnlListView" runat="server" CssClass="view-panel shown">

           

            <!-- SEARCH -->
           <!--<div class="search-wrap">
                <span class="search-icon">🔍</span>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input"
                    placeholder="Search by customer, car or ID..." />
                <asp:Button ID="btnSearch" runat="server" Text="Search"
                    CssClass="btn-search" OnClick="btnSearch_Click" CausesValidation="false" />
            </div>-->
            <asp:GridView ID="gvBookings" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="TripID"
                OnRowCommand="gvBookings_RowCommand"
                CssClass="bookings-grid" CellPadding="12">
                <Columns>
                    <asp:BoundField DataField="TripID"          HeaderText="#" />
                    <asp:BoundField DataField="Client"          HeaderText="Client" />
                    <asp:BoundField DataField="Car"             HeaderText="Car" />
                    <asp:BoundField DataField="Driver"          HeaderText="Driver" />
                    <asp:BoundField DataField="PickupLocation"  HeaderText="Pickup" />
                    <asp:BoundField DataField="DropoffLocation" HeaderText="Dropoff" />
                    <asp:BoundField DataField="PickupTime"      HeaderText="Time" />
                    <asp:BoundField DataField="DriverGender" HeaderText="Gender Pref" />
                    <asp:BoundField DataField="Price"           HeaderText="Price" />
                    <asp:BoundField DataField="Status"          HeaderText="Status" />
                    <asp:ButtonField CommandName="EditTrip" Text="✏ Edit"
                        ButtonType="Button" />
                </Columns>
            </asp:GridView>

        </asp:Panel>
        <asp:Panel ID="pnlCalendarView" runat="server" CssClass="view-panel"/>

            <div class="calendar-wrap">
                <div class="calendar-header">
                    <asp:Label ID="lblCalendarMonth" runat="server" CssClass="calendar-month" Text="MAY 2026" />
                    <div class="cal-nav">
                        <asp:Button ID="btnCalPrev" runat="server" Text="←" CssClass="btn-cal-nav"
                            OnClick="btnCalNav_Click" CommandArgument="prev" CausesValidation="false" />
                        <asp:Button ID="btnCalNext" runat="server" Text="→" CssClass="btn-cal-nav"
                            OnClick="btnCalNav_Click" CommandArgument="next" CausesValidation="false" />
                    </div>
                </div>
                <div class="calendar-grid">
                    <div class="cal-day-header">SUN</div>
                    <div class="cal-day-header">MON</div>
                    <div class="cal-day-header">TUE</div>
                    <div class="cal-day-header">WED</div>
                    <div class="cal-day-header">THU</div>
                    <div class="cal-day-header">FRI</div>
                    <div class="cal-day-header">SAT</div>
                    <asp:Panel ID="pnlCalendarDays" runat="server" />
                </div>
            </div>
        <asp:HiddenField ID="hdnView"          runat="server" Value="List" />
        <asp:HiddenField ID="hdnCalendarMonth" runat="server" Value="" />
        <asp:HiddenField ID="hdnFilter"        runat="server" Value="All" />

    </div>

</form>
</body>
</html>
