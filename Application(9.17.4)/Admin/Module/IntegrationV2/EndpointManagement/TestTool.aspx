<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TestTool.aspx.vb" Inherits="Dynamicweb.Admin.Test" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludejQuery="true" IncludeUIStylesheet="true" IncludePrototype="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        var errorShown = false;
        var required = '<%=Translate.JsTranslate("required")%>';
        var incorrectUrlFormat = '<%=Translate.JsTranslate("incorrect URL format")%>';
        isUrlRegExp = /^((((https?|ftp|gopher|telnet|file|notes|ms-help):((\/\/)|(\\\\)))|(\/admin\/public))+[\w\d:#@%/;$()~_?\+-=\\\.&']*)$/i;
        endpointIsValid = function (saveAsNew) {
            var result = true;
            if (saveAsNew) {
                var endpointName = document.getElementById("newEndpointName");
                var msg = "";
                if (!endpointName.value) {
                    msg = required;
                    result = false;
                }
                dwGlobal.controlErrors("newEndpointName", !!msg, msg);
            }
            var url = document.getElementById("txtUrl");
            var incorrectUrl = "";
            if (!isUrlRegExp.test(url.value)) {
                incorrectUrl = incorrectUrlFormat;
                result = false;
            }
            dwGlobal.controlErrors("txtUrl", !!incorrectUrl, incorrectUrl);
            return result;
        }
        requestIsValid = function () {
            var result = true;
            var fileName = document.getElementById("newRequestName");
            var requiredFileName = "";
            if (!fileName.value) {
                requiredFileName = required;
                result = false;
            }
            dwGlobal.controlErrors("newRequestName", !!requiredFileName, requiredFileName);
            return result;
        }
        responseIsValid = function () {
            var result = true;
            var fileName = document.getElementById("newResponseName");
            var requiredFileName = "";
            if (!fileName.value) {
                requiredFileName = required;
                result = false;
            }
            dwGlobal.controlErrors("newResponseName", !!requiredFileName, requiredFileName);
            return result;
        }

        var $j = jQuery.noConflict();

        $j(window).load(function () {
            var groups = {};
            $j("select option[data-category]").each(function () {
                groups[$j.trim($j(this).attr("data-category"))] = true;
            });
            $j.each(groups, function (c) {
                $j("select option[data-category='" + c + "']").wrapAll('<optgroup label="' + c + '">');
            });
            useDynamicwebServiceClick();
        });

        function save(saveAsNew) {
            if (!endpointIsValid(saveAsNew)) {
                return false;
            }
            initiatePostBack("TestTool", saveAsNew ? "saveAsNew" : "save")
        }

        function saveNewRequest() {
            if (!requestIsValid()) {
                return false;
            }
            initiatePostBack("TestTool", "SaveRequestToFile")
        }

        function saveNewResponse() {
            if (!responseIsValid()) {
                return false;
            }
            initiatePostBack("TestTool", "SaveResponseToFile")
        }

        function initiatePostBack(action, target) {
            var frm = document.getElementById("MainForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        var KeyValueList = function () { }

        KeyValueList.deleteRow = function (grid, link) {
            var optionName = '';
            var row = grid.findContainingRow(link);
            if (row) {
                optionName = row.findControl('txKey').value;

                if (!optionName || optionName.length == 0) {
                    grid.deleteRows([row]);
                }

                if (!optionName || optionName == '') {
                    grid.deleteRows([row]);
                } else if (confirm(KeyValueList._message('message-delete-row').replace('%%', optionName))) {
                    grid.deleteRows([row]);
                }
            }
        }

        KeyValueList._message = function (className) {
            var ret = '';
            var container = null;

            if (className) {
                container = $$('.' + className);
                if (container != null && container.length > 0) {
                    ret = container[0].innerHTML;
                }
            }

            return ret;
        }
        function CheckUniquenessOfKeys(grid) {
            var rows = grid.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var valueField = row.findControl('txKey');
                var value = valueField.value;

                for (var j = i + 1; j < rows.length; j++) {
                    var loopRow = rows[j];
                    var loopValueField = loopRow.findControl('txKey');

                    if (loopValueField.value == value) {
                        loopValueField.focus();
                        loopValueField.parentNode.className = "has-error";
                    } else {
                        loopValueField.parentNode.className = "";
                    }
                }
            }
            return "";
        }

        function useDynamicwebServiceClick() {
            var checkBox = document.getElementById("cbDynamicwebService");
            if (checkBox != null) {
                var dynamicwebRequestExampleDiv = document.getElementById("gbRequestExample");
                var dynamicwebRequestTextInput = document.getElementById("txtDynamicwebRequest");
                var dynamicwebRequestDiv = dynamicwebRequestTextInput.parentElement.parentElement;
                var requestType = document.getElementById("spRequestType");
                var requestBodyDiv = document.getElementById("gbBody");
                if (checkBox.checked) {
                    dynamicwebRequestDiv.style.display = "block";
                    dynamicwebRequestExampleDiv.style.display = "block";
                    requestType.value = "POST";
                    if (dynamicwebRequestTextInput.value == null || dynamicwebRequestTextInput.value == "")
                        dynamicwebRequestTextInput.value = "<GetEcomData></GetEcomData>";
                    requestBodyDiv.style.display = "none";
                } else {
                    requestBodyDiv.style.display = "block";
                    dynamicwebRequestDiv.style.display = "none";
                    dynamicwebRequestExampleDiv.style.display = "none";
                    requestType.value = "GET";
                }
            }
        }
    </script>
</head>
<body>
    <dwc:Card runat="server">
        <form id="MainForm" action="TestTool.aspx" runat="server">
            <asp:HiddenField ID="UrlReferrer" runat="server" />
            <asp:HiddenField ID="EndpointId" runat="server" />

            <dwc:CardHeader runat="server" ID="lbSetup" Title="Test Tool"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="save(false);" Text="Save endpoint" />
                <dw:ToolbarButton ID="cmdSaveAsNew" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="dialog.show('newEndpoint');" Text="Save as new endpoint" />
            </dw:Toolbar>

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="GroupBox" runat="server" Title="Settings">
                    <div class="form-group">
                        <label runat="server" class="control-label" id="lblEndpoint"><%= Translate.Translate("Endpoint") %></label>
                        <div class="form-group-input">
                            <asp:DropDownList runat="server" ID="EndpointList" CssClass="selectpicker" Label="" OnSelectedIndexChanged="EndpointList_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group">
                        <label runat="server" class="control-label" id="lblAuthentication"><%= Translate.Translate("Authentication") %></label>
                        <div class="form-group-input">
                            <asp:DropDownList runat="server" ID="AuthenticationList" CssClass="selectpicker" Label="">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <dwc:InputText ID="txtUrl" runat="server" Label="Url" />
                    <dwc:CheckBox runat="server" ID="cbDynamicwebService" Label="Connects to standard Dynamicweb codeunit service" OnClick="useDynamicwebServiceClick()" />
                    <div class="form-group" id="gbRequestExample">
                        <label runat="server" class="control-label" id="lblRequestExample"><%= Translate.Translate("Request example") %></label>
                        <asp:DropDownList runat="server" ID="ddlRequestExampleList" CssClass="selectpicker" Label="" OnSelectedIndexChanged="RequestExampleList_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>
                        <dwc:Button runat="server" ID="btnRequestExample" BackColor="Orange" BorderStyle="Solid" Name="Save request to file" Value="SaveRequestToFile" DoTranslate="true" Title="Save request to file" OnClick="dialog.show('newRequest');" />
                    </div>
                    <dwc:InputTextArea runat="server" ID="txtDynamicwebRequest" Label="Dynamicweb Codeunit Request" Rows="10" />
                    <dwc:SelectPicker runat="server" ID="spRequestType" CssClass="selectpicker" Name="spRequestType" Label="Type">
                        <asp:ListItem Text="GET" Value="GET"></asp:ListItem>
                        <asp:ListItem Text="POST" Value="POST"></asp:ListItem>
                    </dwc:SelectPicker>
                </dwc:GroupBox>
                <dw:GroupBox runat="server" ID="gbHeaders" Title="Request Headers">
                    <dw:EditableGrid ID="headersGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new header..." ShowHeader="true"
                        NoRowsMessage="No headers found" AllowDeletingRows="true" AllowSortingRows="false" runat="server">
                        <Columns>
                            <asp:TemplateField HeaderText="Key">
                                <ItemTemplate>
                                    <div style="white-space: nowrap">
                                        <asp:TextBox ID="txKey" CssClass="form-control" Text='<%#Eval("Key")%>' onkeyup="CheckUniquenessOfKeys(dwGrid_headersGrid);" runat="server" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Value">
                                <ItemTemplate>
                                    <asp:TextBox ID="txValue" CssClass="form-control" Text='<%#Eval("Value")%>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete" HeaderStyle-Width="75">
                                <ItemTemplate>
                                    <div id="headerDel" runat="server"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove)%>" onclick="KeyValueList.deleteRow(dwGrid_headersGrid, this);"></i></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                    <span class="hidden message-delete-row">
                        <dw:TranslateLabel ID="lbDeleteRow" Text="Are you sure you want to delete an option '%%' ?" runat="server" />
                    </span>
                    <span class="hidden message-not-specified">
                        <dw:TranslateLabel ID="lbNotSpecified" Text="Not specified" runat="server" />
                    </span>
                    <span class="hidden message-not-unique-values">
                        <dw:TranslateLabel ID="lbNotUnique" Text="The key is not unique '%%'." runat="server" />
                    </span>
                </dw:GroupBox>
                <dw:GroupBox runat="server" ID="gbQueryParameters" Title="Query Parameters">
                    <dw:EditableGrid ID="parametersGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new query parameter..." ShowHeader="true"
                        NoRowsMessage="No query parameters found" AllowDeletingRows="true" AllowSortingRows="false" runat="server">
                        <Columns>
                            <asp:TemplateField HeaderText="Key">
                                <ItemTemplate>
                                    <div style="white-space: nowrap">
                                        <asp:TextBox ID="txKey" CssClass="form-control" Text='<%#Eval("Key")%>' onkeyup="CheckUniquenessOfKeys(dwGrid_parametersGrid);" runat="server" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Value">
                                <ItemTemplate>
                                    <asp:TextBox ID="txValue" CssClass="form-control" Text='<%#Eval("Value")%>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete" HeaderStyle-Width="75">
                                <ItemTemplate>
                                    <div id="parameterDel" runat="server"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove)%>" onclick="KeyValueList.deleteRow(dwGrid_parametersGrid, this);"></i></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Request Body" ID="gbBody">
                    <dwc:InputTextArea runat="server" ID="txtBody" ValidateRequestMode="Disabled" Label="Body" Info="text/xml" Rows="5" />
                </dw:GroupBox>                
                <dwc:GroupBox runat="server" Title="Send request">
                    <dwc:Button runat="server" Name="SendRequest" Value="SendRequest" DoTranslate="true" Title="Send request" ActionType="submit" />
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Response">
                    <dwc:Button runat="server" ID="btnResponse" BackColor="Orange" BorderStyle="Solid" Name="Save response to file" Value="SaveResponseToFile" DoTranslate="true" Title="Save response to file" OnClick="dialog.show('newResponse');" />
                    <dwc:InputTextArea runat="server" ID="txtResponse" Label="Response" Rows="30" />
                </dwc:GroupBox>
            </dwc:CardBody>
            <asp:HiddenField ID="NewEndpointDlgShown" runat="server" />
            <dw:Dialog Title="Save endpoint" ID="newEndpoint" Size="Small" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="save(true);">
                <dwc:GroupBox runat="server" Title="Endpoint">
                    <dwc:InputText runat="server" ID="newEndpointName" ClientIDMode="Static" Name="newEndpointName" Label="Name" />
                    <dwc:InputTextArea runat="server" ID="newEndpointDesc" ClientIDMode="Static" Name="newEndpointDesc" Label="Description" />
                </dwc:GroupBox>
            </dw:Dialog>
            <asp:HiddenField ID="NewRequestExamleDlgShown" runat="server" />
            <dw:Dialog Title="Save request example" ID="newRequest" Size="Small" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="saveNewRequest();">
                <dwc:GroupBox runat="server" Title="Request example">
                    <dwc:InputText runat="server" ID="newRequestName" ClientIDMode="Static" Name="newRequestName" Label="FileName" />
                </dwc:GroupBox>
            </dw:Dialog>
            <dw:Dialog Title="Save response" ID="newResponse" Size="Small" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="saveNewResponse();">
                <dwc:GroupBox runat="server" Title="Response">
                    <dwc:InputText runat="server" ID="newResponseName" ClientIDMode="Static" Name="newResponseName" Label="FileName" />
                </dwc:GroupBox>
            </dw:Dialog>
            <asp:HiddenField ID="PostBackAction" runat="server" />
        </form>
    </dwc:Card>
</body>
</html>
