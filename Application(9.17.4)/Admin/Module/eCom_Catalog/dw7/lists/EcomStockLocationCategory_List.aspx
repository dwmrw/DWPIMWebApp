<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomStockLocationCategory_List.aspx.vb" Inherits="Dynamicweb.Admin.EcomStockLocationCategory_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                    <Columns>
                        <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" Width="300" />
                        <dw:ListColumn ID="colDescription" runat="server" Name="Description" />
                    </Columns>
                </dw:List>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>
