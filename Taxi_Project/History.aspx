<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="Taxi_Project.History" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – My Trips</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }

        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 60px;
            background: #1a1a1a;
            border-bottom: 1px solid rgba(245,195,0,0.15);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            z-index: 1000;
        }

        .logo-badge {
            background: #F5C300;
            border-radius: 8px;
            padding: 5px 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .logo-badge span {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 18px;
            color: #111;
            letter-spacing: 2px;
        }

        .logo-sep {
            width: 2px;
            height: 18px;
            background: #111;
            opacity: 0.3;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            font-size: 13px;
            color: #555;
            text-decoration: none;
            font-weight: 500;
        }

        .nav-links a.active {
            color: #F5C300;
        }

        .btn-logout {
            background: transparent;
            border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300;
            border-radius: 8px;
            padding: 6px 14px;
            font-size: 12px;
            cursor: pointer;
        }

        .page {
            margin-top: 80px;
            padding: 2rem;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
        }

        .page-title span {
            color: #F5C300;
        }

        .page-sub {
            font-size: 14px;
            color: #555;
            margin-bottom: 2rem;
        }

        .filter-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .filter-tabs input[type=submit] {
            height: 36px;
            padding: 0 18px;
            border-radius: 50px;
            border: 1px solid rgba(255,255,255,0.07);
            background: #1a1a1a;
            color: #555;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
        }

        .filter-tabs input[type=submit].active {
            background: #F5C300;
            color: #111;
            border-color: #F5C300;
            font-weight: 700;
        }

        .trip-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 18px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
        }

        .badge {
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-pending { color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-active { color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-completed { color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-cancelled { color: #f87171; border: 1px solid rgba(239,68,68,0.3); }

        .trip-price {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 26px;
            color: #F5C300;
        }

        .btn-feedback {
            background: #F5C300;
            color: #111;
            border: none;
            border-radius: 8px;
            padding: 7px 16px;
            font-size: 13px;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-cancel {
            background: transparent;
            border: 1px solid rgba(239,68,68,0.4);
            color: #f87171;
            border-radius: 8px;
            padding: 7px 16px;
            font-size: 13px;
            cursor: pointer;
        }

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.8);
            display: none;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show { display: flex; }

        .modal {
            background: #1a1a1a;
            padding: 2rem;
            border-radius: 20px;
            width: 400px;
        }

        .stars {
            display: flex;
            gap: 8px;
            margin-bottom: 1rem;
        }

        .star {
            font-size: 28px;
            cursor: pointer;
            filter: grayscale(1);
        }

        .star.active {
            filter: grayscale(0);
        }

        textarea {
            width: 100%;
            height: 100px;
            background: #111;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 12px;
            padding: 10px;
            color: #fff;
            resize: none;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="navbar">

        <div class="logo-badge">
            <span>YALLA</span>
            <div class="logo-sep"></div>
            <span>TAXI</span>
        </div>

        <div class="nav-links">
            <asp:LinkButton ID="lnkReserve" runat="server" CssClass="nav-links a" OnClick="lnkReserve_Click">Reserve</asp:LinkButton>
            <a class="active" href="History.aspx">My Trips</a>
        </div>

        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />

    </div>

    <div class="page">

        <p class="page-title">My <span>Trips</span></p>
        <p class="page-sub">Track all your reservations</p>

        <div class="filter-tabs">

            <asp:Button ID="btnAll" runat="server" Text="All" CssClass="active" OnClick="btnAll_Click" />
            <asp:Button ID="btnPending" runat="server" Text="Pending" OnClick="btnPending_Click" />
            <asp:Button ID="btnActive" runat="server" Text="Active" OnClick="btnActive_Click" />
            <asp:Button ID="btnCompleted" runat="server" Text="Completed" OnClick="btnCompleted_Click" />
            <asp:Button ID="btnCancelled" runat="server" Text="Cancelled" OnClick="btnCancelled_Click" />

        </div>

        <asp:Panel ID="pnlTrips" runat="server"></asp:Panel>

    </div>

    <div class="modal-overlay" id="feedbackModal">

        <div class="modal">

            <p>Leave Feedback</p>

            <div class="stars">
                <span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span>
            </div>

            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" />

            <asp:HiddenField ID="hdnRating" runat="server" />
            <asp:HiddenField ID="hdnTripID" runat="server" />

            <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit" OnClick="btnSubmitFeedback_Click" />

            <button type="button" onclick="document.getElementById('feedbackModal').classList.remove('show')">
                Close
            </button>

        </div>

    </div>

</form>

</body>
</html>