<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NewOrderReportPOC.aspx.vb" Inherits="Dynamicweb.Admin.NewOrderReportPOC" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib"></dwc:ScriptLib>
    <style>
        .results-table {
            width: 100%;
        }
        
        .summary-table {
            min-width: 50%;
        }

        tr, td, th {
            border: 1px solid black;
        }

        td {
            padding: 2px 5px;
        }

        thead td {
            font-weight: bold;
            text-transform: uppercase;
        }
    </style>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="New Order Report POC"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" Title="Settings">
                    <dw:DateSelector ID="FromDate" runat="server" AllowNeverExpire="false" AllowNotSet="false" IncludeTime="False" Label="From date" />
                    <dw:DateSelector ID="ToDate" runat="server" AllowNeverExpire="false" AllowNotSet="false" IncludeTime="False" Label="To date" />
                    <dwc:CheckBox ID="DoCompare" runat="server" Label="Compare to previous dates" />
                    <dwc:SelectPicker ID="CompareWith" runat="server" Label="Compare to">
                        <asp:ListItem Text="Previous period" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Previous year" Value="1"></asp:ListItem>
                    </dwc:SelectPicker>

                    <dwc:SelectPicker ID="CurrencySelector" runat="server" Label="Currency"></dwc:SelectPicker>

                    <dwc:Button runat="server" OnClick="document.forms[0].submit()" Title="Show report" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Report result" ID="ReportGroupBox">
                    <asp:Literal ID="TotalOrders" runat="server"></asp:Literal>
                    <br />
                    <table class="results-table">
                        <thead>
                            <asp:Literal ID="TableHeader" runat="server"></asp:Literal>
                        </thead>
                        <tbody>
                            <asp:Literal ID="TableBody" runat="server"></asp:Literal>
                        </tbody>
                    </table>
                    <br />

                    <table class="summary-table">
                        <thead>
                            <asp:Literal ID="SummaryHeader" runat="server"></asp:Literal>
                        </thead>
                        <tbody>
                            <asp:Literal ID="SummaryBody" runat="server"></asp:Literal>
                        </tbody>
                    </table>
                    <br />

                    <asp:Literal runat="server" ID="EcomOrdersRowsCount"></asp:Literal>
                    <br />
                    <asp:Literal runat="server" ID="Milliseconds"></asp:Literal>
                </dwc:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
    </form>
</body>
</html>
