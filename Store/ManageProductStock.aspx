<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ManageProductStock.aspx.cs" Inherits="PreShop.StockManagement.Store.ManageProductStock" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
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
        var Brands = [], Products = [], ProductsConfig = [], Color = [], Sizes = [];
        $(window).load(function () {
            $("#btnAddNewRow").removeAttr("disabled");
        });
        $(document).ready(function () {
            $("#<%= ddlCateogory.ClientID %>").select2({
            });
            EmbedSelect2DropDown();
            ClearProductItems();
            $('#AddEditProduct').on('hide.bs.modal', function (e) {
                ClearProductItems();
            });
            $('#AddEditBrand').on('hide.bs.modal', function (e) {
                ClearBrandItems();
            });
            $('#AddEditSize').on('hide.bs.modal', function (e) {
                ClearSizeItems();
            });
            GetColors();
            GetBrands(-1);
            GetProducts(-1);
            GetProductsConfig(-1);
            GetSizes(-1);
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
            AjaxCall("ManageProductStock.aspx/LoadStockItems", '{Billno: ' + BillNo + '}', BindItems, Loader);
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
            var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
            var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
            var ddlCompany = $("#ddlCompany" + Index);
            var ddlProducts = $("#ddlProducts" + Index);
            var ddlColors = $("#ddlColors" + Index);
            var ddlSizes = $("#ddlSizes" + Index);
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

            //if (IsColor == "2") {
            //    if (ddlColors.val() == "-1") {
            //        ddlColors.addClass("error");
            //        return false;
            //    }
            //    else
            //        ddlColors.removeClass("error");
            //}

            if (HaveSizes == "True") {
                if (ddlSizes.val() == "-1") {
                    ddlSizes.addClass("error");
                    return false;
                }
            }
            else
                ddlSizes.removeClass("error");


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
                $("#<%= hfCurrentIndex.ClientID%>").val(RowId);
                var saleDataHtml = '';
                saleDataHtml += "<tr id='tr" + RowId + "'>";
                var barcode ="<%= Convert.ToBoolean(config.IsBarCode) %>";
                var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
                var HaveSizes = "<%= Convert.ToBoolean(config.HaveSizes) %>";
                if (barcode == "True")
                    saleDataHtml += "<td align='center'><input type='text' disabled='disabled' class='form-control subtotalInputBarCode' id='txtBarCode" + RowId + "'  /></td>";
                saleDataHtml += "<td align='center'><select id='ddlCompany" + RowId + "' class='form-control Searchable' onchange='FillProducts(this.value," + RowId + ",-1)'></select></td>";
                saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='AssignValue(this.value," + RowId + ");GetProductSizes(this.value," + RowId + ",-1);'></select></td>";
                if (HaveSizes == "True")
                    saleDataHtml += "<td align='center'><select id='ddlSizes" + RowId + "' class='form-control Searchable' onchange='CheckNewEntry(" + RowId + ");'></select></td>";
                if (IsColor == "2")
                    saleDataHtml += "<td align='center' style='display:none' id='tdColor" + RowId + "'><div class='newcolorpicker' id='picker" + RowId + "'></div><select id='ddlColors" + RowId + "' class='form-control hidden' onchange='RemoveError(" + RowId + ");'></select></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtQty" + RowId + "' autocomplete='off' class='form-control' style='width:50px' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtPrice" + RowId + "' autocomplete='off' class='form-control' style='width:100px' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtSalePrice" + RowId + "' autocomplete='off' class='form-control' style='width:100px' /></td>";
                saleDataHtml += "<td align='center'><input type='text' disabled='disabled' class='subtotalInput' id='txtAmount" + RowId + "' style='width:110px' /></td>";
                saleDataHtml += "<td align='center'><a href='javascript:;' onclick='Remove(" + RowId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td></tr>";
                tblStockItems.append(saleDataHtml);
                FillBrands(RowId, -1);
                //EmbedSelect2DropDown();
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
                url: "ManageProductStock.aspx/SaveStock",
                data: request,
                dataType: "json",
                beforeSend: function () {
                    $("#btnSubmit").attr('disabled', true);
                },
                success: function (data) {
                    if (data.d == true) {
                        Clear();
                        $("#btnSubmit").attr('disabled', false);
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
            $("#<%= txtTotalBill.ClientID%>").val(null);
            $("#<%= txtPaidAmount.ClientID%>").val(null);
            $("#<%= txtRemainingAmount.ClientID%>").val(null);
            $("#<%= ddlSupplier.ClientID%>").val("-1").trigger('change');
            var txtBillNo = $("#<%= txtBillNo.ClientID%>");
            $("#<%= lblPreviousInvoiceNo.ClientID%>").html(txtBillNo.val());
            txtBillNo.val(parseInt(txtBillNo.val()) + 1);
           // $("#<%= txtPurchaseDate.ClientID%>").val(null);
        }

        function Remove(RowId) {
            $('#tblStockItems tr[id=tr' + RowId + ']').remove();
            CalculateBill();
            CalBill();
        }

        function RemoveError(Index) {
            $("#ddlProducts" + Index).removeClass("error");
        }

        function CheckNewEntry(Index) {
            var ddlSizes = $("#ddlSizes" + Index);
            if (ddlSizes.val() == -2) {
                openModal('#AddEditSize');
            } else {
                RemoveError(Index);
            }
        }

        function GetBrands(SelectedValue) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/FillBrands",
                dataType: "json",
                success: function (res) {
                    Brands = res.d;
                    var Index = $('#<%= hfCurrentIndex.ClientID%>').val();
                    FillBrands(Index, SelectedValue);
                }
            });
        }
        function GetProducts(SelectedValue) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/GetProduct",
                dataType: "json",
                success: function (res) {
                    Products = res.d;
                    var Index = $('#<%= hfCurrentIndex.ClientID%>').val();
                    var CompanyId = $('#<%= hfCompanyID.ClientID%>').val();
                    var ProductId = $('#<%= hfProductID.ClientID%>').val();
                    console.log("ProductId from Getproducts function=" + ProductId);
                    GetProductsConfig(ProductId);
                    FillProducts(CompanyId, Index, SelectedValue);
                    GetProductSizes(ProductId, Index, -1);
                }
            });
        }

        function GetProductsConfig(SelectedValue) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/GetProductConfig",
                dataType: "json",
                success: function (res) {
                    ProductsConfig = res.d;
                    var Index = $('#<%= hfCurrentIndex.ClientID%>').val();
                    FillColors(Index, -1);
                    GetProductConfig(SelectedValue, Index);
                }
            });
        }

        function GetColors() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/GetColors",
                dataType: "json",
                success: function (res) {
                    Color = res.d;
                }
            });
        }

        function GetSizes(SelectedValue) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/GetSizes",
                dataType: "json",
                success: function (res) {
                    Sizes = res.d;
                    var Index = $('#<%= hfCurrentIndex.ClientID%>').val();
                    var ProductId = "";
                    var newProduct = $("#<%= hfAddingNewProduct.ClientID%>").val();
                    if (newProduct == 1) {
                        ProductId = $("#<%= hfProductID.ClientID%>").val();
                    }
                    else {
                        ProductId = $("#<%= hfProductIDExisting.ClientID%>").val();
                    }
                    FillColors(Index, -1);
                    GetProductSizes(ProductId, Index, SelectedValue);
                }
            });
        }

        function FillBrands(Index, SelectedValue) {
            var BrandDropdownId = "#ddlCompany" + Index;
            $(BrandDropdownId).empty();
            $(BrandDropdownId).append($("<option></option>").val("-1").html("Select Brand"));
            $(BrandDropdownId).append($("<option></option>").val("-2").html("Add new Brand"));
            $.each(Brands, function (data, value) {
                $(BrandDropdownId).append($("<option></option>").val(value.CompanyID).html(value.Company));
            })
            $(BrandDropdownId).val(SelectedValue);
            FillProducts(SelectedValue, Index, -1);
            $("#ddlColors" + Index).append($("<option></option>").val("-1").html("Select Color"));
        }

        function FillProducts(CompanyId, Index, SelectedValue) {
            var ProductsDropDown = "#ddlProducts" + Index;
            $(ProductsDropDown).empty();
            if (CompanyId == -2) {
                openModal("#AddEditBrand");
            }
            $('#<%= hfCompanyID.ClientID%>').val(CompanyId);
            $("#ddlCompany" + Index).removeClass("error");
            $(ProductsDropDown).append($("<option></option>").val("-1").html("Select Product"));
            if (CompanyId > 0) {
                $(ProductsDropDown).append($("<option></option>").val("-2").html("Add New Product"));
            }
            var FilteredProducts = Products.filter(function (e) {
                return e.CompanyID == CompanyId;
            });
            $.each(FilteredProducts, function (data, value) {
                $(ProductsDropDown).append($("<option></option>").val(value.ProductID).html(value.Product));
            })
            $(ProductsDropDown).val(SelectedValue);
        }

        function FillColors(Index, SelectedValue) {
            var PaletteColors = [];
            if (Color.length == 0)
                GetColors();
            var ColorDropdownId = "#ddlColors" + Index;
            $(ColorDropdownId).empty();
            $(ColorDropdownId).append($("<option></option>").val("-1").html("Select Color"));
            $.each(Color, function (data, value) {
                $(ColorDropdownId).append($("<option style='background-color:" + value.ColorCode + "'></option>").val(value.ColorID).html(value.ColorName));
                PaletteColors.push(value.ColorCode);
            })
            $(ColorDropdownId).val(SelectedValue);
            initColorPicker(Index, PaletteColors);
        }

        function initColorPicker(Index, PaletteColors) {
            var ColorDropdownId = "#ddlColors" + Index;
            $("#picker" + Index).colorPick({
                'initialColor': '#73879C',
                'allowRecent': false,
                'allowCustomColor': false,
                'paletteLabel': 'Choose color',
                'palette': PaletteColors,
                'onColorSelected': function () {
                    this.element.css({ 'backgroundColor': this.color, 'color': this.color });
                    var SelectedValue = -1;
                    for (var i = 0; i < Color.length; i++) {
                        if (Color[i].ColorCode == this.color) {
                            SelectedValue = Color[i].ColorID;
                        }
                    }
                    $(ColorDropdownId).val(SelectedValue);
                }
            });
        }

        function AssignValue(val, Index) {
           <%-- console.log("Assigning value");
            $("#<%= hfProductID.ClientID %>").val(val);
            GetProductConfig($("#<%= hfProductID.ClientID %>").val(), Index);--%>
            FillColors(Index, -1);
        }

        function GetProductSizes(ProductId, Index, SelectedValue) {
            if (ProductId == -2) {
                openModal("#AddEditProduct");
            }
            $("#ddlProducts" + Index).removeClass("error");
            var newProduct = $("#<%= hfAddingNewProduct.ClientID%>").val();
            if (newProduct == 1) {
                ProductId = $("#<%= hfProductID.ClientID %>").val();
                $("#<%= hfAddingNewProduct.ClientID %>").val(0);
                $("#<%= hfProductIDExisting.ClientID %>").val(0);
            }
            else {
                $("#<%= hfProductIDExisting.ClientID %>").val(ProductId);
            }
            console.log(ProductId + " in getproductsizes function");
            var HaveSizes = "<%= Convert.ToBoolean(config.HaveSizes) %>";
            if (HaveSizes == "True") {
                var SizesDropDown = "#ddlSizes" + Index;
                $(SizesDropDown).empty();
                $(SizesDropDown).append($("<option></option>").val("-1").html("Select Size"));
                $(SizesDropDown).append($("<option></option>").val("-2").html("Add New Size"));
                var FilteredSizes = Sizes.filter(function (e) {
                    return e.ProductID == ProductId;
                });
                $.each(FilteredSizes, function (data, value) {
                    $(SizesDropDown).append($("<option></option>").val(value.SizeID).html(value.Size));
                })
                $(SizesDropDown).val(SelectedValue);
            }
            GetProductConfig(ProductId, Index);
        }

        function GetProductConfig(ProductId, Index) {
            console.log("ProductConfig for " + ProductId);
            var IsColor = "<%= Convert.ToInt16(config.IsColor) %>";
            if (IsColor == "2") {
                var Config = ProductsConfig.filter(function (e) {
                    return e.ProductID == ProductId;
                });
                console.log("Color config " + Config);
                if (Config.length > 0) {
                    console.log("Color config " + Config[0].IsColor);
                    if (Config[0].IsColor == 1) {
                        $("#<%= thColor.ClientID%>").show();
                        $("#tdColor" + Index).show();
                    }
                    else {
                        $("#<%= thColor.ClientID%>").hide();
                        $("#tdColor" + Index).hide();
                        //$("#tdColor" + Index).html(null);
                    }
                }
                else {
                    $("#<%= thColor.ClientID%>").hide();
                    $("#tdColor" + Index).hide();
                }
            }
        }

        function DeleteItem(StockID) {
            if (confirm("Are you sure you want to delete this item?")) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ManageProductStock.aspx/DeleteItem",
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
    <script type="text/javascript">


        function EmbedSelect2DropDown() {
            $(".Searchable").select2({
            });
        }

        function SaveBrand() {
            var brandname = $("#<%= txtBrandName.ClientID%>").val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/SaveBrand",
                data: "{'BrandName':'" + brandname + "'}",
                dataType: "json",
                beforeSend: function () {
                    $("#btnSaveBrand").attr('disabled', true);
                    $("#btnSaveBrand").html('Saving...');
                },
                success: function (data) {
                    var r = data.d;
                    $('#<%= hfCompanyID.ClientID%>').val(r);
                    GetBrands(r == -3 ? -1 : r);
                    hideModal('#AddEditBrand');
                    $("#btnSaveBrand").html('Save');
                    $("#btnSaveBrand").attr('disabled', false);
                    if (r == -3) {
                        $.notify({ title: 'Duplication: ', message: brandname + ' already exist!', icon: 'fa fa-check' }, { type: 'danger' });
                    }
                    else {
                        $.notify({ title: 'Success Status: ', message: 'Brand has been added!', icon: 'fa fa-check' }, { type: 'success' });
                    }

                },
            });
        }

        function ClearBrandItems() {
            $('#<%= txtBrandName.ClientID%>').val(null);
            var Index = $("#<%= hfCurrentIndex.ClientID%>").val();
            $("#ddlCompany" + Index).val("-1").trigger('change');
        }

        function SaveProduct() {
            $("#<%= hfAddingNewProduct.ClientID%>").val(0);
            var Category = $('#<%= ddlCateogory.ClientID%>').val();
            var Product = $('#<%= txtProductName.ClientID%>').val();
            var Condition = $('#<%= ddlProductCondition.ClientID%>').val();
            var chkColor = $('#<%= chkColor.ClientID%>').is(":checked") ? "true" : "false";
            var chkFlavour = $('#<%= chkFlavour.ClientID%>').is(":checked") ? "true" : "false";
            var chkFlavourOnly = $('#<%= chkFlavourOnly.ClientID%>').is(":checked") ? "true" : "false";
            var chkColorOnly = $('#<%= chkColorOnly.ClientID%>').is(":checked") ? "true" : "false";
            var Description = $('#<%= txtDescroption.ClientID%>').val();
            var Unit = $('#<%= ddlUnits.ClientID%>').val();

            var Product = {
                HeadingID: Category,
                CompanyID: $("#<%= hfCompanyID.ClientID%>").val(),
                Product: Product,
                Condition: Condition,
                chkColor: chkColor,
                chkFlavour: chkFlavour,
                chkFlavourOnly: chkFlavourOnly,
                chkColorOnly: chkColorOnly,
                Description: Description,
                Unit: Unit
            };

            var ProductDetail = JSON.stringify({ 'ObjProduct': Product });
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/SaveProduct",
                data: ProductDetail,
                dataType: "json",
                beforeSend: function () {
                    $("#btnSaveProduct").attr('disabled', true);
                    $("#btnSaveProduct").html('Saving...');
                },
                success: function (data) {
                    $find("<%= RadAjaxManager1.ClientID %>").ajaxRequest();
                    var r = data.d;
                    $("#<%= hfProductID.ClientID%>").val(r);
                    $("#<%= hfAddingNewProduct.ClientID%>").val(1);
                    console.log("ProductId from save function" + r);
                    GetProducts(r);
                    hideModal('#AddEditProduct');
                    $("#btnSaveProduct").html('Save');
                    $("#btnSaveProduct").attr('disabled', false);
                    if (r == -3) {
                        $.notify({ title: 'Duplication: ', message: Product + ' already exist!', icon: 'fa fa-check' }, { type: 'danger' });
                    }
                    else {
                        $.notify({ title: 'Success Status: ', message: 'Product has been added!', icon: 'fa fa-check' }, { type: 'success' });
                    }
                },
            });
        }

        function ClearProductItems() {
            console.log("ClearProductItems(); call");
            $('#<%= ddlCateogory.ClientID%>').val("-1").trigger('change');
            $('#<%= txtProductName.ClientID%>').val(null);
            $('#<%= chkColor.ClientID%>').prop('checked', false);
            $('#<%= chkColorOnly.ClientID%>').iCheck('uncheck');
            $('#<%= chkFlavour.ClientID%>').prop('checked', false);
            $('#<%= chkFlavourOnly.ClientID%>').prop('checked', false);
            $('#<%= chkFlavourOnly.ClientID%>').prop('checked', false);
            $('#<%= txtDescroption.ClientID%>').val(null);
            $('#<%= hfDescription.ClientID%>').val(null);
            $('#<%= ddlUnits.ClientID%>').val("-1").trigger('change');
            var Index = $("#<%= hfCurrentIndex.ClientID%>").val();
            $("#ddlProducts" + Index).val("-1").trigger('change');
        }
        function SaveSize() {
            var SizeName = $("#<%= txtSizeName.ClientID%>").val();
            var ProductId = "";
            var newProduct = $("#<%= hfAddingNewProduct.ClientID%>").val();
            if (newProduct == 1) {
                ProductId = $("#<%= hfProductID.ClientID%>").val();
            }
            else {
                ProductId = $("#<%= hfProductIDExisting.ClientID%>").val();
            }
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManageProductStock.aspx/SaveSize",
                data: "{'Size':'" + SizeName + "','ProductID':'" + ProductId + "'}",
                dataType: "json",
                beforeSend: function () {
                    $("#btnSaveSize").attr('disabled', true);
                    $("#btnSaveSize").html('Saving...');
                },
                success: function (data) {
                    var r = data.d;
                    $('#<%= hfSize.ClientID%>').val(r);
                    GetSizes(r == -3 ? -1 : r);
                    hideModal('#AddEditSize');
                    $("#btnSaveSize").html('Save');
                    $("#btnSaveSize").attr('disabled', false);
                    if (r == -3) {
                        $.notify({ title: 'Duplication: ', message: SizeName + ' already exist!', icon: 'fa fa-check' }, { type: 'danger' });
                    }
                    else {
                        $.notify({ title: 'Success Status: ', message: 'Size has been added!', icon: 'fa fa-check' }, { type: 'success' });
                    }

                },
            });
        }

        function ClearSizeItems() {
            $("#<%= txtSizeName.ClientID%>").val(null);
            var Index = $("#<%= hfCurrentIndex.ClientID%>").val();
            $("#ddlSizes" + Index).val("-1").trigger('change');
        }

        function SaveDescription() {
            var descriptionHtml = $('#txtDescription').html();
            $("#<%= txtDescroption.ClientID%>").val(descriptionHtml);
        }

        function LoadDescription() {
            $('#txtDescription').html($("#<%= txtDescroption.ClientID%>").val());
        }

        function AssignSearchUrl(Name) {
            var CurrentIndex = $('#<%= hfCurrentIndex.ClientID%>').val();
            var ddlCompany = document.getElementById('ddlCompany' + CurrentIndex);
            var CompanyName = ddlCompany.options[ddlCompany.selectedIndex].text;
            Name = CompanyName + " " + Name;
            var value = Name.replace(" ", "+");
            document.getElementById('imageLink').href = "https://www.google.com.pk/search?hl=en&tbm=isch&source=hp&biw=1366&bih=626&ei=HkMKXL6zIsyYlwSvgKfgDQ&q=" + value + "&oq=" + value + "&gs_l=img.3..0l10.2214.3746..3947...0.0..0.759.3542.2-2j1j0j2j2......0....1..gws-wiz-img.....0.dxuEkpztc80";
        }

     <%--   $('#AddEditProduct').on('hide.bs.modal', function (e) {
            var hfProductID = $('#<%= hfProductID.ClientID%>');
            var hfDescription = $('#<%= hfDescription.ClientID%>');
            var hfImagePath = $('#<%= hfImagePath.ClientID%>');
            $('#<%= ProductImage.ClientID%>').attr('src', null);
            $("#<%= DivProductImage.ClientID%>").hide();
            $('#<%= ddlCateogory.ClientID%>').val("-1").trigger('change');
            $('#<%= txtProductName.ClientID%>').val(null);
            $('#<%= txtDescroption.ClientID%>').val(null);
            $('#txtDescription').html(null);
            hfProductID.val(null);
            hfDescription.val(null);
            hfImagePath.val(null);
            document.getElementById('imageLink').href = "#";
                <%--document.getElementById("<%=reqFileUpload.ClientID%>").enabled = true;
        });--%>
