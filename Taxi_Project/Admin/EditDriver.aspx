<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditDriver.aspx.cs" Inherits="Taxi_Project.Admin.EditDriver" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Edit Driver</title>

    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0f0f0f;
            display: flex;
            justify-content: center;
            padding: 60px;
        }

        .card {
            width: 500px;
            background: #1a1a1a;
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(245,195,0,0.2);
        }

        .title {
            color: #F5C300;
            text-align: center;
            font-size: 28px;
            margin-bottom: 20px;
            font-family: 'Bebas Neue';
        }

        label {
            color: #aaa;
            font-size: 12px;
        }

        .input {
            width: 100%;
            height: 45px;
            margin-top: 5px;
            margin-bottom: 15px;
            padding: 10px;
            background: #111;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 10px;
            color: white;
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
    </style>
</head>

<body>

<form id="form1" runat="server">

<div class="card">

    <div class="title">Edit Driver</div>

    <label>Full Name</label>
    <asp:TextBox ID="txtFullName" runat="server" CssClass="input" />

    <label>Phone</label>
    <asp:TextBox ID="txtPhone" runat="server" CssClass="input" />

    <label>Gender</label>
    <asp:DropDownList ID="ddlGender" runat="server" CssClass="input">
        <asp:ListItem Text="Male" Value="Male" />
        <asp:ListItem Text="Female" Value="Female" />
    </asp:DropDownList>

    <label>
        <asp:CheckBox ID="chkIsAvailable" runat="server" />
        Available
    </label>

    <asp:Button ID="btnSaveDriver" runat="server"
        Text="Update Driver"
        CssClass="btn"
        OnClick="btnSaveDriver_Click" />

</div>

</form>

</body>
</html>