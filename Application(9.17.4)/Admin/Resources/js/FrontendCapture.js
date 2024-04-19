class FrontendCapture {
    width = 1920;//first get the page in a size that matches a typical view
    height = 1920;

    generate(targetInfo, fileName, token, targetElement, callback) {
        if (fileName === '') {
            fileName = targetInfo.PageId;
            if (targetInfo.FileNameAppend) {
                fileName = fileName + '_' + targetInfo.FileNameAppend;
            }
        }
        //Setup of images        
        const imgElements = targetElement.querySelectorAll('img');
        imgElements.forEach(function (item) {
            const dataSrc = item.getAttribute("data-src");
            if (dataSrc) {
                item.src = dataSrc;
            }
        });

        const svgElements = targetElement.querySelectorAll('svg');
        svgElements.forEach(function (item) {
            const boundingClientRect = item.getBoundingClientRect();
            item.setAttribute("width", boundingClientRect.width);
            item.setAttribute("height", boundingClientRect.height);
            item.style.width = null;
            item.style.height = null;
        });
        //end of setup
        const boundingRect = targetElement.getBoundingClientRect();
        let drawWidth = this.width;
        if (boundingRect.width < drawWidth) {
            drawWidth = boundingRect.width;
        }
        let drawHeight = this.height;
        if (boundingRect.height < drawHeight) {
            drawHeight = boundingRect.height;
        }
        html2canvas(targetElement, {
            allowTaint: true,
            width: drawWidth,
            height: drawHeight
        }).then(canvas => {
            canvas.toBlob(function (blob) {
                const formData = new FormData();
                formData.append('file', blob, fileName);
                fetch('/Admin/Api/Screenshot/' + token, {
                    method: 'POST',
                    body: formData
                })
                    .then(response => callback(targetInfo, response))
                    .catch(error => callback(targetInfo, error));
            }, 'image/png');
        })
        .catch(error => callback(targetInfo, error));
    };
};
var capture = new FrontendCapture();