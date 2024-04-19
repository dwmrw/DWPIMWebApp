
function showSetValueDialog(fieldType, fieldId, rowId) {
    fieldType = fieldType || ContextMenu.callingItemID;
    fieldId = fieldId || ContextMenu.callingID;
    var container = document.getElementById("editorsContainer");
    var editor = Dynamicweb.PIM.BulkEdit.get_current()._setEditorsVisibility(container, fieldId);
    var currentField = rowId ? document.getElementById(rowId + fieldId) : null;
    var currentFieldValue = currentField ? currentField.value : "";
    switch (fieldType) {
        case "EditorText":
            const editorWrapper = new EditorWrapper('EditorTextFieldEditor');
            editorWrapper.setData(currentFieldValue);
            break;
        case "DateTime":
        case "Date":
            setDateField(Dynamicweb.PIM.BulkEdit.get_current()[fieldType + "FieldEditorId"]);
            break;
        case "Select":
        case "GroupDropDownList":
            editor.value = currentField ? currentField.value : editor.options[0].value;
            break;
        case "Link":
            document.getElementById("Link_" + editor.id).value = currentFieldValue;
        default:
            editor.value = currentFieldValue;
    }
    document.getElementById("currentProductRow").value = rowId || "";
    document.getElementById("currentFieldType").value = fieldType || "Text";
    document.getElementById("currentFieldId").value = fieldId || "";
    dialog.show('SetValueDialog', null, fieldType == "EditorText" ? "dialog-lg" : "");
};

function updateFieldValues() {
    var fieldType = document.getElementById("currentFieldType").value;
    var fieldId = document.getElementById("currentFieldId").value;
    var self = Dynamicweb.PIM.BulkEdit.get_current();
    var editorcontainer = null;
    var editorsContainer = document.getElementById("editorsContainer");
    for (var i = 0; i < editorsContainer.children.length; i++) {
        var container = editorsContainer.children[i];
        if (container.tagName === "DIV") {
            if (!!self._getFieldsGridEditor(fieldType, container)) {
                editorcontainer = container;
                break;
            }
        }
    }
    if (!editorcontainer) {
        editorcontainer = editorsContainer.firstElementChild;
    }

    var updatedValue = self._getEditorValue(editorcontainer, fieldType, fieldId);

    var visibleRowIds = null;
    var rowId = document.getElementById("currentProductRow").value;
    if (rowId) {
        visibleRowIds = [rowId];
    } else if (listHasFilter()) {
        visibleRowIds = getRows(true).map(function (row) { return row.getAttribute("data-product-id") + "_;_" + row.getAttribute("data-variant-id") + "_;_" + row.getAttribute("data-language-id") + "_;_" });
    }
    var definitions = getFieldDefinitions(document.getElementById("currentFieldId").value, visibleRowIds);
    for (var i = 0; i < definitions.length; i++) {
        var definition = definitions[i];
        var controlId = definition.controlId;
        var setAdditionalElements = null;
        switch (definition.controlType) {
            case "EditorText":
                controlId = controlId.substring(0, controlId.length - "_editor".length);
                break;
            case "DateTime":
            case "Date":
                controlId = controlId.substring(0, controlId.length - "_label".length) + "_calendar";
                setAdditionalElements = function () {
                    setDateField(controlId, updatedValue);
                    return false;
                }
                break;
            case "Link":
                setAdditionalElements = function () {
                    document.getElementById(controlId.substring("Link_".length)).value = updatedValue;
                    return true;
                }
                break;
            case "MultiSelectList":
                setAdditionalElements = function () {
                    var selector = document.getElementById(controlId);
                    for (var i = 0; i < selector.options.length; i++) {
                        selector.options[i].selected = updatedValue.indexOf(selector.options[i].value) != -1;
                    }
                    if (selector.dwSelector) {
                        selector.dwSelector.select(updatedValue);
                    }
                    return false;
                }
                break;
        }
        var fieldControl = document.getElementById(controlId);
        var fieldContainder = fieldControl.closest(".field-container");
        if (fieldContainder.classList.contains("master-has-variants") || fieldContainder.classList.contains("field-permission-disabled")) {
            continue;
        }
        if (setAdditionalElements != null) {
            if (!setAdditionalElements()) {
                continue;
            }
        }
        fieldControl.value = updatedValue;
    }

    document.getElementById("FocusedFieldId").value = "";
    dialog.hide('SetValueDialog');
};

