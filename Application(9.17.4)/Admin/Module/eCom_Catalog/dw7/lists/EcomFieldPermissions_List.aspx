<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomFieldPermissions_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldPermissions_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.Security.Permissions" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <title></title>
        <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
            <Items>
                <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
                <dw:GenericResource Url="/Admin/Resources/vendors/url-search-params/url-search-params.js" />
            </Items>
        </dw:ControlResources>        
        <style type="text/css">
            .adornment-icons i {
                padding:2px;
            }
            .select-picker-ctrl .control-label .adornment-icons {
                float:right;
            }
            .select-picker-ctrl .control-label {
                margin-top:8px;
            }
        </style>
        <script type="text/javascript" src="../js/ecomLists.js"></script>
        <script type="text/javascript">
            function openPermissionDialog()
            {
                var shopSelector = document.getElementById("ShopSelector");
                var shopId = shopSelector.value;
                var shopName = shopSelector.options[shopSelector.selectedIndex].text;
                if (!!shopId) {
                    var action = <%=GetPermissionDialogAction(True)%>;
                    fillPermissionAction(action, shopId, shopName);
                    Action.Execute(action);
                } else {
                    <%=New ShowMessageAction() With {.Message = "Please select shop to set shop context permission."}.ToString()%>
                }
            }

            function openFieldPermission(fieldSystemName, fieldLabel)
            {
                var shopSelector = document.getElementById("ShopSelector");
                var shopId = shopSelector.value;
                var shopName = shopSelector.options[shopSelector.selectedIndex].text;
                var key = fieldSystemName;
                if (!!shopId) {
                    key = `${shopId}.${key}`;
                }
                var action = <%=GetPermissionDialogAction(False)%>;
                fillPermissionAction(action, key, shopName + ": " + fieldLabel);
                Action.Execute(action);
            }

            function fillPermissionAction(action, key, label) {                
                action.PermissionKey = key;
                action.PermissionTitle = label;
                action.OnSubmitted = { Name: "ScriptFunction", Function: function () { location.reload(); } };;
            }

            function collapseAllGroupboxes()
            {
                toggleAllGroupboxes(false);
            }

            function expandAllGroupboxes()
            {
                toggleAllGroupboxes(true);
            }

            function toggleAllGroupboxes(expand)
            {
                var groupBoxCollapseButtons = document.querySelectorAll(".groupbox-button-collapse");
                for (i = 0; i < groupBoxCollapseButtons.length; i++) {
                    var groupBoxButton = groupBoxCollapseButtons[i];
                    var groupBoxContent = groupBoxButton.nextElementSibling;
                    if(!(expand ^ groupBoxContent.classList.contains("collapsed"))){
                        Dynamicweb.Utilities.GroupBox.toggleCollapse(groupBoxButton.parentNode.parentNode);
                    }
                }
            }

            function updatePermissionToolbarButton(shopSelector) {
                var searchParams = new URLSearchParams(window.location.search);
                if (searchParams.has("ShopId")) {
                    searchParams.set("ShopId", shopSelector.value);
                } else {
                    searchParams.append("ShopId", shopSelector.value);
                }
                var newRelativePathQuery = window.location.pathname + '?' + searchParams.toString();
                history.pushState(null, '', newRelativePathQuery);
                window.location.search = searchParams.toString();
                window.location.reload();
            }

            $(document).observe('dom:loaded', function () {
                var shopSelector = document.getElementById("ShopSelector");
                var adornments = shopSelector.getAttribute("adornments");
                if (adornments) {
                    var container = shopSelector.closest(".dw-ctrl");
                    var label = container.querySelector(".control-label")
                    label.innerHTML += " " + adornments;
                }
            });

        </script>
    </head>
    <body class="screen-container">
        <div class="card">
            <form id="form1" runat="server" enableviewstate="false">
                <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
                <dwc:GroupBox ID="GroupBox1" runat="server" >
                    <dwc:SelectPicker runat="server" ID="ShopSelector" ClientIDMode="Static" Label="Shop" ></dwc:SelectPicker>
                </dwc:GroupBox>
                <dwc:GroupBox ID="StdFldGroupbox" runat="server" Title="Standard fields" Expandable="true" IsCollapsed="true" Personalize="true" >                    
                    <dw:List ID="StdFldList" runat="server" Title="" ShowTitle="false" >
                        <Filters></Filters>
                        <Columns>
                            <dw:ListColumn ID="StdListColumnName" runat="server" Name="Field" WidthPercent="30" />
                            <dw:ListColumn ID="StdListColumnSystemName" runat="server" Name="System name" WidthPercent="30" />
                            <dw:ListColumn ID="StdListColumnIcons" runat="server" Name="Permissions" WidthPercent="25" />
                            <dw:ListColumn ID="StdListColumnAction" runat="server" Name="" ItemAlign="Right" WidthPercent="15" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox ID="CustFldGroupbox" runat="server" Title="Product fields" Expandable="true" IsCollapsed="true" Personalize="true" >                    
                    <dw:List ID="CustFldList" runat="server" Title="" ShowTitle="false" >
                        <Filters></Filters>
                        <Columns>
                            <dw:ListColumn ID="CustListColumnName" runat="server" Name="Field" WidthPercent="30" />
                            <dw:ListColumn ID="CustListColumnSystemName" runat="server" Name="System name" WidthPercent="30" />
                            <dw:ListColumn ID="CustListColumnIcons" runat="server" Name="Permissions" WidthPercent="25" />
                            <dw:ListColumn ID="CustListColumnAction" runat="server" Name="" ItemAlign="Right" WidthPercent="15" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>                
                <div id="CategoriesContainer" runat="server"></div>
                <%--<asp:Repeater ID="CategoriesRepeater" runat="server" EnableViewState="false" >
                    <ItemTemplate>
                        <dwc:GroupBox ID="CatGroupbox" runat="server" Expandable="true" IsCollapsed="true" >                    
                            <dw:List ID="CatList" runat="server" Title="" ShowTitle="false">
                                <Filters></Filters>
                                <Columns>
                                    <dw:ListColumn ID="CatListColumnName" runat="server" Name="Field" WidthPercent="30"  />
                                    <dw:ListColumn ID="CatListColumnSystemName" runat="server" Name="System name" WidthPercent="30" />
                                    <dw:ListColumn ID="CatListColumnIcons" runat="server" Name="Permissions" WidthPercent="25" />
                                    <dw:ListColumn ID="CatListColumnAction" runat="server" Name="" ItemAlign="Right" WidthPercent="15" />
                                </Columns>
                            </dw:List>
                        </dwc:GroupBox>
                    </ItemTemplate>
                </asp:Repeater>--%>
            </form>
        </div>
    </body>
</html>