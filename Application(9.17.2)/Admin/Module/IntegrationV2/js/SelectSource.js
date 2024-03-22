/* File Created: januar 2, 2012 */

function submit() {
    $("form1").submit();
}
function deactivateButtons() {
    if (document.getElementById("forwardButton"))
        document.getElementById("forwardButton").disabled = "disabled";
}
function activateButtons() {
    document.getElementById("forwardButton").disabled = "";
}

function openSourceFile() {
    const list = document.getElementById("FM_Source_file");
    if (list != null) {
        const optionEl = list.options[list.selectedIndex];
        if (optionEl != null) {
            var fullPath = optionEl.getAttribute("fullpath");
            if (fullPath != null) {
                var file = fullPath.substring(fullPath.lastIndexOf('/') + 1);
                var folder = fullPath.substring(0, fullPath.lastIndexOf('/'));
                if (folder[0] == '/') {
                    folder = folder.substring(1);
                }
                if (folder.toLowerCase().indexOf('files/files' == 0)) {
                    folder = folder.substring('files/'.length);
                }
                url = "/Admin/FileManager/FileEditor/FileManager_FileEditorV2.aspx?File=" + file + "&Folder=" + folder + "&CallerOriginalID=Source_file";
                var wnd = window.open(url, '', 'scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes');
                wnd.focus();
            }
        }
    }
}

function drawEditSourceFileIcon() {
    var elements = document.getElementsByClassName("input-group-addon");
    for (var i = 0; i < elements.length; i++) {
        var onClickText = elements[i].getAttribute('onclick');
        if (onClickText != null && onClickText.indexOf('FM_Source_file') > 0) {
            var el = elements[i].parentElement;
            if (el != null) {
                var newElement = document.createElement("span");
                newElement.setAttribute('class', 'input-group-addon');
                newElement.setAttribute('title', 'Edit');
                newElement.setAttribute('data-role', 'filemanager-button-edit');
                newElement.setAttribute('onclick', 'openSourceFile();');
                newElement.innerHTML = '<i id="editImage_Source_file" class="fa fa-pencil"></i>';
                el.appendChild(newElement);
            }
            break;
        }
    }
}