function setDateField(controlId, updatedValue) {
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    if (Dynamicweb.PIM.BulkEdit.prototype._controlIdEndsWith(controlId, "_calendar")) {
        controlId = controlId.substring(0, controlId.length - "_calendar".length)
    }
    var val = updatedValue ? new Date(updatedValue) : null;
    datepicker.SetDate(controlId, val);
    if (val) {
        datepicker.UpdateCalendarDate(val, controlId);
    }
}

function sortAsc() {
    sortRows(1);
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    document.getElementById(ContextMenu.callingID + "_ASC").classList.remove("hidden");
}

function sortDesc() {
    sortRows(-1);
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    document.getElementById(ContextMenu.callingID + "_DESC").classList.remove("hidden");
}

function hideByQuerySelector(querySelector) {
    var elementsToHide = document.querySelectorAll(querySelector);
    for (i = 0; i < elementsToHide.length; ++i) {
        elementsToHide[i].classList.add("hidden");
    }
}

function sortRows(direction) {
    var fieldType = ContextMenu.callingItemID;
    var fieldId = ContextMenu.callingID;
    var tableBody = document.querySelector('#productsContainer>tbody');
    var itemsArr = getRows();
    itemsArr.sort(function (a, b) {
        var valA = getRowValue(a, fieldId);
        var valB = getRowValue(b, fieldId);
        switch (fieldType) {
            case "Integer":
                valA = parseInt(valA);
                valB = parseInt(valB);
                break;
            case "Double":
                valA = parseFloat(valA);
                valB = parseFloat(valB);
                break;
            case "Date":
            case "DateTime":
                valA = Date.parse(valA);
                valB = Date.parse(valB);
                break;
        }
        return valA == valB ? 0 : direction * (valA > valB ? 1 : -1);
    });

    for (i = 0; i < itemsArr.length; ++i) {
        tableBody.appendChild(itemsArr[i]);
    }
}

function getRows(onlyVisible) {
    var list = document.getElementById('productsContainer');
    var rowSelector = ".row:not(.header-row)"
    if (!!onlyVisible) {
        rowSelector += ":not(.hidden)"
    }
    var rowItems = list.querySelectorAll(rowSelector);
    var rows = [];
    for (var i = 0; i < rowItems.length; i++) {
        rows.push(rowItems[i]);
    }
    return rows;
}

function getRowValue(row, controlId) {
    var fieldType = ContextMenu.callingItemID;
    var controlSelector = controlId;
    switch (fieldType) {
        case "Date":
        case "DateTime":
            controlSelector += "_calendar"
            break;
    }
    if (fieldType == "Select") {
        var selector = row.querySelector("[id$='" + controlSelector + "']");
        return selector.options[selector.selectedIndex].text;
    }
    return row.querySelector("[id$='" + controlSelector + "']").value;
}

function getRowCellValue(row, fieldType, fieldId) {
    let controlSelector = fieldId;
    return row.querySelector("[id$='" + controlSelector + "']").value;
}

function setRowCellValue(row, fieldType, fieldId, val) {
    let controlSelector = fieldId;
    let cellEl = row.querySelector("[id$='" + controlSelector + "']");

    var fieldContainder = cellEl.closest(".field-container");
    if (fieldContainder.classList.contains("field-permission-disabled")) {
        return;
    }
    cellEl.value = val;
}

function getProductIdentityKey(row) {
    return new ProductKey(row.dataset.productId, row.dataset.variantId, row.dataset.languageId);
}

function showReplaceDialog() {
    document.getElementById("SearchValue").value = '';
    document.getElementById("ReplacementValue").value = '';
    dialog.show('ReplaceDialog');
}

function replaceValues() {
    var fieldId = ContextMenu.callingID;
    var searchValueElement = document.getElementById("SearchValue");
    var searchValue = searchValueElement.value;
    if (!searchValue) {
        dwGlobal.showControlErrors(searchValueElement, "Cannot be empty")
    } else {
        var replacement = document.getElementById("ReplacementValue").value;
        var gridRows = getRows();
        for (i = 0; i < gridRows.length; ++i) {
            var gridRow = gridRows[i];
            var rowInput = gridRow.querySelector("[id$='" + fieldId + "']");

            var fieldContainder = rowInput.closest(".field-container");
            if (fieldContainder.classList.contains("field-permission-disabled")) {
                continue;
            }
            var escaped = escapeRegExp(searchValue);
            rowInput.value = rowInput.value.replace(new RegExp(escaped, 'ig'), escapeReplacement(replacement));
        }
        document.getElementById("FocusedFieldId").value = "";
        dialog.hide('ReplaceDialog');
    }
}

// https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}

function escapeReplacement(string) {
    return string.replace(/\$/g, '$$$$');
}

