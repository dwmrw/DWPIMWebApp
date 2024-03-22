<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditAdvancedXmlValue.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EditAdvancedXmlValue" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludejQuery="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        function createSelectOptionPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="OptionsListDialog" Title="Advanced Xml Editor" HidePadding="False">
        <Content>
            <div id="content">
                <dw:Editor ID="AdvancedXmlEditor" runat="server" />          
            </div>
        </Content>
        <Footer>            
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Submit'})" id="SaveButton" runat="server"><dw:TranslateLabel runat="server" Text="OK" /></button>
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})"><dw:TranslateLabel runat="server" Text="Cancel" /></button>
        </Footer>
    </dwc:DialogLayout>
</html>
