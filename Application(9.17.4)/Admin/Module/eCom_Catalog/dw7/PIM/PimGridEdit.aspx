<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/PIM/PimMaster.Master"
    AutoEventWireup="false" CodeBehind="PimGridEdit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimGridEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <link rel="Stylesheet" href="../css/productList.css" />
    <link rel="Stylesheet" href="PimGridEdit.css" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductList.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/PIM/PimGridEdit.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js"></script>

    <script type="text/javascript">
        var openScreenAction = <%=New Dynamicweb.Management.Actions.OpenScreenAction("", "").ToJson()%>;        

        var controlRows = [];
    </script>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <input type="hidden" name="ids" value="<%=Request("ids")%>" />
    <input type="hidden" id="currentProductRow" value="" />
    <input type="hidden" id="currentFieldType" value="" />
    <input type="hidden" id="currentFieldId" value="" />
    <asp:HiddenField ID="FocusedFieldId" ClientIDMode="Static" runat="server" />
    
    <div id="ProductListContent" class="list-wrap" runat="server">
        <div class="main-content">            
            <asp:Table ID="productsContainer" ClientIDMode="Static" CssClass="cells" runat="server"></asp:Table>
        </div>
    </div>
    <dw:ContextMenu ID="FunctionsContextMenu" runat="server" OnClientSelectView="onGridContextMenuView">
        <dw:ContextMenuButton runat="server" ID="SetValueContextMenuButton" Text="Set Values" OnClientClick="showSetValueDialog();" icon="Pencil" OnClientGetState="setValueContextGetState()" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace,filteringRestore,sortingRestore,filteringAndSortingRestore,Restore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ReplaceContextMenuButton" Text="Search and replace" OnClientClick="showReplaceDialog();" icon="FindReplace" Views="Replace,sortingReplace,filteringReplace,filteringAndSortingReplace,Restore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="TranslateContextMenuButton" Text="Translate" OnClientClick="showTranslateDialog();" icon="Translate" OnClientGetState="translateContextGetState()" Views="filteringReplace,filteringReplaceRestore,filteringAndSortingReplace,filteringAndSortingReplaceRestore,sortingReplace,sortingReplaceRestore,Replace,ReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="RestoreContextMenuButton" Text="Clear all to default" OnClientClick="restoreCategoryValues();" icon="Refresh" Views="Restore,filteringRestore,sortingRestore,filteringAndSortingRestore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="FilterContextMenuButton" Text="Filter" OnClientClick="showFilteringDialog();" icon="Filter" Divide="Before" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace,Restore,filteringRestore,sortingRestore,filteringAndSortingRestore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="SortAscContextMenuButton" Text="Sort ascending" OnClientClick="sortAsc();" icon="SortAmountAsc" Divide="Before" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace,Restore,filteringRestore,sortingRestore,filteringAndSortingRestore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="SortDescContextMenuButton" Text="Sort descending" OnClientClick="sortDesc();" icon="SortAmountDesc" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace,Restore,filteringRestore,sortingRestore,filteringAndSortingRestore,ReplaceRestore,sortingReplaceRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ClearFilterContextMenuButton" Text="Reset filter" OnClientClick="removeFiltering();" icon="Close" Divide="Before" Views="filtering,filteringAndSorting,filteringReplace,filteringAndSortingReplace,filteringRestore,filteringAndSortingRestore,filteringReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ClearSortContextMenuButton" Text="Remove sorting" OnClientClick="removeSorting();" icon="Close" Divide="Before" Views="sorting,filteringAndSorting,sortingReplace,filteringAndSortingReplace,sortingRestore,filteringAndSortingRestore,sortingReplaceRestore,filteringAndSortingReplaceRestore,filteringAndSortingReplaceRestore"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Dialog ID="SetValueDialog" runat="server" ShowOkButton="true" OkAction="updateFieldValues()" Title="Set values" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <div id="editorsContainer" class="editorsContainer">
                <dwc:InputText runat="server" ID="TextFieldEditor" Label="Value" />
                <dw:Editor runat="server" ID="EditorTextFieldEditor" Height="200" Label="Value" />
                <dwc:InputTextArea runat="server" ID="TextLongFieldEditor" Rows="5" Label="Value" />
                <dwc:SelectPicker runat="server" ID="SelectFieldEditor" Label="Value" />
                <dwc:SelectPicker runat="server" ID="MultiSelectListFieldEditor" Label="Value" AllowSearch="true" Multiple="true"/>
                <div class="form-group">
                    <div class="form-group-input">
                        <dw:GroupDropDownList runat="server" ID="GroupDropDownListFieldEditor" CssClass="selectpicker" ClientIDMode="Static" />
                    </div>
                </div>
                <dwc:InputNumber runat="server" ID="IntegerFieldEditor" IncrementSize="1" ClientIDMode="Static" Label="Value" />
                <dwc:InputNumber runat="server" ID="DoubleFieldEditor" IncrementSize="0.01" ClientIDMode="Static" Label="Value" />
                <dw:LinkManager runat="server" ID="LinkFieldEditor" Label="Value" />
                <dw:DateSelector runat="server" ID="DateFieldEditor" Label="Value" IncludeTime="False" />
                <dw:DateSelector runat="server" ID="DateTimeFieldEditor" Label="Value" IncludeTime="True" />
            </div>
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="FilterDialog" runat="server" ShowOkButton="true" OkAction="filterRows()" Title="Filtering" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <dwc:InputText runat="server" ID="FilterText" Label="Value" />
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="ReplaceDialog" runat="server" ShowOkButton="true" OkAction="replaceValues()" Title="Search and replace" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <dwc:InputText runat="server" ID="SearchValue" Label="Search value" />
            <dwc:InputText runat="server" ID="ReplacementValue" Label="Replacement" />
        </dwc:GroupBox>
    </dw:Dialog>
    
    <dw:Dialog ID="TranslateDialog" runat="server" ShowOkButton="true" OkText="Run" OkAction="runTranslation()" Title="Translate" ShowCancelButton="true" CancelText="Close">
        <dwc:GroupBox runat="server">
            <dw:Infobar runat="server" ID="ErrorInfo" Message="" CssClass="hidden" />
            <div id="translate-from" class="form-group">
                <label class="control-label"><%=Translate.Translate("Translate from")%></label>
                <div ID="TranslateFrom" class="language-panel" runat="server"></div>
            </div>
            <div id="translate-to" class="form-group">
                <label class="control-label"><%=Translate.Translate("Translate to")%></label>
                <div ID="TranslateTo" class="language-panel" runat="server"></div>
            </div>
            <dw:List ID="TranslationProgressBar" runat="server" PageSize="100" ShowPaging="false" ShowEmptyEndColumn="false" ShowTitle="false">
                <Columns>
		            <dw:ListColumn ID="ListColumn1" runat="server" Name="Language" ItemAlign="Center" Width="25">
		            </dw:ListColumn>
		            <dw:ListColumn ID="ListColumn3" runat="server" Name="Progress" Width="0">
		            </dw:ListColumn>
		        </Columns>
            </dw:List>
        </dwc:GroupBox>
    </dw:Dialog>
