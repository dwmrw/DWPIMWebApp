<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EndpointAuthorization.aspx.vb" Inherits="Dynamicweb.Admin.EndpointAuthorization" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false" IncludeScriptaculous="false" IncludePrototype="false">
    </dw:ControlResources>
    <title></title>
    <asp:Literal runat="server" ID="SetterBlock"></asp:Literal>
</head>
<body class="screen-container">
    <div class="card">
        <form id="AuthenticationForm" runat="server" enableviewstate="false">
            <dw:Infobar runat="server" ID="errorBar" Visible="false" />
            <dwc:Card runat="server">
                <dwc:CardBody runat="server">
                    <dw:GroupBox runat="server" Title="OAuth2 authentication result:" ID="GroupBox1" DoTranslation="false">
                        <div>
                            <asp:Literal runat="server" ID="ResultMessage"></asp:Literal>
                        </div>
                    </dw:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
</body>
</html>
