
function applyDropDownOption(listId, hiddenParameters, dropDownOptionParametersToHide, hiddenSections, dropDownOptionSectionsToHide) {
    if (listId != null) {
        showAllHiddenElements(listId, hiddenParameters, hiddenSections);
        applyDropDownOptionParametersToHide(listId, hiddenParameters, dropDownOptionParametersToHide);
        applydropDownOptionSectionsToHide(listId, hiddenSections, dropDownOptionSectionsToHide);
    }
}

function applyDropDownOptionParametersToHide(listId, hiddenParameters, dropDownOptionParametersToHide) {
    var listOptionParametersArrayDictionary = dropDownOptionParametersToHide[listId];
    if (listOptionParametersArrayDictionary != null) {
        var dropdown = document.getElementById(listId);
        if (dropdown != null) {
            var value = dropdown.options[dropdown.selectedIndex].value;
            if (value != null && listOptionParametersArrayDictionary[value] != null) {
                hiddenParameters[listId] = [];
                listOptionParametersArrayDictionary[value].forEach((id) => {
                    var el = document.getElementById(id);
                    if (el == null) {
                        el = document.getElementById(id + '_calendar_btn');
                    }
                    if (el != null) {
                        hideAddInPropertyElement(el);
                        hiddenParameters[listId].push(el.id);
                    }
                });
            }
        }
    }
}

function applydropDownOptionSectionsToHide(listId, hiddenSections, dropDownOptionSectionsToHide) {
    var listOptionSectionsArrayDictionary = dropDownOptionSectionsToHide[listId];
    if (listOptionSectionsArrayDictionary != null) {
        var dropdown = document.getElementById(listId);
        if (dropdown != null) {
            var value = dropdown.options[dropdown.selectedIndex].value;
            if (value != null && listOptionSectionsArrayDictionary[value] != null) {
                listOptionSectionsArrayDictionary[value].forEach((sectionName) => {
                    var sections = findParametersByAttributeContainsValue(document, "sectionname", sectionName, "div");
                    sections.forEach((section) => {
                        section.style.display = 'none';
                    });
                    hiddenSections.push(sectionName);
                });
            }
        }
    }
}

function showAllHiddenElements(listId, hiddenParameters, hiddenSections) {
    if (hiddenParameters[listId] != null) {
        for (var j = 0; j < hiddenParameters[listId].length; j++) {
            showAddInPropertyElement(document.getElementById(hiddenParameters[listId][j]));
        }
        hiddenParameters[listId] = [];
    }
    var sections = findParametersByAttributeContainsValue(document, "sectionname", "", "div");
    for (var k = 0; k < sections.length; k++) {
        sections[k].style.display = '';
    }
    hiddenSections = [];
}

function hideAddInPropertyElement(element) {
    var frmGroupEl = element.closest(".form-group");
    if (frmGroupEl) {
        frmGroupEl.style.display = 'none';
    }
}

function showAddInPropertyElement(element) {
    var frmGroupEl = element.closest(".form-group");
    if (frmGroupEl) {
        frmGroupEl.style.display = '';
    }
}

function findParametersByAttributeContainsValue(parametersDiv, attribute, value, element_type) {
    if (parametersDiv !== null) {
        element_type = element_type || "*";
        var elements = [];
        var parameters = parametersDiv.getElementsByTagName(element_type);
        for (var i = 0; i < parameters.length; i++) {
            var parameter = parameters[i];
            var attributeValue = parameter.getAttribute(attribute);
            if (attributeValue !== null && attributeValue.indexOf(value) >= 0) { elements.push(parameter); }
        }
    }
    return elements;
}

function initMultiColumnDropDown(parentEl) {
    if (parentEl != null) {
        parentEl.querySelector('.custom-select-wrapper').addEventListener('click', function () {
            this.querySelector('.custom-select').classList.toggle('open');
        });

        for (const option of parentEl.querySelectorAll(".custom-option")) {
            option.addEventListener('click', function () {
                if (!this.classList.contains('selected')) {
                    this.parentNode.querySelector('.custom-option.selected').classList.remove('selected');
                    this.classList.add('selected');
                    this.closest('.custom-select').querySelector('.custom-select__trigger span').textContent = this.querySelector("span").textContent;
                    var dropdown = document.getElementById(this.closest('.custom-select-wrapper').dataset.selectid);
                    if (dropdown != null) {
                        dropdown.value = this.dataset.value;
                        dropdown.dispatchEvent(new Event('change'));
                    }
                }
            })
        }

        const headerEl = parentEl.querySelector(".header");
        if (headerEl != null) {
            for (var i = 0; i < headerEl.children.length; i++) {
                var h = headerEl.children[i].children[0].offsetHeight;
                headerEl.children[i].children[1].style["margin-top"] = (-1) * ((Math.round(h/17)-1)*8) + "px";
            }
        }

        window.addEventListener('click', function (e) {
            const select = parentEl.querySelector('.custom-select')
            if (select != null && !select.contains(e.target)) {
                select.classList.remove('open');
            }
        });
    }
}

function sortDropDown(listId, columnIndex) {
    if (listId != null) {
        var sortAsc = true;
        var dropdown = document.getElementById(listId);
        var parentEl = dropdown.parentElement;
        const headerEl = parentEl.querySelector(".header");
        if (headerEl != null) {
            var iconEl = headerEl.children[columnIndex].children[1].children[0];
            if (iconEl.className.indexOf("fa-sort") == -1 && iconEl.className.indexOf("arrow-up") > 0)
                sortAsc = false;
        }
        var customOptionsDiv = parentEl.querySelector('.custom-options');
        var options = Array.prototype.slice.call(customOptionsDiv.children, 0);
        var toSort = options.slice(1);
        toSort.sort(function (a, b) {
            var aord = '';
            var aEl = a.children[columnIndex];
            if (aEl != null && aEl.firstChild != null)
                aord = aEl.firstChild.nodeValue.toLowerCase();

            var bord = '';
            var bEl = b.children[columnIndex];
            if (bEl != null && bEl.firstChild != null)
                bord = bEl.firstChild.nodeValue.toLowerCase();

            return sortByOrder(aord, bord, sortAsc);
        });
        customOptionsDiv.innerHTML = '';
        //header
        customOptionsDiv.appendChild(options[0]);
        for (var i = 0, l = toSort.length; i < l; i++) {
            customOptionsDiv.appendChild(toSort[i]);
        }
        if (headerEl != null) {
            for (var i = 0; i < headerEl.children.length; i++) {
                if (i == columnIndex) {
                    headerEl.children[i].children[1].children[0].className = sortAsc ? "fa fa-long-arrow-up" : "fa fa-long-arrow-down";
                } else {
                    headerEl.children[i].children[1].children[0].className = "fa fa-sort";
                }
            }
        }
        dropdown.click();
    }
}

function sortByOrder(a, b, asc) {
    if ((isNumeric(a) && isNumeric(b)) || (isNumeric(a) && !b) || (isNumeric(b) && !a)) {
        var a1 = isNumeric(a) ? parseInt(a) : 0;
        var b1 = isNumeric(b) ? parseInt(b) : 0;
        if (a1 < b1)
            return asc ? -1 : 1;
        if (a1 > b1)
            return asc ? 1 : -1;
        return 0;
    } else {
        if (a < b)
            return asc ? -1 : 1;
        if (a > b)
            return asc ? 1 : -1;
        return 0;
    }
}

function isNumeric(str) {
    if (typeof str != "string") return false;
    return !isNaN(str) && !isNaN(parseFloat(str));
}