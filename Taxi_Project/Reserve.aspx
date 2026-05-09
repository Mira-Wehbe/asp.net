<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reserve.aspx.cs" Inherits="Taxi_Project.Reserve" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Reserve</title>
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
            padding: 0 2rem; z-index: 100;
        }
        .logo-badge { background: #F5C300; border-radius: 8px; padding: 5px 12px; display: flex; align-items: center; gap: 6px; }
        .logo-badge span { font-family: 'Bebas Neue', sans-serif; font-size: 18px; color: #111; letter-spacing: 2px; }
        .logo-sep { width: 2px; height: 18px; background: #111; opacity: 0.3; }
        .nav-links { display: flex; gap: 2rem; }
        .nav-links a { font-size: 13px; color: #555; text-decoration: none; font-weight: 500; }
        .nav-links a.active { color: #F5C300; }
        .nav-user { display: flex; align-items: center; gap: 10px; }
        .nav-user span { font-size: 13px; color: #555; }
        .btn-logout { background: transparent; border: 1px solid rgba(245,195,0,0.3); color: #F5C300; border-radius: 8px; padding: 6px 14px; font-size: 12px; cursor: pointer; }

        /* LAYOUT */
        .layout { display: flex; margin-top: 60px; height: calc(100vh - 60px); }

        /* LEFT PANEL */
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
        .input-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); font-size: 15px; color: #444; }
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

        /* MAP PIN INDICATOR */
        .map-hint {
            background: rgba(245,195,0,0.07);
            border: 1px solid rgba(245,195,0,0.15);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 13px;
            color: #888;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .map-hint .dot { width: 10px; height: 10px; border-radius: 50%; background: #F5C300; flex-shrink: 0; }
        .map-hint .dot.red { background: #ff4444; }

        /* PRICE ESTIMATE */
        .price-box {
            background: #111;
            border: 1px solid rgba(245,195,0,0.2);
            border-radius: 14px;
            padding: 1.2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .price-label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .price-value { font-family: 'Bebas Neue', sans-serif; font-size: 32px; color: #F5C300; letter-spacing: 1px; }
        .price-sub { font-size: 11px; color: #444; margin-top: 2px; }

        /* DIVIDER */
        .divider { height: 1px; background: rgba(255,255,255,0.05); }

        /* SUBMIT BTN */
        .btn-submit {
            width: 100%; height: 52px;
            background: #F5C300; color: #111;
            border: none; border-radius: 14px;
            font-size: 15px; font-weight: 700;
            cursor: pointer; letter-spacing: 0.5px;
        }
        .btn-submit:hover { background: #ffd000; }

        /* MAP */
        .map-area { flex: 1; position: relative; }
        #map { width: 100%; height: 100%; }
        .map-overlay {
            position: absolute; top: 1rem; right: 1rem;
            background: #1a1a1a;
            border: 1px solid rgba(245,195,0,0.15);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 13px; color: #888;
            z-index: 10;
        }
        .map-overlay strong { color: #F5C300; display: block; margin-bottom: 4px; font-size: 12px; letter-spacing: 1px; text-transform: uppercase; }

        /* HIDDEN FIELDS */
        .hidden { display: none; }
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
            <a href="Reserve.aspx" class="active">Reserve</a>
            <a href="History.aspx">My Trips</a>
        </div>
        <div class="nav-user">
            <%-- ID: lblUserName | USE: lblUserName.Text --%>
            <asp:Label ID="lblUserName" runat="server" Style="font-size:13px; color:#555;" />
            <%-- ID: btnLogout | USE: btnLogout_Click --%>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>
    </div>

    <div class="layout">

        <!-- LEFT PANEL: FORM -->
        <div class="panel">

            <div>
                <p class="panel-title">Book a <span>Ride</span></p>
                <p class="panel-sub">Fill in the details below</p>
            </div>

            <!-- PICKUP HINT -->
            <div class="map-hint">
                <div class="dot"></div>
                Click on the map to set your <strong style="color:#F5C300; font-size:13px;">Pickup</strong> location
            </div>

            <!-- PICKUP LOCATION -->
            <div class="field">
                <label>Pickup Location</label>
                <div class="input-wrap">
                    <span class="input-icon">📍</span>
                    <%-- ID: txtPickup | USE: txtPickup.Text --%>
                    <asp:TextBox ID="txtPickup" runat="server" placeholder="Click map or type address" />
                </div>
            </div>

            <!-- DROPOFF HINT -->
            <div class="map-hint">
                <div class="dot red"></div>
                Click on the map to set your <strong style="color:#ff4444; font-size:13px;">Dropoff</strong> location
            </div>

            <!-- DROPOFF LOCATION -->
            <div class="field">
                <label>Dropoff Location</label>
                <div class="input-wrap">
                    <span class="input-icon">🏁</span>
                    <%-- ID: txtDropoff | USE: txtDropoff.Text --%>
                    <asp:TextBox ID="txtDropoff" runat="server" placeholder="Click map or type address" />
                </div>
            </div>

            <!-- DATE & TIME -->
            <div class="row-2">
                <div class="field">
                    <label>Date</label>
                    <div class="input-wrap">
                        <span class="input-icon">📅</span>
                        <%-- ID: txtDate | USE: txtDate.Text --%>
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                    </div>
                </div>
                <div class="field">
                    <label>Time</label>
                    <div class="input-wrap">
                        <span class="input-icon">🕐</span>
                        <%-- ID: txtTime | USE: txtTime.Text --%>
                        <asp:TextBox ID="txtTime" runat="server" TextMode="Time" />
                    </div>
                </div>
            </div>

            <!-- CAR TYPE -->
            <div class="field">
                <label>Car Type</label>
                <div class="input-wrap">
                    <span class="input-icon">🚕</span>
                    <%-- ID: ddlCar | USE: ddlCar.SelectedValue --%>
                    <asp:DropDownList ID="ddlCar" runat="server">
                        <asp:ListItem Value="">Select a car...</asp:ListItem>
                        <asp:ListItem Value="Sedan4">🚗 Sedan — 4 Seats (Standard)</asp:ListItem>
                        <asp:ListItem Value="Van8">🚐 Van — 8 Seats (Standard)</asp:ListItem>
                        <asp:ListItem Value="SUV4">🚙 SUV — 4 Seats (Premium)</asp:ListItem>
                        <asp:ListItem Value="Minibus8">🚌 Minibus — 8 Seats (Premium)</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

          <!-- DRIVER GENDER -->
            <div class="field">
                <label>Driver Gender</label>
                <div class="input-wrap">
                    <span class="input-icon">👤</span>
                    <%-- ID: ddlDriverGender | USE: ddlDriverGender.SelectedValue --%>
                    <asp:DropDownList ID="ddlDriverGender" runat="server">
                        <asp:ListItem Value="">No preference</asp:ListItem>
                        <asp:ListItem Value="Male">Male Driver</asp:ListItem>
                        <asp:ListItem Value="Female">Female Driver</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- PRICE ESTIMATE -->
            <div class="price-box">
                <div>
                    <div class="price-label">Estimated Price</div>
                    <div class="price-sub">Based on distance</div>
                </div>
                <%-- ID: lblPrice | USE: lblPrice.Text --%>
                <div>
                    <asp:Label ID="lblPrice" runat="server" Text="$0.00" CssClass="price-value" />
                </div>
            </div>

            <!-- ERROR -->
            <%-- ID: lblError | USE: lblError.Text / lblError.Visible = true --%>
            <asp:Label ID="lblError" runat="server" Visible="false"
                Style="display:block; background:#2a1a1a; border:1px solid #8B3030; color:#ff6b6b; border-radius:10px; padding:10px 14px; font-size:13px;" />

            <!-- SUBMIT -->
            <%-- ID: btnReserve | USE: btnReserve_Click --%>
            <asp:Button ID="btnReserve" runat="server" Text="Confirm Booking →" CssClass="btn-submit" OnClick="btnReserve_Click" />

            <!-- HIDDEN: lat/lng saved here from map click -->
            <%-- ID: hdnPickupLat | USE: hdnPickupLat.Value --%>
            <asp:HiddenField ID="hdnPickupLat" runat="server" />
            <%-- ID: hdnPickupLng | USE: hdnPickupLng.Value --%>
            <asp:HiddenField ID="hdnPickupLng" runat="server" />
            <%-- ID: hdnDropoffLat | USE: hdnDropoffLat.Value --%>
            <asp:HiddenField ID="hdnDropoffLat" runat="server" />
            <%-- ID: hdnDropoffLng | USE: hdnDropoffLng.Value --%>
            <asp:HiddenField ID="hdnDropoffLng" runat="server" />
            <%-- ID: hdnDistance | USE: hdnDistance.Value --%>
            <asp:HiddenField ID="hdnDistance" runat="server" />

        </div>

        <!-- RIGHT: MAP -->
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

<!-- GOOGLE MAPS -->
    <script>
        let map, pickupMarker, dropoffMarker, directionsRenderer;
        let clickStep = 1;

        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: 33.8938, lng: 35.5018 }, // Beirut
                zoom: 13,
                styles: [
                    { elementType: 'geometry', stylers: [{ color: '#1a1a1a' }] },
                    { elementType: 'labels.text.fill', stylers: [{ color: '#F5C300' }] },
                    { elementType: 'labels.text.stroke', stylers: [{ color: '#1a1a1a' }] },
                    { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#2a2a2a' }] },
                    { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#0f0f0f' }] }
                ]
            });

            // Directions renderer (reused so old route gets replaced)
            directionsRenderer = new google.maps.DirectionsRenderer({
                map: map,
                suppressMarkers: true,
                polylineOptions: { strokeColor: '#ff4444', strokeWeight: 4, strokeOpacity: 0.9 }
            });

            // Click on map to set pickup/dropoff
            map.addListener('click', function (e) {
                const lat = e.latLng.lat();
                const lng = e.latLng.lng();

                if (clickStep === 1) {
                    if (pickupMarker) pickupMarker.setMap(null);
                    pickupMarker = new google.maps.Marker({
                        position: e.latLng, map: map,
                        icon: { path: google.maps.SymbolPath.CIRCLE, scale: 10, fillColor: '#F5C300', fillOpacity: 1, strokeColor: '#fff', strokeWeight: 2 },
                        title: 'Pickup'
                    });
                    document.getElementById('<%= hdnPickupLat.ClientID %>').value = lat;
                document.getElementById('<%= hdnPickupLng.ClientID %>').value = lng;
                document.getElementById('<%= txtPickup.ClientID %>').value = lat.toFixed(5) + ', ' + lng.toFixed(5);
                clickStep = 2;

            } else {
                if (dropoffMarker) dropoffMarker.setMap(null);
                dropoffMarker = new google.maps.Marker({
                    position: e.latLng, map: map,
                    icon: { path: google.maps.SymbolPath.CIRCLE, scale: 10, fillColor: '#ff4444', fillOpacity: 1, strokeColor: '#fff', strokeWeight: 2 },
                    title: 'Dropoff'
                });
                document.getElementById('<%= hdnDropoffLat.ClientID %>').value = lat;
                document.getElementById('<%= hdnDropoffLng.ClientID %>').value = lng;
                document.getElementById('<%= txtDropoff.ClientID %>').value = lat.toFixed(5) + ', ' + lng.toFixed(5);
                drawRoute(pickupMarker.getPosition(), dropoffMarker.getPosition());
                clickStep = 1;
            }
        });

        // Auto route when user TYPES in the text boxes
        document.getElementById('<%= txtPickup.ClientID %>').addEventListener('change', searchAndRoute);
        document.getElementById('<%= txtDropoff.ClientID %>').addEventListener('change', searchAndRoute);
    }

    // Search addresses and draw route
    function searchAndRoute() {
        const pickup = document.getElementById('<%= txtPickup.ClientID %>').value;
        const dropoff = document.getElementById('<%= txtDropoff.ClientID %>').value;

        if (!pickup || !dropoff) return;

        const geocoder = new google.maps.Geocoder();

        geocoder.geocode({ address: pickup }, function (pickupResults, pickupStatus) {
            if (pickupStatus === 'OK') {
                const pickupPos = pickupResults[0].geometry.location;

                if (pickupMarker) pickupMarker.setMap(null);
                pickupMarker = new google.maps.Marker({
                    position: pickupPos, map: map,
                    icon: { path: google.maps.SymbolPath.CIRCLE, scale: 10, fillColor: '#F5C300', fillOpacity: 1, strokeColor: '#fff', strokeWeight: 2 }
                });

                document.getElementById('<%= hdnPickupLat.ClientID %>').value = pickupPos.lat();
                document.getElementById('<%= hdnPickupLng.ClientID %>').value = pickupPos.lng();

                geocoder.geocode({ address: dropoff }, function (dropoffResults, dropoffStatus) {
                    if (dropoffStatus === 'OK') {
                        const dropoffPos = dropoffResults[0].geometry.location;

                        if (dropoffMarker) dropoffMarker.setMap(null);
                        dropoffMarker = new google.maps.Marker({
                            position: dropoffPos, map: map,
                            icon: { path: google.maps.SymbolPath.CIRCLE, scale: 10, fillColor: '#ff4444', fillOpacity: 1, strokeColor: '#fff', strokeWeight: 2 }
                        });

                        document.getElementById('<%= hdnDropoffLat.ClientID %>').value = dropoffPos.lat();
                        document.getElementById('<%= hdnDropoffLng.ClientID %>').value = dropoffPos.lng();

                        drawRoute(pickupPos, dropoffPos);

                        // Zoom to fit both markers
                        const bounds = new google.maps.LatLngBounds();
                        bounds.extend(pickupPos);
                        bounds.extend(dropoffPos);
                        map.fitBounds(bounds);
                    }
                });
            }
        });
    }

    // Draw red route line
    function drawRoute(origin, destination) {
        const service = new google.maps.DirectionsService();

        service.route({ origin, destination, travelMode: 'DRIVING' }, function (result, status) {
            if (status === 'OK') {
                directionsRenderer.setDirections(result);
                const dist = result.routes[0].legs[0].distance.value / 1000;
                document.getElementById('<%= hdnDistance.ClientID %>').value = dist.toFixed(2);
                const price = (dist * 2.5).toFixed(2);
                document.getElementById('<%= lblPrice.ClientID %>').innerText = '$' + price;
            }
        });
        }
    </script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCJPd-KO_XvRZ4nLO_WsvsTHpMvoB9S7qk&callback=initMap" async defer></script>

</body>
</html>