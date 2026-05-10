<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Taxi_Project.Home" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }

        body {
            font-family: 'Inter', sans-serif;
            background: #0f0f0f;
            color: #fff;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* BACKGROUND */
        .bg-grid {
            position: fixed; inset: 0; z-index: 0; pointer-events: none;
            background-image:
                linear-gradient(rgba(245,195,0,0.035) 1px, transparent 1px),
                linear-gradient(90deg, rgba(245,195,0,0.035) 1px, transparent 1px);
            background-size: 52px 52px;
        }
        .bg-glow {
            position: fixed; z-index: 0; pointer-events: none;
            width: 700px; height: 700px; border-radius: 50%;
            background: radial-gradient(circle, rgba(245,195,0,0.06) 0%, transparent 65%);
            top: -100px; left: 50%; transform: translateX(-50%);
        }

        /* NAV */
        nav {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            height: 68px; display: flex; align-items: center; justify-content: space-between;
            padding: 0 5%;
            background: rgba(15,15,15,0.88);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(245,195,0,0.08);
        }
        .logo-badge {
            background: #F5C300; border-radius: 10px; padding: 6px 14px;
            display: flex; align-items: center; gap: 8px;
        }
        .logo-badge span {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 22px; color: #111; letter-spacing: 2px;
        }
        .logo-sep { width: 2px; height: 22px; background: #111; opacity: 0.3; }

        .nav-right { display: flex; align-items: center; gap: 12px; }

        .btn-login {
            height: 40px; padding: 0 20px;
            background: transparent; border: 1.5px solid rgba(245,195,0,0.4);
            border-radius: 10px; color: #F5C300;
            font-size: 13px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: flex; align-items: center;
            transition: all .2s;
        }
        .btn-login:hover { background: rgba(245,195,0,0.08); border-color: #F5C300; }

        .btn-register {
            height: 40px; padding: 0 20px;
            background: #F5C300; border: none; border-radius: 10px;
            color: #111; font-size: 13px; font-weight: 700; cursor: pointer;
            text-decoration: none; display: flex; align-items: center;
            transition: background .2s;
        }
        .btn-register:hover { background: #ffd000; }

        .btn-mytrips {
            height: 40px; padding: 0 20px;
            background: transparent; border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 10px; color: #aaa;
            font-size: 13px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: flex; align-items: center; gap: 6px;
            transition: all .2s;
        }
        .btn-mytrips:hover { border-color: rgba(245,195,0,0.4); color: #F5C300; }

        /* HERO LOGO AREA */
        .hero {
            position: relative; z-index: 10;
            padding: 120px 5% 40px;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            text-align: center;
        }

        .hero-logo {
            display: flex; flex-direction: column; align-items: center; gap: 16px;
            margin-bottom: 16px;
        }
        .hero-logo-badge {
            background: #F5C300; border-radius: 16px; padding: 14px 32px;
            display: flex; align-items: center; gap: 12px;
        }
        .hero-logo-badge span {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 52px; color: #111; letter-spacing: 4px; line-height: 1;
        }
        .hero-logo-sep { width: 3px; height: 50px; background: #111; opacity: 0.25; }

        .hero-tagline {
            font-size: 14px; color: #555; letter-spacing: 2px;
            text-transform: uppercase; font-weight: 500;
        }

        /* FLEET LABEL */
        .fleet-label {
            position: relative; z-index: 10;
            text-align: center; margin-bottom: 0;
            padding: 20px 0 0;
        }
        .fleet-label p {
            font-size: 11px; font-weight: 700; letter-spacing: 3px;
            text-transform: uppercase; color: #F5C300;
        }
        .fleet-label h2 {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 52px; letter-spacing: -1px; margin-top: 4px;
        }

        /* CAROUSEL */
        .carousel-section {
            position: relative; z-index: 10;
            padding: 20px 0 60px;
            display: flex; align-items: center; justify-content: center;
        }

        /* Side arrow buttons */
        .arrow-btn {
            flex-shrink: 0;
            width: 60px; height: 60px; border-radius: 14px;
            background: rgba(245,195,0,0.08);
            border: 1.5px solid rgba(245,195,0,0.2);
            color: #F5C300; font-size: 22px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: all .2s;
            margin: 0 24px;
            position: relative; z-index: 20;
        }
        .arrow-btn:hover { background: rgba(245,195,0,0.15); border-color: #F5C300; }
        .arrow-btn:disabled { opacity: .25; cursor: not-allowed; }

        /* Cards track */
        .cars-wrapper { overflow: hidden; flex: 1; max-width: 1100px; }

        .cars-track {
            display: flex; gap: 32px;
            transition: transform .5s cubic-bezier(.4,0,.2,1);
        }

        /* Each car card */
        .car-card {
            flex: 0 0 calc(50% - 16px);
            display: flex; flex-direction: column;
            align-items: center; text-align: center;
            padding: 20px 20px 32px;
            cursor: pointer;
            transition: transform .3s;
        }
        .car-card:hover { transform: translateY(-6px); }

        .car-img-wrap {
            width: 100%; height: 240px;
            display: flex; align-items: flex-end; justify-content: center;
            margin-bottom: 28px; position: relative;
        }
        .car-img-wrap img {
            max-width: 100%; max-height: 100%;
            object-fit: contain;
            filter: drop-shadow(0 24px 40px rgba(0,0,0,0.6));
            transition: transform .4s cubic-bezier(.4,0,.2,1);
        }
        .car-card:hover .car-img-wrap img { transform: scale(1.04) translateY(-6px); }

        .car-name {
            font-family: 'Inter', sans-serif;
            font-size: 22px; font-weight: 700;
            color: #F5C300; margin-bottom: 14px;
        }

        .car-info {
            font-size: 14px; line-height: 1.9; color: #aaa;
        }
        .car-info strong { color: #fff; font-weight: 600; }

        .car-book-btn {
            margin-top: 22px;
            height: 46px; padding: 0 32px;
            background: #F5C300; border: none; border-radius: 12px;
            color: #111; font-size: 14px; font-weight: 700;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px;
            transition: background .2s, transform .15s;
        }
        .car-book-btn:hover { background: #ffd000; transform: translateY(-2px); }

        /* Dots */
        .dots {
            position: relative; z-index: 10;
            display: flex; justify-content: center; gap: 8px;
            margin-top: 8px; margin-bottom: 40px;
        }
        .dot {
            width: 8px; height: 8px; border-radius: 4px;
            background: rgba(255,255,255,0.15); cursor: pointer;
            transition: all .3s;
        }
        .dot.active { width: 24px; background: #F5C300; }

        /* FOOTER */
        footer {
            position: relative; z-index: 10;
            border-top: 1px solid rgba(245,195,0,0.08);
            padding: 28px 5%;
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 12px;
        }
        footer p { font-size: 12px; color: #333; }
        footer a { font-size: 12px; color: #444; text-decoration: none; }
        footer a:hover { color: #F5C300; }

        @media (max-width: 768px) {
            .car-card { flex: 0 0 85vw; }
            .arrow-btn { margin: 0 8px; width: 44px; height: 44px; font-size: 18px; }
            .hero-logo-badge span { font-size: 36px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

<div class="bg-grid"></div>
<div class="bg-glow"></div>

<!-- NAV -->
<nav>
    <div class="logo-badge">
        <span>YALLA</span>
        <div class="logo-sep"></div>
        <span>TAXI</span>
    </div>
    <div class="nav-right">
        <asp:Button ID="btnMyTrips"
            runat="server"
            Text="🧾 My Trips"
            CssClass="btn-mytrips"
            OnClick="btnMyTrips_Click" />
        <asp:Button ID="btnLogin"
            runat="server"
            Text="Login"
            CssClass="btn-login"
            OnClick="btnLogin_Click" />
        <asp:Button ID="btnRegister"
            runat="server"
            Text="Register"
            CssClass="btn-register"
            OnClick="btnRegister_Click" />
    </div>
</nav>

<!-- HERO LOGO -->
<section class="hero">
    <div class="hero-logo">
        <div class="hero-logo-badge">
            <span>YALLA</span>
            <div class="hero-logo-sep"></div>
            <span>TAXI</span>
        </div>
        <p class="hero-tagline">Your ride, your way — 24/7 across Lebanon</p>
    </div>
</section>

<!-- FLEET LABEL -->
<div class="fleet-label">
    <p>Our Fleet</p>
    <h2>CHOOSE YOUR RIDE</h2>
</div>

<!-- CAROUSEL -->
<div class="carousel-section">

    <!-- FIX #2: type="button" prevents form submission -->
    <button class="arrow-btn" type="button" id="btnPrev" onclick="slide(-1)">←</button>

    <div class="cars-wrapper">
        <div class="cars-track" id="carsTrack">

            <!-- STANDARD -->
            <div class="car-card" data-index="0">
                <div class="car-img-wrap">
                    <img src="images/img3.png" alt="Yalla Standard" />
                </div>
                <div class="car-name">Yalla Standard</div>
                <div class="car-info">
                    <strong>Seats:</strong> 4 Passengers
                </div>
                <asp:Button ID="btnStandard"
                    runat="server"
                    Text="Book Standard →"
                    CssClass="car-book-btn"
                    OnClick="btnStandard_Click" />
            </div>

            <!-- BUSINESS -->
            <div class="car-card" data-index="1">
                <div class="car-img-wrap">
                    <img src="images/img1.png" alt="Yalla Business" />
                </div>
                <div class="car-name">Yalla Business Class</div>
                <div class="car-info">
                    <strong>Seats:</strong> 4 Passengers<br>
                    <strong>Unbranded Cars</strong>
                </div>
                <asp:Button ID="btnBusiness"
                    runat="server"
                    Text="Book Business →"
                    CssClass="car-book-btn"
                    OnClick="btnBusiness_Click" />
            </div>

            <!-- VAN -->
            <div class="car-card" data-index="2">
                <div class="car-img-wrap">
                    <img src="images/img2.png" alt="Yalla Van" />
                </div>
                <div class="car-name">Yalla Van</div>
                <div class="car-info">
                    <strong>Seats:</strong> 7 Passengers
                </div>
                <asp:Button ID="btnVan"
                    runat="server"
                    Text="Book Van →"
                    CssClass="car-book-btn"
                    OnClick="btnVan_Click" />
            </div>

            <!-- DUPLICATE OF FIRST CARD (for seamless forward loop) -->
            <div class="car-card">
                <div class="car-img-wrap">
                    <img src="images/img3.png" alt="Yalla Standard" />
                </div>
                <div class="car-name">Yalla Standard</div>
                <div class="car-info">
                    <strong>Seats:</strong> 4 Passengers
                </div>
                <a href="Reserve.aspx?class=standard" class="car-book-btn">
                    Book Standard →
                </a>
            </div>

        </div>
    </div>

    <!-- FIX #2: type="button" prevents form submission -->
    <button class="arrow-btn" type="button" id="btnNext" onclick="slide(1)">→</button>

</div>

<!-- DOTS -->
<div class="dots" id="dots">
    <div class="dot active" onclick="goTo(0)"></div>
    <div class="dot" onclick="goTo(1)"></div>
    <div class="dot" onclick="goTo(2)"></div>
</div>

<!-- FOOTER -->
<footer>
    <div class="logo-badge">
        <span>YALLA</span>
        <div class="logo-sep"></div>
        <span>TAXI</span>
    </div>
    <p>© 2026 Yalla Taxi. All rights reserved.</p>
</footer>

<script>
    var current = 0;
    var total = 3;
    var isAnimating = false; // prevent double-clicks mid-animation

    function updateCarousel(animated) {
        var track = document.getElementById('carsTrack');
        var dots = document.getElementById('dots').querySelectorAll('.dot');

        var perView = window.innerWidth > 768 ? 2 : 1;
        var gapPx = 32;

        var trackW = track.parentElement.offsetWidth;
        var cardW = (trackW - gapPx * (perView - 1)) / perView;

        var offset = current * (cardW + gapPx);

        track.style.transition = animated
            ? 'transform .5s cubic-bezier(.4,0,.2,1)'
            : 'none';

        track.style.transform = 'translateX(-' + offset + 'px)';

        dots.forEach(function (d, i) {
            d.classList.toggle('active', i === (current % total));
        });
    }

    function slide(dir) {
        if (isAnimating) return; // block during animation
        isAnimating = true;

        current += dir;
        updateCarousel(true);

        // LOOP FORWARD — wait for animation, then jump silently
        if (current === total) {
            setTimeout(function () {
                current = 0;
                updateCarousel(false);
                isAnimating = false;
            }, 500);
            return;
        }

        // LOOP BACKWARD — wait for animation, then jump silently
        if (current < 0) {
            setTimeout(function () {
                current = total - 1;
                updateCarousel(false);
                isAnimating = false;
            }, 500);
            return;
        }

        setTimeout(function () { isAnimating = false; }, 500);
    }

    function goTo(idx) {
        if (isAnimating) return;
        current = idx;
        updateCarousel(true);
    }

    window.addEventListener('resize', function () {
        updateCarousel(false);
    });

    updateCarousel(false);
</script>
    </form>
</body>
</html>


