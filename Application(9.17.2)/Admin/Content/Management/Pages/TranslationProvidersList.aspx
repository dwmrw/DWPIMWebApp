<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TranslationProvidersList.aspx.vb" Inherits="Dynamicweb.Admin.TranslationProvidersList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        class TranslationProvidersListPage {
            constructor(opts) {
                this.options = opts;
            }

            createTranslationProvider() {
                Action.Execute(this.options.actions.edit, { id: "" });
            }

            editTranslationProvider(evt, translationProviderId) {
                Action.Execute(this.options.actions.edit, { TranslationProviderId: translationProviderId });
            }

            deleteTranslationProvider(evt, rowID) {
                evt.stopPropagation();
                var translationProviderIds = [];
                let row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                let confirmStr = row.children[0].innerText ? row.children[0].innerText : row.children[0].innerHTML;
                confirmStr = confirmStr.replace('&nbsp;', "");
                confirmStr = confirmStr.replace('&qout;', "");
                translationProviderIds.push(rowID);
                confirmStr = "\'" + confirmStr + "\'";
                Action.Execute(this.options.actions.delete, {
                    ids: translationProviderIds,
                    names: confirmStr
                });
            }
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="TranslationProviders" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New translationProvider" runat="server" OnClientClick="currentPage.createTranslationProvider();" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstTranslationProvidersList" AllowMultiSelect="false" HandleSortingManually="false" ShowPaging="false" ShowTitle="false" PageSize="2000" NoItemsMessage="No translation providers found">
                    <Columns>
                        <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colCreated" EnableSorting="true" Name="Oprettet" Width="200" runat="server" />
                        <dw:ListColumn ID="colDefault" ItemAlign="Center" HeaderAlign="Right" Name="Default" Width="45" runat="server" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
