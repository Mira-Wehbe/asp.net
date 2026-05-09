<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Taxi_Project.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body {
            font-family: 'Inter', sans-serif;
            background: #0f0f0f;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }

        .bg-text {
            position: fixed;
            font-family: 'Bebas Neue', sans-serif;
            font-size: 260px;
            color: rgba(245,195,0,0.04);
            letter-spacing: -10px;
            user-select: none;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            white-space: nowrap;
            z-index: 0;
        }

        .circle-glow {
            position: fixed;
            width: 600px;
            height: 600px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(245,195,0,0.08) 0%, transparent 65%);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 0;
        }

        .grid {
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(245,195,0,0.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(245,195,0,0.04) 1px, transparent 1px);
            background-size: 50px 50px;
            z-index: 0;
        }

        .card {
            position: relative;
            z-index: 10;
            width: 420px;
            background: #1a1a1a;
            border-radius: 28px;
            border: 1px solid rgba(245,195,0,0.15);
            padding: 2.8rem;
        }

        .logo-row {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2rem;
        }

        .logo-badge {
            background: #F5C300;
            border-radius: 10px;
            padding: 6px 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .logo-badge span {
            font-family: 'Bebas Neue', sans-serif;
            font-size: 22px;
            color: #111;
            letter-spacing: 2px;
        }

        .logo-sep {
            width: 2px;
            height: 22px;
            background: #111;
            opacity: 0.3;
        }

        .heading {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            text-align: center;
            margin-bottom: 4px;
        }

        .heading span { color: #F5C300; }

        .subheading {
            font-size: 14px;
            color: #555;
            text-align: center;
            margin-bottom: 2rem;
        }

        .tabs {
            display: flex;
            background: #111;
            border-radius: 14px;
            padding: 4px;
            margin-bottom: 2rem;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .tab {
            flex: 1;
            height: 38px;
            border: none;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            background: transparent;
            color: #555;
        }

        .tab.active {
            background: #F5C300;
            color: #111;
            font-weight: 700;
        }

        .field { margin-bottom: 1.1rem; }

        .field label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #555;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .input-wrap { position: relative; }

        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 15px;
            color: #444;
        }

        .input-wrap input {
            width: 100%;
            height: 50px;
            background: #111;
            border: 1.5px solid rgba(255,255,255,0.07);
            border-radius: 12px;
            padding: 0 16px 0 44px;
            font-size: 14px;
            color: #fff;
            outline: none;
        }

        .input-wrap input::placeholder { color: #444; }

        .input-wrap input:focus { border-color: #F5C300; }

        .row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0.6rem 0 1.6rem;
        }

        .stay {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            color: #555;
            cursor: pointer;
        }

        .forgot {
            font-size: 13px;
            color: #F5C300;
            font-weight: 500;
            cursor: pointer;
        }

        .btn {
            width: 100%;
            height: 52px;
            background: #F5C300;
            color: #111;
            border: none;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            letter-spacing: 0.5px;
        }

        .btn:hover { background: #ffd000; }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 1.4rem 0;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.07);
        }

        .divider-text {
            font-size: 12px;
            color: #444;
        }

        .register-link {
            text-align: center;
            font-size: 13px;
            color: #555;
        }

        .register-link a {
            color: #F5C300;
            font-weight: 600;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="bg-text">YALLA</div>
<div class="circle-glow"></div>
<div class="grid"></div>

<form id="form1" runat="server">

    <div class="card">

        <!-- LOGO -->
        <div class="logo-row">
            <div class="logo-badge">
                <span>YALLA</span>
                <div class="logo-sep"></div>
                <span>TAXI</span>
            </div>
        </div>

        <p class="heading">Welcome <span>back.</span></p>
        <p class="subheading">Your next ride is one tap away</p>

        <!-- TABS -->
        <div class="tabs">
            <button type="button" class="tab active" onclick="window.location='Login.aspx'">Sign in</button>
            <button type="button" class="tab" onclick="window.location='Register.aspx'">Register</button>
        </div>

        <!-- ERROR -->
        <asp:Label ID="lblError" runat="server" Visible="false" />
        <!-- C# USE: lblError.Text / lblError.Visible -->

        <!-- EMAIL -->
        <div class="field">
            <label>Email</label>
            <div class="input-wrap">
                <span class="input-icon">✉</span>

                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
                <!-- C# USE: txtEmail.Text -->
            </div>
        </div>

        <!-- PASSWORD -->
        <div class="field">
            <label>Password</label>
            <div class="input-wrap">
                <span class="input-icon">🔒</span>

                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                <!-- C# USE: txtPassword.Text -->
            </div>
        </div>

        <!-- OPTIONS -->
        <div class="row">
            <label class="stay">
                <input type="checkbox" />
                Stay signed in
            </label>

            <span class="forgot">Forgot password?</span>
        </div>

        <!-- BUTTON -->
        <asp:Button ID="btnLogin" runat="server" Text="Continue →" CssClass="btn" OnClick="btnLogin_Click" />
        <!-- C# USE: btnLogin_Click -->

        <!-- DIVIDER -->
        <div class="divider">
            <div class="divider-line"></div>
            <span class="divider-text">or</span>
            <div class="divider-line"></div>
        </div>

        <!-- REGISTER -->
        <p class="register-link">
            Don't have an account? <a href="Register.aspx">Register now</a>
        </p>

    </div>

</form>

</body>
</html>