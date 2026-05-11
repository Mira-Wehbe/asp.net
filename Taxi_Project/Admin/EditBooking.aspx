<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditBooking.aspx.cs" Inherits="Taxi_Project.Admin.EditBooking" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Edit Booking</title>
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
        .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 2rem; }
        .page-header h1 { font-size: 30px; font-weight: 700; }
        .page-header h1 span { color: #F5C300; }
        .trip-id-badge {
            background: rgba(245,195,0,0.12);
            border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 8px;
            padding: 6px 16px; font-size: 14px; font-weight: 700;
        }

        /* ── MESSAGES ────────────────────────────────── */
        .msg-box     { border-radius: 10px; padding: 12px 16px; font-size: 13px; display: block; margin-bottom: 1.5rem; }
        .msg-error   { background: #1e1010; border: 1px solid rgba(255,80,80,0.3);  color: #ff6b6b; }
        .msg-success { background: #0f1e10; border: 1px solid rgba(34,197,94,0.3);  color: #4ade80; }

        /* ── FORM LAYOUT ─────────────────────────────── */
        .form-layout { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }

        .form-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.8rem;
        }
        .form-card.full { grid-column: 1 / -1; }

        .card-title {
            font-size: 13px; font-weight: 700; color: #F5C300;
            text-transform: uppercase; letter-spacing: 1.5px;
            margin-bottom: 1.4rem;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(245,195,0,0.1);
        }

        /* ── FIELD ───────────────────────────────────── */
        .field { display: flex; flex-direction: column; gap: 8px; margin-bottom: 1.2rem; }
        .field:last-child { margin-bottom: 0; }
        .field-label { font-size: 12px; font-weight: 600; color: #555; text-transform: uppercase; letter-spacing: 1px; }

        .field-value {
            font-size: 15px; color: #aaa;
            background: #111; border-radius: 10px;
            padding: 13px 16px;
            border: 1.5px solid rgba(255,255,255,0.05);
            display: block;
        }
        .field-input {
            width: 100%; height: 50px; background: #111;
            border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 10px; padding: 0 16px;
            color: #fff; font-size: 14px;
            font-family: 'Inter', sans-serif;
            outline: none; transition: border-color .2s;
        }
        .field-input:focus { border-color: #F5C300; }
        .field-select {
            width: 100%; height: 50px; background: #111;
            border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 10px; padding: 0 16px;
            color: #fff; font-size: 14px;
            font-family: 'Inter', sans-serif;
            outline: none; appearance: none;
            transition: border-color .2s;
        }
        .field-select:focus { border-color: #F5C300; }
        .field-select option { background: #1a1a1a; }

        /* ── ACTIONS ─────────────────────────────────── */
        .form-actions {
            grid-column: 1 / -1;
            display: flex; gap: 14px; margin-top: 0.5rem;
        }
        .btn-save {
            flex: 1; height: 52px; background: #F5C300;
            border: none; border-radius: 12px; color: #111;
            font-size: 15px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: background .2s;
        }
        .btn-save:hover { background: #ffd500; }
        .btn-back {
            height: 52px; padding: 0 28px; background: transparent;
            border: 1.5px solid rgba(255,255,255,0.1);
            border-radius: 12px; color: #555; font-size: 15px;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: all .2s;
        }
        .btn-back:hover { border-color: rgba(255,80,80,0.4); color: #f87171; }
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
            <h1>Edit <span>Booking</span></h1>
            <asp:Label ID="lblTripID" runat="server" CssClass="trip-id-badge" />
        </div>

        <!-- MESSAGES -->
        <asp:Label ID="lblError"   runat="server" Visible="false" CssClass="msg-box msg-error" />
        <asp:Label ID="lblSuccess" runat="server" Visible="false" CssClass="msg-box msg-success" />

        <!-- FORM GRID -->
        <div class="form-layout">

            <!-- LEFT: Trip Info -->
            <div class="form-card">
                <div class="card-title">📋 Trip Details</div>

                <div class="field">
                    <div class="field-label">Client</div>
                    <asp:Label ID="lblClient" runat="server" CssClass="field-value" />
                </div>

                <div class="field">
                    <div class="field-label">Pickup Location</div>
                    <asp:TextBox ID="txtPickup" runat="server" CssClass="field-input" />
                </div>

                <div class="field">
                    <div class="field-label">Dropoff Location</div>
                    <asp:TextBox ID="txtDropoff" runat="server" CssClass="field-input" />
                </div>

                <div class="field">
                    <div class="field-label">Pickup Time</div>
                    <asp:TextBox ID="txtPickupTime" runat="server" CssClass="field-input" TextMode="DateTimeLocal" />
                </div>
                <div class="field">
                    <div class="field-label">Client Prefers</div>
                    <asp:Label ID="lblGender" runat="server" CssClass="field-value" />
                </div>

                <div class="field">
                    <div class="field-label">Price ($)</div>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="field-input" />
                </div>
            </div>

            <!-- RIGHT: Assignment -->
            <div class="form-card">
                <div class="card-title">🚗 Assignment</div>

                <div class="field">
                    <div class="field-label">Car Type</div>
                    <asp:Label ID="lblCar" runat="server" CssClass="field-value" />
                </div>

                <div class="field">
                    <div class="field-label">Assigned Driver</div>
                    <asp:DropDownList ID="ddlDriver" runat="server" CssClass="field-select" />
                </div>

                <div class="field">
                    <div class="field-label">Status</div>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="field-select">
                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                        <asp:ListItem Value="Active">Active</asp:ListItem>
                        <asp:ListItem Value="Completed">Completed</asp:ListItem>
                        <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- ACTIONS -->
            <div class="form-actions">
                <asp:Button ID="btnSave" runat="server" Text="💾 Save Changes"
                    CssClass="btn-save" OnClick="btnSave_Click" />
                <asp:Button ID="btnBack" runat="server" Text="← Back to Bookings"
                    CssClass="btn-back" OnClick="btnBack_Click" CausesValidation="false" />
            </div>

        </div>
    </div>

</form>
</body>
</html>
