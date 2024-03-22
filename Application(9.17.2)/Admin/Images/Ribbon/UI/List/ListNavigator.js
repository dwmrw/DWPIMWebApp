/// <reference path="/Admin/Resources/js/layout/Actions.js" />

class ListNavigatorDispatcher {
    static getStorage() {
        let wnd = window.parent || window;
        wnd.__listNavigatorsStorage = wnd.__listNavigatorsStorage || {};
        return wnd.__listNavigatorsStorage;
    }

    static getFromStorage(listControlId, listUrl) {
        let storage = ListNavigatorDispatcher.getStorage();
        let key = listControlId + listUrl;
        let listNav = storage[key];
        if (!listNav) {
            listNav = new ListNavigator(listControlId, listUrl);
            storage[key] = listNav;
        }
        return listNav;
    }

    static popFromStorage(listControlId, listUrl) {
        let storage = ListNavigatorDispatcher.getStorage();
        let key = listControlId + listUrl;
        let listNavObj = storage[key];
        if (listNavObj) {
            storage[key] = null;
            delete storage[key];
        }
        return ListNavigatorDispatcher.restoreExecutionContext(listNavObj || new ListNavigator(listControlId, listUrl));
    }
    static restoreExecutionContext(listNavObj) {
        return ListNavigator.copy(listNavObj);
    }

    static persist(listControlId, listUrl, pageNumber, sortColumnIndex, sortDirection) {
        let listNav = ListNavigatorDispatcher.getFromStorage(listControlId, listUrl);
        listNav.pageNumber = pageNumber;
        listNav.sortColumnIndex = sortColumnIndex;
        listNav.sortDirection = sortDirection;
    }

    static navigate(listControlId, listUrl) {
        let listNav = ListNavigatorDispatcher.popFromStorage(listControlId, listUrl);
        listNav.navigateToCurrent();
    }
}

class ListNavigator {
    pageNumber = 0;
    sortColumnIndex = 0;
    sortDirection = 0;

    constructor(listControlId, listUrl) {
        this.listControlId = listControlId;
        this.listUrl = listUrl;
    }

    static navigateTo(listControlId, listUrl, pageNumber, sortColumnIndex, sortDirection) {
        let postData = {
            _EVENTTARGET: listControlId,
            __EVENTARGUMENT: `PageIndexChanged: ${pageNumber}`,
        };
        postData[`${listControlId}:SortColumnIndex`] = sortColumnIndex;
        postData[`${listControlId}:SortDirection`] = sortDirection;
        Action.openWindowWithVerb("POST", listUrl, postData);
    }
    static copy(listNavObj) {
        let listNav = new ListNavigator(listNavObj.listControlId, listNavObj.listUrl);
        listNav.pageNumber = listNavObj.pageNumber;
        listNav.sortColumnIndex = listNavObj.sortColumnIndex;
        listNav.sortDirection = listNavObj.sortDirection;
        return listNav;
    }

    navigateToCurrent() {
        ListNavigator.navigateTo(this.listControlId, this.listUrl, this.pageNumber, this.sortColumnIndex, this.sortDirection);
    }
}

