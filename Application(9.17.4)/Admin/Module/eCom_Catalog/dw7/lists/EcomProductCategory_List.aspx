<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomProductCategory_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductCategory_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/ListNavigator.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script>
        function editCategory(categoryId) {
            ListNavigatorDispatcher.persist("<%= List1.ID %>", "../Lists/EcomProductCategory_List.aspx", <%= List1.PageNumber %>, <%= List1.SortColumnIndex %>, <%= List1.SortDirection %>)
            openInContentFrame(`../Edit/EcomProductCategory_Edit.aspx?ID=${categoryId}`);
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters>
                    <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175" ShowSubmitButton="True" />           
                    <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Paging size" AutoPostBack="true" Priority="3" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                            <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                            <dw:ListFilterOption Text="All" Value="all" DoTranslate="True"/>
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colFieldsCount" runat="server" Name="Fields count" EnableSorting="true" />
                    <dw:ListColumn ID="colFieldsType" runat="server" Name="Field type" EnableSorting="false" />                    
                    <dw:ListColumn ID="colUsage" runat="server" Name="Usage" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>
</body>
</html>