</asp:Content>

<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterHolder" runat="server">
    <script type="text/javascript">        


        Dynamicweb.PIM.BulkEdit.get_current().initialize({
            viewMode: 'GridEditView',
            isReadOnly: <%= IsReadOnly.ToString().ToLower() %>,
            actions: {
                openDialog: <%= New OpenDialogAction("").ToJson() %>,
                closeAction: <%=New OpenScreenAction(Dynamicweb.Core.Converter.ToString(Request("returnUrl")) + "&KeepListSettings=true").ToJson()%>
            }
        });

        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToRelated"] = "<%=Translate.translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("related"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["TranslationSourceMissing"] = "<%=Translate.Translate("There are %% Products with missing source language")%>";
        
        Dynamicweb.PIM.BulkEdit.get_current().confirmAction = <%=New ConfirmMessageAction(Translate.Translate("Confirm Action"), "").ToJson()%>;
        Dynamicweb.PIM.BulkEdit.get_current().openScreenAction = <%=New OpenScreenAction("", "").ToJson()%>;

        Dynamicweb.PIM.BulkEdit.get_current().DateFieldEditorId = "<%=DateFieldEditor.UniqueID%>";
        Dynamicweb.PIM.BulkEdit.get_current().DateTimeFieldEditorId = "<%=DateTimeFieldEditor.UniqueID%>";

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.pimpgridedit", "en") %>
        };

        productMenu._warningAssortmentsMessage = '<%= Translate.JsTranslate("Assortments module is not installed. Only ungrouped products will processed.")%>';
        productMenu._successCopyMessage = '<%= Translate.JsTranslate("The selected products were successfully copied.")%>';
        productMenu._confirmCopyFromNonPromaryGroup = '<%= Translate.JsTranslate("Current group is not primary. Product will be related to this group during related groups copying.")%>';
        productMenu._failureCopyMessage = '<%= Translate.JsTranslate("Errors occurred when copying the products. Some products may have been copied. Error message:")%>';
        productMenu._deleteMessage = '<%= Translate.JsTranslate("Slet?")%>';
        productMenu._deleteMessage2 = '<%= Translate.JsTranslate("Slet?")%>';
        productMenu._detachMessage = '<%= Translate.JsTranslate("Do you want to detach the selected products? This will remove all language versions of the selected products from the group!")%>';
        productMenu._failureDetachMessage = '<%= Translate.JsTranslate("Errors occurred when detaching the products. Some products may have been detached.")%>';
        <%If String.IsNullOrWhiteSpace(EcomGroupId) Then %>
        productMenu._queryId = '<%=QueryId%>';
        productMenu._groupId = '<%=GroupId%>';
        <%End If%>

        setButtonsTooltip("FunctionsContextMenu", "<%=Translate.JsTranslate("Function available in viewmode: Simple view.")%>");

        if (window.CKEDITOR) {
            CKEDITOR.instances['EditorTextFieldEditor'].on("instanceReady", function () {
                new overlay('__ribbonOverlay').hide();
            });
        } else {
            new overlay('__ribbonOverlay').hide();
        }

    </script>
</asp:Content>