function showFilteringDialog() {
    document.getElementById("FilterText").value = '';
    dialog.show('FilterDialog');
}

function listHasFilter() {
    return document.querySelector(".column-header-adornment.filtering-adornment:not(.hidden)") != null;
}

function filterRows() {
    var fieldId = ContextMenu.callingID;
    hideByQuerySelector(".column-header-adornment.filtering-adornment");
    var textFilter = document.getElementById("FilterText").value.toLowerCase();
    document.getElementById(ContextMenu.callingID + "_Filter").classList.remove("hidden");

    var gridRows = getRows();
    for (i = 0; i < gridRows.length; ++i) {
        var gridRow = gridRows[i];
        var rowValue = getRowValue(gridRow, fieldId).toLowerCase();
        if ((!!textFilter && rowValue.indexOf(textFilter.toLowerCase()) >= 0) || (!textFilter && !rowValue)) {
            gridRow.classList.remove("hidden");
        } else {
            gridRow.classList.add("hidden");
        }
    }

    dialog.hide('FilterDialog');
}

function onGridContextMenuView() {
    var view = '';
    var fieldType = ContextMenu.callingItemID;
    var fieldId = ContextMenu.callingID;
    if (!document.getElementById(fieldId + "_Filter").classList.contains("hidden")) {
        view = 'filtering';
    }
    if (!document.getElementById(fieldId + "_ASC").classList.contains("hidden") || !document.getElementById(fieldId + "_DESC").classList.contains("hidden")) {
        view = view ? 'filteringAndSorting' : 'sorting';
    }
    if (fieldType == "Text" || fieldType == "EditorText" || fieldType == "TextLong") {
        view += 'Replace';
    }
    var definitions = getCategoryFieldEditors(fieldId);
    if (definitions.length) {
        view += 'Restore';
    }
    return view || 'common';
}

function setValueContextGetState() {
    if (!ContextMenu.callingItemID) {
        return 'disabled';
    } else if (ContextMenu.callingItemID == 'ProductVariantCombinationName') {
        return 'hidden';
    }
    return null;
}

function translateContextGetState() {
    if (!ContextMenu.callingItemID) {
        return 'disabled';
    }
    let fieldId = ContextMenu.callingID;
    let definitions = getFieldDefinitions(fieldId);
    if (!definitions || definitions.length == 0) {
        return 'disabled';
    }
    let fieldInfo = definitions[0];
    if (!fieldInfo.languageEditing) {
        return 'disabled';
    }
    return null;
}

function removeFiltering() {
    hideByQuerySelector(".column-header-adornment.filtering-adornment");
    var gridRows = getRows();
    for (i = 0; i < gridRows.length; ++i) {
        var gridRow = gridRows[i];
        gridRow.classList.remove("hidden");
    }
}

function removeSorting() {
    var tableBody = document.querySelector('#productsContainer>tbody');
    hideByQuerySelector(".column-header-adornment.sorting-adornment");
    var itemsArr = getRows();
    itemsArr.sort(function (a, b) {
        return a.getAttribute("data-original-sorting") - b.getAttribute("data-original-sorting");
    });

    for (i = 0; i < itemsArr.length; ++i) {
        tableBody.appendChild(itemsArr[i]);
    }
}

function setButtonsTooltip(menuId, disabledButtonTooltip) {
    var menu = document.getElementById(menuId);
    menu.querySelectorAll("a.button-disabled").forEach(function (button) {
        button.title = disabledButtonTooltip;
    });
}

function restoreCategoryValues() {
    var definitions = getCategoryFieldEditors(ContextMenu.callingID);
    for (var i = 0; i < definitions.length; i++) {
        definitions[i].isInherited = true;
    }
}

function getCategoryFieldEditors(fieldId) {
    var categoryFieldEditors = [];
    var definitions = getFieldDefinitions(fieldId);
    for (var i = 0; i < definitions.length; i++) {
        var definition = definitions[i];
        var controlId = definition.controlId;
        switch (definition.controlType) {
            case "EditorText":
                controlId = controlId.substring(0, controlId.length - "_editor".length);
                break;
            case "DateTime":
            case "Date":
                controlId = controlId.substring(0, controlId.length - "_label".length);
                break;
            case "Link":
                controlId = controlId.substring("Link_".length);
                break;
        }
        const categoryFieldEditor = Dynamicweb.PIM.BulkEdit.CategoryFieldEditor.editorsById[controlId];
        if (categoryFieldEditor) {
            categoryFieldEditors.push(categoryFieldEditor);
        }
    }
    return categoryFieldEditors;
}

