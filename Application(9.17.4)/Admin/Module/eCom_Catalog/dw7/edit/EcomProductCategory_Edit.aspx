<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomProductCategory_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductCategory_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/ListNavigator.js" />
        </Items>
    </dw:ControlResources>

    <style>
        .add-button-container {
            text-align: center;
            padding: 10px;
        }
        .add-button-container button {
            margin: 0 10px 0 10px;
        }
        #ReferenceFieldsDialog .selection-box.with-search {
            width: 1054px;
        }
    </style>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">
        var deleteMessage = "<%=deleteMessage %>";

        $(document).observe('dom:loaded', function () {
            document.getElementById('NameStr').focus();
        });

        function showUsage() {
            dialog.show("UsageDialog");
        }

        function checkUsage() {
            if (<%= UsageCount %> > 0) {
                dialog.show("DeleteDialog");
            }
            else {
                if (confirm(deleteMessage)) {
                    document.getElementById('Form1').DeleteButton.click();
                }
            }
        }

        //  Delete row
        function delField(link) {
            if (event.stopPropagation) { event.stopPropagation(); } else { event.cancelBubble = true; }
            if (confirm('<%= Translate.JsTranslate("Do you want delete field?") %>')) {
                var row = link.closest(".listRow");
                if (row) {
                    var id = row.getAttribute("itemid");
                    document.getElementById("DeletedRows").value += id + ","
                    row.remove();
                    var addButton = $('AddFieldBtn');
                    addButton.innerHTML = '<%= Translate.JsTranslate("Save product category before adding new fields")%>';
                    addButton.disabled = true;
                    addButton.onclick = "";
                    var addReferencesButton = $('AddReferenceFields');
                    addReferencesButton.style.display = 'none';                  
                }
            }
        }

        function setSystemName(fromObject, toObject) {
            var nameBox;
            var sysNameBox;
            if (typeof (fromObject) == 'string' && typeof (toObject) == 'object') {
                nameBox = dwGrid_FieldsGrid.findContainingRow(toObject).findControl(fromObject);
                sysNameBox = toObject;
            } else if (typeof (fromObject) == 'object' && typeof (toObject) == 'string') {
                nameBox = fromObject;
                sysNameBox = dwGrid_FieldsGrid.findContainingRow(fromObject).findControl(toObject);
            } else if (typeof (fromObject) == 'object' && typeof (toObject) == 'object') {
                nameBox = fromObject;
                sysNameBox = toObject;
            } else { return; }

            var sysName;
            if ($F(sysNameBox).strip().empty()) {
                sysName = $F(nameBox);
            } else {
                sysName = $F(sysNameBox);
            }
            sysNameBox.value = sysName.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
        }

        function addReferenceFields() {
            document.getElementById('SelectedReferenceFields').value = SelectionBox.getElementsRightAsArray('ReferenceFieldsSelector');
            document.getElementById('Cmd').value = "AddReferenceFields";
            document.getElementById('Form1').SaveButton.click();
        }

        function save(close) {
            document.getElementById('Close').value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        function cancel() {
            ListNavigatorDispatcher.navigate("List1", "../Lists/EcomProductCategory_List.aspx")
        }

        function toggleFlag(element, fieldId, flagName) {
            if (event.stopPropagation) { event.stopPropagation(); } else { event.cancelBubble = true; }
            new overlay("loadingOverlay").show();

            var flagIcon = element.querySelector(".toggle-icon");
            var checked = flagIcon.getAttribute("data-active") == 'true';
            new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/edit/EcomProductCategory_Edit.aspx", {
                asynchronous: false,
                method: 'post',
                parameters: { AjaxCmd: 'ChangeFlag', ID:"<%=Request("ID")%>", FieldId: fieldId, FlagName: flagName, Checked: checked },
                onSuccess: function (request) {
                    changeFlagIcon(flagIcon, request.responseText);
                },
                onComplete: function () {
                    new overlay("loadingOverlay").hide();
                }
            });

            return false;
        }

        changeFlagIcon = function (rowStateEl, newFlag) {
            rowStateEl.setAttribute('data-active', newFlag);
            rowStateEl.setAttribute('class', rowStateEl.getAttribute("data-css-state-active-" + newFlag));
        }
    </script>

