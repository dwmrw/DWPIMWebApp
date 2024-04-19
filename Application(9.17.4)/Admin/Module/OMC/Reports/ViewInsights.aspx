<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewInsights.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Reports.ViewInsights" EnableViewState="false" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Translate.Translate("Insights") %></title>
    <dwc:ScriptLib runat="server">
        <script src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    </dwc:ScriptLib>
    <script type="text/javascript">
        function showFilters() {
            dialog.show('dlgFilters');
        }

        function applyFilters() {
            dialog.hide('dlgFilters');
            postChange();
        }

        function postChange() {
            showSpinner();
            var form = document.getElementById('form1');
            form.submit()
        }

        function showSpinner() {
            new overlay('spinner').show();
        }
    </script>
    <style>
        .card .card-body {
            padding-top: 0px;
            padding-left: 5px;
        }

        .ct-tools-text{
            vertical-align: middle;
        }

        #dashboard-iframe{
            height: calc(100vh - 70px);
        }
    </style>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server">
                <div class="ct-tools">
                    <button type="button" class="btn btn-flat waves-effect" id="cmdFilters" onclick="showFilters();"><%=KnownIconInfo.GetIconHtml(KnownIcon.CalendarO)%> <asp:Literal ID="litSelectedPeriod" runat="server" /></button>
                    <span class="ct-tools-text"><asp:Literal ID="litComparisonPeriod" runat="server" /></span>
                </div>
            </dwc:CardHeader>
            <dwc:CardBody runat="server">
                <div id="dashboard-container">
                    <iframe name="dashboardframe" id="dashboard-iframe" src="<%= GetInsightsDashboardUrl() %>"></iframe>
                </div>
            </dwc:CardBody>
        </dwc:Card>

        <dw:Dialog ID="dlgFilters" Title="Date range" Size="Medium" OkAction="applyFilters();" ShowOkButton="true" ShowCancelButton="true" runat="server">
            <dw:AddInConfigurator runat="server" ID="insightWidgetFilters"></dw:AddInConfigurator>
        </dw:Dialog>
    </form>
    <dw:Overlay runat="server" id="spinner"></dw:Overlay>
</body>
</html>
