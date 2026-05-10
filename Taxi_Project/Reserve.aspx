<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reserve.aspx.cs" Inherits="Taxi_Project.ReservePage" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Reserve</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; overflow: hidden; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }

        /* ── NAVBAR ─────────────────────────────────────── */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; height: 60px;
            background: #151515; border-bottom: 1px solid rgba(245,195,0,0.12);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem; z-index: 1000;
        }
        .logo-badge {
            background: #F5C300; border-radius: 8px;
            padding: 5px 14px; display: flex; align-items: center; gap: 7px;
        }
        .logo-badge span {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 19px; color: #111; letter-spacing: 2px;
        }
        .logo-sep { width: 2px; height: 16px; background: #111; opacity: 0.25; }

        .nav-links { display: flex; align-items: center; gap: 2rem; }
        .nav-links a {
            font-size: 13px; font-weight: 500;
            color: #F5C300; text-decoration: none;
        }
        .btn-nav {
            background: none; border: none; outline: none;
            font-family: 'Inter', sans-serif; font-size: 13px;
            font-weight: 500; color: #555; cursor: pointer; padding: 0;
            transition: color .2s;
        }
        .btn-nav:hover { color: #F5C300; }
        .btn-logout {
            background: transparent;
            border: 1px solid rgba(245,195,0,0.3);
            color: #F5C300; border-radius: 8px;
            padding: 6px 16px; font-size: 12px;
            font-family: 'Inter', sans-serif;
            cursor: pointer; transition: background .2s;
        }
        .btn-logout:hover { background: rgba(245,195,0,0.08); }

        /* ── LAYOUT ─────────────────────────────────────── */
        .layout { display: flex; margin-top: 60px; height: calc(100vh - 60px); }

        /* ── PANEL ─────────────────────────────────────── */
        .panel {
            width: 400px; min-width: 400px;
            background: #151515;
            border-right: 1px solid rgba(245,195,0,0.08);
            overflow-y: auto; padding: 1.8rem 1.6rem;
            display: flex; flex-direction: column; gap: 1.1rem;
        }
        .panel-title { font-size: 22px; font-weight: 700; }
        .panel-title span { color: #F5C300; }
        .panel-sub { font-size: 12px; color: #444; margin-top: 2px; }

        /* ── FIELD ─────────────────────────────────────── */
        .field { display: flex; flex-direction: column; gap: 6px; }
        .field-label {
            display: flex; align-items: center; gap: 7px;
            font-size: 10px; font-weight: 700;
            color: #444; letter-spacing: 1.8px; text-transform: uppercase;
        }
        .dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
        .dot-yellow { background: #F5C300; }
        .dot-red    { background: #ff4040; }

        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 13px; top: 50%;
            transform: translateY(-50%);
            font-size: 14px; pointer-events: none; z-index: 1;
        }
        .input-wrap input,
        .input-wrap select {
            width: 100%; height: 48px;
            background: #111; border-radius: 11px;
            padding: 0 14px 0 42px;
            font-size: 13px; color: #fff; outline: none;
            font-family: 'Inter', sans-serif;
            transition: border-color .2s; appearance: none;
        }
        .input-wrap input::placeholder { color: #333; }
        .input-wrap select option { background: #1a1a1a; }

        /* pickup — yellow border */
        .pickup-wrap input { border: 1.5px solid rgba(245,195,0,0.3); }
        .pickup-wrap input:focus { border-color: #F5C300; }

        /* dropoff — red border */
        .dropoff-wrap input { border: 1.5px solid rgba(255,64,64,0.3); }
        .dropoff-wrap input:focus { border-color: #ff4040; }

        /* neutral */
        .neutral-wrap input,
        .neutral-wrap select { border: 1.5px solid rgba(255,255,255,0.07); }
        .neutral-wrap input:focus,
        .neutral-wrap select:focus { border-color: #F5C300; }

        .select-arrow {
            position: absolute; right: 14px; top: 50%;
            transform: translateY(-50%);
            font-size: 10px; color: #555; pointer-events: none;
        }

        /* ── SUGGESTIONS ────────────────────────────────── */
        .suggestions-box {
            position: absolute; top: 52px; left: 0; right: 0;
            background: #1c1c1c; border: 1px solid rgba(245,195,0,0.18);
            border-radius: 10px; z-index: 3000; overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
        .suggestion-item {
            padding: 10px 15px; font-size: 12px; color: #aaa; cursor: pointer;
            border-bottom: 1px solid rgba(255,255,255,0.04); transition: background .15s;
        }
        .suggestion-item:last-child { border-bottom: none; }
        .suggestion-item:hover { background: rgba(245,195,0,0.09); color: #F5C300; }

        /* ── ROW ────────────────────────────────────────── */
        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: .9rem; }

        /* ── PRICE BOX ──────────────────────────────────── */
        .price-box {
            background: #111; border: 1px solid rgba(245,195,0,0.18);
            border-radius: 13px; padding: 1.1rem 1.3rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        .price-label { font-size: 10px; color: #444; text-transform: uppercase; letter-spacing: 1.4px; }
        .price-value { font-family: 'Bebas Neue', sans-serif; font-size: 34px; color: #F5C300; }
        .km-text { font-size: 11px; color: #555; margin-top: 3px; }
        .km-text span { color: #F5C300; font-weight: 600; }

        /* ── ERROR ──────────────────────────────────────── */
        .error-box {
            display: block; background: #1e1010;
            border: 1px solid rgba(255,80,80,0.3);
            color: #ff6b6b; border-radius: 10px;
            padding: 10px 14px; font-size: 12px;
        }

        /* ── CALCULATE ──────────────────────────────────── */
        .btn-calc {
            width: 100%; height: 46px;
            background: transparent;
            border: 1.5px solid rgba(245,195,0,0.5);
            color: #F5C300; border-radius: 13px;
            font-size: 13px; font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer; letter-spacing: 0.4px;
            transition: background .2s;
        }
        .btn-calc:hover { background: rgba(245,195,0,0.08); }

        /* ── CALCULATE ──────────────────────────────────── */
        .btn-calc {
            width: 100%; height: 46px;
            background: transparent;
            border: 1.5px solid rgba(245,195,0,0.5);
            color: #F5C300; border-radius: 13px;
            font-size: 13px; font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer; letter-spacing: 0.4px;
            transition: background .2s;
        }
        .btn-calc:hover { background: rgba(245,195,0,0.08); }

        /* ── SUBMIT ─────────────────────────────────────── */
        .btn-submit {
            width: 100%; height: 50px;
            background: #F5C300; color: #111;
            border: none; border-radius: 13px;
            font-size: 14px; font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer; letter-spacing: 0.4px;
            transition: background .2s;
        }
        .btn-submit:hover { background: #ffd500; }

        /* ── MAP ────────────────────────────────────────── */
        .map-area { flex: 1; position: relative; }
        #map { width: 100%; height: 100%; }
        .leaflet-container { background: #0f0f0f; }

        .map-instructions {
            position: absolute; top: 14px; right: 14px;
            background: #151515; border: 1px solid rgba(245,195,0,0.15);
            border-radius: 11px; padding: 11px 15px;
            font-size: 12px; color: #666; z-index: 900; line-height: 1.8;
        }
        .map-instructions strong {
            display: block; color: #F5C300;
            font-size: 10px; letter-spacing: 1.4px;
            text-transform: uppercase; margin-bottom: 4px;
        }
        .pickup-pin, .dropoff-pin {
            width: 20px; height: 20px; border-radius: 50%;
            border: 3px solid #fff; box-shadow: 0 0 8px rgba(0,0,0,0.6);
        }
        .pickup-pin  { background: #F5C300; }
        .dropoff-pin { background: #ff4040; }

        .panel::-webkit-scrollbar { width: 4px; }
        .panel::-webkit-scrollbar-track { background: transparent; }
        .panel::-webkit-scrollbar-thumb { background: rgba(245,195,0,0.2); border-radius: 4px; }
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
            <asp:Button ID="btnMyTrips" runat="server"
                Text="My Trips" CssClass="btn-nav"
                OnClick="btnMyTrips_Click" CausesValidation="false" />
        </div>
        <div style="display:flex;align-items:center;gap:10px;">
            <asp:Label ID="lblUserName" runat="server" Style="font-size:12px;color:#444;" />
            <asp:Button ID="btnLogout" runat="server"
                Text="Logout" CssClass="btn-logout"
                OnClick="btnLogout_Click" CausesValidation="false" />
        </div>
    </div>

    <!-- LAYOUT -->
    <div class="layout">
        <div class="panel">

            <div>
                <p class="panel-title">Book a <span>Ride</span></p>
                <p class="panel-sub">Fill in the details below</p>
            </div>
            <asp:Label ID="lblSelectedCar" runat="server" Style="font-size:12px; color:#F5C300;" />

            <!-- PICKUP -->
            <div class="field">
                <div class="field-label">
                    <span class="dot dot-yellow"></span>
                    Pickup Location
                </div>
                <div class="input-wrap pickup-wrap">
                    <span class="input-icon">📍</span>
                    <asp:TextBox ID="txtPickup" runat="server"
                        placeholder="Click map or type city/area"
                        autocomplete="off"
                        onkeyup="onType(this,'pickup')" />
                    <div class="suggestions-box" id="pickupSuggestions" style="display:none;"></div>
                </div>
            </div>

            <!-- DROPOFF -->
            <div class="field">
                <div class="field-label">
                    <span class="dot dot-red"></span>
                    Dropoff Location
                </div>
                <div class="input-wrap dropoff-wrap">
                    <span class="input-icon">🏁</span>
                    <asp:TextBox ID="txtDropoff" runat="server"
                        placeholder="Click map or type city/area"
                        autocomplete="off"
                        onkeyup="onType(this,'dropoff')" />
                    <div class="suggestions-box" id="dropoffSuggestions" style="display:none;"></div>
                </div>
            </div>

            <!-- DATE + TIME -->
            <div class="row-2">
                <div class="field">
                    <div class="field-label">Date</div>
                    <div class="input-wrap neutral-wrap">
                        <span class="input-icon">📅</span>
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">Time</div>
                    <div class="input-wrap neutral-wrap">
                        <span class="input-icon">🕐</span>
                        <asp:TextBox ID="txtTime" runat="server" TextMode="Time" />
                    </div>
                </div>
            </div>

            <!-- DRIVER GENDER -->
            <div class="field">
                <div class="field-label">Driver Gender</div>
                <div class="input-wrap neutral-wrap">
                    <span class="input-icon">👤</span>
                    <asp:DropDownList ID="ddlDriverGender" runat="server"
                        style="width:100%;height:48px;background:#111;border:1.5px solid rgba(255,255,255,0.07);border-radius:11px;padding:0 14px 0 42px;font-size:13px;color:#fff;outline:none;font-family:'Inter',sans-serif;appearance:none;">
                        <asp:ListItem Value="">No preference</asp:ListItem>
                        <asp:ListItem Value="Male">Male Driver</asp:ListItem>
                        <asp:ListItem Value="Female">Female Driver</asp:ListItem>
                    </asp:DropDownList>
                    <span class="select-arrow">▼</span>
                </div>
            </div>

            <!-- PRICE BOX -->
            <div class="price-box">
                <div>
                    <div class="price-label">Estimated Price</div>
                    <div class="km-text" id="kmDisplay">Distance: <span>—</span></div>
                </div>
                <asp:Label ID="lblPrice" runat="server" Text="—" CssClass="price-value" />
            </div>

            <!-- ERROR -->
            <asp:Label ID="lblError" runat="server" Visible="false" CssClass="error-box" />

            <!-- CALCULATE -->
            <asp:Button ID="btnCalculate" runat="server"
                Text="Calculate Price 🧮"
                CssClass="btn-calc"
                OnClick="btnCalculate_Click"
                CausesValidation="false" />

            <!-- CONFIRM -->
            <asp:Button ID="btnReserve" runat="server"
                Text="Confirm Booking →"
                CssClass="btn-submit"
                OnClick="btnReserve_Click" />
            <asp:Label ID="lblSuccess" runat="server" Visible="false" CssClass="success-box" />

            <!-- HIDDEN FIELDS -->
            <asp:HiddenField ID="hdnPickupLat"  runat="server" />
            <asp:HiddenField ID="hdnPickupLng"  runat="server" />
            <asp:HiddenField ID="hdnDropoffLat" runat="server" />
            <asp:HiddenField ID="hdnDropoffLng" runat="server" />
            <asp:HiddenField ID="hdnDistance"   runat="server" />
            <asp:HiddenField ID="hdnCarRate"    runat="server" Value="2.5" />

        </div>

        <!-- MAP -->
        <div class="map-area">
            <div id="map"></div>
            <div class="map-instructions">
                <strong>Instructions</strong>
                1st click → Pickup 📍<br/>
                2nd click → Dropoff 🏁
            </div>
        </div>
    </div>

</form>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    var clickStep = 1;
    var pickupMarker = null;
    var dropoffMarker = null;
    var routeLayer = null;
    var typeTimer = null;

    // Lebanon bounding box — map cannot go outside this
    var LB = L.latLngBounds(L.latLng(33.05, 35.10), L.latLng(34.69, 36.62));

    var pickupIcon = L.divIcon({
        className: '', html: '<div class="pickup-pin"></div>',
        iconSize: [20, 20], iconAnchor: [10, 10]
    });
    var dropoffIcon = L.divIcon({
        className: '', html: '<div class="dropoff-pin"></div>',
        iconSize: [20, 20], iconAnchor: [10, 10]
    });

    var map = L.map('map', {
        center: [33.8938, 35.5018], zoom: 10,
        minZoom: 9, maxZoom: 18,
        maxBounds: LB, maxBoundsViscosity: 1.0,
        zoomControl: true, attributionControl: false
    });

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 18, bounds: LB
    }).addTo(map);

    map.on('click', function (e) {
        if (!LB.contains(e.latlng)) return;
        var lat = e.latlng.lat, lng = e.latlng.lng;
        if (clickStep === 1) {
            placePickup(lat, lng, lat.toFixed(4) + ', ' + lng.toFixed(4));
            clickStep = 2;
        } else {
            placeDropoff(lat, lng, lat.toFixed(4) + ', ' + lng.toFixed(4));
            clickStep = 1;
            if (pickupMarker) drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
        }
    });

    function placePickup(lat, lng, label) {
        if (pickupMarker) map.removeLayer(pickupMarker);
        pickupMarker = L.marker([lat, lng], { icon: pickupIcon }).addTo(map);
        document.getElementById('<%= hdnPickupLat.ClientID %>').value = lat;
        document.getElementById('<%= hdnPickupLng.ClientID %>').value = lng;
        document.getElementById('<%= txtPickup.ClientID %>').value = label;
    }

    function placeDropoff(lat, lng, label) {
        if (dropoffMarker) map.removeLayer(dropoffMarker);
        dropoffMarker = L.marker([lat, lng], { icon: dropoffIcon }).addTo(map);
        document.getElementById('<%= hdnDropoffLat.ClientID %>').value = lat;
        document.getElementById('<%= hdnDropoffLng.ClientID %>').value = lng;
        document.getElementById('<%= txtDropoff.ClientID %>').value    = label;
    }

    function drawRoute(from, to) {
        if (routeLayer) map.removeLayer(routeLayer);
        fetch('https://router.project-osrm.org/route/v1/driving/'
            + from.lng+','+from.lat+';'+to.lng+','+to.lat
            + '?overview=full&geometries=geojson')
        .then(function(r){return r.json();})
        .then(function(data){
            if (data.code !== 'Ok') return;
            var route = data.routes[0];
            routeLayer = L.geoJSON(route.geometry, {
                style: { color:'#ff4040', weight:4, opacity:0.8 }
            }).addTo(map);
            map.fitBounds(routeLayer.getBounds(), { padding:[40,40] });

            var distKm = (route.distance / 1000).toFixed(2);
            document.getElementById('<%= hdnDistance.ClientID %>').value = distKm;
            document.getElementById('kmDisplay').innerHTML = 'Distance: <span>' + distKm + ' km</span>';
        });
    }

    function onType(inputEl, which) {
        var query = inputEl.value.trim();
        var box = document.getElementById(which === 'pickup' ? 'pickupSuggestions' : 'dropoffSuggestions');
        if (query.length < 3) { box.style.display = 'none'; return; }
        clearTimeout(typeTimer);
        typeTimer = setTimeout(function () {
            fetch('https://nominatim.openstreetmap.org/search?format=json&limit=5&countrycodes=lb&q='
                + encodeURIComponent(query), { headers: { 'Accept-Language': 'en' } })
                .then(function (r) { return r.json(); })
                .then(function (results) {
                    box.innerHTML = '';
                    if (!results.length) { box.style.display = 'none'; return; }
                    results.forEach(function (place) {
                        var item = document.createElement('div');
                        item.className = 'suggestion-item';
                        item.textContent = place.display_name;
                        item.addEventListener('click', function () {
                            var lat = parseFloat(place.lat), lng = parseFloat(place.lon);
                            var label = place.display_name.split(',')[0];
                            if (which === 'pickup') {
                                placePickup(lat, lng, label); map.setView([lat, lng], 14); clickStep = 2;
                                if (dropoffMarker) drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
                            } else {
                                placeDropoff(lat, lng, label); map.setView([lat, lng], 14); clickStep = 1;
                                if (pickupMarker) drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
                            }
                            box.style.display = 'none';
                        });
                        box.appendChild(item);
                    });
                    box.style.display = 'block';
                })
                .catch(function () { box.style.display = 'none'; });
        }, 450);
    }
    

    document.addEventListener('click', function (e) {
        if (!e.target.closest('.input-wrap')) {
            document.getElementById('pickupSuggestions').style.display = 'none';
            document.getElementById('dropoffSuggestions').style.display = 'none';
        }
    });

    window.onload = function () {
        var pickupLat = document.getElementById('<%= hdnPickupLat.ClientID %>').value;
        var pickupLng = document.getElementById('<%= hdnPickupLng.ClientID %>').value;
        var dropoffLat = document.getElementById('<%= hdnDropoffLat.ClientID %>').value;
    var dropoffLng = document.getElementById('<%= hdnDropoffLng.ClientID %>').value;

    if (pickupLat && pickupLng) {
        placePickup(parseFloat(pickupLat), parseFloat(pickupLng),
            document.getElementById('<%= txtPickup.ClientID %>').value);
    }

    if (dropoffLat && dropoffLng) {
        placeDropoff(parseFloat(dropoffLat), parseFloat(dropoffLng),
            document.getElementById('<%= txtDropoff.ClientID %>').value);
        }

        if (pickupLat && dropoffLat) {
            drawRoute(
                L.latLng(parseFloat(pickupLat), parseFloat(pickupLng)),
                L.latLng(parseFloat(dropoffLat), parseFloat(dropoffLng))
            );
        }
    };
</script>
</body>
</html>

