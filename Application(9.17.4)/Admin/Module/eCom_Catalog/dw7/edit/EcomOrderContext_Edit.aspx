<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderContext_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderContext_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

    <script type="text/javascript">
        var contexts = <%=ExistingOrderContexts%>;

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function saveOrderContext(close) {
            $("Close").value = close ? 1 : 0;
            $('Form1').SaveButton.click();
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" runat="server">
            <dwc:GroupBox runat="server" Title="Order context">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label for="IdStr"><dw:TranslateLabel ID="tLabelId" runat="server" Text="Id" /></label>
                        </td>
                        <td>
                            <asp:TextBox ID="IdStr" Enabled="false" CssClass="std" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="NameStr"><dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" /></label>
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" MaxLength="255" CssClass="std" runat="server" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelShops" runat="server" Text="Shops" />
                        </td>
                        <td>
                            <dwc:CheckBoxGroup ID="ShopList" runat="server"></dwc:CheckBoxGroup>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <input id="Close" type="hidden" name="Close" value="0" />
        </form>
    </div>
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>

</body>
</html>
