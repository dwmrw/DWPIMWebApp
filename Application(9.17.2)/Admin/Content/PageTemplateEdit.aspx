<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PageTemplateEdit.aspx.vb" Inherits="Dynamicweb.Admin.PageTemplateEdit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true" IncludeUIStylesheet="true" CombineOutput="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var requiredValueWarn = "<%=Translator.JsTranslate("required") %>";

        function ChangeCategoryType() {
            var categoryTypeNew = document.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];

            if (categoryTypeNew.checked) {
                document.getElementById("TemplateNewCategoryDiv").style.display = '';
                document.getElementById("TemplateExistingCategoriesDiv").style.display = 'none';
            }
            else {
                document.getElementById("TemplateNewCategoryDiv").style.display = 'none';
                document.getElementById("TemplateExistingCategoriesDiv").style.display = '';
            }
        }
        
        function SaveTemplate(pageId, onSuccess) {
            var isTemplate = "true";
            if (document.getElementById("isTemplate")) {
                isTemplate = document.getElementById("isTemplate").checked.toString();
            }

            var categoryTypeNew = document.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0] || { checked: true };
            var templateCategory = categoryTypeNew.checked ? document.getElementById("TemplateNewCategory") : document.getElementById("TemplateCategory");
            if (categoryTypeNew.checked) {
                if (!templateCategory.value) {
                    dwGlobal.showControlErrors(templateCategory, requiredValueWarn);
                    templateCategory.focus();
                    return false;
                }
                else {
                    dwGlobal.hideControlErrors(templateCategory);
                }
            }

            var url = "/Admin/Content/PageTemplateEdit.aspx?cmd=SaveAsTemplate&PageID=" + pageId 
                + "&TemplateName=" + encodeURI(document.getElementById("TemplateName").value)
                + "&TemplateDescription=" + encodeURI(document.getElementById("TemplateDescription").value)
                + "&TemplateImage=" + encodeURI(document.getElementById("FM_TemplateImage").value)
                + "&isTemplate=" + encodeURI(isTemplate)
                + "&TemplateCategory=" + encodeURI(templateCategory.value);

            fetch(url, {
                method: 'POST'
            }).then((resp) => resp.json()
            ).then((data) => {
                if (onSuccess) {
                    onSuccess(data.TemplateId);
                }
            }).catch(reason => {
                console.log("Unable to save template: {0}", reason);
            });

            return true;
        }
    </script>
</head>
<body>
    <div class="card">
        <form runat="server" action="PageTemplateEdit.aspx" method="post">
            <dwc:GroupBox runat="server">
                <dwc:InputText runat="server" ID="TemplateName" Label="Navn" ValidationMessage="" MaxLength="255" />
                <dwc:InputText runat="server" ID="TemplateDescription" Label="Beskrivelse" MaxLength="255" />
                <dw:FileManager runat="server" ID="TemplateImage" Name="TemplateImage"  Label="Image" Extensions="jpg,gif,png,swf,webp,tif,tiff" />
                <div id="isTemplateRow" runat="server" visible="false">
                    <dwc:CheckBox ID="isTemplate" runat="server" Value="1" Label="Aktiv" SelectedFieldValue="1" />
                </div>
                <dwc:RadioGroup runat="server" ID="TemplateCategoryType" Name="TemplateCategoryType" Label="Categories" Info="" SelectedValue="new" >
                    <dwc:RadioButton runat="server" ID="TemplateCategoryTypeNew" Label="New" FieldValue="new" OnClick="ChangeCategoryType()" />
                    <dwc:RadioButton runat="server" ID="TemplateCategoryTypeExisting" Label="Existing" FieldValue="existing" OnClick="ChangeCategoryType()" />
                </dwc:RadioGroup>
                <div id="TemplateNewCategoryDiv" runat="server">
                    <dwc:InputText runat="server" ID="TemplateNewCategory" Label="Category name" ValidationMessage="" MaxLength="255" />
                </div>
                <div id="TemplateExistingCategoriesDiv" runat="server" style="display: none;">
                    <dwc:SelectPicker ID="TemplateCategory" runat="server" Label="Category name"></dwc:SelectPicker>
                </div>
            </dwc:GroupBox>
        </form>
    </div>
</body>
</html>
