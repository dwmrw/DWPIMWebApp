function QueryStringExists() {
    var field = 'layout';
    var url = window.location.href;
    if (url.indexOf('?' + field + '=') != -1)
        return true;
    else if (url.indexOf('&' + field + '=') != -1)
        return true;
    return false
}

function EnsureLayout() {
    if (QueryStringExists() == false) {
        window.location.href = window.location.href + '&layout=BaseLayout';
    }
}
EnsureLayout();