<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Drivers.aspx.cs" Inherits="Taxi_Project.Admin.Drivers" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Drivers</title>
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
        .main { margin-left: 240px; flex: 1; padding: 2.5rem; min-height: 100vh; }

        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header-left h1 { font-size: 26px; font-weight: 700; }
        .page-header-left h1 span { color: #F5C300; }
        .page-header-left p { font-size: 14px; color: #555; margin-top: 4px; }

        .btn-add {
            height: 42px; padding: 0 20px;
            background: #F5C300; border: none; border-radius: 10px;
            color: #111; font-size: 13px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer; transition: background .2s;
        }
        .btn-add:hover { background: #ffd500; }

        /* ── FILTER BAR ──────────────────────────────── */
        .filter-bar { display: flex; gap: 8px; margin-bottom: 1.5rem; }
        .filter-btn {
            height: 36px; padding: 0 16px;
            background: #1a1a1a; border: 1px solid rgba(255,255,255,0.07);
            border-radius: 8px; color: #555; font-size: 13px;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: all .2s; font-weight: 500;
        }
        .filter-btn:hover { border-color: rgba(245,195,0,0.3); color: #fff; }
        .filter-btn.active { background: rgba(245,195,0,0.1); border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* ── DRIVERS GRID ────────────────────────────── */
        .drivers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.2rem;
        }

        /* ── DRIVER CARD ─────────────────────────────── */
        .driver-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.4rem;
            display: flex; flex-direction: column; gap: 14px;
            transition: border-color .2s, transform .2s;
        }
        .driver-card:hover { border-color: rgba(245,195,0,0.25); transform: translateY(-2px); }

        .driver-card-top { display: flex; justify-content: space-between; align-items: flex-start; }
        .driver-avatar {
            width: 48px; height: 48px; background: #111;
            border-radius: 50%; display: flex; align-items: center;
            justify-content: center; font-size: 22px;
            border: 2px solid rgba(245,195,0,0.2);
        }
        .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; }
        .badge-available { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-busy      { background: rgba(245,195,0,0.1);  color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }

        .driver-name  { font-size: 17px; font-weight: 700; color: #fff; }
        .driver-phone { font-size: 12px; color: #555; margin-top: 2px; }

        .driver-details { display: flex; flex-direction: column; gap: 6px; }
        .detail-row { display: flex; justify-content: space-between; align-items: center; }
        .detail-label { font-size: 12px; color: #444; }
        .detail-value { font-size: 12px; color: #aaa; font-weight: 500; }
        .detail-value.yellow { color: #F5C300; font-weight: 700; }

        .driver-divider { height: 1px; background: rgba(255,255,255,0.05); }

        .driver-actions { display: flex; gap: 8px; }
        .btn-edit {
            flex: 1; height: 36px;
            background: transparent; border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 8px; font-size: 12px;
            font-family: 'Inter', sans-serif; cursor: pointer; font-weight: 600;
            transition: background .2s;
        }
        .btn-edit:hover { background: rgba(245,195,0,0.08); }
        .btn-toggle {
            flex: 1; height: 36px;
            background: transparent; border: 1px solid rgba(255,255,255,0.07);
            color: #555; border-radius: 8px; font-size: 12px;
            font-family: 'Inter', sans-serif; cursor: pointer; font-weight: 600;
            transition: all .2s;
        }
        .btn-toggle:hover { border-color: rgba(255,80,80,0.3); color: #f87171; }

        /* ── MODAL ───────────────────────────────────── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.7); z-index: 500;
            align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: #1a1a1a; border: 1px solid rgba(245,195,0,0.15);
            border-radius: 20px; padding: 2rem; width: 420px;
            display: flex; flex-direction: column; gap: 1.2rem;
        }
        .modal-title { font-size: 18px; font-weight: 700; }
        .modal-title span { color: #F5C300; }
        .modal-field { display: flex; flex-direction: column; gap: 6px; }
        .modal-label { font-size: 11px; color: #444; text-transform: uppercase; letter-spacing: 1.5px; font-weight: 700; }
        .modal-input {
            height: 44px; background: #111; border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 10px; padding: 0 14px; color: #fff; font-size: 13px;
            font-family: 'Inter', sans-serif; outline: none; transition: border-color .2s;
        }
        .modal-input:focus { border-color: #F5C300; }
        .modal-select {
            height: 44px; background: #111; border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 10px; padding: 0 14px; color: #fff; font-size: 13px;
            font-family: 'Inter', sans-serif; outline: none; appearance: none;
        }
        .modal-select option { background: #1a1a1a; }
        .modal-actions { display: flex; gap: 10px; margin-top: 4px; }
        .btn-save {
            flex: 1; height: 44px; background: #F5C300; border: none;
            border-radius: 10px; color: #111; font-size: 14px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer; transition: background .2s;
        }
        .btn-save:hover { background: #ffd500; }
        .btn-cancel-modal {
            flex: 1; height: 44px; background: transparent;
            border: 1px solid rgba(255,255,255,0.1); border-radius: 10px;
            color: #555; font-size: 14px; font-family: 'Inter', sans-serif;
            cursor: pointer; transition: all .2s;
        }
        .btn-cancel-modal:hover { border-color: rgba(255,80,80,0.3); color: #f87171; }

        /* ── MESSAGES ────────────────────────────────── */
        .msg-box     { border-radius: 10px; padding: 10px 14px; font-size: 13px; display: block; }
        .msg-error   { background: #1e1010; border: 1px solid rgba(255,80,80,0.3);   color: #ff6b6b; }
        .msg-success { background: #0f1e10; border: 1px solid rgba(34,197,94,0.3);   color: #4ade80; }

        /* ── EMPTY STATE ─────────────────────────────── */
        .empty-state { grid-column: 1 / -1; text-align: center; padding: 4rem 2rem; color: #333; }
        .empty-state span { font-size: 48px; display: block; margin-bottom: 1rem; }
        .empty-state p { font-size: 14px; }
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
        <a href="Calendar.aspx"   class="nav-item"><span class="nav-icon">📅</span> Calendar</a>
        <a href="AIInsights.aspx" class="nav-item"><span class="nav-icon">🤖</span> AI Insights</a>
        <a href="Cars.aspx"       class="nav-item"><span class="nav-icon">🚗</span> Cars</a>
        <a href="Drivers.aspx"    class="nav-item active"><span class="nav-icon">👨‍✈️</span> Drivers</a>
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
            <div class="page-header-left">
                <h1>Fleet <span>Drivers</span></h1>
                <p>Manage all drivers in the system</p>
            </div>
            <asp:Button ID="btnAddDriver" runat="server" Text="+ Add Driver"
                CssClass="btn-add" OnClick="btnAddDriver_Click" CausesValidation="false" />
        </div>

        <!-- MESSAGES -->
        <asp:Label ID="lblError"   runat="server" Visible="false" CssClass="msg-box msg-error"   style="margin-bottom:1rem;" />
        <asp:Label ID="lblSuccess" runat="server" Visible="false" CssClass="msg-box msg-success" style="margin-bottom:1rem;" />

        <!-- FILTER BAR -->
        <div class="filter-bar">
            <asp:Button ID="btnFilterAll"       runat="server" Text="All"       CssClass="filter-btn active" OnClick="btnFilter_Click" CommandArgument="All"       CausesValidation="false" />
            <asp:Button ID="btnFilterAvailable" runat="server" Text="Available" CssClass="filter-btn"        OnClick="btnFilter_Click" CommandArgument="Available" CausesValidation="false" />
            <asp:Button ID="btnFilterBusy"      runat="server" Text="Busy"      CssClass="filter-btn"        OnClick="btnFilter_Click" CommandArgument="Busy"      CausesValidation="false" />
        </div>

        <!-- DRIVERS GRID — filled by C# -->
        <div class="drivers-grid">
            <asp:Panel ID="pnlDrivers" runat="server" />
        </div>

        <!-- HIDDEN FIELDS -->
        <asp:HiddenField ID="hdnEditDriverID" runat="server" />
        <asp:HiddenField ID="hdnModalOpen"    runat="server" Value="0" />

    </div>

    <!-- ADD / EDIT MODAL -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal">
            <div class="modal-title"><asp:Label ID="lblModalTitle" runat="server" Text="Add New " /><span>Driver</span></div>

            <div class="modal-field">
                <div class="modal-label">Full Name</div>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="modal-input" placeholder="e.g. John Doe" />
            </div>

            <div class="modal-field">
                <div class="modal-label">Phone</div>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="modal-input" placeholder="e.g. 70123456" />
            </div>

            <div class="modal-field">
                <div class="modal-label">Assign Car</div>
                <asp:DropDownList ID="ddlCar" runat="server" CssClass="modal-select" />
            </div>

            <div class="modal-actions">
                <asp:Button ID="btnSaveDriver"   runat="server" Text="Save Driver" CssClass="btn-save"         OnClick="btnSaveDriver_Click" />
                <asp:Button ID="btnCancelModal"  runat="server" Text="Cancel"      CssClass="btn-cancel-modal" OnClick="btnCancelModal_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

</form>

<script>
    window.onload = function () {
        var flag = document.getElementById('<%= hdnModalOpen.ClientID %>').value;
        if (flag === '1') {
            document.getElementById('modalOverlay').classList.add('open');
        }
    };
</script>

</body>
</html>
