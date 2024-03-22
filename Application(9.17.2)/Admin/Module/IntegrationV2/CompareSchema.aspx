<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CompareSchema.aspx.vb" Inherits="Dynamicweb.Admin.CompareSchema" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head runat="server">
		<title/>
		<dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="true"></dw:ControlResources>
		<link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/DoMapping.css" type="text/css"/>
	</head>
	<body>
		<form id="form1" runat="server">
			<dwc:GroupBox runat="server">
				<dw:List ID="errorList" runat="server" Title="Errors List" TranslateTitle="True" StretchContent="false" PageSize="25" ShowPaging="true" Height="400">
					<Columns>
						<dw:ListColumn ID="Source" EnableSorting="false" runat="server" Name="Source" Width="30"/>
						<dw:ListColumn ID="ErrorType" EnableSorting="true" runat="server" Name="Error Type" Width="30"/>
						<dw:ListColumn ID="Tables" runat="server" Name="Tables/Columns"/>
					</Columns>
				</dw:List>
				<dw:TranslateLabel ID="lblMappingErrorText" Text="Mapping errors should be fixed manually." runat="server"/>
				<br/>
				<dw:TranslateLabel ID="lblConfirmText" Text="Click OK to update the schema for source and destination" runat="server"/>
			</dwc:GroupBox>
		</form>
	</body>
</html>
