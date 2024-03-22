<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomStockLocationCategory_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomStockLocationCategory_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/FormValidation.js" />
        </Items>
    </dw:ControlResources>

    <script>
        function save(close) {
            document.getElementById("Close").value = close ? "1" : "0";
            console.log(document.getElementById("Close").value);
            document.getElementById('form1').SaveButton.click();
        }

        function remove() {
            var deleteMessage = '<%= Translate.JsTranslate("Do you want to delete the selected stock location category?")%>';
            if (confirm(deleteMessage)) {
                document.getElementById('form1').DeleteButton.click();
            }
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <dwc:GroupBox runat="server" Title="Stock location category">
                    <dwc:InputText ID="NameText" Label="Name" runat="server" />
                    <dwc:InputTextArea ID="DescriptionText" Label="Description" runat="server" />
                </dwc:GroupBox>

                <input id="Close" type="hidden" name="Close" runat="server" />
                <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
                <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>
            </form>
        </dwc:CardBody>
    </dwc:Card>

    <script>
        $(document).observe('dom:loaded', function () {
            addMinLengthRestriction('NameText', 1, '<%=EmptyNameMessage%>');
            activateValidation('form1');
            document.getElementById('NameText').focus();
        });
    </script>
</body>
</html>