</head>
<body class="area-pink screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <dw:Overlay runat="server" ID="loadingOverlay" />
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <input id="DeletedRows" type="hidden" name="DeletedRows" value="" />
            <input id="Cmd" type="hidden" name="Cmd" value="" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" onblur="setSystemName(this, $('SystemNameStr'));" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSystemName" runat="server" Text="Systemnavn" />
                        </td>
                        <td>
                            <asp:TextBox ID="SystemNameStr" CssClass="std" runat="server" onblur="setSystemName($('NameStr'), this);" />
                            <small class="help-block error" id="errSystemNameStr"></small>
                        </td>
                    </tr>
                </table>

                <dwc:RadioGroup runat="server" ID="CategoryType" Label="Field type">
                    <dwc:RadioButton runat="server" ID="RegularCategory" Label="Category" FieldValue="0" />
                    <dwc:RadioButton runat="server" ID="ProductFields" Label="Property" FieldValue="1" />
                    <dwc:RadioButton runat="server" ID="SystemFields" Label="Reference" FieldValue="2" />
                </dwc:RadioGroup>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server">
                <dw:List ID="FieldsList" runat="server" AllowMultiSelect="false" NoItemsMessage="No fields for this category" Title="Fields" PageSize="25">
                    <Filters>
                        <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175" ShowSubmitButton="True" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Paging size" AutoPostBack="true" Priority="3" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                                <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                                <dw:ListFilterOption Text="All" Value="all" DoTranslate="True" />
                            </Items>
                        </dw:ListDropDownListFilter>
                    </Filters>
                    <Columns>
                        <dw:ListColumn ID="ListColumn2" runat="server" Name="Name" />
                        <dw:ListColumn ID="ListColumn3" runat="server" Name="SystemName" />
                        <dw:ListColumn ID="ListColumn5" runat="server" Name="Type" />
                        <dw:ListColumn ID="ListColumn6" runat="server" Name="Reference" />
                        <dw:ListColumn ID="ListColumn4" runat="server" Name="Hide if field has no value" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn1" runat="server" Name="Do not render" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn9" runat="server" Name="Language editing" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn10" runat="server" Name="Variant editing" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn11" runat="server" Name="Required" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn12" runat="server" Name="Read only" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn13" runat="server" Name="Hidden" HeaderAlign="Center" ItemAlign="Center" />
                        <dw:ListColumn ID="ListColumn8" runat="server" Name="Delete" HeaderAlign="Center" ItemAlign="Center" />
                    </Columns>
                </dw:List>
                <div class="add-button-container">
                    <dwc:Button runat="server" ID="AddFieldBtn" />
                    <dwc:Button runat="server" ID="AddReferenceFields" />
                </div>
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:HiddenField runat="server" ID="hiddenCategoryID" Value="" />

            <dw:Dialog runat="server" ID="UsageDialog" OkAction="dialog.hide('UsageDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Usage" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="UsageContent" />
                </div>
            </dw:Dialog>   

            <dw:Dialog runat="server" ID="DeleteDialog" OkAction="dialog.hide('DeleteDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Cannot delete" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="DeleteContent" />
                </div>
            </dw:Dialog>         

            <dw:Dialog runat="server" ID="ReferenceFieldsDialog" OkAction="addReferenceFields();" ShowOkButton="true" Title="Add reference fields" TranslateTitle="true">                
                <dwc:GroupBox ID="ReferenceFieldsGroupBox" runat="server" Title="Select fields">
                   <dw:SelectionBox runat="server" ID="ReferenceFieldsSelector" LeftHeader="System fields" RightHeader="Selected fields" ShowSearchBox="true" Width="500" Height="500"></dw:SelectionBox>
                    <input type="hidden" name="SelectedReferenceFields" id="SelectedReferenceFields" value="" />
                </dwc:GroupBox>
            </dw:Dialog>
        </form>
    </div>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addRegExRestriction('SystemNameStr', '^[a-zA-Z]+[a-zA-Z0-9_]*$', '<%=Translate.JsTranslate("System name is incorrect")%>');
        activateValidation('Form1');
    </script>

</body>
</html>
