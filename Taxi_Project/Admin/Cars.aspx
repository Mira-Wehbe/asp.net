<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cars.aspx.cs" Inherits="Taxi_Project.Admin.Cars" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Cars</title>
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

        /* ── ADD CAR BUTTON ──────────────────────────── */
        .btn-add {
            height: 42px; padding: 0 20px;
            background: #F5C300; border: none; border-radius: 10px;
            color: #111; font-size: 13px; font-weight: 700;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: background .2s;
        }
        .btn-add:hover { background: #ffd500; }

        /* ── FILTER BAR ──────────────────────────────── */
        .filter-bar {
            display: flex; gap: 8px; margin-bottom: 1.5rem;
        }
        .filter-btn {
            height: 36px; padding: 0 16px;
            background: #1a1a1a; border: 1px solid rgba(255,255,255,0.07);
            border-radius: 8px; color: #555; font-size: 13px;
            font-family: 'Inter', sans-serif; cursor: pointer;
            transition: all .2s; font-weight: 500;
        }
        .filter-btn:hover { border-color: rgba(245,195,0,0.3); color: #fff; }
        .filter-btn.active { background: rgba(245,195,0,0.1); border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* ── CARS GRID ───────────────────────────────── */
        .cars-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.2rem;
        }

        /* ── CAR CARD ────────────────────────────────── */
        .car-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px; padding: 1.4rem;
            display: flex; flex-direction: column; gap: 14px;
            transition: border-color .2s, transform .2s;
        }
        .car-card:hover { border-color: rgba(245,195,0,0.25); transform: translateY(-2px); }

        .car-card-top { display: flex; justify-content: space-between; align-items: flex-start; }
        .car-icon { font-size: 32px; }
        .badge { padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 600; }
        .badge-active    { background: rgba(34,197,94,0.1);  color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-inactive  { background: rgba(255,80,80,0.1);  color: #f87171; border: 1px solid rgba(255,80,80,0.3); }
        .badge-standard  { background: rgba(245,195,0,0.1);  color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-business  { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-van       { background: rgba(168,85,247,0.1); color: #c084fc; border: 1px solid rgba(168,85,247,0.3); }

        .car-model { font-size: 17px; font-weight: 700; color: #fff; }
        .car-plate { font-size: 12px; color: #555; margin-top: 2px; }

        .car-details { display: flex; flex-direction: column; gap: 6px; }
        .car-detail-row { display: flex; justify-content: space-between; align-items: center; }
        .car-detail-label { font-size: 12px; color: #444; }
        .car-detail-value { font-size: 12px; color: #aaa; font-weight: 500; }
        .car-detail-value.yellow { color: #F5C300; font-weight: 700; }

        .car-divider { height: 1px; background: rgba(255,255,255,0.05); }

        .car-actions { display: flex; gap: 8px; }
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

        /* ── ERROR / SUCCESS ─────────────────────────── */
        .msg-box { border-radius: 10px; padding: 10px 14px; font-size: 13px; display: block; }
        .msg-error   { background: #1e1010; border: 1px solid rgba(255,80,80,0.3); color: #ff6b6b; }
        .msg-success { background: #0f1e10; border: 1px solid rgba(34,197,94,0.3); color: #4ade80; }

        /* ── EMPTY STATE ─────────────────────────────── */
        .empty-state {
            grid-column: 1 / -1; text-align: center;
            padding: 4rem 2rem; color: #333;
        }
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
        <a href="Cars.aspx"       class="nav-item active"><span class="nav-icon">🚗</span> Cars</a>
        <a href="Drivers.aspx"    class="nav-item"><span class="nav-icon">👨‍✈️</span> Drivers</a>
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
                <h1>Fleet <span>Cars</span></h1>
                <p>Manage all cars in the system</p>
            </div>
            <asp:Button ID="btnAddCar" runat="server" Text="+ Add Car"
                CssClass="btn-add" OnClick="btnAddCar_Click" CausesValidation="false" />
        </div>

        <!-- MESSAGES -->
        <asp:Label ID="lblError"   runat="server" Visible="false" CssClass="msg-box msg-error"   style="margin-bottom:1rem;" />
        <asp:Label ID="lblSuccess" runat="server" Visible="false" CssClass="msg-box msg-success" style="margin-bottom:1rem;" />

        <!-- FILTER BAR -->
        <div class="filter-bar">
            <asp:Button ID="btnFilterAll"      runat="server" Text="All"      CssClass="filter-btn active" OnClick="btnFilter_Click" CommandArgument="All"      CausesValidation="false" />
            <asp:Button ID="btnFilterStandard" runat="server" Text="Standard" CssClass="filter-btn"        OnClick="btnFilter_Click" CommandArgument="Standard" CausesValidation="false" />
            <asp:Button ID="btnFilterBusiness" runat="server" Text="Business" CssClass="filter-btn"        OnClick="btnFilter_Click" CommandArgument="Business" CausesValidation="false" />
            <asp:Button ID="btnFilterVan"      runat="server" Text="Van"      CssClass="filter-btn"        OnClick="btnFilter_Click" CommandArgument="Van"      CausesValidation="false" />
        </div>

        <!-- CARS GRID — filled by C# -->
        <div class="cars-grid">
            <asp:Panel ID="pnlCars" runat="server" />
        </div>

        <!-- HIDDEN FIELDS for edit modal -->
        <asp:HiddenField ID="hdnEditCarID"    runat="server" />
        <asp:HiddenField ID="hdnModalOpen"    runat="server" Value="0" />

    </div>

    <!-- ADD / EDIT MODAL -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal">
            <div class="modal-title"><asp:Label ID="lblModalTitle" runat="server" Text="Add New " /><span>Car</span></div>

            <div class="modal-field">
                <div class="modal-label">Plate Number</div>
                <asp:TextBox ID="txtPlate" runat="server" CssClass="modal-input" placeholder="e.g. ABC 123" />
            </div>

            <div class="modal-field">
                <div class="modal-label">Model</div>
                <asp:TextBox ID="txtModel" runat="server" CssClass="modal-input" placeholder="e.g. Toyota Corolla" />
            </div>

            <div class="modal-field">
                <div class="modal-label">Car Type</div>
                <asp:DropDownList ID="ddlCarType" runat="server" CssClass="modal-select">
                    <asp:ListItem Value="Standard">Standard</asp:ListItem>
                    <asp:ListItem Value="Business">Business</asp:ListItem>
                    <asp:ListItem Value="Van">Van</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="modal-field">
                <div class="modal-label">Seats</div>
                <asp:TextBox ID="txtSeats" runat="server" CssClass="modal-input" placeholder="e.g. 4" TextMode="Number" />
            </div>

            <div class="modal-field">
                <div class="modal-label">Rate Per KM ($)</div>
                <asp:TextBox ID="txtRate" runat="server" CssClass="modal-input" placeholder="e.g. 2.50" />
            </div>

            <div class="modal-actions">
                <asp:Button ID="btnSaveCar"    runat="server" Text="Save Car"  CssClass="btn-save"         OnClick="btnSaveCar_Click" />
                <asp:Button ID="btnCancelModal" runat="server" Text="Cancel"   CssClass="btn-cancel-modal" OnClick="btnCancelModal_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

</form>

<script>
    // Open modal if C# flagged it
    window.onload = function () {
        var flag = document.getElementById('<%= hdnModalOpen.ClientID %>').value;
        if (flag === '1') {
            document.getElementById('modalOverlay').classList.add('open');
        }
    };
</script>

</body>
</html>
