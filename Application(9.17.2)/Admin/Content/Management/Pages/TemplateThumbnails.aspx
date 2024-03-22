<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="TemplateThumbnails.aspx.vb" Inherits="Dynamicweb.Admin.TemplateThumbnails" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        var page = SettingsPage.getInstance();
        page.onSave = function () {
		    document.getElementById('MainForm').submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Template thumbnails" />

        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server">
                <dwc:CheckBox runat="server" ID="thumbnailsActive" Name="/Globalsettings/System/Thumbnails/Active" Label="Active" />
                <dw:FolderManager runat="server" ID="thumbnailsFolder" Name="/Globalsettings/System/Thumbnails/Path" Label="Thumbnails folder" />
                <dwc:SelectPicker Label="Image format" ID="thumbnailsImageFormat" runat="server" Name="/Globalsettings/System/Thumbnails/ImageFormat">
                </dwc:SelectPicker>
                <dwc:InputNumber runat="server" ID="thumbnailsWidth" Name="/Globalsettings/System/Thumbnails/Width" Label="Width" />
                <dwc:InputNumber runat="server" ID="thumbnailsHeight" Name="/Globalsettings/System/Thumbnails/Height" Label="Height" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
