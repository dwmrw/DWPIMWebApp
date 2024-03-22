<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PageTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.PageTypeSelect" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/PageTypeSelect.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    <script src="/Admin/Resources/js/layout/Notifire.js"></script>
    <style>
        .groupbox-content { 
           display: flex;
           flex-direction: row;
           flex-wrap: wrap;
        }

        div.empty-page .groupbox-content {
            color: #BDBDBD;
        }

        .page-type { 
            border: 1px solid #EEEEEE;
            display: inline-block;
            margin: 0 10px 10px 0;
            padding: 15px;
            cursor: pointer;
            flex-basis: 33%;
        }

        .page-type:nth-child(3n) {
            margin-right: -20px;
        }

        div.empty-page .page-type {
            border: none;
            margin: 0;
            flex-basis: 20%;
        }

        .page-type:hover {
            background-color: #f3f3f3;
            border: 1px solid #EEEEEE;
        }

        .page-type-icon {
            float: left;
            font-size: 32px;
        }

        .page-type-simple {
            float: left;
            margin-left: 8px;
            margin-top: 8px;
            width: 80%;
        }

        .page-type-image {
            text-align: center;
        }

        .page-type-image img {
            width: 100%;
        }

        .page-type-name{
            color: #000;
            font-weight: bold;
        }

        .page-type-description {
            color: #9E9E9E;
            padding-bottom: 8px;
        }
    </style>
</head>
<body class="area-blue">
    <div id="FormContent" runat="server" class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="New page" />
            <dwc:CardBody id="CardContent" runat="server">
                <dwc:GroupBox runat="server" ID="GroupEmptyPages" Expandable="true" IsCollapsed="true" Title="Add empty page" ClassName="empty-page">
                    <div id="tabBlankPage" runat="server" style="width:100%">
                        <div class="page-type" style="width:100%" onclick="Dynamicweb.Items.PageTypeSelect.get_current().newPage(0);">
                            <span class="page-type-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO)%>"></i></span>
                            <div class="page-type-simple">
                                <div class="page-type-name"><dw:TranslateLabel runat="server" Text="Blank page" /></div>
                                <div class="page-type-description"><small><dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Choose this to create a new blank page" /></small></div>
                            </div>
                        </div>
                    </div>
                </dwc:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
    </div>

    <div class="center-block" id="MessageBlock" visible="False" runat="server">
        <div class="centered text-center">
            <span class="label">
                <dw:TranslateLabel Text="No content is available." runat="server" />
            </span>
        </div>
    </div>

    <dw:Overlay ID="ribbonOverlay" runat="server" Message="" ShowWaitAnimation="True" />

    <dw:Dialog ID="NewPageDialog" runat="server" Title="Ny side" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="Dynamicweb.Items.PageTypeSelect.get_current().newPageSubmit(); ">
        <div class="form-group">
            <label class="control-label" for="PageName">
                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Sidenavn" />
            </label>
            <div class="form-group-input">
                <input type="text" runat="server" id="PageName" name="PageName" class="form-control" maxlength="255" />
                <div id="rowBasedOn" class="m-t-5">
                    <dw:TranslateLabel runat="server" Text="Based on" />
                    <label id="ChosenTemplateName"></label>
                </div>
            </div>
        </div>
        <dwc:RadioGroup runat="server" ID="PageOptions" Name="PageOptions" Label="Page status">
            <dwc:RadioButton runat="server" FieldValue="Published" Label="Published" />
            <dwc:RadioButton runat="server" FieldValue="Unpublished" Label="Unpublished" />
            <dwc:RadioButton runat="server" FieldValue="HideInMenu" Label="Hide in menu" />
        </dwc:RadioGroup>
    </dw:Dialog>

    <script type="text/javascript">
        Dynamicweb.Items.PageTypeSelect.get_current().set_parentPageId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("ParentPageID")) %>);
        Dynamicweb.Items.PageTypeSelect.get_current().set_areaId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("AreaID"))%>);
        Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['SpecifyPageName'] = '<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>';
        Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['ItemType'] = '<%=Translate.JsTranslate("item type")%>';
        Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['Template'] = '<%=Translate.JsTranslate("page template")%>';
        Dynamicweb.Items.PageTypeSelect.get_current().initialize();
    </script>
    <asp:Literal ID="ThumbnailHelper" runat="server"></asp:Literal>
</body>
</html>
