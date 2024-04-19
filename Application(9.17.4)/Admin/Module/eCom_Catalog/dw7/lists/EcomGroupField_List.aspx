<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomGroupField_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomGroupField_List" %>

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
        function editGroupField(fieldId) {
            ListNavigatorDispatcher.persist("<%= List1.ID %>", "../Lists/EcomGroupField_List.aspx", <%= List1.PageNumber %>, <%= List1.SortColumnIndex %>, <%= List1.SortDirection %>)
            let editPageUrl = "../Edit/EcomField_Edit.aspx?Type=GROUPS";
            if (fieldId) {
                editPageUrl += `&ID=${fieldId}`;
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
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Feltnavn" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colTemplate" runat="server" Name="Template tag" EnableSorting="true" />
                    <dw:ListColumn ID="colTypeName" runat="server" Name="Felttype" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>
</body>
</html>