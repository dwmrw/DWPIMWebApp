<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent2.Master" Language="vb" AutoEventWireup="false" CodeBehind="EcomAdvConfigPrices_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigPrices_Edit" EnableViewState="false" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="Stylesheet" type="text/css" href="../css/EcomAdvConfigPricesEdit.css" media="screen" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeScriptaculous="true"></dw:ControlResources>
    <script type="text/javascript" src="../js/EcomAdvConfigPricesEdit.js"></script>

    <script type="text/javascript">
        document.observe("dom:loaded", function () {
            var trans = {};
            trans['RequestError'] = '<%=Translate.Translate("Something went wrong! Try again.")%>';

            new Dynamicweb.Managment.Ecom.AdvConfig.Prices.Forms.Main({
                help: function () {
                    <%=Gui.Help("", "administration.controlpanel.ecom.prices") %>
                },
                translations: trans
            });
        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server" >
    <div id="PageContent">        
		<dwc:GroupBox runat="server" Title="Indstillinger">			
            <dwc:InputNumber Name="/Globalsettings/Ecom/Price/PricesInDbVAT" ID="PricesInDbVAT" Label="System moms" IncrementSize="0.01" runat="server">
                <dwc:FieldAddOn Text="%" />
            </dwc:InputNumber>
			<dwc:CheckBox runat="server" ID="PricesInDbIncludesVAT" Name="/Globalsettings/Ecom/Price/PricesInDbIncludesVAT" Label="Priser i DB inkl. moms"  Info="If set, prices in database includes VAT and VAT is lifted off the prices before being used. System VAT % is used to lift of VAT when reading the price from DB" />
			<dwc:CheckBox runat="server" ID="UseSalesTaxGroupRateAsSystemTax" Name="/Globalsettings/Ecom/Price/UseSalesTaxGroupRateAsSystemTax" Label="Use VAT group rate as system tax" Info="If set, and a product is placed in a VAT group, the VAT group percent is used as system VAT when loading the price - if that VAT group has a value in the current VAT country context." />

			<dwc:CheckBox runat="server" ID="CalculatePercentShippingFeeInclVAT" Name="/Globalsettings/Ecom/Price/CalculatePercentShippingFeeInclVAT" Label="Beregn % forsendelsesgebyr inkl. moms" />
			<dwc:CheckBox runat="server" ID="UseDeliveryCountry" Name="/Globalsettings/Ecom/Order/VAT/UseDeliveryCountry" Label="Brug alt. leveringsland ved moms" Info="Country decides the VAT rate used in calculations. When checked the order delivery country is used for VAT calculations on orders" />
			<dwc:CheckBox runat="server" ID="CalculatePaymentFeeInclShippingFee" Name="/Globalsettings/Ecom/Price/CalculatePaymentFeeInclShippingFee" Label="Calculate payment fee from price including shipping fee" Info="When payment fees are % of ordertotal, check this box to have shipping fees be part of the total" />
			<dwc:CheckBox runat="server" ID="AllowNegativeOrderTotalPrice" Name="/Globalsettings/Ecom/Price/AllowNegativeOrderTotalPrice" Label="Allow negative total order price" Info="When enabled orders with a negative total is allowed" />
            <dw:Infobar runat="server" ID="NoSystemVatWarning" Visible="false" Type="Warning" Message="Prices in the database includes VAT, but no 'System VAT' is set"/>
            <dw:Infobar runat="server" ID="MultipleCountriesWarning" Visible="false" Type="Warning" Message="Prices in the database include VAT, but the solution contains multiple countries. Are you sure this is what you want?" />
            <dwc:CheckBox runat="server" id="RoundPricesWithVAT" Name="/Globalsettings/Ecom/Price/RoundPricesWithVAT" Label="Afrund priser med moms" Info="When prices are being rounded using rounding rules, this setting will round the price with VAT first and calculate the price without VAT after. If not set, it is opposite" />
        </dwc:GroupBox>

        <dwc:GroupBox Title="Calculation rounding" runat="server">
            <dwc:RadioGroup runat="server" ID="Roundingrule" Name="/Globalsettings/Ecom/Price/Roundingrule" SelectedValue="" Label="Order rounding">
                <dwc:RadioButton runat="server" FieldValue="" Label="Round only displayed price" Info="Rounding two order lines (3 x 4.992 = 14.976) + (2 x 2.443 = 4,886) Total = 19,862 in DB = 19,86 displayed" />
                <dwc:RadioButton runat="server" FieldValue="OrderlineTotal" Label="Round order line total" Info="Rounding two order lines (3 x 4.992 = 14.976 = 14.98) + (2 x 2.443 = 4,886 = 4,89) Total = 19,87 in DB" />
                <dwc:RadioButton runat="server" FieldValue="RoundUnitPrice" Label="Round unit price" Info="Rounding two order lines (3 x 4.992 = 3 x 4.99 = 14.97) + (2 x 2.443 = 2 x 2.44 = 4.88) Total = 19,85 in DB" />
            </dwc:RadioGroup>
        </dwc:GroupBox>				

        <dwc:GroupBox Title="Calculate VAT on fees" runat="server">
			<dwc:CheckBox runat="server" ID="IncludeVATOnPaymentFee" Name="/Globalsettings/Ecom/Order/PaymentFee/IncludeVATOnPaymentFee" Label="Payment" info="Add VAT on payment fees"/>
			<dwc:CheckBox runat="server" ID="IncludeVATOnShippingFee" Name="/Globalsettings/Ecom/Order/ShippingFee/IncludeVATOnShippingFee" Label="Shipment" info="Add VAT on shipping fees" />			
		</dwc:GroupBox>
    </div>

    <% Translate.GetEditOnlineScript() %>

</asp:Content>
