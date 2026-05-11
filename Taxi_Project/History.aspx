﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="Taxi_Project.History" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – My Trips</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }

        /* ── Navbar ── */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; height: 60px;
            background: #1a1a1a;
            border-bottom: 1px solid rgba(245,195,0,0.15);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem; z-index: 1000;
        }
        .logo-badge {
            background: #F5C300; border-radius: 8px; padding: 5px 12px;
            display: flex; align-items: center; gap: 6px;
        }
        .logo-badge span { font-family:'Bebas Neue',sans-serif; font-size:18px; color:#111; letter-spacing:2px; }
        .logo-sep { width:2px; height:18px; background:#111; opacity:0.3; }
        .nav-links { display:flex; gap:2rem; }
        .nav-links a { font-size:13px; color:#555; text-decoration:none; font-weight:500; }
        .nav-links a.active { color:#F5C300; }
        .btn-logout {
            background:transparent; border:1px solid rgba(245,195,0,0.3);
            color:#F5C300; border-radius:8px; padding:6px 14px; font-size:12px; cursor:pointer;
        }

        /* ── Page ── */
        .page { margin-top:80px; padding:2rem; max-width:900px; margin-left:auto; margin-right:auto; }
        .page-title { font-size:28px; font-weight:700; }
        .page-title span { color:#F5C300; }
        .page-sub { font-size:14px; color:#555; margin-bottom:2rem; }

        /* ── Filter tabs ── */
        .filter-tabs { display:flex; gap:8px; margin-bottom:2rem; flex-wrap:wrap; }

        /* FIX: use filter-btn as base, active overrides it */
        .filter-btn {
            height:36px; padding:0 18px; border-radius:50px;
            border:1px solid rgba(255,255,255,0.07);
            background:#1a1a1a; color:#555;
            font-size:13px; font-weight:500; cursor:pointer;
        }
        .filter-btn.active {
            background:#F5C300 !important;
            color:#111 !important;
            border-color:#F5C300 !important;
            font-weight:700 !important;
        }

        /* ── Trip card ── */
        .trip-card {
            background:#1a1a1a; border:1px solid rgba(255,255,255,0.07);
            border-radius:18px; padding:1.5rem; margin-bottom:1rem;
            display:flex; justify-content:space-between;
        }
        .badge { padding:5px 14px; border-radius:50px; font-size:12px; font-weight:600; }
        .badge-pending   { color:#F5C300; border:1px solid rgba(245,195,0,0.3); }
        .badge-active    { color:#60a5fa; border:1px solid rgba(59,130,246,0.3); }
        .badge-completed { color:#4ade80; border:1px solid rgba(34,197,94,0.3); }
        .badge-cancelled { color:#f87171; border:1px solid rgba(239,68,68,0.3); }

        .trip-price { font-family:'Bebas Neue',sans-serif; font-size:26px; color:#F5C300; }

        .btn-feedback {
            background:#F5C300; color:#111; border:none; border-radius:8px;
            padding:7px 16px; font-size:13px; cursor:pointer; font-weight:600;
        }
        .btn-cancel {
            background:transparent; border:1px solid rgba(239,68,68,0.4);
            color:#f87171; border-radius:8px; padding:7px 16px; font-size:13px; cursor:pointer;
        }

        /* ── Modal ── */
        .modal-overlay {
            position:fixed; inset:0; background:rgba(0,0,0,0.8);
            display:none; align-items:center; justify-content:center; z-index:2000;
        }
        .modal-overlay.show { display:flex; }
        .modal { background:#1a1a1a; padding:2rem; border-radius:20px; width:420px; }
        .modal h3 { margin-bottom:1.2rem; font-size:18px; }

        /* ── Stars ── */
        .stars { display:flex; gap:6px; margin-bottom:1rem; align-items:center; }
        .star { font-size:28px; cursor:pointer; opacity:0.3; transition:opacity 0.15s; }
        .star.active { opacity:1; }

        /* Number input for rating */
        .rating-input-wrap { margin-bottom:1rem; }
        .rating-input-wrap label { font-size:13px; color:#888; display:block; margin-bottom:6px; }
        .rating-number {
            width:70px; padding:6px 10px; border-radius:8px;
            background:#111; border:1px solid rgba(255,255,255,0.1);
            color:#fff; font-size:15px; text-align:center;
        }
        .rating-number:focus { outline:none; border-color:#F5C300; }

        textarea {
            width:100%; height:100px; background:#111;
            border:1px solid rgba(255,255,255,0.07); border-radius:12px;
            padding:10px; color:#fff; resize:none; margin-bottom:1rem;
        }
        .modal-buttons { display:flex; gap:10px; margin-top:0.5rem; }
        .btn-submit-feedback {
            flex:1; background:#F5C300; color:#111; border:none;
            border-radius:8px; padding:9px; font-size:14px;
            font-weight:700; cursor:pointer;
        }
        .btn-close-modal {
            flex:1; background:transparent; color:#555;
            border:1px solid rgba(255,255,255,0.1); border-radius:8px;
            padding:9px; font-size:14px; cursor:pointer;
        }
        .rating-error { color:#f87171; font-size:12px; margin-top:4px; display:none; }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo-badge">
            <span>YALLA</span>
            <div class="logo-sep"></div>
            <span>TAXI</span>
        </div>
        <div class="nav-links">
            <asp:LinkButton ID="lnkReserve" runat="server" OnClick="lnkReserve_Click">Reserve</asp:LinkButton>
            <a class="active" href="History.aspx">My Trips</a>
        </div>
        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
    </div>

    <!-- Page -->
    <div class="page">
        <p class="page-title">My <span>Trips</span></p>
        <p class="page-sub">Track all your reservations</p>

        <!-- Filter tabs — CssClass is set from code-behind -->
        <div class="filter-tabs">
            <asp:Button ID="btnAll"       runat="server" Text="All"       CssClass="filter-btn active" OnClick="btnAll_Click" />
            <asp:Button ID="btnPending"   runat="server" Text="⏳ Pending"  CssClass="filter-btn"        OnClick="btnPending_Click" />
            <asp:Button ID="btnActive"    runat="server" Text="🔵 Active"   CssClass="filter-btn"        OnClick="btnActive_Click" />
            <asp:Button ID="btnCompleted" runat="server" Text="✅ Completed" CssClass="filter-btn"       OnClick="btnCompleted_Click" />
        </div>

        <asp:Panel ID="pnlTrips" runat="server"></asp:Panel>
    </div>

    <!-- Feedback Modal -->
    <div class="modal-overlay" id="feedbackModal">
        <div class="modal">
            <h3>⭐ Leave Feedback</h3>

            <!-- Number input: type 1-5, stars update live -->
            <div class="rating-input-wrap">
                <label>Enter rating (1 to 5):</label>
                <input type="number" id="ratingNumber" class="rating-number"
                       min="1" max="5" placeholder="1–5"
                       oninput="syncStarsFromNumber(this.value)" />
                <p class="rating-error" id="ratingError">Please enter a number between 1 and 5.</p>
            </div>

            <!-- Stars: click to rate -->
            <div class="stars" id="starsRow">
                <span class="star" onclick="setRating(1)">⭐</span>
                <span class="star" onclick="setRating(2)">⭐</span>
                <span class="star" onclick="setRating(3)">⭐</span>
                <span class="star" onclick="setRating(4)">⭐</span>
                <span class="star" onclick="setRating(5)">⭐</span>
            </div>

            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine"
                         placeholder="Write your comment (optional)..."
                         style="width:100%;height:100px;background:#111;border:1px solid rgba(255,255,255,0.07);
                                border-radius:12px;padding:10px;color:#fff;resize:none;margin-bottom:1rem;" />

            <asp:HiddenField ID="hdnRating" runat="server" />
            <asp:HiddenField ID="hdnTripID" runat="server" />

            <div class="modal-buttons">
                <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit"
                            CssClass="btn-submit-feedback"
                            OnClick="btnSubmitFeedback_Click"
                            OnClientClick="return validateFeedback();" />
                <button type="button" class="btn-close-modal" onclick="closeFeedback()">Cancel</button>
            </div>
        </div>
    </div>

</form>

<script>

    // ── Open / close modal ────────────────────────────────────────────────────
    function openFeedback(tripId) {
        document.getElementById('feedbackModal').classList.add('show');
        document.getElementById('<%= hdnTripID.ClientID %>').value = tripId;
        // Reset state
        setRating(0);
        document.getElementById('ratingNumber').value = '';
        document.getElementById('<%= txtComment.ClientID %>').value = '';
        document.getElementById('ratingError').style.display = 'none';
    }

    function closeFeedback() {
        document.getElementById('feedbackModal').classList.remove('show');
    }

    // ── Star logic ────────────────────────────────────────────────────────────
    function setRating(n) {
        var stars = document.querySelectorAll('#starsRow .star');
        stars.forEach(function (s, i) {
            s.classList.toggle('active', i < n);
        });
        document.getElementById('<%= hdnRating.ClientID %>').value = n > 0 ? n : '';

        // Sync the number input too
        var numInput = document.getElementById('ratingNumber');
        if (n > 0) numInput.value = n;
    }

    // Called when user types in the number box
    function syncStarsFromNumber(val) {
        var n = parseInt(val);
        var errEl = document.getElementById('ratingError');
        if (n >= 1 && n <= 5) {
            setRating(n);
            errEl.style.display = 'none';
        } else {
            setRating(0);
            document.getElementById('<%= hdnRating.ClientID %>').value = '';
            errEl.style.display = val === '' ? 'none' : 'block';
        }
    }

    // ── Validate before submit ────────────────────────────────────────────────
    function validateFeedback() {
        var rating = document.getElementById('<%= hdnRating.ClientID %>').value;
        if (!rating || parseInt(rating) < 1 || parseInt(rating) > 5) {
            document.getElementById('ratingError').style.display = 'block';
            document.getElementById('ratingNumber').focus();
            return false;   // stop postback
        }
        return true;        // allow postback
    }

</script>
</body>
</html>