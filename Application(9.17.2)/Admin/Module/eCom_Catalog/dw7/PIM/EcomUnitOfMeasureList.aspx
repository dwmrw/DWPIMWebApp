<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomUnitOfMeasureList.aspx.vb" Inherits="Dynamicweb.Admin.EcomUnitOfMeasureList" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function UnitOfMeasureListPage(options) {
            let dialogId = "ProductUnitsDialog";
            function getSelectedRows() {
                return List.getSelectedRows('UnitOfMeasureList');
            }

            function getSelectedRowId() {
                return ContextMenu.callingItemID;
            }

            function executeCommand(cmd, ids) {
                if (ids) {
                    document.getElementById('cmd').value = cmd;
                    document.getElementById('rowIds').value = ids;
                    WaterMark.hideAll();
                    form1.submit();
                }
            }

            var api = {
                initialize: function (options) {
                    this.options = options;
                    this.productId = options.ProductId;
                    this.variantId = options.VariantId;
                    this.languageId = options.LanguageId;
                    this.labels = options.Labels;
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, this.labels.listDialogTitle);
                    }
                    if (options.BaseRowId > 0) {
                        let baseRow = List.getRowByID('UnitOfMeasureList', 'row' + options.BaseRowId);
                        if (baseRow) {
                            let checkbox = baseRow.select('input[type="checkbox"]');
                            if (checkbox && checkbox.length > 0) {
                                checkbox[0].setAttribute("disabled", "disabled");
                            }
                        }
                    }
                },
                add: function () {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, this.labels.createItemDialogTitle);
                    }
                    location.href = 'EcomUnitOfMeasureEdit.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId;
                },
                edit: function (id) {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.setTitle(dialogId, this.labels.editItemDialogTitle);
                    }
                    if (!id) id = getSelectedRowId();
                    location.href = 'EcomUnitOfMeasureEdit.aspx?productId=' + this.productId + '&variantId=' + this.variantId + '&languageId=' + this.languageId + '&AutoId=' + id;
                },
                delete: function (id) {
                    if (confirm(this.labels.deleteMessage)) {
                        if (!id) id = getSelectedRowId();
                        executeCommand('delete', id);
                    }
                },
                deleteSelected: function () {
                    if (confirm(this.labels.deleteMessage)) {
                        let rows = getSelectedRows();
                        if (rows.length > 0) {
                            let ids = rows.map(function (row) { return row.getAttribute('itemid'); })
                            executeCommand('delete', ids.join(','));
                        }
                    }
                },
                onRowSelected: function () {
                    if (this.options.deletePermitted) {
                        let rows = getSelectedRows();

                        if (rows.length > 0) {
                            document.getElementById('cmdDelete').disabled = false;
                        }
                        else {
                            document.getElementById('cmdDelete').disabled = true;
                        }
                    }
                },
                cancel: function () {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.hide(dialogId);
                    }
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
        <input type="hidden" id="rowIds" name="rowIds" />
        <dwc:Card runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Icon="Cancel" Text="Cancel" OnClientClick="currentPage.cancel()" />
                <dw:ToolbarButton ID="cmdAdd" runat="server"  Icon="PlusSquare" Text="New unit of measure" OnClientClick="currentPage.add()" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Remove" Text="Delete unit of measure" OnClientClick="currentPage.deleteSelected()" Disabled="true" />
            </dw:Toolbar>

            <dw:List ID="UnitOfMeasureList" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25" OnClientSelect="currentPage.onRowSelected();">
                <Filters>
                    <dw:ListAutomatedSearchFilter ID="SearchFilter" runat="server" />
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colUnit" runat="server" Name="Unit of measure" EnableSorting="true" />
                    <dw:ListColumn ID="colQuantity" runat="server" Name="Qty. per unit of measure" EnableSorting="true" />
                    <dw:ListColumn ID="colIsDefault" runat="server" Name="Base unit of measure" EnableSorting="true" />
                </Columns>
            </dw:List>
        </dwc:Card>

        <dw:ContextMenu ID="UnitContextMenu" runat="server">
            <dw:ContextMenuButton ID="editButton" runat="server" Icon="Pencil" Text="Edit" OnClientClick="currentPage.edit();" />
            <dw:ContextMenuButton ID="deleteButton" runat="server" Icon="Delete" Text="Delete" OnClientClick="currentPage.delete();" />
        </dw:ContextMenu>

        <dw:ContextMenu ID="BaseUnitContextMenu" runat="server">
            <dw:ContextMenuButton ID="editBaseButton" runat="server" Icon="Pencil" Text="Edit" OnClientClick="currentPage.edit();" />
        </dw:ContextMenu>
    </form>
</body>
</html>

