<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCar.aspx.cs" Inherits="Taxi_Project.Admin.EditCar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Edit Car</title>

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
            align-items: center;
            min-height: 100vh;
        }

        .card {
            width: 520px;
            background: #1a1a1a;
            border-radius: 24px;
            padding: 2rem;
            border: 1px solid rgba(245,195,0,0.2);
        }

        .title {
            text-align: center;
            color: #fff;
            font-size: 28px;
            margin-bottom: 20px;
        }

        .title span {
            color: #F5C300;
        }

        label {
            font-size: 12px;
            color: #aaa;
        }

        .input {
            width: 100%;
            height: 48px;
            margin-top: 6px;
            margin-bottom: 14px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.1);
            background: #111;
            color: #fff;
            padding: 10px;
        }

        .btn {
            width: 100%;
            height: 50px;
            background: #F5C300;
            border: none;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover {
            background: #ffd500;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

<div class="card">

    <div class="title">Edit <span>Car</span></div>

    <label>Plate Number</label>
    <asp:TextBox ID="txtPlateNumber" runat="server" CssClass="input" />

    <label>Model</label>
    <asp:TextBox ID="txtModel" runat="server" CssClass="input" />

    <label>Car Type</label>
    <asp:DropDownList ID="ddlCarType" runat="server" CssClass="input">
        <asp:ListItem Text="Standard" Value="Standard" />
        <asp:ListItem Text="Business" Value="Business" />
        <asp:ListItem Text="Van" Value="Van" />
    </asp:DropDownList>

    <label>Rate Per KM</label>
    <asp:TextBox ID="txtRatePerKm" runat="server" CssClass="input" />

    <label>
        <asp:CheckBox ID="chkIsActive" runat="server" /> Active
    </label>

    <br /><br />

    <asp:Button ID="btnSaveCar" runat="server" Text="Edit Car" CssClass="btn"
        OnClick="btnSaveCar_Click" />

</div>

</form>

</body>
</html>