</script>
    <link href="Select2/CustomCss.css" rel="stylesheet" />
    <style>
        .select2 {
            width: 100% !important;
        }

        .editor-wrapper {
            min-height: 190px !important;
        }

        #example {
            text-align: center;
        }

            #example .demo-container {
                display: inline-block;
                text-align: left;
            }

        .demo-container .RadUpload .ruUploadProgress {
            width: 210px;
            display: inline-block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: top;
        }

        .ruBrowse {
            color: #fff !important;
            background-color: #26B99A !important;
            border-color: #169F85 !important;
            background-image: none !important;
            margin-bottom: 5px !important;
            margin-right: 5px !important;
            display: inline-block !important;
            padding: 5px 10px !important;
            margin-bottom: 0 !important;
            font-size: 12px !important;
            font-weight: 400 !important;
            line-height: 1.5 !important;
            text-align: center !important;
            white-space: nowrap !important;
            vertical-align: middle !important;
            touch-action: manipulation !important;
            cursor: pointer !important;
            -webkit-user-select: none !important;
            -moz-user-select: none !important;
            -ms-user-select: none !important;
            user-select: none !important;
            background-image: none !important;
            border: 1px solid transparent !important;
            border-radius: 4px !important;
        }

        .RadUpload_Default .ruSelectWrap .ruBrowse:hover {
            background-color: #398439 !important;
            cursor: pointer;
        }

        div.RadUpload_Default .ruBrowse::before {
            display: inline-block;
            font: normal normal normal 14px/1 FontAwesome;
            font-size: inherit;
            text-rendering: auto;
            margin-right: 5px !important;
            -webkit-font-smoothing: antialiased;
            content: "\f093";
        }

        .btn {
            margin-bottom: 0px !important
        }
    </style>
    <script>
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
    </script>
    <asp:HiddenField ID="hfStockID" runat="server" />
    <asp:HiddenField ID="hdnQuantity" runat="server" />
    <asp:HiddenField ID="hfTotal" runat="server" />
    <asp:HiddenField ID="HfBillNo" runat="server" />
    <asp:HiddenField ID="hfSupplierId" runat="server" />
    <asp:HiddenField ID="hdnPic" runat="server" />
    <asp:HiddenField ID="hfBarcode" runat="server" />
    <asp:HiddenField ID="hfColorOrId" runat="server" />
    <asp:HiddenField ID="hfImagePath" runat="server" />
    <asp:HiddenField ID="hfProductID" runat="server" />
    <asp:HiddenField ID="hfProductIDExisting" runat="server" />
    <asp:HiddenField ID="hfAddingNewProduct" runat="server" />
    <asp:HiddenField ID="hfCompanyID" runat="server" />
    <asp:HiddenField ID="hfDescription" runat="server" />
    <asp:HiddenField ID="hfCurrentIndex" runat="server" />
    <asp:HiddenField ID="hfSize" runat="server" />

    <!-- Pop up brands -->
    <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditBrand">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" id="clscmp" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabelcmp">
                        <asp:Label ID="Label2" runat="server">Add New Brand</asp:Label></h4>
                </div>
                <div class="modal-body">
                    <div class="x_content" style="float: none!important">
                        <div class="row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group">
                                    <label>
                                        Brand Name:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtBrandName" ErrorMessage="Enter Brand Name" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    </label>
                                    <asp:TextBox runat="server" ID="txtBrandName" class="form-control" TabIndex="1"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" id="btnSaveBrand" onclick="SaveBrand();">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!--Product Pop up start -->
    <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "modal fade bs-example-modal-sm" : "modal fade bs-example-modal-lg" %>' role="dialog" aria-hidden="true" id="AddEditProduct">
        <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "modal-dialog modal-sm" : "modal-dialog modal-lg" %>'>
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" onclick="ClearProductItems();" id="cls" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        <asp:Label ID="Label1" runat="server">Add New Product</asp:Label></h4>
                </div>
                <div class="modal-body">
                    <div class="x_content" style="float: none!important">
                        <div class="row">
                            <div class="col-sm-6 col-md-6 col-lg-6" id="DivCategory" runat="server" style="display: none">
                                <div class="form-group">
                                    <label>
                                        Select Category:&nbsp;
                                                <asp:RequiredFieldValidator ID="reqCategory" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlCateogory" ErrorMessage="*" CssClass="has-error" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    </label>
                                    <asp:DropDownList ID="ddlCateogory" runat="server" class="form-control" TabIndex="2">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "col-sm-12 col-md-12 col-lg-12" : "col-sm-6 col-md-6 col-lg-6" %>'>
                                <div class="form-group">
                                    <label>
                                        Product Condition:&nbsp;
                                    </label>
                                    <asp:DropDownList ID="ddlProductCondition" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="New" Value="New"></asp:ListItem>
                                        <asp:ListItem Text="Used" Value="Used"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class='col-sm-12 col-md-12 col-lg-12'>
                                <div class="form-group">
                                    <label>
                                        Product Name:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" CssClass="has-error" SetFocusOnError="true" ControlToValidate="txtProductName" ErrorMessage="*" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtProductName" ValidationExpression="[^$]+" Display="Dynamic" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>

                                    </label>
                                    <asp:TextBox runat="server" ID="txtProductName" onpaste="AssignSearchUrl(this.value);" oninput="AssignSearchUrl(this.value);" onchange="AssignSearchUrl(this.value);" class="form-control col-md-7 col-xs-12" TabIndex="4"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-sm-4" id="divColorOnly" runat="server" style="display: none">
                                <div class="form-group">
                                    <label></label>
                                    <p>
                                        Color:
                                                                <input type="checkbox" name="gender" class="flat" id="chkColorOnly" runat="server" />&nbsp&nbsp
                                    </p>
                                </div>
                            </div>
                            <div class="col-sm-4" id="rowFlavourColor" runat="server" style="display: none">
                                <div class="form-group">
                                    <label></label>
                                    <p>
                                        Color:
                                                               
                                                                <input type="radio" class="flat" name="gender" id="chkColor" runat="server" />&nbsp&nbsp
                                                                Flavour:
                                                               
                                                                <input type="radio" class="flat" name="gender" id="chkFlavour" runat="server" />
                                    </p>
                                </div>
                            </div>
                            <div class="col-sm-4" id="divFlavourOnly" runat="server" style="display: none">
                                <div class="form-group">
                                    <label></label>
                                    <p>
                                        Falvour:
                                                                <input type="checkbox" class="flat" name="gender" id="chkFlavourOnly" runat="server" />&nbsp&nbsp
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="uploadingArea" runat="server">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label>
                                        &nbsp<span class="required">
                                            <asp:RequiredFieldValidator ID="reqFileUpload" Enabled="false" runat="server" CssClass="has-error" Display="Dynamic" SetFocusOnError="true" ControlToValidate="flvProductUpload" ErrorMessage="Choose an image" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="fileUploadReg" Enabled="false" runat="server" Display="Dynamic" ControlToValidate="flvProductUpload" ValidationExpression="^.*\.((j|J)(p|P)(e|E)?(g|G)|(p|P)(n|N)(g|G))$" CssClass="has-error" ErrorMessage="Please choose only PNG or JPG format" ValidationGroup="validation"></asp:RegularExpressionValidator>
                                        </span>
                                    </label>
                                    <asp:FileUpload ID="flvProductUpload" Visible="false" runat="server" AllowMultiple="true" ClientIDMode="Static" />

                                    <div class="demo-container size-narrow" runat="server" id="DemoContainer1">
                                        <telerik:RadAsyncUpload ClientIDMode="Static" MultipleFileSelection="Automatic" OnFileUploaded="AsyncUpload1_FileUploaded"
                                            ToolTip="Upload Images of your product" RenderMode="Lightweight"
                                            runat="server" ID="AsyncUpload1" ChunkSize="1048576" MaxFileInputsCount="8" HideFileInput="true">
                                            <Localization Select="Upload Images" />
                                        </telerik:RadAsyncUpload>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <telerik:RadProgressArea RenderMode="Lightweight" runat="server" ID="RadProgressArea1" />
                                <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
                                    <AjaxSettings>
                                        <telerik:AjaxSetting AjaxControlID="ConfiguratorPanel1">
                                            <UpdatedControls>
                                                <telerik:AjaxUpdatedControl ControlID="ConfiguratorPanel1" />
                                                <telerik:AjaxUpdatedControl ControlID="DemoContainer1" />
                                            </UpdatedControls>
                                        </telerik:AjaxSetting>
                                    </AjaxSettings>
                                </telerik:RadAjaxManager>
                                <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
                            </div>
                            <div id="DivProductImage" runat="server" clientidmode="Static" style="display: none" class="col-sm-4">
                                <img id="ProductImage" runat="server" clientidmode="Static" src="#" style="height: 115px;" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6 col-md-6 col-lg-6" style='<%=Convert.ToBoolean(config.StandAlonePortal) ? "display: none": "display: block" %>; padding-top: 10px; padding-bottom: 10px;'>
                                <span class="pull-right" style="margin-right: 92px;">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <b><i class="fa fa-arrow-down"></i></b>
                                    <br />
                                    <a href="#" id="imageLink" target="_blank" style="color: #0094ff">Click here to find & download Image from google</a>
                                </span>
                            </div>
                            <div class="col-sm-6 col-md-6 col-lg-6" id="DivUnits" runat="server">
                                <div class="form-group">
                                    <label>
                                        Select unit:&nbsp;
                                                            <asp:RequiredFieldValidator ID="reqUnits" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlUnits" ErrorMessage="*" CssClass="has-error" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    </label>
                                    <p>
                                        <asp:DropDownList ID="ddlUnits" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="row" style='<%=Convert.ToBoolean(config.StandAlonePortal) ? "display: none": "display: block" %>'>
                            <div class="col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group">

                                    <label>
                                        Description:&nbsp;
                                             <asp:RequiredFieldValidator ID="reqDescription" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtDescroption" ErrorMessage="*" CssClass="has-error" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    </label>
                                    <div class="btn-toolbar editor" data-role="editor-toolbar" data-target="#txtDescription">
                                        <div class="btn-group">
                                            <a class="btn dropdown-toggle" data-toggle="dropdown" title="Font Size"><i class="fa fa-text-height"></i>&nbsp;<b class="caret"></b></a>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a data-edit="fontSize 5">
                                                        <p style="font-size: 17px">Huge</p>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a data-edit="fontSize 3">
                                                        <p style="font-size: 14px">Normal</p>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a data-edit="fontSize 1">
                                                        <p style="font-size: 11px">Small</p>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="btn-group">
                                            <a class="btn" data-edit="bold" title="Bold (Ctrl/Cmd+B)"><i class="fa fa-bold"></i></a>
                                            <a class="btn" data-edit="italic" title="Italic (Ctrl/Cmd+I)"><i class="fa fa-italic"></i></a>
                                            <a class="btn" data-edit="strikethrough" title="Strikethrough"><i class="fa fa-strikethrough"></i></a>
                                            <a class="btn" data-edit="underline" title="Underline (Ctrl/Cmd+U)"><i class="fa fa-underline"></i></a>
                                        </div>

                                        <div class="btn-group">
                                            <a class="btn" data-edit="insertunorderedlist" title="Bullet list"><i class="fa fa-list-ul"></i></a>
                                            <a class="btn" data-edit="insertorderedlist" title="Number list"><i class="fa fa-list-ol"></i></a>
                                            <a class="btn" data-edit="outdent" title="Reduce indent (Shift+Tab)"><i class="fa fa-dedent"></i></a>
                                            <a class="btn" data-edit="indent" title="Indent (Tab)"><i class="fa fa-indent"></i></a>
                                        </div>

                                        <div class="btn-group">
                                            <a class="btn" data-edit="justifyleft" title="Align Left (Ctrl/Cmd+L)"><i class="fa fa-align-left"></i></a>
                                            <a class="btn" data-edit="justifycenter" title="Center (Ctrl/Cmd+E)"><i class="fa fa-align-center"></i></a>
                                            <a class="btn" data-edit="justifyright" title="Align Right (Ctrl/Cmd+R)"><i class="fa fa-align-right"></i></a>
                                            <a class="btn" data-edit="justifyfull" title="Justify (Ctrl/Cmd+J)"><i class="fa fa-align-justify"></i></a>
                                        </div>

                                        <div class="btn-group">
                                            <a class="btn" data-edit="undo" title="Undo (Ctrl/Cmd+Z)"><i class="fa fa-undo"></i></a>
                                            <a class="btn" data-edit="redo" title="Redo (Ctrl/Cmd+Y)"><i class="fa fa-repeat"></i></a>
                                        </div>
                                    </div>
                                    <div id="txtDescription" onkeyup="SaveDescription();" class="editor-wrapper"></div>
                                    <asp:TextBox runat="server" ID="txtDescroption" class="form-control col-md-7 col-xs-12" Style="display: none; resize: none!important" TabIndex="4" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="ClearProductItems();" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" id="btnSaveProduct" onclick="SaveProduct()">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!--Product Pop up end -->

    <!-- Pop up Size -->
    <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditSize">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" id="clsSize" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabelSize">
                        <asp:Label ID="Label3" runat="server">Add New Size</asp:Label></h4>
                </div>
                <div class="modal-body">
                    <div class="x_content" style="float: none!important">
                        <div class="row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group">
                                    <label>
                                        Size:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtBrandName" ErrorMessage="Enter Brand Name" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    </label>
                                    <asp:TextBox runat="server" ID="txtSizeName" class="form-control" TabIndex="1"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" id="btnSaveSize" onclick="SaveSize();">Save</button>
                </div>
            </div>
        </div>
    </div>


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
                                                <button type="button" class="close" id="cls2" data-dismiss="modal">
                                                    <span aria-hidden="true">×</span>
                                                </button>
                                                <h4 class="modal-title" id="myModalLabel2">
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
                                        <th runat="server" id="thSzes" visible="false">Size</th>
                                        <th runat="server" id="thColor" style="display: none">Color</th>
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

        function hideModal(id) {
            $(id).modal('hide');
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