function getFieldDefinitions(fieldId, visibleRowIds) {
    let self = Dynamicweb.PIM.BulkEdit.get_current();
    return self._controlDefinitions.filter(function (definition, index) {
        if (visibleRowIds != null && !visibleRowIds.some(function (rowId) { return definition.controlId.indexOf(rowId) == 0; })) {
            return false
        }
        let id = fieldId;
        switch (definition.controlType) {
            case "EditorText":
                id += "_editor";
                break;
            case "DateTime":
            case "Date":
                id += "_label";
                break;
        }
        return self._controlIdEndsWith(definition.controlId, "_" + id);
    });
}

function showTranslateDialog() {
    checkSourceLanguageFields();
    dialog.show('TranslateDialog');
}

function checkSourceLanguageFields(fromLanguageId) {
    let fieldType = ContextMenu.callingItemID;
    let fieldId = ContextMenu.callingID;
    if (!fromLanguageId) {
        let fromEl = document.querySelector("#translate-from .language-checkbox.active");
        fromLanguageId = fromEl.dataset.langId;
    }
    let missingSourceLangRows = getRows().filter(row => {
        var rowIdentity = getProductIdentityKey(row);
        var rowValue = getRowCellValue(row, fieldType, fieldId);
        let strippedrowValue = rowValue.replace(/(<([^>]+)>)/gi, "");
        return rowIdentity.languageId == fromLanguageId && (!rowValue || !strippedrowValue);
    });    
    var missingSourceValues = missingSourceLangRows.length;
    if (!!missingSourceValues) {
        errorUiComponent(true, Dynamicweb.PIM.BulkEdit.get_current().terminology["TranslationSourceMissing"].replace("%%", missingSourceValues));
    } else {
        errorUiComponent(false);
    }
}

function runTranslation() {
    let fieldType = ContextMenu.callingItemID;
    let fieldId = ContextMenu.callingID;
    let fromEl = document.querySelector("#translate-from .language-checkbox.active");
    let fromLanguageId = fromEl.dataset.langId;
    let fromCultureInfo = fromEl.dataset.cultureInfo;
    let toLanguageIds = Array.from(document.querySelectorAll("#translate-to .language-checkbox.active"))
        .filter(el => el.dataset.langId !== fromLanguageId)
        .map(el => el.dataset.langId);
    let langIds = new Set(toLanguageIds);
    langIds.add(fromLanguageId);
    let rowsPerLang = getRows().reduce((map, row) => {
        var productKey = getProductIdentityKey(row);
        if (!langIds.has(productKey.languageId)) {
            return map;
        }
        let langRows = map.get(productKey.languageId);
        if (langRows) {
            langRows.push(row);
        }
        else {
            langRows = [row];
            map.set(productKey.languageId, langRows);
        }
        return map;
    }, new Map());
    let from = new LanguageRows(fromLanguageId, fromCultureInfo, rowsPerLang.get(fromLanguageId));
    let processors = toLanguageIds.map(langId => {
        let cultureInfo = document.querySelector(`#translate-to .language-checkbox[data-lang-id=${langId}]`).dataset.cultureInfo;
        let to = new LanguageRows(langId, cultureInfo, rowsPerLang.get(langId));
        return new TranslateProcessor(from, to, new TranslateProcessorOptions(fieldType, fieldId));
    });
    errorUiComponent(false);
    processors.forEach(translator => {
        translator.run();
    })
}

function errorUiComponent(show, msg) {
    let el = document.getElementById("InfoBar_ErrorInfo");
    if (show) {
        el.querySelector(".alert-container").textContent = msg || "";
        el.classList.remove("hidden");
    } else {
        el.classList.add("hidden");
    }
}

function selectTranslateFrom(evt, langId) {
    let langEl = evt.currentTarget;
    let langPanelEl = langEl.closest(".language-panel");
    let selectedLanguages = Array.from(langPanelEl.querySelectorAll(".language-checkbox.active"));
    selectedLanguages.forEach(node => {
        node.classList.remove("active");
    });
    checkSourceLanguageFields(langId);
    langEl.classList.add("active");
    Array.from(document.getElementById("translate-to").querySelectorAll(".language-checkbox")).forEach(el => {
        el.classList.remove("disabled");
        if (el.dataset.langId == langId) {
            if (el.classList.contains("active")) {
                selectTranslateTo({ currentTarget: el }, langId);
            }
            el.classList.add("disabled");
        }
    });
}

