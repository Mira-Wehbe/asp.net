<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DriverForm.aspx.cs" Inherits="Taxi_Project.Admin.DriverForm" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yalla Taxi – Driver Form</title>

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

    <p class="heading">Add <span>Driver</span></p>

    <!-- Full Name -->
    <div class="field">
        <label>Full Name</label>
        <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-input" />
    </div>

    <!-- Phone -->
    <div class="field">
        <label>Phone</label>
        <asp:TextBox ID="txtPhone" runat="server" CssClass="asp-input" />
    </div>

    <!-- Gender -->
    <div class="field">
        <label>Gender</label>
        <asp:DropDownList ID="ddlGender" runat="server" CssClass="asp-input">
            <asp:ListItem Text="Select Gender" Value="" />
            <asp:ListItem Text="Male" Value="Male" />
            <asp:ListItem Text="Female" Value="Female" />
        </asp:DropDownList>
    </div>

  

    <!-- Available -->
    <div class="field">
        <label>
            <asp:CheckBox ID="chkIsAvailable" runat="server" Checked="true" />
            Available
        </label>
    </div>

    <!-- Button -->
    <asp:Button ID="btnSaveDriver" runat="server" Text="Save Driver →"
        CssClass="btn" OnClick="btnSaveDriver_Click" />

</div>

</form>

</body>
</html>