(function (tinymce) {
    const setup = function (editor, url) {
        editor.ui.registry.addButton("linktopage", {
            tooltip: "Link to page",
            icon: "document-properties",
            onAction: () => {
                const callback = function (options, model) {
                    const href = "/Default.aspx?Id=" + model.Selected;
                    const selectedText = editor.selection.getContent({ 'format': 'html' });
                    if (selectedText && selectedText != '') {
                        editor.execCommand('mceReplaceContent', false, '<a href="' + href + '">' + selectedText + '</a>');
                    } else {
                        editor.insertContent('<a href="' + href + '">' + model.SelectedPageName + '</a>');
                    }
                }

                const dlgAction = createLinkDialog(LinkDialogTypes.Page, [], callback);
                Action.Execute(dlgAction);
            },
        });

        editor.ui.registry.addButton("linktofile", {
            tooltip: "Link to file",
            icon: "gallery",
            onAction: () => {
                const callback = function (options, model) {
                    const href = "/Files" + model.Selected;
                    const selectedText = editor.selection.getContent({ 'format': 'html' });
                    if (selectedText && selectedText != '') {
                        editor.execCommand('mceReplaceContent', false, '<a href="' + href + '">' + selectedText + '</a>');
                    } else {
                        editor.insertContent('<a href="' + href + '">' + model.Selected + '</a>');
                    }
                }

                const dlgAction = createLinkDialog(LinkDialogTypes.File, [], callback);
                Action.Execute(dlgAction);
            },
        });
    };

    tinymce.PluginManager.add('dwlink', setup);
})(tinymce);