<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="Taxi_Project.Admin.Calendar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Calendar</title>
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
        .main { margin-left: 240px; flex: 1; padding: 2.5rem; min-height: 100vh; overflow-y: auto; width: calc(100% - 240px);display: block; }

        /* ── PAGE HEADER ─────────────────────────────── */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header h1 { font-size: 26px; font-weight: 700; }
        .page-header h1 span { color: #F5C300; }
        .btn-back {
            height: 38px; padding: 0 20px;
            background: transparent; border: 1.5px solid rgba(255,255,255,0.1);
            border-radius: 8px; color: #555; font-size: 13px;
            font-family: 'Inter', sans-serif; cursor: pointer; transition: all .2s;
        }
        .btn-back:hover { border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* ── ASP CALENDAR STYLING ────────────────────── */
        .cal-wrap {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px;
            padding: 1.5rem;
            width: 100%;
            display: block;
        }
        .cal-wrap > table,
        .cal-wrap table.cal-table {
            width: 100% !important;
            border-collapse: collapse !important;
            table-layout: fixed !important;
        }
        a.trip-count {
            display: inline-block;
            background: #F5C300; color: #111;
            border-radius: 50px; font-size: 10px;
            font-weight: 700; padding: 1px 7px;
            margin-top: 4px; text-decoration: none;
        }
        a.trip-count:hover { background: #ffd500; }
        /* Override asp:Calendar table */
        table.cal-table { width: 100%; border-collapse: collapse; }

        /* Title row (Month Year + nav arrows) */
           .cal-title {
                background: #111;
                color: #F5C300;
                font-family: 'Bebas Neue', sans-serif;
                font-size: 22px;
                letter-spacing: 2px;
                padding: 10px 14px !important;   /* was no explicit limit → ballooned */
                text-align: center;
                border-radius: 10px;
                height: 48px !important;         /* pin it */
                line-height: 1 !important;
           }
        .cal-prev-next {
            background: transparent; border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 6px; padding: 4px 10px;
            font-size: 14px; cursor: pointer;
        }

        /* Day headers */
        .cal-day-header {
            background: #111; color: #444;
            font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            padding: 10px 8px; text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .cal-wrap table tr:first-child td {
            height: 48px !important;
            max-height: 48px !important;
            padding: 0 !important;
        }
        /* Day cells */
        .cal-day {
            padding: 8px; min-height: 120px;
            vertical-align: top;
            border: 1px solid rgba(255,255,255,0.04);
            color: #555; font-size: 13px; font-weight: 600;
        }
        .cal-day:hover { background: rgba(245,195,0,0.04); }

        /* Today */
        .cal-today {
            background: rgba(245,195,0,0.07);
            border: 1px solid rgba(245,195,0,0.2) !important;
            color: #F5C300 !important; font-weight: 700;
        }
        .cal-day-header {
                background: #111;
                color: #444;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                padding: 10px 8px;
                text-align: center;
                height: 36px !important;
                border-bottom: 1px solid rgba(255,255,255,0.05);
        }

            /* Day cells: equal height, fill remaining space */
        .cal-day {
                padding: 8px;
                height: 120px !important;        /* consistent row height */
                vertical-align: top;
                border: 1px solid rgba(255,255,255,0.04);
                color: #555;
                font-size: 13px;
                font-weight: 600;
                width: 14.28% !important;
        }
        .cal-day:hover { background: rgba(245,195,0,0.04); }

            /* Today */
         .cal-today {
                background: rgba(245,195,0,0.07);
                border: 1px solid rgba(245,195,0,0.2) !important;
                color: #F5C300 !important;
                font-weight: 700;
         }

            /* Selected */
         .cal-selected {
                background: rgba(245,195,0,0.15) !important;
                color: #F5C300 !important;
         }

            /* Other-month & weekend */
        .cal-other-month { color: #2a2a2a; background: rgba(0,0,0,0.2); }
         .cal-weekend  { color: #666; }
        /* Selected day */
        .cal-selected {
            background: rgba(245,195,0,0.15) !important;
            color: #F5C300 !important;
        }
        .ht: 120px !important;
        }
        /* Other month days */
        .cal-other-month { color: #2a2a2a; background: rgba(0,0,0,0.2); }

        /* Weekend */
        .cal-weekend { color: #666; }

        /* Trip count badge inside day */
        .trip-count {
            display: inline-block;
            background: #F5C300; color: #111;
            border-radius: 50px; font-size: 10px;
            font-weight: 700; padding: 1px 7px;
            margin-top: 4px;
        }

        /* ── SELECTED DAY TRIPS LIST ─────────────────── */
        .trips-panel {
            margin-top: 1.5rem;
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.5rem;
        }
        .trips-panel-title {
            font-size: 15px; font-weight: 700; color: #fff;
            margin-bottom: 1rem;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .trips-panel-title span { color: #F5C300; }

        /* Trip row */
        .trip-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .trip-row:last-child { border-bottom: none; }
        .trip-row-left { display: flex; align-items: center; gap: 12px; }
        .trip-avatar {
            width: 34px; height: 34px; background: #F5C300;
            border-radius: 8px; display: flex; align-items: center;
            justify-content: center; font-weight: 700; color: #111; font-size: 13px;
        }
        .trip-client { font-size: 13px; font-weight: 600; color: #fff; }
        .trip-route  { font-size: 11px; color: #555; margin-top: 2px; }
        .trip-time   { font-size: 12px; color: #F5C300; font-weight: 600; }

        .badge { padding: 3px 10px; border-radius: 50px; font-size: 10px; font-weight: 600; }
        .badge-pending   { background: rgba(245,195,0,0.1);  color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-active    { background: rgba(34,197,94,0.1);  color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-completed { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-cancelled { background: rgba(255,80,80,0.1);  color: #f87171; border: 1px solid rgba(255,80,80,0.3); }

        .btn-edit-trip {
            background: transparent; border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 6px; padding: 5px 12px;
            font-size: 11px; font-weight: 600; cursor: pointer;
            font-family: 'Inter', sans-serif; transition: background .2s;
        }
        .btn-edit-trip:hover { background: rgba(245,195,0,0.08); }

        .empty-state { text-align: center; padding: 2rem; color: #333; font-size: 13px; }
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

        <!-- HEADER -->
        <div class="page-header">
            <h1>Trip <span>Calendar</span></h1>
            <asp:Button ID="btnBack" runat="server" Text="← Back to Bookings"
                CssClass="btn-back" OnClick="btnBack_Click" CausesValidation="false" />
        </div>

        <!-- ASP CALENDAR -->
        <div class="cal-wrap">
            <asp:Calendar ID="calTrips" runat="server"
                Width="100%"
                CssClass="cal-table"
                TitleStyle-CssClass="cal-title"
                NextPrevStyle-CssClass="cal-prev-next"
                DayHeaderStyle-CssClass="cal-day-header"
                DayStyle-CssClass="cal-day"
                TodayDayStyle-CssClass="cal-today"
                SelectedDayStyle-CssClass="cal-selected"
                OtherMonthDayStyle-CssClass="cal-other-month"
                WeekendDayStyle-CssClass="cal-weekend"
                ShowGridLines="true"
                OnDayRender="calTrips_DayRender"
                OnSelectionChanged="calTrips_SelectionChanged"
                SelectionMode="Day" />
        </div>

        <!-- TRIPS FOR SELECTED DAY -->
        <asp:Panel ID="pnlTrips" runat="server" CssClass="trips-panel" Visible="false">
            <div class="trips-panel-title">
                Trips on <span><asp:Label ID="lblSelectedDate" runat="server" /></span>
            </div>
            <asp:Panel ID="pnlTripsList" runat="server" />
        </asp:Panel>

    </div>

</form>
</body>
</html>
