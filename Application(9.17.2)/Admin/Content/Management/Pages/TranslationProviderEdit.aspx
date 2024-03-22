<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TranslationProviderEdit.aspx.vb" Inherits="Dynamicweb.Admin.TranslationProviderEdit" %>


<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        #translatebtn {
            width: auto;
            padding: 0 4px;
        }
    </style>
    <asp:Literal ID="addInSelectorScripts" runat="server" />
    <script>
        class TranslationProviderEditPage {
            constructor(opts) {
                this.options = opts;
            }

            save(close) {
                if (this.validate()) {
                    let cmd = document.getElementById('cmdSubmit');
                    cmd.value = close ? "SaveAndClose" : "Save";
                    cmd.click();
                }
            }

            validate() {
                let hasValue = function (el) {
                    return !!el.value;
                };
                let nameEl = document.getElementById(this.options.ids.name)
                if (!hasValue(nameEl)) {
                    dwGlobal.showControlErrors(nameEl, this.options.labels.emptyName);
                    nameEl.focus();
                    return false;
                }
                let providerSelectorEl = document.getElementById(this.options.ids.providerSelector)
                if (!hasValue(providerSelectorEl)) {
                    dwGlobal.showControlErrors(providerSelectorEl, this.options.labels.emptyProviderName);
                    providerSelectorEl.focus();
                    return false;
                }
                return true;
            };

            cancel() {
                Action.Execute(this.options.actions.list);
            }

            showTestSettignsDialog() {
                let translatedTextEl = document.getElementById(this.options.ids.translatedText);
                dwGlobal.hideControlErrors(translatedTextEl, "");
                dialog.show(this.options.ids.testSettingsDlg);
            }

            testSettigns() {
                let act = this.options.actions.settingsCheck;
                act.Parameters = {
                    SourceCultureInfo: document.getElementById(this.options.ids.sourceLanguage).value,
                    DestinationCultureInfo: document.getElementById(this.options.ids.destinationLanguage).value,
                    SourceText: [document.getElementById(this.options.ids.sourceText).value],
                };
                showOverlay("testWait");
                Action.Execute(act);
            }

            showSettingsCheckSuccessResult(act, model) {
                hideOverlay("testWait");
                let translatedTextEl = document.getElementById(this.options.ids.translatedText);
                dwGlobal.hideControlErrors(translatedTextEl, "");
                if (model.Succeeded) {
                    translatedTextEl.value = model.Data[0];
                }
                else {
                    translatedTextEl.value = "";
                    dwGlobal.showControlErrors(translatedTextEl, model.Message);
                }
            }

            showSettingsCheckFailResult() {
                hideOverlay("testWait");
                let translatedTextEl = document.getElementById(this.options.ids.translatedText);
                translatedTextEl.value = "";
                dwGlobal.showControlErrors(translatedTextEl, "Internal server error. See console.");
            }
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit online translation service" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true);" />
                    <dw:ToolbarButton ID="cmdTestSettings" Icon="TextFormat" Text="Test settings" runat="server" OnClientClick="currentPage.showTestSettignsDialog();" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="TimesCircle" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="State settings" runat="server">
                        <dwc:InputText ID="TranslationProviderName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                        <dwc:CheckBox ID="IsDefault" runat="server" Label="Default" />
                    </dwc:GroupBox>
                    <dw:AddInSelector ID="addInSelector" runat="server" AddInGroupName="Online translations providers" UseLabelAsName="False" AddInBreakFieldsets="False"
                        AddInShowNothingSelected="true" NoParametersMessage="No provider selected." AddInTypeName="Dynamicweb.Extensibility.Provider.TranslationProvider" />
                    <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
                    <dw:Dialog ID="TestSettingsDialog" Title="Test settings" Size="Small" ShowCancelButton="true" CancelText="Close" ShowClose="true" runat="server" ShowOkButton="false" OkAction="">
                        <dwc:SelectPicker runat="server" ID="SourceLanguage" Label="Source language" AllowSearch="true"></dwc:SelectPicker>
                        <dwc:SelectPicker runat="server" ID="DestinationLanguage" Label="Destination language"  AllowSearch="true"></dwc:SelectPicker>
                        <dwc:InputText runat="server" ID="SourceText" Label="Source text" Value="hello" ValidationMessage="">
                            <dwc:FieldAddOn Id="translatebtn" Text="Try translate" OnClick="currentPage.testSettigns()" />
                        </dwc:InputText>
                        <dwc:InputText runat="server" ID="TranslatedText" Label="Translated Text" Value="" ValidationMessage=""></dwc:InputText>
                        <dw:Overlay ID="testWait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
                    </dw:Dialog>
                    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

