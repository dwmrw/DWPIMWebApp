<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomSortList.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.SortList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeScriptaculous="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.css" />
            <dw:GenericResource Url="../css/sort.css" />
            <dw:GenericResource Url="../js/dwsort.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Overlay/Overlay.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var sorter;

        Event.observe(window, 'load', function () {
            Position.includeScrollOffsets = true;
            sorter = new DWSortable('items',
                {
                    name: function (s) { return ("" + s.children[1].innerHTML).toLowerCase(); }
                }
            );
        });

        function save() {
            showOverlay("overlay");
            new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/lists/EcomSortList.aspx?DialogMode=<%=DialogMode%>&BackUrl=<%=BackUrl%>&GroupId=<%=Request("GroupId")%>&fieldId=<%=Request("fieldId")%>", {
                method: 'post',
                parameters: {
                    "Items": Sortable.sequence('items').join(','),
                    "Save": "save",
                    "Command": document.getElementById("command").value
                },
                onSuccess: function (data) { window.location.href = data.responseText; },
                onComplete: hideOverlay("overlay")
            });
        }

        function saveVariants() {
            save();
        }

        function moveToTop() {
            moveRow(1);
        }

        function moveToBottom() {
            moveRow(-1);
        }

        function moveRow(direction) {
            var sequence = Sortable.sequence('items');
            var selectedItems = $$('ul li.list-group-item.selected');
            var selectedItemsArray = [];

            for (var i = 0; i < selectedItems.length; i++) {
                var element = selectedItems[i].getAttribute("data-id");
                var index = sequence.indexOf(element);
                sequence.splice(index, 1);
                selectedItemsArray.push(element);
            }

            if (direction < 0) {
                for (var i = 0; i < selectedItemsArray.length; i++) {
                    sequence.push(selectedItemsArray[i]);
                }
                return Sortable.setSequence('items', sequence);
            } else {
                for (var i = 0; i < sequence.length; i++) {
                    selectedItemsArray.push(sequence[i]);
                }
                return Sortable.setSequence('items', selectedItemsArray);
            }
        }

        function findContainingRow(element) {
            var ret = null;

            if (element) {
                element = $(element);

                if (element.descendantOf($("items"))) {
                    while (element) {
                        if ((element.tagName + '').toLowerCase() == 'li') {
                            ret = element;
                            break;
                        } else {
                            if (typeof (element.up) == 'function')
                                element = element.up();
                            else
                                break;
                        }
                    }
                }
            }

            return ret;
        }

        function handleCheckboxes(link) {
            var row = findContainingRow(link);
            row.toggleClassName("selected");
        }

    </script>
</head>
<body class="<%=If(DialogMode, "", "screen-container")%>"">
    <dwc:Card runat="server">
        <dw:Overlay ID="overlay" runat="server" Message="Please wait" ShowWaitAnimation="true"></dw:Overlay>
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>     
        <dwc:CardBody runat="server">
            <form id="Form1" method="post" runat="server">
                <input type="hidden" id="command" name="command" runat="server" />
                <div class="list">
                    <asp:Repeater ID="SortingRepeater" runat="server" EnableViewState="false">
                        <HeaderTemplate>
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <span class="sort-col w100">
                                        <a href="#" onclick="sorter.sortBy('name'); return false;"><%=Translate.Translate("Name")%></a>
                                        <i id="name_up" style="display: none" class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp)%>"></i>
                                        <i id="name_down" style="display: none" class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown)%>"></i>
                                    </span>
                                </li>
                            </ul>
                            <ul id="items">
                        </HeaderTemplate>

                        <ItemTemplate></ItemTemplate>
                    
                        <FooterTemplate>
                            </ul>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>