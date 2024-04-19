<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomUnitOfMeasureEdit.aspx.vb" Inherits="Dynamicweb.Admin.EcomUnitOfMeasureEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function UnitOfMeasureEditPage(options) {
            function executeCommand(cmd) {
                document.getElementById('cmd').value = cmd;
                form1.submit();
            }

            var api = {
                initialize: function (options) {
                    this.productId = options.ProductId;
                    this.variantId = options.VariantId;
                    this.languageId = options.LanguageId;
                    this.labels = options.Labels;
                },
                save: function (close) {
                    document.getElementById('close').value = close;
                    executeCommand('save');
                },
                delete: function () {
                    if (confirm(this.labels.deleteMessage)) {
                        executeCommand('delete');
                    }
                },
                cancel: function () {
                    location.href = 'EcomUnitOfMeasureList.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId;
                }
            }

            api.initialize(options);
            return api;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="cmd" name="cmd" />
        <input type="hidden" id="close" name="close" />
        <asp:HiddenField ID="SavedAutoId" runat="server" />
        <dwc:Card runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Icon="Save" Text="Save" OnClientClick="currentPage.save(false)" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Icon="Save" Text="Save and close" OnClientClick="currentPage.save(true)" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Remove" Text="Delete unit of measure" OnClientClick="currentPage.delete()" Disabled="true" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Icon="Cancel" IconColor="Danger" Text="Cancel" OnClientClick="currentPage.cancel()" />
            </dw:Toolbar>
            <dwc:GroupBox Title="General" runat="server">
                <dwc:SelectPicker ID="UnitSelectPicker" runat="server" Label="Unit"></dwc:SelectPicker>
                <dwc:InputNumber ID="QuantityPerUnitNumber" runat="server" Label="Quantity per unit" Min="0" IncrementSize="0.1"></dwc:InputNumber>
                <dwc:CheckBox ID="IsBaseUnitCheck" runat="server" Label="Base unit of measure" />
            </dwc:GroupBox>
        </dwc:Card>
    </form>
</body>
</html>

