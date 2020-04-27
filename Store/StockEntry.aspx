<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="StockEntry.aspx.cs" Inherits="PreShop.StockManagement.Store.StockEntry" %>

<%@ Register Assembly="SpartansControls" Namespace="SpartansControls" TagPrefix="sp" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #tblStockItems td {
            vertical-align: middle !important;
        }

        .subtotalInput {
            border: 0px;
            background: transparent;
            text-align: center;
            cursor: default;
        }

        .subtotalInputBarCode {
            text-align: center;
            cursor: default;
        }

        .error {
            border-color: #F00;
        }
    </style>
    <script type="text/javascript">
        function loadBarCode() {
            $(document).scannerDetection({
                timeBeforeScanTest: 200, // wait for the next character for upto 200ms
                startChar: [120], // Prefix character for the cabled scanner (OPL6845R)
                endChar: [13], // be sure the scan is complete if key 13 (enter) is detected
                avgTimeByChar: 40, // it's not a barcode if a character takes longer than 40ms
                onComplete: function (barcode, qty) {
                    AddNewRow();
                }, // main callback function	
                //onError: function (string) { alert('Error ' + string); }
            });
        }
    </script>

    <%--StockIn With Ajax--%>
    <script type="text/javascript">
        var Brands = [], Products = [], Color = [], Sizes = [];
        $(document).ready(function () {
            GetBrands();
            GetProducts();
            GetColors();
            GetSizes();
            $("#btnAddNewRow").removeAttr("disabled");
            $("#btnSubmit").on('click', function () {
                if (isValid()) {
                    SaveStock();
                }
            });
            $('#<%= ddlSupplier.ClientID%>').on('change', function () {
                var SupplierId = $(this).val();
                if (SupplierId != -2)
                    $('#<%= hfSupplierId.ClientID%>').val(SupplierId);
                else if (SupplierId == -2) {
                    openModal("#AddSupplier");
                }
            });
            var BillNo = $("#<%= HfBillNo.ClientID%>").val();
            if (BillNo != null & BillNo != '' & BillNo != 'undefined') {
                bindStockItems(BillNo)
            }
            $('#<%= txtBillNo.ClientID%>').on('change', function () {
                bindStockItems($(this).val())
            });
        });

        function isValid() {
            var SupplierId = $('#<%= ddlSupplier.ClientID %>').val();
            var BillNo = $('#<%= txtBillNo.ClientID%>').val();
            var Date = $('#<%= txtPurchaseDate.ClientID %>').val();
            var txtPaidAmount = $('#<%= txtPaidAmount.ClientID%>').val();
            var txtTotalBill = $('#<%= txtTotalBill.ClientID%>').val();
            var txtRemainingAmount = $('#<%= txtRemainingAmount.ClientID%>').val();
            if (BillNo == "") {
                alert("Please enter Invoice no");
                return false;
            }
            else if (Date == "") {
                alert("Please select any date");
                return false;
            }
            else if (SupplierId == "-1" && $('#<%= divSuppliers.ClientID %>').is(':visible')) {
                alert("Please select Supplier");
                return false;
            }
            else if (txtTotalBill == "") {
                alert("Total Bill field is empty add some items to fill the Bill Field");
                return false;
            }
            else if (txtPaidAmount == "") {
                alert("Enter Paid Amount");
                return false;
            }
            else if (txtRemainingAmount == "") {
                alert("Remaining amount field is empty enter paid amount to fill remaining amount");
                return false;
            }
            else {
                return true;
            }
        }

        function openModal(id) {
            $(id).modal('show');
        }

        function bindStockItems(BillNo) {
            AjaxCall("StockEntry.aspx/LoadStockItems", '{Billno: ' + BillNo + '}', BindItems, Loader);
        }

        function BindItems(data) {
            var tblStockItems = $("#tblStockItems > tbody");
            tblStockItems.empty();
            if (data.d != "") {
                $('#btnSubmit').attr('disabled', false);
                var StockCount = data.d[0].StockCount;
                $("#<%=txtTotalBill.ClientID%>").val(data.d[0].TotalBill);
                $("#<%=txtRemainingAmount.ClientID%>").val(data.d[0].RemainingAmount);
                $("#<%=txtPaidAmount.ClientID%>").val(data.d[0].PaidAmount);
                if (data.d[0].ddlSupplier != null)
                    $("#<%= ddlSupplier.ClientID%>").val(data.d[0].ddlSupplier).trigger('change');
                else
                    $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
                $("#<%= HfBillNo.ClientID%>").val(data.d[0].BillNo);
                var BarCode = '';
                var barcode ="<%= Convert.ToBoolean(config.IsBarCode) %>";
                for (var i = 0; i < StockCount; i++) {
                    if (barcode == "True")
                        BarCode = "<td align='center'><input type='text' disabled='disabled' value='" + data.d[i].BarCode + "' class='form-control subtotalInputBarCode' id='txtBarCode" + i + "'  /></td>";
                    tblStockItems.append("<tr id='tr" + i + "'>" + BarCode +
                        "<td align='center'><input type='hidden' value='" + data.d[i].StockId + "' id='hfStockId" + i + "' /><select class='form-control Searchable' id='ddlCompany" + i + "' onchange='FillProducts(this.value," + i + ",-1)'></select></td>" +
                        "<td align='center'><select class='form-control Searchable' id='ddlProducts" + i + "' onchange='RemoveError(" + i + ");'></select></td>" +
                        "<td align='center'><input class='form-control' type='text' value='" + data.d[i].Quantity + "' id='txtQty" + i + "' autocomplete='off' style='width:50px' onkeydown='CalculateItemTotal(" + i + ");' onkeyup='CalculateItemTotal(" + i + ");' /></td>" +
                        "<td align='center'><input class='form-control' type='text' value='" + data.d[i].Price + "' id='txtPrice" + i + "' autocomplete='off' style='width:100px' onkeydown='CalculateItemTotal(" + i + ");' onkeyup='CalculateItemTotal(" + i + ");' /></td>" +
                        "<td align='center'><input class='form-control' type='text' value='" + data.d[i].SalePrice + "' id='txtSalePrice" + i + "' style='width:100px' autocomplete='off' /></td>" +
                        "<td align='center'><input type='text' value='" + data.d[i].Amount + "' disabled='disabled' class='subtotalInput' id='txtAmount" + i + "' style='width:110px' /></td>" +
                        "<td align='center'><a href='javascript:;' onclick='DeleteItem(" + data.d[i].StockId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td></tr>");
                    FillBrands(i, data.d[i].CompanyId);
                    FillProducts(data.d[i].CompanyId, i, data.d[i].ProductID);
                }

                //$("<%= txtPurchaseDate.ClientID %>").datepicker("setDate", new Date(data.d[0].PurchaseDate));
            }
            else {
                $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
                $("#<%=txtTotalBill.ClientID%>").val(null);
                $("#<%=txtPaidAmount.ClientID%>").val(null);
                $("#<%=txtRemainingAmount.ClientID%>").val(null);
                $('#btnSubmit').attr('disabled', true);
            }
        }

        function ValidateRow(Index) {
            var barcode = "<%= Convert.ToBoolean(config.IsBarCode) %>";
            var ddlCompany = $("#ddlCompany" + Index);
            var ddlProducts = $("#ddlProducts" + Index);
            var txtQty = $("#txtQty" + Index);
            var txtPrice = $("#txtPrice" + Index);
            var txtSalePrice = $("#txtSalePrice" + Index);

            if (barcode == "True") {
                var Barcode = $("#txtBarCode" + Index);
                if (Barcode.length > 0) {
                    if (Barcode.val() == "") {
                        Barcode.addClass("error");
                        return false;
                    }
                    else
                        Barcode.removeClass("error");
                }
            }

            if (ddlCompany.val() == "-1") {
                ddlCompany.addClass("error");
                return false;
            }
            else
                ddlCompany.removeClass("error");
            if (ddlProducts.val() == "-1") {
                ddlProducts.addClass("error");
                return false;
            }
            else
                ddlProducts.removeClass("error");

            if (txtQty.val() == "") {
                txtQty.addClass("error");
                return false;
            }
            else
                txtQty.removeClass("error");

            if (txtPrice.val() == "") {
                txtPrice.addClass("error");
                return false;
            }
            else
                txtPrice.removeClass("error");

            if (txtSalePrice.val() == "") {
                txtSalePrice.addClass("error");
                return false;
            }
            else
                txtSalePrice.removeClass("error");
            return true;
        }

        function AddNewRow() {
            var tblStockItems = $("#tblStockItems > tbody");
            if (ValidateRow($("#tblStockItems > tbody >tr:last").index())) {
                var RowId = $("#tblStockItems > tbody >tr:last").index() + 1;
                var saleDataHtml = '';
                saleDataHtml += "<tr id='tr" + RowId + "'>";
                var barcode ="<%= Convert.ToBoolean(config.IsBarCode) %>";
                var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
                var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
                if (barcode == "True")
                    saleDataHtml += "<td align='center'><input type='text' disabled='disabled' class='form-control subtotalInputBarCode' id='txtBarCode" + RowId + "'  /></td>";
                saleDataHtml += "<td align='center'><select id='ddlCompany" + RowId + "' class='form-control Searchable' onchange='FillProducts(this.value," + RowId + ",-1)'></select></td>";
                saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='GetProductSizes(this.value," + RowId + ",-1);'></select></td>";
                if (HaveSizes == "True")
                    saleDataHtml += "<td align='center'><select id='ddlSizes" + RowId + "' class='form-control Searchable' onchange='RemoveError(" + RowId + ");'></select></td>";
                if (IsColor == "2")
                    saleDataHtml += "<td align='center'><select id='ddlColors" + RowId + "' class='form-control Searchable' onchange='RemoveError(" + RowId + ");'></select></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtQty" + RowId + "' autocomplete='off' class='form-control' style='width:50px' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtPrice" + RowId + "' autocomplete='off' class='form-control' style='width:100px' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtSalePrice" + RowId + "' autocomplete='off' class='form-control' style='width:100px' /></td>";
                saleDataHtml += "<td align='center'><input type='text' disabled='disabled' class='subtotalInput' id='txtAmount" + RowId + "' style='width:110px' /></td>";
                saleDataHtml += "<td align='center'><a href='javascript:;' onclick='Remove(" + RowId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td></tr>";
                tblStockItems.append(saleDataHtml);
                FillBrands(RowId, -1);
                if (IsColor == "2")
                    FillColors(RowId, -1);
                $("#btnSubmit").attr('disabled', false);
                CalculateBill();
                CalBill();
                $("html, body").animate({ scrollTop: $(document).height() }, 2000);
            }
        }

        function SaveStock() {
            $tableStock = $('#tblStockItems > tbody  > tr');
            var Stock = [];
            var TotalStock = $tableStock.length;
            var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
            var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
            for (var i = 0; i < TotalStock; i++) {
                Stock.push({
                    StockId: $("#hfStockId" + i).length > 0 ? $("#hfStockId" + i).val() : null,
                    SizeId: (HaveSizes == "True") ? $("#ddlSizes" + i).val() : "0",
                    ColorId: (IsColor == "2") ? $("#ddlColors" + i).val() : "0",
                    StockColorOrFlavorId: "0",
                    CompanyId: $("#ddlCompany" + i).val(),
                    ProductID: $("#ddlProducts" + i).val(),
                    Price: $("#txtPrice" + i).val(),
                    SalePrice: $("#txtSalePrice" + i).val(),
                    Quantity: $("#txtQty" + i).val(),
                    Expense: "0",
                    PurchaseDate: $("#<%= txtPurchaseDate.ClientID%>").val(),
                    Billno: $("#<%= txtBillNo.ClientID%>").val(),
                    BarCode: $("#txtBarCode" + i).length > 0 ? $("#txtBarCode" + i).val() : null,
                    SerialNo: '',
                    hdnQuantity: "0"
                });
            }
            var request = {
                BillNo: $("#<%= txtBillNo.ClientID%>").val(),
                Date: $("#<%= txtPurchaseDate.ClientID%>").val(),
                SupplierId: $("#<%=ddlSupplier.ClientID %>").val(),
                items: Stock,
                TotalBill: 0,
                Paid: $("#<%=txtPaidAmount.ClientID %>").val(),
                Remaining: $("#<%=txtRemainingAmount.ClientID %>").val()
            };
            request = JSON.stringify({ 'request': request });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/SaveStock",
                data: request,
                dataType: "json",
                beforeSend: function () {
                    $("#btnSubmit").attr('disabled', true);
                },
                success: function (data) {
                    if (data.d == true) {
                        Clear();
                        $.notify({ title: 'Stock Status: ', message: 'Stock has been saved', icon: 'fa fa-check' }, { type: 'success' });
                    }
                    else {
                        window.location.href = "<%= PreShop.Common.StoreBackToLoginUrl %>";
                    }
                }
            });
        }

        function Clear() {
            $("#tblStockItems > tbody").empty();
            $("#<%= txtBillNo.ClientID%>").val(null);
            $("#<%= txtTotalBill.ClientID%>").val(null);
            $("#<%= txtPaidAmount.ClientID%>").val(null);
            $("#<%= txtRemainingAmount.ClientID%>").val(null);
            $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
            $("#<%= txtPurchaseDate.ClientID%>").val(null);
        }

        function Remove(RowId) {
            $('#tblStockItems tr[id=tr' + RowId + ']').remove();
            CalculateBill();
            CalBill();
        }

        function RemoveError(Index) {
            $("#ddlProducts" + Index).removeClass("error");
        }

        function GetBrands() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/FillBrands",
                dataType: "json",
                success: function (res) {
                    Brands = res.d;
                }
            });
        }
        function GetProducts() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/GetProduct",
                dataType: "json",
                success: function (res) {
                    Products = res.d;
                }
            });
        }

        function GetColors() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/GetColors",
                dataType: "json",
                success: function (res) {
                    console.log(res.d);
                    Color = res.d;
                }
            });
        }

        function GetSizes() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/GetSizes",
                dataType: "json",
                success: function (res) {
                    Sizes = res.d;
                }
            });
        }


        function FillBrands(Index, SelectedValue) {
            if (Brands.length == 0)
                GetBrands();
            var BrandDropdownId = "#ddlCompany" + Index;
            $(BrandDropdownId).empty();
            $(BrandDropdownId).append($("<option></option>").val("-1").html("Select Brand"));
            $.each(Brands, function (data, value) {
                $(BrandDropdownId).append($("<option></option>").val(value.CompanyID).html(value.Company));
            })
            $(BrandDropdownId).val(SelectedValue);
            $("#ddlProducts" + Index).append($("<option></option>").val("-1").html("Select Product"));
            $("#ddlColors" + Index).append($("<option></option>").val("-1").html("Select Color"));
        }

        function FillProducts(CompanyId, Index, SelectedValue) {
            $("#ddlCompany" + Index).removeClass("error");
            var ProductsDropDown = "#ddlProducts" + Index;
            $(ProductsDropDown).empty();
            $(ProductsDropDown).append($("<option></option>").val("-1").html("Select Product"));
            var FilteredProducts = Products.filter(function (e) {
                return e.CompanyID == CompanyId;
            });
            $.each(FilteredProducts, function (data, value) {
                $(ProductsDropDown).append($("<option></option>").val(value.ProductID).html(value.Product));
            })
            $(ProductsDropDown).val(SelectedValue);
        }

        function FillColors(Index, SelectedValue) {
            if (Color.length == 0)
                GetColors();
            var ColorDropdownId = "#ddlColors" + Index;
            $(ColorDropdownId).empty();
            $(ColorDropdownId).append($("<option></option>").val("-1").html("Select Color"));
            $.each(Color, function (data, value) {
                $(ColorDropdownId).append($("<option style='background-color:" + value.ColorCode + "'></option>").val(value.ColorID).html(value.ColorName));
            })
            $(ColorDropdownId).val(SelectedValue);
        }

        function GetProductSizes(ProductId, Index, SelectedValue) {
            var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
            if (HaveSizes == "True") {
                $("#ddlProducts" + Index).removeClass("error");
                var SizesDropDown = "#ddlSizes" + Index;
                $(SizesDropDown).empty();
                $(SizesDropDown).append($("<option></option>").val("-1").html("Select Size"));
                var FilteredSizes = Sizes.filter(function (e) {
                    return e.ProductID == ProductId;
                });
                $.each(FilteredSizes, function (data, value) {
                    $(SizesDropDown).append($("<option></option>").val(value.SizeID).html(value.Size));
                })
                $(SizesDropDown).val(SelectedValue);
            }
        }

        function DeleteItem(StockID) {
            if (confirm("Are you sure you want to delete this item?")) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "StockEntry.aspx/DeleteItem",
                    data: "{'StockID':'" + StockID + "'}",
                    dataType: "json",
                    success: function (data) {
                        bindStockItems($("#<%= txtBillNo.ClientID%>").val());
                        $.notify({ title: 'Delete Status: ', message: 'Item has been deleted!', icon: 'fa fa-check' }, { type: 'success' });
                    },
                });
            }
        }
        function Loader() {
            $("#tblStockItems > tbody").empty();
            $("#tblStockItems > tbody").append("<tr><td colspan='9'><i class='fa fa-2x fa-spin fa-spinner'></i></td></tr>");
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
                    <div class="row" id="DivPrevioudBillNo" runat="server">
                        <div class="col-sm-12">
                            <div class="form-group">
                                <label>
                                    Previous Invoice no: <span class="text-danger">
                                        <asp:Label ID="lblPreviousInvoiceNo" runat="server"></asp:Label></span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label>
                                    Invoice No: <span class="required has-error">*</span>
                                </label>
                                <asp:TextBox ID="txtBillNo" runat="server" CssClass="form-control" TabIndex="2" autocomplete="off"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label>
                                    Purchase Date:<span class="required has-error">*</span>
                                </label>
                                <sp:DatePicker ID="txtPurchaseDate" ClientIDMode="Static" Width="100%" autocomplete="off" runat="server" IconClass="fa fa-calendar"></sp:DatePicker>
                            </div>
                        </div>
                        <div class="col-sm-4" id="divSuppliers" runat="server">
                            <div class="form-group">
                                <label>
                                    Supplier: <span class="required has-error">*</span>
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
                    <div class="clearfix"></div>
                    <div class="row">
                        <div class="col-sm-12">
                            <table id="tblStockItems" class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th runat="server" id="thBarCode"><i class="fa fa-barcode"></i>BarCode</th>
                                        <th>Brand</th>
                                        <th>Product</th>
                                        <th runat="server" id="thColor" visible="false">Color</th>
                                        <th runat="server" id="thSzes" visible="false">Size</th>
                                        <th>Qty</th>
                                        <th>Price(Per Item)</th>
                                        <th>Sale Price(Per Item)</th>
                                        <th>Amount</th>
                                        <th>Action(s)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot id="ManualEntryButton" runat="server">
                                    <tr id="trFooter">
                                        <td colspan="9">
                                            <button id="btnAddNewRow" disabled="disabled" type="button" onclick="AddNewRow();" class="btn btn-success" style="margin-bottom: 10px">Add new stock</button>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
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
                            <button id="btnSubmit" class="btn btn-primary" type="button" disabled="disabled">Submit</button>
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

        function CalculateBill() {
            var TotalBill = 0;
            for (var i = 0; i < $("#tblStockItems > tbody >tr").length; i++) {
                TotalBill += parseFloat($("#txtAmount" + i).val() != '' ? $("#txtAmount" + i).val() : 0);
            }
            $("#<%=txtTotalBill.ClientID%>").val(TotalBill);
        }

        function CalculateItemTotal(Index) {
            if ($("#txtPrice" + Index).val() != '')
                $("#txtPrice" + Index).removeClass("error");
            if ($("#txtQty" + Index).val() != '')
                $("#txtQty" + Index).removeClass("error");
            if ($("#txtSalePrice" + Index).val() != '')
                $("#txtSalePrice" + Index).removeClass("error");
            var ItemPrice = document.getElementById("txtPrice" + Index).value;
            //var Expense = parseFloat(document.getElementById("#").value);
            var Quantity = document.getElementById("txtQty" + Index).value;
            var result = (parseFloat(ItemPrice != '' ? ItemPrice : 0) * parseFloat(Quantity != '' ? Quantity : 0));// + Expense
            document.getElementById("txtAmount" + Index).value = result;
            CalculateBill();
        }
        function CalBill() {
            var TotalBill = document.getElementById("<%= txtTotalBill.ClientID%>").value;
            var Paid = document.getElementById("<%= txtPaidAmount.ClientID%>").value;
            var result = parseFloat(TotalBill != '' ? TotalBill : 0) - parseFloat(Paid != '' ? Paid : 0);
            document.getElementById("<%=txtRemainingAmount.ClientID%>").value = result;
        }
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>


