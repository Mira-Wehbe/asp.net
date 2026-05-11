<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarForm.aspx.cs" Inherits="Taxi_Project.CarForm" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Car Form</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #0f0f0f;
            display: flex;
            justify-content: center;
            padding: 60px 20px;
        }

        .card {
            width: 520px;
            background: #1a1a1a;
            border-radius: 28px;
            border: 1px solid rgba(245,195,0,0.15);
            padding: 2.2rem;
        }

        .logo {
            text-align: center;
            margin-bottom: 2rem;
            color: #F5C300;
            font-family: 'Bebas Neue';
            font-size: 28px;
        }

        .heading {
            text-align: center;
            color: white;
            font-size: 28px;
            font-weight: 700;
        }

        .heading span {
            color: #F5C300;
        }

        .field {
            margin-top: 15px;
        }

        label {
            font-size: 12px;
            color: #888;
        }

        .asp-input {
            width: 100%;
            height: 50px;
            background: #111;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 10px;
            color: white;
            margin-top: 5px;
        }

        .btn {
            width: 100%;
            height: 52px;
            margin-top: 20px;
            background: #F5C300;
            border: none;
            border-radius: 14px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

<div class="card">

    <div class="logo">YALLA TAXI</div>

    <p class="heading">Add <span>Car</span></p>

    <!-- Plate -->
    <div class="field">
        <label>Plate Number</label>
        <asp:TextBox ID="txtPlateNumber" runat="server" CssClass="asp-input" />
    </div>

    <!-- Model -->
    <div class="field">
        <label>Model</label>
        <asp:TextBox ID="txtModel" runat="server" CssClass="asp-input" />
    </div>

    <!-- Car Type -->
    <div class="field">
        <label>Car Type</label>
        <asp:DropDownList ID="ddlCarType" runat="server" CssClass="asp-input">
            <asp:ListItem Text="Select Type" Value="" />
            <asp:ListItem Text="Standard" Value="Standard" />
            <asp:ListItem Text="Business" Value="Business" />
            <asp:ListItem Text="Van" Value="Van" />
        </asp:DropDownList>
    </div>

    <!-- Rate -->
    <div class="field">
        <label>Rate Per KM</label>
        <asp:TextBox ID="txtRatePerKm" runat="server" CssClass="asp-input" />
    </div>

    <!-- Active -->
    <div class="field">
        <label>
            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
            Active
        </label>
    </div>

    <!-- Button -->
    <asp:Button ID="btnSaveCar" runat="server" Text="Save Car →" CssClass="btn"
        OnClick="btnSaveCar_Click" />

</div>

</form>

</body>
</html>
