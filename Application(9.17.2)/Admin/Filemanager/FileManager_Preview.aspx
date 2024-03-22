<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FileManager_Preview.aspx.vb" Inherits="Dynamicweb.Admin.FileManager_Preview" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<%if BlnFileNotFound Then%>
<SCRIPT language='JavaScript'>
	alert('<%=Translate.JsTranslate("Filen er ikke fundet")%>');
	window.close();
</SCRIPT>
<%End If%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="FileManager_Preview.css" rel="stylesheet" type="text/css" />
<dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
<title><%=Translate.JsTranslate("FileManager")%></title>
<script type="text/javascript">
var winOpener = opener;
var picWidth = <%=Width%>;
var picHeight = <%=Height%>;

function ResizeWin() {
	var resWidth = 700;
	var resHeight = 700;
    
	try {
		if (picWidth > resWidth) {
			resWidth = picWidth + 32;
		}
		if (picHeight > resHeight) {
			//resHeight = picHeight;
			resHeight = picHeight + 100;
		}	
	} catch(e) {
		//Nothing
	}	
	
	window.resizeTo(resWidth,resHeight)
}
window.onload= ResizeWin
</script>
</head>
<body style="margin:0px;">
        <%If Ext = ".gif" Or Ext = ".jpg" Or Ext = ".png" Or Ext = ".bmp" Or Ext = ".pdf" Or Ext = ".swf" Or Ext = ".webp" Then%>
            <div id="wrapperImage">
		            <div id="imagearea">
			            <%=TmpHTML%>
		            </div>
            </div>
       <%Else %>
            <div id="wrapperFile">
		        <div id="filearea">
			        <%=TmpHTML%>
		        </div>
            </div>
	        <div id="statusBar">
		        <span class="statusBarItem"><span><%= FilePath%></span></span>		
	        </div>
      <%End If%>
</body>
</html>
<%
    Translate.GetEditOnlineScript()
%>