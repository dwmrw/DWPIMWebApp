<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_CustomerExperienceCenterFavorites_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_CustomerExperienceCenterFavorites_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomParagraph.js" />
    </Items>
</dw:ControlResources>

<dw:ModuleHeader runat="server" ModuleSystemName="eCom_CustomerExperienceCenterFavorites"></dw:ModuleHeader>
<dw:ModuleSettings runat="server" ModuleSystemName="eCom_CustomerExperienceCenterFavorites" Value="RetrieveListBasedOn, PageSize, SortByField, SortOrder, FavoriteListsTemplate, DetailTemplate" />

<dwc:GroupBox runat="server" Title="Show">
    <dwc:RadioGroup ID="RetrieveListBasedOn" Label="Retrieve list based on" runat="server">
        <dwc:RadioButton FieldValue="UseUserID" Label="User id" runat="server" />
        <dwc:RadioButton FieldValue="UseCustomerNumber" Label="Customer number" runat="server" />
        <dwc:RadioButton FieldValue="UseImpersonationIds" Label="Own favorite lists and lists made by users that current user can impersonate" runat="server" />     
    </dwc:RadioGroup>
</dwc:GroupBox>

<dwc:GroupBox runat="server" Title="Display">
    <dwc:InputNumber ID="PageSize" Label="Lists per page" Min="1" runat="server" />
    <dwc:SelectPicker ID="SortByField" Label="Sort by field" runat="server"></dwc:SelectPicker>
    <dwc:SelectPicker ID="SortOrder" Label="Sort direction" runat="server"></dwc:SelectPicker>
</dwc:GroupBox>

<dwc:GroupBox runat="server" Title="Templates">
    <dw:FileManager runat="server" ID="FavoriteListsTemplate" Label="List" Folder="Templates/eCom/CustomerExperienceCenter/Favorites" FullPath="True"></dw:FileManager>
    <dw:FileManager runat="server" ID="DetailTemplate" Label="Detail" Folder="Templates/eCom/CustomerExperienceCenter/Favorites" FullPath="True"></dw:FileManager>
</dwc:GroupBox>