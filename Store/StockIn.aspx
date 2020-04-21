<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="StockIn.aspx.cs" Inherits="PreShop.StockManagement.Store.StockIn" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function CalculateItemTotal() {
            var ItemPrice = parseFloat(document.getElementById("<%=txtPrice.ClientID%>").value);
            var Expense = parseFloat(document.getElementById("<%=txtExpense.ClientID%>").value);
            var Quantity = parseFloat(document.getElementById("<%=txtQuanity.ClientID%>").value);
            var result = (ItemPrice * Quantity);// + Expense
            document.getElementById("<%=txtTotalAmount.ClientID%>").value = result;
            document.getElementById("<%=hfTotal.ClientID%>").value = result;
        }
        function CalBill() {
            var TotalBill = parseFloat(document.getElementById("<%=txtTotalBill.ClientID%>").value);
            var Paid = parseFloat(document.getElementById("<%=txtPaidAmount.ClientID%>").value);
            var result = TotalBill - Paid;
            document.getElementById("<%=txtRemainingAmount.ClientID%>").value = result;
        }
        function checkUncheck(checked, divID, oldDiv) {
            if (checked == true) {
                $(oldDiv).hide();
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }

        function displayHide(checked, divID) {
            if (checked == true) {
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }

        function displayHideCode(divID) {
            $(divID).show();
        }

        function showSaleDiv() {
            $('#divSale').show();
            $('#liSale').show();
        }

        function loadBarCode() {
            $(document).scannerDetection({
                timeBeforeScanTest: 200, // wait for the next character for upto 200ms
                startChar: [120], // Prefix character for the cabled scanner (OPL6845R)
                endChar: [13], // be sure the scan is complete if key 13 (enter) is detected
                avgTimeByChar: 40, // it's not a barcode if a character takes longer than 40ms
                onComplete: function (barcode, qty) {
                    $('#<%= txtSerialOrBarcode.ClientID %>').val(barcode);
                    $('#<%= hfBarcode.ClientID %>').val(barcode);
                    $('#spanBarCode').show();
                }, // main callback function	
                //onError: function (string) { alert('Error ' + string); }
            });
        }
    </script>

    <%--StockIn With Ajax--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#btnSaveItem').on('click', function () {
                SaveItem();
            });

            $('#<%= ddlProduct.ClientID%>').on('change', function () {
                BindProductAttributes($(this).val());
            });
            $('#<%= ddlSupplier.ClientID%>').on('change', function () {
                var SupplierId = $(this).val();
                if (SupplierId != -2)
                    $('#<%= hfSupplierId.ClientID%>').val(SupplierId);
                else if (SupplierId == -2) {
                    openModal("#AddSupplier");
                }
            });

            $('#<%= ddlCompany.ClientID%>').on('change', function () {
                AjaxCall("StockIn.aspx/GetProducts", '{CompanyID: ' + $(this).val() + '}', GetProducts, LoadingSpinnerDropDown);
            });

            function LoadingSpinnerDropDown() {
                $("#<%= ddlProduct.ClientID %>").empty();
                $("#<%= ddlProduct.ClientID %>").prepend($('<option></option>').html('Loading products...'));
            }

            function GetProducts(data) {
                if (data.d != null) {
                    var ProductIdP, ProductP;
                    $("#<%= ddlProduct.ClientID %>").empty();
                    if (data.d[0].ProductIdP != null) {
                        ProductIdP = data.d[0].ProductIdP.split(',');
                        ProductP = data.d[0].ProductP.split(',');
                        $("#<%= ddlProduct.ClientID %>").append($("<option selected='selected'></option>").val("-1").html("Select Product"));
                        for (var i = 0; i < ProductIdP.length; i++) {
                            $("#<%= ddlProduct.ClientID %>").append($("<option></option>").val(ProductIdP[i]).html(ProductP[i]));
                        }
                        $("#<%= ddlProduct.ClientID%>").val(EditProductID).trigger('change');
                    }
                }
            }

            var BillNo = $("#<%= HfBillNo.ClientID%>").val();
            if (BillNo != null & BillNo != '' & BillNo != 'undefined') {
                bindStockItems(BillNo)
            }
            <%--$('#<%= txtBillNo.ClientID%>').keyup(function () {
                bindStockItems($(this).val())
            });
            $('#<%= txtBillNo.ClientID%>').keydown(function () {
                bindStockItems($(this).val())
            });--%>

            $('#<%= txtBillNo.ClientID%>').on('change', function () {
                bindStockItems($(this).val())
            });
        });

        function BindProductAttributes(ProductId) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockIn.aspx/BindProductAttributes",
                data: '{ProductID: ' + ProductId + '}',
                dataType: "json",
                success: function (data) {
                    if (data.d != null) {
                        var SizeID, SizeName;
                        if (data.d[0].SizeID != null) {
                            SizeID = data.d[0].SizeID.split(',');
                            SizeName = data.d[0].Size.split(',');

                            $("#<%= ddlsizes.ClientID %>").empty();
                            $("#<%= ddlsizes.ClientID %>").append($("<option></option>").val("-1").html("Select Size"));
                            for (var i = 0; i < SizeID.length; i++) {
                                $("#<%= ddlsizes.ClientID %>").append($("<option></option>").val(SizeID[i]).html(SizeName[i]));
                            }
                            $("#<%= ddlsizes.ClientID %>").val(SizeSelectedValue).trigger('change');
                        }

                        var ColorOrFlavorID, ColorOrFlavour;
                        if (data.d[0].IsProductColor == 1)
                            $("#lblFlvaourOrColor").html("Colors ");
                        else
                            $("#lblFlvaourOrColor").html("Flavours ");

                        if (data.d[0].ColorOrFlavorID != null) {
                            ColorOrFlavorID = data.d[0].ColorOrFlavorID.split(',');
                            ColorOrFlavour = data.d[0].ColorOrFlavour.split(',');
                            $("#<%= ddlColors.ClientID %>").empty();
                            $("#<%= ddlColors.ClientID %>").append($("<option></option>").val("-1").html("Select"));
                            for (var i = 0; i < ColorOrFlavorID.length; i++) {
                                $("#<%= ddlColors.ClientID %>").append($("<option></option>").val(ColorOrFlavorID[i]).html(ColorOrFlavour[i]));
                            }
                            $("#<%= ddlColors.ClientID %>").val(ColorSelectedValue).trigger('change');
                        }
                    }
                },
            });
        }

        function openModal(id) {
            $(id).modal('show');
        }

        function bindStockItems(BillNo) {
            AjaxCall("StockIn.aspx/LoadStockItems", '{Billno: ' + BillNo + '}', BindItems, Loader);
        }

        function BindItems(data) {
            if (data.d != "") {
                var tblStockItems = $("#tblStockItems > tbody");
                tblStockItems.empty();
                $('#<%= btnSubmit.ClientID%>').attr('disabled', false);
                var StockCount = data.d[0].StockCount;
                $("#<%=txtTotalBill.ClientID%>").val(data.d[0].TotalBill);
                $("#<%=txtRemainingAmount.ClientID%>").val(data.d[0].RemainingAmount);
                debugger;
                $("#<%=txtPaidAmount.ClientID%>").val(data.d[0].PaidAmount);
                if (data.d[0].ddlSupplier != null)
                    $("#<%= ddlSupplier.ClientID%>").val(data.d[0].ddlSupplier).trigger('change');
                else
                    $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
                $("#<%= HfBillNo.ClientID%>").val(data.d[0].BillNo);
                var saleDataHtml = '';
                for (var i = 0; i < StockCount; i++) {
                    saleDataHtml += "<tr>";
                    saleDataHtml += "<td>" + data.d[i].PurchaseDate + "</td>";
                    saleDataHtml += "<td>" + data.d[i].Product + "</td>";
                    saleDataHtml += "<td>" + data.d[i].Company + "</td>";
                    saleDataHtml += "<td>" + data.d[i].Quantity + "</td>";
                    saleDataHtml += "<td>" + data.d[i].Price + "</td>";
                    saleDataHtml += "<td>" + data.d[i].SalePrice + "</td>";
                    saleDataHtml += "<td>" + data.d[i].Amount + "</td>";
                    saleDataHtml += "<td><a href='javascript:;' onclick='EditItem(" + data.d[i].StockId + ");' style='color:red'><i class='fa fa-edit' Style='font-size: 15px!important'></i></a>&nbsp<a href='javascript:;' onclick='DeleteItem(" + data.d[i].StockId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td>";
                }
                tblStockItems.append(saleDataHtml);
                $find("<%= txtPurchaseDate.ClientID %>").set_selectedDate(new Date(data.d[0].PurchaseDate));
            }
            else {
                $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
                $("#<%=txtTotalAmount.ClientID%>").val(null);
                $("#<%=txtPaidAmount.ClientID%>").val(null);
                $("#<%=txtRemainingAmount.ClientID%>").val(null);
                $('#<%= btnSubmit.ClientID%>').attr('disabled', true);
            }
        }

        function Clear() {
            $("#<%= ddlsizes.ClientID%>").val("-1").trigger('change');
            $("#<%= ddlColors.ClientID%>").val("-1").trigger('change');
            $("#<%=txtSerialOrBarcode.ClientID%>").val(null);
            $("#<%=txtQuanity.ClientID%>").val(null);
            $("#<%=hdnQuantity.ClientID%>").val(null);
            $("#<%=txtPrice.ClientID%>").val(null);
            $("#<%=txtSalePrice.ClientID%>").val(null);
            $("#<%=txtExpense.ClientID%>").val(null);
            $("#<%=txtTotalAmount.ClientID%>").val(null);
            $("#<%=hfColorOrId.ClientID%>").val(null);
            $("#<%=hfStockID.ClientID%>").val(null);
        }

        function DeleteItem(StockID) {
            if (confirm("Are you sure you want to delete this item?")) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "StockIn.aspx/DeleteItem",
                    data: "{'StockID':'" + StockID + "'}",
                    dataType: "json",
                    success: function (data) {
                        bindStockItems($("#<%= txtBillNo.ClientID%>").val());
                        $.notify({ title: 'Delete Status: ', message: 'Item has been deleted!', icon: 'fa fa-check' }, { type: 'success' });
                    },
                });
            }
        }

        function SaveItem() {
            if (isValid()) {
                var date = $find("<%= txtPurchaseDate.ClientID %>").get_selectedDate().toDateString();
                    var SizeId = $('#<%= ddlsizes.ClientID %>').val(), ColorOrFlavorId = $('#<%= ddlColors.ClientID %>').val();
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "StockIn.aspx/SaveItem",
                        data: "{'StockID':'" + $('#<%= hfStockID.ClientID%>').val() + "','SizeId':'" + SizeId + "','ColorId':'" + ColorOrFlavorId + "','StockColorOrFlavorId':'" + $('#<%= hfColorOrId.ClientID%>').val() + "','CompanyId':'" + $('#<%= ddlCompany.ClientID %>').val() + "', 'ProductID':'" + $('#<%= ddlProduct.ClientID %>').val() + "', 'ItemPP':'" + $('#<%= txtPrice.ClientID %>').val() + "','ItemSP':'" + $('#<%= txtSalePrice.ClientID %>').val() + "', 'Quantity':'" + $('#<%= txtQuanity.ClientID %>').val() + "', 'Expense':'" + $('#<%= txtExpense.ClientID %>').val() + "', 'PurchaseDate':'" + date + "', 'Billno':'" + $('#<%= txtBillNo.ClientID %>').val() + "', 'BarCode':'" + $('#<%= txtSerialOrBarcode.ClientID %>').val() + "', 'SerialNo':'" + $('#<%= txtSerialOrBarcode.ClientID %>').val() + "', 'hdnQuantity':'" + $('#<%= hdnQuantity.ClientID %>').val() + "'}",
                        dataType: "json",
                        beforeSend: function () {
                            $("#btnSaveItem").attr('disabled', true);
                        },
                        success: function (data) {
                            if (data.d == true) {
                                bindStockItems($("#<%= txtBillNo.ClientID%>").val());
                                $("#<%= HfBillNo.ClientID%>").val($("#<%= txtBillNo.ClientID%>").val());
                                Clear();
                                $.notify({ title: 'Item Status: ', message: 'Item has been saved', icon: 'fa fa-check' }, { type: 'success' });
                            }
                            else {
                                window.location.href = "<%= PreShop.Common.StoreBackToLoginUrl %>";
                        }
                    },
                    complete: function () {
                        $("#btnSaveItem").attr('disabled', false);
                    }
                });
            }
        }
        var EditProductID = -1, ColorSelectedValue = -1, SizeSelectedValue = -1;
        function EditItem(StockID) {
            $('#<%= hfStockID.ClientID%>').val(StockID);
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "StockIn.aspx/GetItemById",
                    data: "{'StockID':'" + StockID + "'}",
                    dataType: "json",
                    success: function (data) {
                        $("#<%= txtBillNo%>").val(data.d.BillNo);
                        $("#<%= ddlCompany.ClientID%>").val(data.d.CompanyId).trigger('change');
                        EditProductID = data.d.ProductID;
                        ColorSelectedValue = data.d.ColorId;
                        SizeSelectedValue = data.d.SizeId;
                        $("#<%= ddlSupplier.ClientID%>").val(data.d.SupplierId).trigger('change');
                        $("#<%= hfColorOrId.ClientID%>").val(data.d.StockColorOrFlavorId);
                        $find("<%= txtPurchaseDate.ClientID %>").set_selectedDate(new Date(data.d.PurchaseDate));
                        $("#<%=txtSerialOrBarcode.ClientID%>").val(data.d.BarCodeOrSerailNo);
                        $("#<%=txtQuanity.ClientID%>").val(data.d.Quantity);
                        $("#<%=hdnQuantity.ClientID%>").val(data.d.Quantity);
                        $("#<%=txtPrice.ClientID%>").val(data.d.Price);
                        $("#<%=txtSalePrice.ClientID%>").val(data.d.SalePrice);
                        $("#<%=txtExpense.ClientID%>").val(data.d.Expense);
                        $("#<%=txtTotalAmount.ClientID%>").val(data.d.Amount);
                },
            });
        }

        function Loader() {
            $("#tblStockItems > tbody").empty();
            $("#tblStockItems > tbody").append("<tr><td colspan='9'><i class='fa fa-2x fa-spin fa-spinner'></i></td></tr>");
        }

        function isValid() {
            var RetailerId = $('#<%= ddlSupplier.ClientID %>').val();
                var BillNo = $('#<%= txtBillNo.ClientID%>').val();
                var CompanyId = $('#<%= ddlCompany.ClientID %>').val();
                var ProductId = $('#<%= ddlProduct.ClientID %>').val();
                var txtPurchaseDate = $('#<%= txtPurchaseDate.ClientID %>').val();
                var SizeId = $('#<%= ddlsizes.ClientID %>').val();
                var ColorId = $('#<%= ddlColors.ClientID %>').val();
                var SerialNoOrBarcode = $('#<%= txtSerialOrBarcode.ClientID %>').val();

                if (BillNo == "") {
                    alert("Please enter Bill no");
                    return false;
                }
                else if (CompanyId == "-1") {
                    alert("Please select any brand");
                    return false;
                }
                else if (ProductId == "-1") {
                    alert("Please select any product");
                    return false;
                }
                else if (txtPurchaseDate == "") {
                    alert("Please select date of purchasing");
                    return false;
                }
                else if (RetailerId == "-1" && $('#<%= divSuppliers.ClientID %>').is(':visible')) {
                    alert("Please select any supplier");
                    return false;
                }
                else if (SizeId == "-1" && $('#<%= ddlsizes.ClientID %>').is(':visible')) {
                    alert("Please select any size");
                    return false;
                }
                else if (ColorId == "-1" && $('#<%= ddlColors.ClientID %>').is(':visible')) {
                    alert("Please select any color for this product");
                    return false;
                }
                else if (SerialNoOrBarcode == "" && $('#<%= divBarCode.ClientID %>').is(':visible')) {
                    alert("Please scan your product barcode");
                    return false;
                }
                else if ($('#<%= txtQuanity.ClientID %>').val() == "") {
                    alert("Enter Quanitity");
                    return false;
                }
                else if ($('#<%= txtPrice.ClientID %>').val() == "") {
                    alert("Enter Purchase price");
                    return false;
                }
                else if ($('#<%= txtSalePrice.ClientID %>').val() == "") {
                alert("Enter Sale price");
                return false;
            }
            else {
                return true;
            }
        }
    </script>
    <link href="Select2/CustomCss.css" rel="stylesheet" />
    <style>
        .select2 {
            width: 100% !important;
        }
    </style>
    <asp:HiddenField ID="hfStockID" runat="server" />
    <asp:HiddenField ID="hdnQuantity" runat="server" />
    <asp:HiddenField ID="hfTotal" runat="server" />
    <asp:HiddenField ID="HfBillNo" runat="server" />
    <asp:HiddenField ID="hfSupplierId" runat="server" />
    <asp:HiddenField ID="hdnPic" runat="server" />
    <asp:HiddenField ID="hfBarcode" runat="server" />
    <asp:HiddenField ID="hfColorOrId" runat="server" />
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Add/Edit Stock <i class="fa fa-arrow-down"></i>
                    </h2>
                    <center style="font-size: 15px; color: red" id="BarCodeHeading" runat="server" visible="false">
                        Scan Product Barcode with your Barcode reader
                    </center>
                    <div class="clearfix"></div>
                </div>
                <span class="has-error">* Required fields</span>
                <asp:HiddenField ID="hfSerialNo" runat="server" />
                <div class="x_content">
                     <div class="row">
                        <div class="col-sm-12">
                             <div class="form-group">
                                <label>
                                   Previous Invoice no: <span class="text-danger"><asp:Label ID="lblPreviousInvoiceNo" runat="server"></asp:Label></span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Invoice No: <span class="required has-error">*</span>
                                </label>
                                <asp:TextBox ID="txtBillNo" runat="server" CssClass="form-control" TabIndex="2" autocomplete="off"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Brand: <span class="required has-error">*</span>
                                </label>
                                <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control Searchable" TabIndex="3">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Product: <span class="required has-error">*</span>
                                </label>
                                <asp:DropDownList ID="ddlProduct" runat="server" class="form-control Searchable" TabIndex="4">
                                </asp:DropDownList>

                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Purchase Date:<span class="required has-error">*</span>
                                </label>
                                <telerik:RadDatePicker RenderMode="Lightweight" ID="txtPurchaseDate" ClientIDMode="Static" Width="100%" autocomplete="off" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                </telerik:RadDatePicker>
                                <br />
                                <asp:CompareValidator ID="cmpDate" runat="server" ControlToValidate="txtPurchaseDate" Operator="LessThanEqual" EnableClientScript="true" Type="Date" Display="Dynamic" ValidationGroup="Validation" SetFocusOnError="true" CssClass="has-error" ErrorMessage="Date must be less then or equal to todays date!"></asp:CompareValidator>
                            </div>
                        </div>
                        <div class="col-sm-2" id="divSuppliers" runat="server">
                            <div class="form-group">
                                <label>
                                    Supplier: <span class="required has-error">*
                                                  <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlSupplier" InitialValue="-1" ValidationGroup="Validation1" ErrorMessage="Required" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                    </span>
                                </label>
                                <asp:DropDownList ID="ddlSupplier" runat="server" class="form-control Searchable" TabIndex="6">
                                </asp:DropDownList>
                                <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="AddSupplier">
                                    <div class="modal-dialog modal-sm">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <button type="button" class="close" id="cls" data-dismiss="modal">
                                                    <span aria-hidden="true">×</span>
                                                </button>
                                                <h4 class="modal-title" id="myModalLabel">
                                                    <asp:Label ID="lblPopUpHeading" runat="server">Add Supplier</asp:Label></h4>
                                            </div>
                                            <div class="modal-body">
                                                <!-- Content  -->
                                                <div class="x_content" style="float: none!important">

                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label>
                                                                    Supplier Name :&nbsp;
                                                <asp:RequiredFieldValidator ID="req" runat="server" ValidationGroup="ValidationRetailer" ControlToValidate="txtRetailerName" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                </label>
                                                                <asp:TextBox ID="txtRetailerName" runat="server" CssClass="form-control"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ID="reg" runat="server" ControlToValidate="txtRetailerName" Display="Dynamic" ErrorMessage="Invaid Input." CssClass="has-error" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label>
                                                                    Contact # :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="ValidationRetailer" ControlToValidate="txtContact" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                </label>
                                                                <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" data-inputmask="'mask': '9999-9999999'"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label>
                                                                    Address :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="ValidationRetailer" ControlToValidate="txtAddress" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                </label>
                                                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" Rows="6" TextMode="MultiLine" Style="resize: none!important"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="clearfix"></div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                                <asp:Button ID="btnSaveRetailer" runat="server" Text="Save" OnClientClick="if (!Page_ClientValidate('Validation')){ return false; } this.disabled = true; this.value = 'Saving...';" UseSubmitBehavior="false" OnClick="btnSaveRetailer_Click" CssClass="btn btn-primary" ValidationGroup="ValidationRetailer" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ln_solid"></div>
                    <div class="row">
                        <div class="col-sm-2" id="divSize" runat="server">
                            <div class="form-group">
                                <label>
                                    Size: <span class="required has-error">*</span>
                                </label>
                                <asp:DropDownList ID="ddlsizes" runat="server" class="form-control Searchable" TabIndex="7"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-sm-2" id="DivColor" runat="server">
                            <div class="form-group">
                                <label>
                                    <span id="lblFlvaourOrColor">Color</span>:<span class="required has-error">*</span>
                                </label>
                                <asp:DropDownList ID="ddlColors" runat="server" class="form-control Searchable" TabIndex="8">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="col-sm-2" id="divBarCode" runat="server">
                            <div class="form-group">
                                <label>
                                    <asp:Label ID="lblSerialOrBarcode" runat="server"></asp:Label>:<span class="required has-error" id="spanBarCode" style="display: none"><i class="fa fa-check" style="color: #26B99A"></i></span>
                                </label>
                                <asp:TextBox ID="txtSerialOrBarcode" runat="server" autocomplete="off" CssClass="form-control" TabIndex="9"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-1">
                            <div class="form-group">
                                <label>
                                    Qty: <span class="required has-error">*</span>
                                </label>

                                <asp:TextBox ID="txtQuanity" runat="server" CssClass="form-control" autocomplete="off" TabIndex="10" onkeypress="return isNumber(event)" onkeydown="CalculateItemTotal();" onkeyup="CalculateItemTotal();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Item P.P: <span class="required has-error">*</span>
                                </label>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" autocomplete="off" TabIndex="11" onkeydown="CalculateItemTotal();" onkeyup="CalculateItemTotal();"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Item S.P: <span class="required has-error">*</span>
                                </label>
                                <asp:TextBox ID="txtSalePrice" runat="server" CssClass="form-control" autocomplete="off" TabIndex="12"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-2 hidden">
                            <div class="form-group">
                                <label>
                                    Expense: <span class="required has-error">*</span>
                                </label>
                                <asp:TextBox ID="txtExpense" runat="server" CssClass="form-control hidden" autocomplete="off" TabIndex="13" onkeydown="CalculateItemTotal();" onkeyup="CalculateItemTotal();"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label>
                                    Amount: 
                                </label>
                                <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div class="row">
                        <div class="col-sm-1">
                            <div class="form-group">
                                <label>
                                    &nbsp
                                </label>
                                <button id="btnSaveItem" type="button" class="btn btn-primary submit">Save Item</button>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div style="height: 200px!important; overflow-y: scroll!important">
                        <table id="tblStockItems" class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th>Purchase Date</th>
                                    <th>Product</th>
                                    <th>Company</th>
                                    <th>Qty</th>
                                    <th>Price(Per Item)</th>
                                    <th>Sale Price(Per Item)</th>
                                    <th>Amount</th>
                                    <th>Action(s)</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                    <div class="row">
                        <div id="divTotals" runat="server">
                            <div class="col-sm-2">
                                <label>
                                    Total Bill:
                                
                                </label>
                                <asp:TextBox ID="txtTotalBill" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                            </div>
                            <div class="col-sm-2">
                                <label>
                                    Paid:<span class="required">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ValidationGroup="Validation1" ControlToValidate="txtPaidAmount" Display="Dynamic" ErrorMessage="Enter Paid Amount" CssClass="has-error"></asp:RequiredFieldValidator></span></label>
                                <asp:TextBox ID="txtPaidAmount" runat="server" autocomplete="off" CssClass="form-control" onkeyup="CalBill();" onkeydown="CalBill();"></asp:TextBox>
                            </div>
                            <div class="col-sm-2">
                                <label>Remaining:</label>
                                <asp:TextBox ID="txtRemainingAmount" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-1">
                            <label>&nbsp</label>
                            <asp:Button ID="btnSubmit" runat="server" Text="Save Stock with supplier details" CssClass="btn btn-primary" disabled="disabled" OnClick="btnSubmit_Click" ValidationGroup="Validation1" OnClientClick="if (!Page_ClientValidate('Validation1')){ return false; } this.disabled = true; this.value = 'Saving...';"
                                UseSubmitBehavior="false" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#datatable-responsive').dataTable({
                "bSort": false
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>

