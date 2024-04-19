<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditEndpointAuthentication.aspx.vb" Inherits="Dynamicweb.Admin.EditEndpointAuthentication" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false" IncludeScriptaculous="false" IncludePrototype="false">
    </dw:ControlResources>
    <script src="/Admin/Resources/js/layout/dwglobal.js" type="text/javascript"></script>
    <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>
    <script type="text/javascript">
        var required = '<%=Translate.JsTranslate("required")%>';
        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("EditEndpointAuthentication", close ? "close" : "")
        }

        isValid = function () {            
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            var el = document.getElementById("txtName");
            if (!el.value) {
                dwGlobal.showControlErrors("txtName", required);
                result = false;
            }            
            var selectBox = $('Dynamicweb.DataIntegration.EndpointManagement.BaseEndpointAuthenticationAddIn_AddInTypes');
            if (selectBox != null) {
                var selected = selectBox.options[selectBox.selectedIndex].value;
                if (selected.startsWith("Dynamicweb.DataIntegration.EndpointManagement.AuthenticationAddIns.OAuth2") ||
                    selected.indexOf("UserImpersonationEndpointAuthenticationAddIn") > 0 ||
                    selected.indexOf("S2SEndpointAuthenticationAddIn") > 0) {
                    var el = document.getElementById("Tenant_Id");
                    if (el == null)
                        el = document.getElementById("Directory_(tenant)_Id");                    
                    if (!el.value) {
                        dwGlobal.showControlErrors(el.id, required);
                        el.parentElement.innerHTML += "<small class=\"help-block error\" id=\"help" + el.id + "\">" + required + "</small>";
                        result = false;
                    }
                    el = document.getElementById("Client_Id");
                    if (el == null)
                        el = document.getElementById("Application_(client)_Id");
                    if (!el.value) {
                        dwGlobal.showControlErrors(el.id, required);
                        el.parentElement.innerHTML += "<small class=\"help-block error\" id=\"help" + el.id + "\"> " + required + "</small> ";
                        result = false;
                    }
                    el = document.getElementById("Client_Secret");
                    if (!el.value) {
                        dwGlobal.showControlErrors("Client_Secret", required);
                        el.parentElement.innerHTML += "<small class=\"help-block error\" id=\"helpClient_Secret\">" + required + "</small>";
                        result = false;
                    }
                    if (selected.endsWith("OAuth2CrmEndpointAuthenticationAddIn") || selected.endsWith("UserImpersonationEndpointAuthenticationAddIn")) {
                        el = document.getElementById("URL");
                        if (!el.value) {
                            dwGlobal.showControlErrors("URL", required);
                            el.parentElement.innerHTML += "<small class=\"help-block error\" id=\"helpClient_Secret\">" + required + "</small>";
                            result = false;
                        }
                    }
                }
            }
            return result;
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditEndpointAuthenticationForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            Action.Execute({
                Name: "OpenScreen",
                Url: "<%= GetBackUrl() %>"
            });
        }

        deleteAuthentication = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this authentication?")%>')) {
                initiatePostBack('RemoveEndpointAuthentication', "");
            }
        }

        function onSuccess(code, id) {
            document.getElementById("AuthorizationCode").value = code;
            if (id != null) {
                document.getElementById("AuthenticationId").value = id;
            }
            document.getElementById("EditEndpointAuthenticationForm").submit();
        }

        function onError(error) {
            var warningBar = $("InfoBar_errorBar");
            if (warningBar != null) {
                var errorContainer = warningBar.select(".alert-container")[0];
                var alertIcon = errorContainer.select('i')[0].outerHTML;
                errorContainer.innerHTML = alertIcon + ' ' + error;
                warningBar.show();
            }
        }

        function copyUrl() {
            copyToClipboard(document.getElementById("OAuth2Url").value);
        }

        function copyToClipboard(textToCopy) {
            if (navigator.clipboard && window.isSecureContext) {
                return navigator.clipboard.writeText(textToCopy);
            } else {
                let textArea = document.createElement("textarea");
                textArea.value = textToCopy;
                textArea.style.position = "fixed";
                textArea.style.left = "-999999px";
                textArea.style.top = "-999999px";
                document.body.appendChild(textArea);
                textArea.focus();
                textArea.select();
                return new Promise((res, rej) => {
                    document.execCommand('copy') ? res() : rej();
                    textArea.remove();
                });
            }
        }
    </script>
    <style type="text/css">
        .form-control.copyUrl{
            width: 80% !important;
        }
        .btn.copyUrl{
            width: 19%; height: 33px; vertical-align: bottom;
        }
    </style>
</head>
<body class="screen-container">
    <form id="EditEndpointAuthenticationForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Edit authentication"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ editSave(false); }}" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ editSave(true); }}" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" Icon="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteAuthentication()" Text="Delete" Visible="False" />
            </dw:Toolbar>
            <dw:Infobar runat="server" ID="errorBar" Visible="false" />
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Authentication information" ID="GroupBox1">
                    <dw:Infobar Type="Error" ID="authProviderError" runat="server" Visible="false"></dw:Infobar>
                    <div class="form-group" runat="server" id="rowId" visible="false">
                        <label class="control-label"><%=Translate.Translate("Id")%></label>
                        <div>
                            <asp:Literal ID="lblId" runat="server" />
                        </div>
                    </div>
                    <dwc:InputText ID="txtName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                    <asp:Literal ID="authTypeSelectorScripts" runat="server"></asp:Literal>
                    <dw:AddInSelector ID="authTypeSelector" runat="server" UseLabelAsName="True" AddInTypeName="Dynamicweb.DataIntegration.EndpointManagement.BaseEndpointAuthenticationAddIn" AddInShowFieldset="false" AddInShowNothingSelected="false" />
                    <asp:Literal ID="authTypeSelectorLoadScript" runat="server"></asp:Literal>
                    <div class="form-group" runat="server" id="OAuth2AuthorizationUrlDiv" visible="false">
                        <div class="dw-ctrl textbox-ctrl form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Authorization url" />
                            </label>
                            <div class="form-group-input">
                                <input class="form-control copyUrl" type="text" id="OAuth2Url" name="OAuth2Url" runat="server" autocomplete="off" disabled="disabled" />
                                <input name="copyUrlBtn" type="button" id="copyUrlBtn" class="btn copyUrl" value="Copy" onclick="copyUrl();" />
                            </div>
                        </div>
                    </div>
                </dw:GroupBox>
                <asp:HiddenField ID="PostBackAction" runat="server" />
                <asp:HiddenField ID="hdBackUrl" runat="server" />
                <asp:HiddenField ID="AuthorizationCode" runat="server" />
                <asp:HiddenField ID="AuthenticationId" runat="server" />
            </dwc:CardBody>
        </dwc:Card>
    </form>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
