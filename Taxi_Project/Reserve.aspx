<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reserve.aspx.cs" Inherits="Taxi_Project.Reserve" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Reserve</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: #0f0f0f; color: #fff; }

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

        .layout { display: flex; margin-top: 60px; height: calc(100vh - 60px); }

        .panel {
            width: 420px; background: #1a1a1a;
            border-right: 1px solid rgba(245,195,0,0.1);
            overflow-y: auto; padding: 2rem;
            display: flex; flex-direction: column; gap: 1.2rem;
        }
        .panel-title { font-size: 20px; font-weight: 700; color: #fff; margin-bottom: 0.5rem; }
        .panel-title span { color: #F5C300; }
        .panel-sub { font-size: 13px; color: #555; margin-top: -0.8rem; }

        .field { display: flex; flex-direction: column; gap: 7px; }
        .field label { font-size: 11px; font-weight: 600; color: #555; letter-spacing: 1.5px; text-transform: uppercase; }
        .input-wrap { position: relative; }
        .input-icon { position: absolute; left: 14px; top: 15px; font-size: 15px; color: #444; z-index: 1; }
        .input-wrap input, .input-wrap select {
            width: 100%; height: 50px;
            background: #111;
            border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 12px;
            padding: 0 16px 0 44px;
            font-size: 14px; color: #fff; outline: none;
        }
        .input-wrap input::placeholder { color: #444; }
        .input-wrap input:focus, .input-wrap select:focus { border-color: #F5C300; }
        .input-wrap select option { background: #1a1a1a; }

        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        .map-hint {
            background: rgba(245,195,0,0.07);
            border: 1px solid rgba(245,195,0,0.15);
            border-radius: 12px; padding: 12px 16px;
            font-size: 13px; color: #888;
            display: flex; align-items: center; gap: 10px;
        }
        .map-hint .dot { width: 10px; height: 10px; border-radius: 50%; background: #F5C300; flex-shrink: 0; }
        .map-hint .dot.red { background: #ff4444; }

        .price-box {
            background: #111;
            border: 1px solid rgba(245,195,0,0.2);
            border-radius: 14px; padding: 1.2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        .price-label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .price-value { font-family: 'Bebas Neue', sans-serif; font-size: 32px; color: #F5C300; letter-spacing: 1px; }
        .km-badge { font-size: 12px; color: #888; margin-top: 4px; }
        .km-badge span { color: #F5C300; font-weight: 600; }

        .btn-submit {
            width: 100%; height: 52px;
            background: #F5C300; color: #111;
            border: none; border-radius: 14px;
            font-size: 15px; font-weight: 700;
            cursor: pointer; letter-spacing: 0.5px;
        }
        .btn-submit:hover { background: #ffd000; }

        .map-area { flex: 1; position: relative; }
        #map { width: 100%; height: 100%; }

        .map-overlay {
            position: absolute; top: 1rem; right: 1rem;
            background: #1a1a1a;
            border: 1px solid rgba(245,195,0,0.15);
            border-radius: 12px; padding: 12px 16px;
            font-size: 13px; color: #888; z-index: 999;
        }
        .map-overlay strong { color: #F5C300; display: block; margin-bottom: 4px; font-size: 12px; letter-spacing: 1px; text-transform: uppercase; }

        .leaflet-container { background: #0f0f0f; }

        .pickup-pin, .dropoff-pin {
            width: 22px; height: 22px; border-radius: 50%;
            border: 3px solid #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
        }
        .pickup-pin  { background: #F5C300; }
        .dropoff-pin { background: #ff4444; }

        /* Suggestion dropdown */
        .suggestions-box {
            position: absolute; top: 54px; left: 0; right: 0;
            background: #1e1e1e;
            border: 1px solid rgba(245,195,0,0.2);
            border-radius: 10px;
            z-index: 2000; overflow: hidden;
            box-shadow: 0 8px 24px rgba(0,0,0,0.5);
        }
        .suggestion-item {
            padding: 10px 16px;
            font-size: 13px; color: #ccc;
            cursor: pointer;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            transition: background .15s;
        }
        .suggestion-item:last-child { border-bottom: none; }
        .suggestion-item:hover { background: rgba(245,195,0,0.1); color: #F5C300; }
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
            <a href="Reserve.aspx" class="active">Reserve</a>
            <a href="History.aspx">My Trips</a>
        </div>
        <div class="nav-user">
            <asp:Label ID="lblUserName" runat="server" Style="font-size:13px; color:#555;" />
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>
    </div>

    <div class="layout">

        <div class="panel">

            <div>
                <p class="panel-title">Book a <span>Ride</span></p>
                <p class="panel-sub">Fill in the details below</p>
            </div>

            <div class="map-hint">
                <div class="dot"></div>
                Click the map or type to set your <strong style="color:#F5C300; font-size:13px; margin-left:4px;">Pickup</strong>
            </div>

            <div class="field">
                <label>Pickup Location</label>
                <div class="input-wrap">
                    <span class="input-icon">📍</span>
                    <asp:TextBox ID="txtPickup" runat="server"
                        placeholder="Click map or type city/area"
                        autocomplete="off"
                        onkeyup="onType(this, 'pickup')" />
                    <div class="suggestions-box" id="pickupSuggestions" style="display:none;"></div>
                </div>
            </div>

            <div class="map-hint">
                <div class="dot red"></div>
                Click the map or type to set your <strong style="color:#ff4444; font-size:13px; margin-left:4px;">Dropoff</strong>
            </div>

            <div class="field">
                <label>Dropoff Location</label>
                <div class="input-wrap">
                    <span class="input-icon">🏁</span>
                    <asp:TextBox ID="txtDropoff" runat="server"
                        placeholder="Click map or type city/area"
                        autocomplete="off"
                        onkeyup="onType(this, 'dropoff')" />
                    <div class="suggestions-box" id="dropoffSuggestions" style="display:none;"></div>
                </div>
            </div>

            <div class="row-2">
                <div class="field">
                    <label>Date</label>
                    <div class="input-wrap">
                        <span class="input-icon">📅</span>
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                    </div>
                </div>
                <div class="field">
                    <label>Time</label>
                    <div class="input-wrap">
                        <span class="input-icon">🕐</span>
                        <asp:TextBox ID="txtTime" runat="server" TextMode="Time" />
                    </div>
                </div>
            </div>

            <div class="field">
                <label>Driver Gender</label>
                <div class="input-wrap">
                    <span class="input-icon">👤</span>
                    <asp:DropDownList ID="ddlDriverGender" runat="server">
                        <asp:ListItem Value="">No preference</asp:ListItem>
                        <asp:ListItem Value="Male">Male Driver</asp:ListItem>
                        <asp:ListItem Value="Female">Female Driver</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="price-box">
                <div>
                    <div class="price-label">Estimated Price</div>
                    <div class="km-badge" id="kmDisplay">Distance: <span>—</span></div>
                </div>
                <div>
                    <asp:Label ID="lblPrice" runat="server" Text="$0.00" CssClass="price-value" />
                </div>
            </div>

            <asp:Label ID="lblError" runat="server" Visible="false"
                Style="display:block; background:#2a1a1a; border:1px solid #8B3030; color:#ff6b6b; border-radius:10px; padding:10px 14px; font-size:13px;" />

            <asp:Button ID="btnReserve" runat="server" Text="Confirm Booking →" CssClass="btn-submit" OnClick="btnReserve_Click" />

            <asp:HiddenField ID="hdnPickupLat"  runat="server" />
            <asp:HiddenField ID="hdnPickupLng"  runat="server" />
            <asp:HiddenField ID="hdnDropoffLat" runat="server" />
            <asp:HiddenField ID="hdnDropoffLng" runat="server" />
            <asp:HiddenField ID="hdnDistance"   runat="server" />

        </div>

        <div class="map-area">
            <div id="map"></div>
            <div class="map-overlay">
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

    var pickupIcon = L.divIcon({
        className: '',
        html: '<div class="pickup-pin"></div>',
        iconSize: [22, 22], iconAnchor: [11, 11]
    });
    var dropoffIcon = L.divIcon({
        className: '',
        html: '<div class="dropoff-pin"></div>',
        iconSize: [22, 22], iconAnchor: [11, 11]
    });

    // ── Map init ───────────────────────────────────────────
    var map = L.map('map', {
        center: [33.8938, 35.5018],
        zoom: 13,
        zoomControl: true,
        attributionControl: false
    });

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
        maxZoom: 19
    }).addTo(map);

    // ── Map click ──────────────────────────────────────────
    map.on('click', function (e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
        if (clickStep === 1) {
            placePickup(lat, lng, lat.toFixed(5) + ', ' + lng.toFixed(5));
            clickStep = 2;
        } else {
            placeDropoff(lat, lng, lat.toFixed(5) + ', ' + lng.toFixed(5));
            clickStep = 1;
            drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
        }
    });

    // ── Helpers ────────────────────────────────────────────
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

    // ── Typing → Nominatim suggestions ────────────────────
    // Free geocoding, no API key needed
    function onType(inputEl, which) {
        var query = inputEl.value.trim();
        var boxId = which === 'pickup' ? 'pickupSuggestions' : 'dropoffSuggestions';
        var box   = document.getElementById(boxId);

        if (query.length < 3) { box.style.display = 'none'; return; }

        clearTimeout(typeTimer);
        typeTimer = setTimeout(function () {
            var url = 'https://nominatim.openstreetmap.org/search'
                    + '?format=json&limit=5&countrycodes=lb'
                    + '&q=' + encodeURIComponent(query);

            fetch(url, { headers: { 'Accept-Language': 'en' } })
                .then(function (r) { return r.json(); })
                .then(function (results) {
                    box.innerHTML = '';
                    if (!results.length) { box.style.display = 'none'; return; }

                    results.forEach(function (place) {
                        var item = document.createElement('div');
                        item.className   = 'suggestion-item';
                        item.textContent = place.display_name;

                        item.addEventListener('click', function () {
                            var lat   = parseFloat(place.lat);
                            var lng   = parseFloat(place.lon);
                            var label = place.display_name.split(',')[0];

                            if (which === 'pickup') {
                                placePickup(lat, lng, label);
                                map.setView([lat, lng], 14);
                                if (dropoffMarker) {
                                    drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
                                } else {
                                    clickStep = 2;
                                }
                            } else {
                                placeDropoff(lat, lng, label);
                                map.setView([lat, lng], 14);
                                if (pickupMarker) {
                                    drawRoute(pickupMarker.getLatLng(), dropoffMarker.getLatLng());
                                }
                                clickStep = 1;
                            }
                            box.style.display = 'none';
                        });

                        box.appendChild(item);
                    });

                    box.style.display = 'block';
                })
                .catch(function () { box.style.display = 'none'; });

        }, 500);
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.input-wrap')) {
            document.getElementById('pickupSuggestions').style.display  = 'none';
            document.getElementById('dropoffSuggestions').style.display = 'none';
        }
    });

    // ── Draw red route via OSRM ────────────────────────────
    function drawRoute(from, to) {
        if (routeLayer) map.removeLayer(routeLayer);

        var url = 'https://router.project-osrm.org/route/v1/driving/'
                + from.lng + ',' + from.lat + ';'
                + to.lng   + ',' + to.lat
                + '?overview=full&geometries=geojson';

        fetch(url)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.code !== 'Ok') return;

                var route = data.routes[0];

                routeLayer = L.geoJSON(route.geometry, {
                    style: { color: '#ff4444', weight: 4, opacity: 0.85 }
                }).addTo(map);

                map.fitBounds(routeLayer.getBounds(), { padding: [40, 40] });

                var distKm = (route.distance / 1000).toFixed(2);
                document.getElementById('<%= hdnDistance.ClientID %>').value = distKm;

                document.getElementById('kmDisplay').innerHTML =
                    'Distance: <span>' + distKm + ' km</span>';

                // Preview price (C# will recalculate on submit)
                var price = (parseFloat(distKm) * 2.5).toFixed(2);
                document.getElementById('<%= lblPrice.ClientID %>').innerText = '$' + price;
            });
    }
</script>

</body>
</html>
