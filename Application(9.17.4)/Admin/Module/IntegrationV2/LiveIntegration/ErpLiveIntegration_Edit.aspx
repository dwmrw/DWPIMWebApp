<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ErpLiveIntegration_Edit.aspx.vb" Inherits="Dynamicweb.Admin.ErpLiveIntegration_Edit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Live Integration Add-ins</title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true" IncludeUIStylesheet="true" />
    <script type="text/javascript" src="/Admin/Module/IntegrationV2/js/LiveIntegrationAddInSettings.js"></script>
    <script type="text/javascript">
        function redirectToSettingsPage(typeName, instanceId) {
            var url = '/Admin/Module/IntegrationV2/LiveIntegration/LiveIntegrationAddInSettings.aspx';
            if (typeName != null) {
                url += '?addInFullName=' + typeName;
            }
            if (instanceId != null) {
                url += '&DynamicwebLiveIntegrationInstanceId=' + instanceId;
            }
            window.location.href = url;
        }
        function showLogs(url) {
            dialog.show("HistoryLogDialog", url);
        }
        function deleteInstance(settingsFile) {
            window.location.href = '/Admin/Module/IntegrationV2/LiveIntegration/ErpLiveIntegration_Edit.aspx?action=delete&settingsFile='
                + settingsFile;
        }
    </script>
    <style type="text/css">
        .selectpicker.std {
            width:90% !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    
        <dw:List ID="addInList" ShowTitle="true" Title="Add-In Overview" AllowMultiSelect="false" TranslateTitle="True" runat="server">
            <Columns>
                <dw:ListColumn ID="addInName" Name="Add-In Name" runat="server" Width="300" />
                <dw:ListColumn ID="addInType" Name="Add-In Label" runat="server" Width="200" />
                <dw:ListColumn ID="addInVersion" Name="Add-In Version" runat="server" Width="100" />
                <dw:ListColumn ID="createInstance" Name="Create instance" Width="100" runat="server" ItemAlign="Center" CssClass="pointer" />
            </Columns>
        </dw:List>
        <dw:ContextMenu ID="addInListContextMenu" runat="server">
            <dw:ContextMenuButton runat="server" ID="addInLogButton" Text="Show log" Icon="EventNote"></dw:ContextMenuButton>
            <dw:ContextMenuButton runat="server" ID="addInDownloadLogButton" Text="Download log" Icon="Download"></dw:ContextMenuButton>
            <dw:ContextMenuButton runat="server" ID="addInSelectLogForDownloadButton" Text="Select log for download" Icon="PlayDownload" OnClientClick="dialog.show('selectLogDlg');"></dw:ContextMenuButton>
        </dw:ContextMenu>
        <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Live Integration add-in log" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" >
            <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
        <p></p>
        <dw:List ID="instancesList" ShowTitle="true" Title="Live Integration instances" AllowMultiSelect="false" TranslateTitle="True" runat="server">
            <Columns>
                <dw:ListColumn ID="instanceId" Name="Instance Id" runat="server" Width="50" />
                <dw:ListColumn ID="instanceAddInName" Name="Add-In Name" runat="server" Width="250" />
                <dw:ListColumn ID="instanceLabel" Name="Instance label" runat="server" Width="200" />
                <dw:ListColumn ID="instanceShopId" Name="Shop" runat="server" Width="50" />
                <dw:ListColumn ID="instanceEnabled" Name="Active" runat="server" ItemAlign="Center" Width="50" />
                <dw:ListColumn ID="instanceRemove" Name="Remove" Width="50" runat="server" ItemAlign="Center" CssClass="pointer" />
            </Columns>
        </dw:List>
        <dw:Dialog runat="server" ID="selectLogDlg" ShowOkButton="true" ShowCancelButton="true" Title="Select log file for download" Size="Small" 
            OkAction="downloadSelectedFile();" OkText="Download">
            <dw:GroupBox runat="server">
                <dw:FileManager runat="server" ID="selectedLogFile" ShowOnlyAllowedExtensions="true" Extensions="txt,log" AllowBrowse="true" AllowUpload="false" ToolTip="Select log file for download" Folder="/System/Log/LiveIntegration" FullPath="true" />
            </dw:GroupBox>
        </dw:Dialog>
        <input type="hidden" name="action" id="action" value="" />
        <% 
            Translate.GetEditOnlineScript()
        %>
    </form>
</body>
</html>
