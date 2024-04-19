class Capture {
    sharedNotificationId = 'dwthumbnails';
    refreshWhenDone = false;
    refreshDocument = null;
    cancel = false;
    translations = {};
    processing = 0;
    processingTargets = [];
    constructor(translations) {
        this.translations = translations;
    }
    showMessage(msg, id, timeout, cancelCallback) {
        if (!notifire || !id) {
            return;
        }
        if (!timeout) {
            timeout = timeout || 30000;
        }
        notifire({ msg: msg, id: id, timeout: timeout, callback: cancelCallback || null });
    }
    showStatus(index, total) {
        let text = this.translations['Generating thumbnail(s)'];
        const generateMultiple = index > 0 && total > 1;
        if (generateMultiple) {
            text = this.translations['Processing ({0} of {1})'].replace('{0}', index).replace('{1}', total);
        }
        this.showMessage(text, this.sharedNotificationId);
    }
    showError(targetInfo, msg) {
        if (!targetInfo) {
            return;
        }
        let info = '<div>' + targetInfo.DisplayName + '</div><div style="font-weight:bold;">' + msg + '</div>';
        this.showMessage(info, "dwthumbnails" + targetInfo.PageId, 600000);
    }
    completeStatus() {
        const message = this.translations['Thumbnail(s) done'];
        this.showMessage(message, this.sharedNotificationId);
        const self = this;

        this.processing -= 1;
        if (this.processing <= 0) {
            setTimeout(function () {
                if (self.refreshWhenDone === true && self.refreshDocument && self.refreshDocument.location) {
                    self.refreshDocument.location.reload();
                }

                const notificationPopup = document.getElementById(self.sharedNotificationId);
                if (notificationPopup)
                    notificationPopup.click();

            }, 1000);
        }
    }
    removeIFrame(targetInfo) {
        const iframeId = 'FrontendRender' + targetInfo.PageId;
        const iframe = document.getElementById(iframeId);
        if (iframe) {
            iframe.remove();
        }
    }
    generateMultiple(targetInfos, onComplete) {
        if (!targetInfos) return;
        let total = targetInfos.length;
        if (total === 0) {
            return;
        }
        this.processing += 1;
        let index = 0;
        const self = this;
        self.cancel = false;

        const text = this.translations['Generating thumbnail(s)'] + '<br />&nbsp;';
        (function showActivityIndicator(spinnerCount) {
            setTimeout(function () {
                let updatedText = text;
                if (spinnerCount < 3) {
                    spinnerCount = spinnerCount + 1;

                    for (let i = 0; i < spinnerCount; i++) {
                        updatedText = updatedText + '.';
                    }
                } else {
                    spinnerCount = 0;
                }

                if (index === 0 && !self.cancel) {
                    self.showMessage(updatedText, self.sharedNotificationId, 0, stopExecution);
                    showActivityIndicator(spinnerCount);
                }
            }, 500);
        })(4);
        targetInfos.forEach(function (targetInfo) {
            self.generate(targetInfo, updateStatus, updateTotal);
            self.processingTargets.push(targetInfo);
        });

        function stopExecution() {
            self.cancel = true;
            self.processingTargets.forEach(function (targetInfo) {
                self.removeIFrame(targetInfo);
            });
        }

        function updateTotal(newCount) {
            total = total + newCount;
        }

        function updateStatus(targetInfo, response) {
            if (self.cancel) {
                return;
            }

            if (response && response.status !== 200) {
                self.showError(targetInfo, response.statusText);
                self.refreshWhenDone = false;
            } else {
                if (onComplete) {
                    onComplete(targetInfo);
                }
            }
            index = index + 1;
            if (index === total) {
                self.completeStatus();
            } else if (document.getElementById(self.sharedNotificationId)) {//only update the text, if the notifire has not been dismissed
                self.showStatus(index, total);
            }
        }
    }
    generate(targetInfo, callback, updateTotal) {
        if (!targetInfo) {
            return;
        }
        const iframeId = 'FrontendRender' + targetInfo.PageId;
        var iframeCheck = document.getElementById(iframeId);
        if (iframeCheck) {
            return;
        }

        const renderer = document.createElement('IFRAME');
        renderer.id = iframeId;
        renderer.style = 'position: absolute; top: -1920px';
        renderer.width = '1920';
        renderer.height = '1280';
        renderer.src = '/Default.aspx?ID=' + targetInfo.PageId + '&visualedit=true';
        renderer.onload = setupIframe;
        document.body.appendChild(renderer);

        function setupIframe() {
            const frontendBody = document.querySelector('#' + iframeId).contentWindow.document.body;
            const canvas2HtmlScriptLink = document.createElement('SCRIPT');
            canvas2HtmlScriptLink.src = '/Admin/Resources/js/html2canvas.min.js';
            frontendBody.appendChild(canvas2HtmlScriptLink);
            const screenCaptursScriptLink = document.createElement('SCRIPT');
            screenCaptursScriptLink.src = '/Admin/Resources/js/FrontendCapture.js';
            frontendBody.appendChild(screenCaptursScriptLink);
            screenCaptursScriptLink.onload = loader;
            canvas2HtmlScriptLink.onload = loader;
            let counter = 0;
            function loader() {
                //ensures that we wait for both javascript resources to finish loading, before we proceed to call the takeScreenShot function
                counter = counter + 1;
                if (counter === 2) {
                    const frontendCapture = document.querySelector('#' + iframeId).contentWindow.capture;
                    const targetElement = document.querySelector('#' + iframeId).contentDocument.body;
                    if (targetInfo.Targets && targetInfo.Targets.length > 0) {
                        updateTotal(targetInfo.Targets.length - 1);
                        targetInfo.Targets.forEach(function (domTargetInfo) {
                            const domTargetElement = targetElement.querySelector(domTargetInfo.QuerySelect);
                            if (domTargetElement) {
                                frontendCapture.generate(targetInfo, domTargetInfo.ID, domTargetInfo.Token, domTargetElement, callback);
                            }
                        });
                    }
                    if (targetInfo.Token) {
                        frontendCapture.generate(targetInfo, targetInfo.PageId, targetInfo.Token, targetElement, callback);
                    }
                }
            }
        }
    }
}

function CreateCapture(translations) {
    return new Capture(translations);
}