function selectTranslateTo(evt, langId) {
    let langEl = evt.currentTarget;
    if (langEl.classList.contains("disabled")) {
        return;
    }
    langEl.classList.toggle("active");
    let rows = Array.from(document.querySelectorAll(`.listRow.lang-progress-row[itemid=${langId}]`));
    rows.forEach(node => {
        node.classList.toggle("hidden");
    });
}

class TranslateProcessor {
    constructor(from, to, options) {
        this.from = from;
        this.to = to;
        this.options = options;
        this.progressBar = new ProgressBar(document.querySelector(`.listRow.lang-progress-row[itemid=${to.langId}] .progress-indicator`))
    }

    splitList(arr, chunk) {
        let result = [];
        let i, j;
        for (i = 0, j = arr.length; i < j; i += chunk) {
            result.push(arr.slice(i, i + chunk));
        }
        return result;
    }

    run() {
		if (!this.to.rows || !this.from.rows) {
			return;
		}
		
        const CHUNK_SIZE = 25;
        let chunks = this.splitList(this.from.rows, CHUNK_SIZE);
        this.progressBar.total = chunks.length;
        let translatedRowPerProductKey = this.to.rows.reduce((map, row) => {
            let productKey = getProductIdentityKey(row);
            map.set(productKey.toString(), row);
            return map;
        }, new Map());
        chunks.forEach(rows => {
            let sourceTextArr = rows
                .filter(row => {
                    let productKey = getProductIdentityKey(row);
                    productKey.languageId = this.to.languageId;
                    let translatedRow = translatedRowPerProductKey.get(productKey.toString());
                    return translatedRow != null;
                })
                .map(row => this.from.getCellValue(row, this.options.fieldType, this.options.fieldId));
            if (sourceTextArr.length > 0) {
                this.executeTranslation(sourceTextArr)
                    .then((model) => {
                        if (model.Succeeded) {
                            let translatedTextArr = model.Data;
                            rows.forEach((row, index) => {
                                let productKey = getProductIdentityKey(row);
                                productKey.languageId = this.to.languageId;
                                let translatedRow = translatedRowPerProductKey.get(productKey.toString());
                                if (translatedRow) {
                                    this.to.setCellValue(translatedRow, this.options.fieldType, this.options.fieldId, translatedTextArr[index]);
                                }
                            });
                        } else {
                            errorUiComponent(true, model.Message);
                        }
                    })
                    .catch((e) => {
                        errorUiComponent(true, e.toString());
                    })
                    .finally((f) => {
                        this.progressBar.tick();
                    });
            } else {
                this.progressBar.tick();
            }
        });
    }

    async executeTranslation(sourceTextArr) {
        let response = await fetch(this.options.translateUrl, {
            method: "POST",
            headers: {
                "content-type": "application/json"
            },
            body: JSON.stringify({
                SourceCultureInfo: this.from.cultureInfo,
                DestinationCultureInfo: this.to.cultureInfo,
                SourceText: sourceTextArr
            })
        })
        if (!response.ok) {
            throw new Error(`HTTP error! ${response}`);
        } else {
            return await response.json();
        }
    }
};

class ProgressBar {
    constructor(progressBarEl) {
        this.progressBarEl = progressBarEl;
        this.total = 100;
    }

    get total() {
        return this._total;
    }

    set total(val) {
        this._total = val;
        this._current = 0;
    }

    tick() {
        this._current += 1;
        this.render();
    }

    render() {
        let perc = Math.round((this._current * 100) / this.total);
        this.progressBarEl.dataset.value = perc;
        this.progressBarEl.innerText = `${perc} %`;
    }
};

class LanguageRows {
    constructor(langId, cultureInfo, langRows) {
        this.langId = langId;
        this.culture = cultureInfo;
        this.rowsEl = langRows;
    }

    get languageId() {
        return this.langId;
    }

    get cultureInfo() {
        return this.culture;
    }

    get rows() {
        return this.rowsEl;
    }

    getCellValue(row, fieldType, fieldId) {
        return getRowCellValue(row, fieldType, fieldId);
    }

    setCellValue(row, fieldType, fieldId, val) {
        setRowCellValue(row, fieldType, fieldId, val);
    }
}

class TranslateProcessorOptions {
    constructor(fieldType, fieldId) {
        this.translateUrl = "/Admin/api/translation/translatehtml";
        this.fieldType = fieldType;
        this.fieldId = fieldId;
    }
}

class ProductKey {
    constructor(productId, variantId, languageId) {
        this.productId = productId;
        this.variantId = variantId || "";
        this.languageId = languageId;
    }

    toString() {
        return `${this.productId}_;_${this.variantId}_;_${this.languageId}_;_`;
    }
}