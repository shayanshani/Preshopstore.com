<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="StoreConfiguration.aspx.cs" Inherits="PreShop.AdminPortal.StoreConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        $(document).ready(function () {
            jQuery.fn.ToggleSection = function () {
                return this.css('visibility', function (i, visibility) {
                    return (visibility == 'visible') ? 'hidden' : 'visible';
                });
            };

            jQuery.fn.ToggleSectionDisplay = function () {
                return this.css('display', function (i, visibility) {
                    return (visibility == 'none') ? 'block' : 'none';
                });
            };
            $("#<%= chkColor.ClientID%>").click(function () {
                $("#<%= chkFlavor.ClientID%>").prop('checked', false);
                $("#<%= chkColorFlavor.ClientID%>").prop('checked', false);
            });

            $("#<%= chkFlavor.ClientID%>").click(function () {
                $("#<%= chkColor.ClientID%>").prop('checked', false);
                $("#<%= chkColorFlavor.ClientID%>").prop('checked', false);
            });

            $("#<%= chkColorFlavor.ClientID%>").click(function () {
                $("#<%= chkColor.ClientID%>").prop('checked', false);
                $("#<%= chkFlavor.ClientID%>").prop('checked', false);
            });

            $("#<%= chkSeparateDomain.ClientID%>").click(function () {
                $("#<%= divDomainUrl.ClientID%>").ToggleSectionDisplay();
            });

            $("#<%= chkSingleCategory.ClientID%>").click(function () {
                $("#<%= chkStandAlonePortal.ClientID%>").prop('checked', false);
                $("#<%= DivCategorySetup.ClientID%>").ToggleSectionDisplay();
            });

            $("#<%= chkStandAlonePortal.ClientID%>").click(function () {
                $("#<%= chkSingleCategory.ClientID%>").prop('checked', false);
                $("#<%= DivCategorySetup.ClientID%>").css('display', 'none');
            });
            $("#<%= chkResendEmail.ClientID%>").click(function () {
                $("#<%= divEmailId.ClientID%>").ToggleSectionDisplay();
             });
        });
    </script>
    <style>
        .switchery {
            width: 40px !important;
            margin-bottom: 10px !important;
        }
    </style>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Update Configuration</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="form-horizontal">
                                <div class="row">
                                    <h5>Store Setting
                                    </h5>
                                    <hr />
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label" style="display: none">Multiple Branches:</label>
                                        <div class="col-sm-1" style="display: none">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkMutlipleBranches">
                                            </label>
                                        </div>
                                        <label class="col-sm-2 control-label">BarCode reader:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkBarcode">
                                            </label>
                                        </div>
                                        <label class="col-sm-2 control-label">Reciept Print:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkPrinter">
                                            </label>
                                        </div>

                                        <label class="col-sm-2 control-label">Booking:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkBooking">
                                            </label>
                                        </div>

                                        <label class="col-sm-2 control-label">Live Client:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkClient">
                                            </label>
                                        </div>

                                        <label class="col-sm-2 control-label">Show Products on Site:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkLiveStore">
                                            </label>
                                        </div>
                                        <label class="col-sm-2 control-label">Stand Alone Portal:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkStandAlonePortal">
                                            </label>
                                        </div>

                                        <label class="col-sm-2 control-label">Have Customers:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkCustomers">
                                            </label>
                                        </div>
                                        <label class="col-sm-2 control-label">Have Suppliers:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkSuppliers">
                                            </label>
                                        </div>
                                        <div id="DivDomainSetup" runat="server" style="display: none">
                                            <label class="col-sm-2 control-label">Separate Domain:</label>
                                            <div class="col-sm-1">
                                                <label>
                                                    <input type="checkbox" class="js-switch" runat="server" id="chkSeparateDomain">
                                                </label>
                                            </div>
                                        </div>
                                        <label class="col-sm-2 control-label">Single Category:</label>
                                        <div class="col-sm-1">
                                            <label>
                                                <input type="checkbox" class="js-switch" runat="server" id="chkSingleCategory">
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div id="DivCategorySetup" runat="server" style="display: none">
                                    <hr />
                                    <div class="row">
                                        <h5>Category Setup
                                        </h5>
                                        <hr />
                                        <label class="col-sm-2 control-label">Category:</label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlCategory" CssClass="form-control Searchable" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div id="divDomainUrl" runat="server" style="display: none">
                                    <hr />
                                    <div class="row">
                                        <h5>Domain Setup
                                        </h5>
                                        <hr />
                                        <label class="col-sm-2 control-label">Domain URL:</label>
                                        <div class="col-sm-3">
                                            <div class="input-group m-b">
                                                <span class="input-group-addon">www.</span>
                                                <asp:TextBox ID="txtDomainUrl" runat="server" class="form-control" placeholder="www.Examplestore.com"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <label class="col-sm-4 control-label">Quantity Unit:(<small>Put comma(,) for multiple units or Leave unit textbox empty if this store is not using any unit</small>)</label>
                                    <div class="col-sm-3">
                                        <asp:TextBox ID="txtUnit" runat="server" class="form-control" placeholder="meter,kilogram etc"></asp:TextBox>
                                    </div>
                                </div>
                                <hr />
                            </div>
                            <div class="row" id="divCategories" runat="server">
                                <h5>Assign Categories
                                </h5>
                                <hr />
                                <div id="CheckboxesRepeaterCat">
                                    <asp:Repeater ID="rptCategories" runat="server" OnItemDataBound="rptCategories_ItemDataBound">
                                        <ItemTemplate>
                                            <label class="col-sm-2 control-label"><%# Eval("Category") %></label>
                                            <div class="col-sm-1">
                                                <label class="switch switch-info m-b">
                                                    <input type="checkbox" class="js-switch" runat="server" id="chkCategory" value='<%# Eval("HeadingId") %>'>
                                                    <span>
                                                        <i class="handle"></i>
                                                    </span>
                                                </label>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            <div class="row">
                                <h5>Store Types
                                </h5>
                                <hr />
                                <div id="CheckboxesRepeater">
                                    <asp:Repeater ID="rptStoreTypes" runat="server" OnItemDataBound="rptStoreTypes_ItemDataBound">
                                        <ItemTemplate>
                                            <label class="col-sm-2 control-label"><%# Eval("StoreType") %></label>
                                            <div class="col-sm-1">
                                                <label class="switch switch-info m-b">
                                                    <input type="checkbox" class="js-switch" runat="server" id="chkStoreType" value='<%# Eval("StoreTypeId") %>'>
                                                    <span>
                                                        <i class="handle"></i>
                                                    </span>
                                                </label>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>

                            </div>
                            <hr />
                            <div class="row" id="divStockSetting" runat="server" visible="false">
                                <h5>Stock/Sales Setting
                                </h5>
                                <hr />
                                <label class="col-sm-2 control-label">Auto Generate order #:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkOrderNo">
                                    </label>
                                </div>

                                <label class="col-sm-2 control-label">Size:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkSizes">
                                    </label>
                                </div>

                                <label class="col-sm-2 control-label">Color only:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkColor">
                                    </label>
                                </div>

                                <label class="col-sm-2 control-label">Flavour only:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkFlavor">
                                    </label>
                                </div>

                                <label class="col-sm-2 control-label">Flavour/Color:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkColorFlavor">
                                    </label>
                                </div>

                            </div>
                            <hr />
                            <div class="row">
                                <h5>Week Start Setting
                                </h5>
                                <hr />
                                <label class="col-sm-2 control-label">Week Start:</label>
                                <div class="col-sm-2">
                                    <asp:DropDownList ID="ddlWeekStart" CssClass="form-control" runat="server">
                                        <asp:ListItem Value="0">Sun</asp:ListItem>
                                        <asp:ListItem Value="1" Selected="True">Mon</asp:ListItem>
                                        <asp:ListItem Value="2">Tue</asp:ListItem>
                                        <asp:ListItem Value="3">Wed</asp:ListItem>
                                        <asp:ListItem Value="4">Thu</asp:ListItem>
                                        <asp:ListItem Value="5">Fri</asp:ListItem>
                                        <asp:ListItem Value="6">Sat</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <label class="col-sm-2 control-label">Full Day Name:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkDayName">
                                    </label>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <h5>Other Setting
                                </h5>
                                <hr />
                                <label class="col-sm-2 control-label">Send Message after order:</label>
                                <div class="col-sm-1">
                                    <label>
                                        <input type="checkbox" class="js-switch" runat="server" id="chkorderMessage">
                                    </label>
                                </div>
                                <div id="divResendEmail" runat="server" visible="false">
                                    <label class="col-sm-2 control-label">Re-send Email:</label>
                                    <div class="col-sm-1">
                                        <label class="switch switch-dark m-b">
                                            <input type="checkbox" class="js-switch" runat="server" id="chkResendEmail">
                                            <span>
                                                <i class="handle"></i>
                                            </span>
                                        </label>
                                    </div>

                                    <div id="divEmailId" runat="server" style="display: none">
                                        <label class="col-sm-2 control-label">Enter Correct Email:</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="txtEmail" runat="server" class="form-control" placeholder="Email Address"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:HiddenField ID="hfConfigID" runat="server" />
                    <div class="row">
                        <div class="col-sm-12">
                            <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Submit Configuration" OnClientClick="return validateCheckBoxes();" ValidationGroup="validation" Style="float: right!important" class="btn btn-success" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function validateCheckBoxes() {
            var isValid = false;
            $('#CheckboxesRepeater input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    isValid = true;
                }
            });
            if (isValid == false) {
                alert("Please select at least one Store type");
                return false;
            }
            else {
                $('#CheckboxesRepeaterCat input[type="checkbox"]').each(function () {
                    if ($(this).prop('checked') == true) {
                        isValid = true;
                    }
                });
                if (isValid == false) {
                    alert("Please select at least one Category");
                    return false;
                }
                else {
                    return true;
                }
            }
        }

    </script>
</asp:Content>
