<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomField_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomField_List" %>

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
        function editField(fieldId, isSystemName) {
            ListNavigatorDispatcher.persist("<%= List1.ID %>", "../Lists/EcomField_List.aspx", <%= List1.PageNumber %>, <%= List1.SortColumnIndex %>, <%= List1.SortDirection %>)
            let editPageUrl = "../Edit/EcomField_Edit.aspx";
            if (fieldId) {
                if (isSystemName) {
                    editPageUrl += `?StandardFieldSystemName=${fieldId}`;
                }
                else {
                    editPageUrl += `?ID=${fieldId}`;
                }
            }
            openInContentFrame(editPageUrl);
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
                    <dw:ListColumn ID="colSystem" runat="server" Name="System Field" EnableSorting="true" Width="50" ItemAlign="Center" HeaderAlign="Center" />
                    <dw:ListColumn ID="colName" runat="server" Name="Feltnavn" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colTemplate" runat="server" Name="Template tag" EnableSorting="true" />
                    <dw:ListColumn ID="colTypeName" runat="server" Name="Felttype" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>
</body>
</html>