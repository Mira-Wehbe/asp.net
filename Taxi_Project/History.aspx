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

        /* NAVBAR */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0;
            height: 60px; background: #1a1a1a;
            border-bottom: 1px solid rgba(245,195,0,0.15);
            display: flex; align-items: center;
            justify-content: space-between;
            padding: 0 2rem; z-index: 1000;
        }
        .logo-badge { background: #F5C300; border-radius: 8px; padding: 5px 12px; display: flex; align-items: center; gap: 6px; }
        .logo-badge span { font-family: 'Bebas Neue', sans-serif; font-size: 18px; color: #111; letter-spacing: 2px; }
        .logo-sep { width: 2px; height: 18px; background: #111; opacity: 0.3; }
        .nav-links { display: flex; gap: 2rem; }
        .nav-links a { font-size: 13px; color: #555; text-decoration: none; font-weight: 500; }
        .nav-links a.active { color: #F5C300; }
        .nav-user { display: flex; align-items: center; gap: 10px; }
        .btn-logout { background: transparent; border: 1px solid rgba(245,195,0,0.3); color: #F5C300; border-radius: 8px; padding: 6px 14px; font-size: 12px; cursor: pointer; }

        /* PAGE */
        .page { margin-top: 80px; padding: 2rem; max-width: 900px; margin-left: auto; margin-right: auto; }
        .page-title { font-size: 28px; font-weight: 700; margin-bottom: 4px; }
        .page-title span { color: #F5C300; }
        .page-sub { font-size: 14px; color: #555; margin-bottom: 2rem; }

        /* FILTER TABS */
        .filter-tabs { display: flex; gap: 8px; margin-bottom: 2rem; flex-wrap: wrap; }
        .filter-tab {
            height: 36px; padding: 0 18px;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 50px; background: #1a1a1a;
            color: #555; font-size: 13px; font-weight: 500;
            cursor: pointer;
        }
        .filter-tab.active { background: #F5C300; color: #111; border-color: #F5C300; font-weight: 700; }
        .filter-tab:hover { border-color: #F5C300; color: #F5C300; }

        /* TRIP CARD */
        .trip-card {
            background: #1a1a1a;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 18px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }
        .trip-card:hover { border-color: rgba(245,195,0,0.2); }

        .trip-left { display: flex; flex-direction: column; gap: 10px; flex: 1; }
        .trip-route { display: flex; align-items: center; gap: 10px; }
        .trip-from { font-size: 15px; font-weight: 600; color: #fff; }
        .trip-arrow { color: #F5C300; font-size: 18px; }
        .trip-to { font-size: 15px; font-weight: 600; color: #fff; }
        .trip-meta { display: flex; gap: 1.5rem; }
        .trip-meta-item { font-size: 12px; color: #555; display: flex; align-items: center; gap: 5px; }
        .trip-meta-item span { color: #888; }

        /* STATUS BADGES */
        .badge {
            padding: 5px 14px; border-radius: 50px;
            font-size: 12px; font-weight: 600;
            letter-spacing: 0.5px; white-space: nowrap;
        }
        .badge-pending { background: rgba(245,195,0,0.1); color: #F5C300; border: 1px solid rgba(245,195,0,0.3); }
        .badge-active { background: rgba(59,130,246,0.1); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .badge-completed { background: rgba(34,197,94,0.1); color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
        .badge-cancelled { background: rgba(239,68,68,0.1); color: #f87171; border: 1px solid rgba(239,68,68,0.3); }

        /* TRIP RIGHT */
        .trip-right { display: flex; flex-direction: column; align-items: flex-end; gap: 10px; }
        .trip-price { font-family: 'Bebas Neue', sans-serif; font-size: 26px; color: #F5C300; letter-spacing: 1px; }

        /* ACTION BUTTONS */
        .btn-cancel {
            background: transparent;
            border: 1px solid rgba(239,68,68,0.4);
            color: #f87171; border-radius: 8px;
            padding: 7px 16px; font-size: 13px;
            cursor: pointer; font-weight: 500;
        }
        .btn-cancel:hover { background: rgba(239,68,68,0.1); }

        .btn-feedback {
            background: #F5C300; color: #111;
            border: none; border-radius: 8px;
            padding: 7px 16px; font-size: 13px;
            cursor: pointer; font-weight: 600;
        }
        .btn-feedback:hover { background: #ffd000; }

        /* FEEDBACK MODAL */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.8);
            display: none; align-items: center;
            justify-content: center; z-index: 2000;
        }
        .modal-overlay.show { display: flex; }
        .modal {
            background: #1a1a1a;
            border: 1px solid rgba(245,195,0,0.15);
            border-radius: 20px; padding: 2rem;
            width: 400px;
        }
        .modal-title { font-size: 20px; font-weight: 700; margin-bottom: 4px; }
        .modal-title span { color: #F5C300; }
        .modal-sub { font-size: 13px; color: #555; margin-bottom: 1.5rem; }
        .stars { display: flex; gap: 8px; margin-bottom: 1.2rem; }
        .star { font-size: 28px; cursor: pointer; filter: grayscale(1); transition: filter 0.2s; }
        .star.active { filter: grayscale(0); }
        .modal textarea {
            width: 100%; height: 100px;
            background: #111; border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 12px; padding: 12px 16px;
            font-size: 14px; color: #fff; outline: none;
            resize: none; font-family: 'Inter', sans-serif;
        }
        .modal textarea::placeholder { color: #444; }
        .modal textarea:focus { border-color: #F5C300; }
        .modal-actions { display: flex; gap: 10px; margin-top: 1rem; }
        .btn-submit-feedback {
            flex: 1; height: 46px;
            background: #F5C300; color: #111;
            border: none; border-radius: 10px;
            font-size: 14px; font-weight: 700; cursor: pointer;
        }
        .btn-close-modal {
            height: 46px; padding: 0 20px;
            background: transparent;
            border: 1px solid rgba(255,255,255,0.1);
            color: #555; border-radius: 10px;
            font-size: 14px; cursor: pointer;
        }

        /* EMPTY STATE */
        .empty {
            text-align: center; padding: 4rem 2rem;
            color: #333;
        }
        .empty-icon { font-size: 48px; margin-bottom: 1rem; }
        .empty-text { font-size: 16px; color: #444; }
    </style>
</head>
<body>

<form id="form1" runat="server">

    <!-- NAVBAR -->
    <div class="navbar">
        <div class="logo-badge">
            <span>YALLA</span>
            <div class="logo-sep"></div>
            <span>TAXI</span>
        </div>
        <div class="nav-links">
            <a href="Reserve.aspx">Reserve</a>
            <a href="History.aspx" class="active">My Trips</a>
        </div>
        <div class="nav-user">
            <%-- ID: lblUserName | USE: lblUserName.Text --%>
            <asp:Label ID="lblUserName" runat="server" Style="font-size:13px; color:#555;" />
            <%-- ID: btnLogout | USE: btnLogout_Click --%>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>
    </div>

    <div class="page">

        <p class="page-title">My <span>Trips</span></p>
        <p class="page-sub">Track all your reservations</p>

        <!-- FILTER TABS -->
        <div class="filter-tabs">
            <button type="button" class="filter-tab active" onclick="filterTrips('all')">All</button>
            <button type="button" class="filter-tab" onclick="filterTrips('Pending')">⏳ Pending</button>
            <button type="button" class="filter-tab" onclick="filterTrips('Active')">🚕 Active</button>
            <button type="button" class="filter-tab" onclick="filterTrips('Completed')">✅ Completed</button>
            <button type="button" class="filter-tab" onclick="filterTrips('Cancelled')">❌ Cancelled</button>
        </div>

        <!-- TRIP CARDS CONTAINER -->
        <%-- ID: pnlTrips | USE: pnlTrips to add cards dynamically --%>
         <asp:Panel ID="pnlTrips" runat="server">

        <!-- Empty state (backend will hide this when trips exist) -->
                <div class="empty" id="emptyState">
                    <div class="empty-icon">🚕</div>
                    <p class="empty-text">No trips yet. <a href="Reserve.aspx" style="color:#F5C300;">Book your first ride!</a></p>
                </div>

    </asp:Panel>
    </div>

    <!-- FEEDBACK MODAL -->
    <div class="modal-overlay" id="feedbackModal">
        <div class="modal">
            <p class="modal-title">Leave <span>Feedback</span></p>
            <p class="modal-sub">How was your ride?</p>
            <div class="stars">
                <span class="star" onclick="setRating(1)">⭐</span>
                <span class="star" onclick="setRating(2)">⭐</span>
                <span class="star" onclick="setRating(3)">⭐</span>
                <span class="star" onclick="setRating(4)">⭐</span>
                <span class="star" onclick="setRating(5)">⭐</span>
            </div>
            <%-- ID: txtComment | USE: txtComment.Text --%>
            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" placeholder="Tell us about your experience..." />
            <%-- ID: hdnRating | USE: hdnRating.Value --%>
            <asp:HiddenField ID="hdnRating" runat="server" />
            <%-- ID: hdnTripID | USE: hdnTripID.Value --%>
            <asp:HiddenField ID="hdnTripID" runat="server" />
            <div class="modal-actions">
                <%-- ID: btnSubmitFeedback | USE: btnSubmitFeedback_Click --%>
                <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Feedback" CssClass="btn-submit-feedback" OnClick="btnSubmitFeedback_Click" />
                <button type="button" class="btn-close-modal" onclick="closeFeedback()">Cancel</button>
            </div>
        </div>
    </div>

</form>

<script>
    // Filter trips by status
    function filterTrips(status) {
        const cards = document.querySelectorAll('.trip-card');
        const tabs = document.querySelectorAll('.filter-tab');

        tabs.forEach(t => t.classList.remove('active'));
        event.target.classList.add('active');

        cards.forEach(card => {
            if (status === 'all' || card.dataset.status === status)
                card.style.display = 'flex';
            else
                card.style.display = 'none';
        });
    }

    // Open feedback modal
    function openFeedback(btn) {
        document.getElementById('feedbackModal').classList.add('show');
    }

    // Close feedback modal
    function closeFeedback() {
        document.getElementById('feedbackModal').classList.remove('show');
    }

    // Star rating
    let currentRating = 0;
    function setRating(rating) {
        currentRating = rating;
        document.getElementById('<%= hdnRating.ClientID %>').value = rating;
        const stars = document.querySelectorAll('.star');
        stars.forEach((s, i) => {
            s.classList.toggle('active', i < rating);
        });
    }
</script>

</body>
</html>