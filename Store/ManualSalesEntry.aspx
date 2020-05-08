<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ManualSalesEntry.aspx.cs" Inherits="PreShop.StockManagement.Store.ManualSalesEntry" %>

<%@ Register Assembly="SpartansControls" Namespace="SpartansControls" TagPrefix="sp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #SaleData td {
            vertical-align: middle !important;
        }

        .ChangeSales {
            width: 50%;
        }

        .subtotalInput {
            border: 0px;
            background: transparent;
            text-align: center;
            cursor: default;
            width: 50%;
        }

        .table > thead:first-child > tr:first-child > th {
            text-align: center;
        }

        .error {
            border-color: #F00;
        }
    </style>
    <script>
        var Brands = [], Products = [], ProductsConfig = [], Color = [], Sizes = [], Prices = [];
        $(window).load(function () {
            $("#btnAddNewRow").removeAttr("disabled");
        });
        $(document).ready(function () {
            GetBrands();
            GetProducts();
            GetProductsConfig();
            GetColors();
            GetSizes();
            GetPrices();
            $("#btnSubmit").on('click', function () {
                if (isValid())
                    SaveSales();
            });
            var BillNo = $("#<%= HfBillNo.ClientID%>").val();
            if (BillNo != null & BillNo != '' & BillNo != 'undefined') {
                BindSalesItems(BillNo)
            }
            $('#<%= txtBillNo.ClientID%>').on('change', function () {
                BindSalesItems($(this).val())
            });
        });

        function init() {
            timeDisplay = document.createTextNode("");
            document.getElementById("clock").appendChild(timeDisplay);
        }
        function updateClock() {
            var currentTime = new Date();

            var currentHours = currentTime.getHours();
            var currentMinutes = currentTime.getMinutes();
            var currentSeconds = currentTime.getSeconds();

            // Pad the minutes and seconds with leading zeros, if required
            currentMinutes = (currentMinutes < 10 ? "0" : "") + currentMinutes;
            currentSeconds = (currentSeconds < 10 ? "0" : "") + currentSeconds;

            // Choose either "AM" or "PM" as appropriate
            var timeOfDay = (currentHours < 12) ? "AM" : "PM";

            // Convert the hours component to 12-hour format if needed
            currentHours = (currentHours > 12) ? currentHours - 12 : currentHours;

            // Convert an hours component of "0" to "12"
            currentHours = (currentHours == 0) ? 12 : currentHours;

            // Compose the string for display
            var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds + " " + timeOfDay;

            // Update the time display
            document.getElementById("clock").firstChild.nodeValue = currentTimeString;
        }
        function printInvoice() {
            CreateInvoice();
            var contents = document.getElementById("InvoiceToPrint").innerHTML;
            var frame1 = document.createElement('iframe');
            frame1.name = "frame1";
            frame1.style.position = "absolute";
            frame1.style.top = "-1000000px";
            document.body.appendChild(frame1);
            var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
            frameDoc.document.open();
            frameDoc.document.write('<html><head><title></title>');
            frameDoc.document.write('<link href="vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" media="print">');
            frameDoc.document.write('<link href="build/css/custom.min.css" rel="stylesheet" media="print">');
            frameDoc.document.write('<style type="text/css" media="print"> .printInvoice { width: 100%; zoom: 185%; }</style></head><body>');
            frameDoc.document.write(contents);
            frameDoc.document.write('</body></html>');
            frameDoc.document.close();
            setTimeout(function () {
                window.frames["frame1"].focus();
                window.frames["frame1"].print();
                document.body.removeChild(frame1);
            }, 500);
            return false;
        }

        function isValid() {
            var CustomerId = $('#<%= ddlCustomerType.ClientID %>').val();
            var BillNo = $('#<%= txtBillNo.ClientID%>').val();
            var Date = $('#<%= txtDate.ClientID %>').val();
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
            else if (CustomerId == "-2" && $('#<%= divCustomer.ClientID %>').is(':visible')) {
                alert("Please select Customer Type");
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

        function ValidateRow(Index) {
            var ddlCompany = $("#ddlCompany" + Index);
            var ddlProducts = $("#ddlProducts" + Index);
            var txtQty = $("#txtQty" + Index);
            var txtPrice = $("#txtPrice" + Index);
            var txtSalePrice = $("#txtSalePrice" + Index);
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



        function Loader() {
            $("#SaleData > tbody").empty();
            $("#SaleData > tbody").append("<tr><td colspan='9'><i class='fa fa-2x fa-spin fa-spinner'></i></td></tr>");
        }

        function BindSalesItems(BillNo) {
            AjaxCall("ManualSalesEntry.aspx/BindDatatable", '{BillNo: ' + BillNo + '}', BindItems, Loader);
        }

        function BindItems(data) {
            var SaleData = $("#SaleData > tbody");
            SaleData.empty();
            if (data.d != null) {
                $('#btnSubmit').attr('disabled', false);
                $('#<%= divPrintCheck.ClientID%>').attr('disabled', false);
               <%-- 
                if (data.d[0].ddlSupplier != null)
                    $("#<%= ddlCustomerType.ClientID%>").val(data.d[0].ddlSupplier).trigger('change');
                else
                    $("#<%= ddlCustomerType.ClientID%>").val("-1").trigger('change');--%>
                $('#<%= txtTotalBill.ClientID%>').val(null);
                $('#<%= txtPaidAmount.ClientID%>').val(null);
                $('#<%= txtDiscount.ClientID%>').val(null);
                $('#<%= HfBillNo.ClientID%>').val(null);
                $('#<%= lblInvoiceTotal.ClientID%>').html(null);
                $('#<%= lblDiscount.ClientID%>').html(null);
                $('#<%= lblInvoiceTotalBill.ClientID%>').html(null);
                for (var i = 0; i < data.d.length; i++) {
                    SaleData.append("<tr id='tr" + i + "'>" +
                        "<td><input type='hidden' value='" + data.d[i].SaleId + "' id='hfSaleId" + i + "' /><select class='form-control Searchable' id='ddlCompany" + i + "' onchange='FillProducts(this.value," + i + ",-1)'></select></td>" +
                        "<td><select class='form-control Searchable' id='ddlProducts" + i + "' onchange='GetProductSizes(this.value," + i + ",-1);FillPrices(this.value," + i + ");'></select></td>" +
                        "<td><input class='form-control' type='text' value='" + data.d[i].Quantity + "' id='txtQty" + i + "' style='width:50px' onkeydown='CalculateItemTotal(" + i + ");' onkeyup='CalculateItemTotal(" + i + ");' /></td>" +
                        "<td><input class='subtotalInput' type='text' value='" + data.d[i].Price + "' id='txtPrice" + i + "' style='width:100px' /></td>" +
                        "<td><input class='form-control' type='text' value='" + data.d[i].SalePrice + "' id='txtSalePrice" + i + "' onkeydown='CalculateItemTotal(" + i + ");' onkeyup='CalculateItemTotal(" + i + ");' style='width:100px' /></td>" +
                        "<td><input class='form-control' type='text' value='" + data.d[i].Discount + "' id='txtDiscount" + i + "' onkeydown='CalculateItemTotal(" + i + ");' onkeyup='CalculateItemTotal(" + i + ");' style='width:100px' /></td>" +
                        "<td><input type='text' value='" + data.d[i].SubTotal + "' disabled='disabled' class='subtotalInput' id='txtAmount" + i + "' style='width:110px' /></td>" +
                        "<td><a href='javascript:;' onclick='DeleteItem(" + data.d[i].SaleId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td></tr>");
                    FillBrands(i, data.d[i].CompanyId);
                    FillProducts(data.d[i].CompanyId, i, data.d[i].ProductID);
                }
                CalculateBill();
            }
            else {
                $("#<%= ddlCustomerType.ClientID%>").val("-2").trigger('change');
                $("#<%=txtTotalBill.ClientID%>").val(null);
                $("#<%=txtPaidAmount.ClientID%>").val(null);
                $("#<%=txtRemainingAmount.ClientID%>").val(null);
                $('#btnSubmit').attr('disabled', true);
                $('#<%= divPrintCheck.ClientID%>').attr('disabled', true);
            }
        }

        function AddNewRow() {
            var SaleData = $("#SaleData > tbody");
            if (ValidateRow($("#SaleData > tbody >tr:last").index())) {
                var RowId = $("#SaleData > tbody >tr:last").index() + 1;
                var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
                var HaveSizes = "<%= Convert.ToBoolean(config.HaveSizes) %>";

                var saleDataHtml = '';
                saleDataHtml += "<tr id='tr" + RowId + "'>";
                saleDataHtml += "<td align='center'><select id='ddlCompany" + RowId + "' class='form-control Searchable' onchange='FillProducts(this.value," + RowId + ",-1)'></select></td>";
                if (HaveSizes == "True") {
                    saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='GetProductSizes(this.value," + RowId + ",-1);FillPrices(this.value," + RowId + ");'></select></td>";
                    if (IsColor == "2") {
                        saleDataHtml += "<td align='center'><select id='ddlSizes" + RowId + "' class='form-control Searchable' onchange='FillColors(this.value," + RowId + ",-1);RemoveError(" + RowId + ");'></select></td>";
                    }
                    else {
                        saleDataHtml += "<td align='center'><select id='ddlSizes" + RowId + "' class='form-control Searchable' onchange='RemoveError(" + RowId + ");'></select></td>";
                    }
                }
                else if (IsColor == "2") {
                    saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='FillColors(this.value," + RowId + ",-1);GetProductSizes(this.value," + RowId + ",-1);FillPrices(this.value," + RowId + ");'></select></td>";
                }
                else {
                    saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='GetProductSizes(this.value," + RowId + ",-1);FillPrices(this.value," + RowId + ");'></select></td>";
                }
                if (IsColor == "2")
                    saleDataHtml += "<td align='center' style='display:none' id='tdColor" + RowId + "'><div class='newcolorpicker' id='picker" + RowId + "'></div><select id='ddlColors" + RowId + "' class='form-control hidden Searchable' onchange='RemoveError(" + RowId + ");'></select></td>";
                saleDataHtml += "<td align='center'><input type='text' value='1' autocomplete='off' id='txtQty" + RowId + "' class='form-control' style='width:50px' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtPrice" + RowId + "' class='subtotalInput' style='width:100px' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtSalePrice" + RowId + "' class='form-control' style='width:100px' autocomplete='off' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' id='txtDiscount" + RowId + "' value='0' class='form-control' style='width:100px' autocomplete='off' onkeydown='CalculateItemTotal(" + RowId + ");' onkeyup='CalculateItemTotal(" + RowId + ");' /></td>";
                saleDataHtml += "<td align='center'><input type='text' disabled='disabled' class='subtotalInput' id='txtAmount" + RowId + "' style='width:110px' /></td>";
                saleDataHtml += "<td align='center'><a href='javascript:;' onclick='Remove(" + RowId + ");' style='color:red'> <i class='fa fa-close' Style='font-size: 15px!important'></i></a></td></tr>";
                SaleData.append(saleDataHtml);
                FillBrands(RowId, -1);
                $("#btnSubmit").attr('disabled', false);
                $('#<%= divPrintCheck.ClientID%>').attr('disabled', false);
                $("html, body").animate({ scrollTop: $(document).height() }, 2000);
            }
        }

        function CreateInvoice() {
            var InvoiceHtml = '', ProductName = '';
            $("#tblInvoice > tbody").empty();
            var billno = $("#<%= txtBillNo.ClientID%>").val();
            $("#<%= lblBillNo.ClientID%>").html(billno);
            $tableSales = $('#SaleData > tbody  > tr');
            var TotalSales = $tableSales.length;
            for (var i = 0; i < TotalSales; i++) {
                ProductName = $("#ddlProducts" + i).children("option").filter(":selected").text().split('-')[0];
                InvoiceHtml += "<tr>" +
                    "<td>" + ProductName + "</td>" +
                    "<td>" + $("#txtQty" + i).val() + "</td>" +
                    "<td>" + $("#txtSalePrice" + i).val() + "</td>" +
                    "<td>" + $("#txtAmount" + i).val() + "</td>"
                "</tr>";
            }
            $("#tblInvoice > tbody").append(InvoiceHtml);
            var Discount = $("#<%= txtDiscount.ClientID %>").val();
            var TotalBill = $("#<%= txtTotalBill.ClientID%>").val();
            $('#<%= lblInvoiceTotal.ClientID%>').html(TotalBill);
            $('#<%= lblDiscount.ClientID%>').html(Discount);
            $('#<%= lblInvoiceTotalBill.ClientID%>').html(parseFloat(TotalBill) - parseFloat(Discount));
        }

        function SaveSales() {
            $tableSales = $('#SaleData > tbody  > tr');
            var Sales = [];
            var TotalSales = $tableSales.length;
            var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
            var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
            for (var i = 0; i < TotalSales; i++) {
                Sales.push({
                    SaleId: $("#hfSaleId" + i).length > 0 ? $("#hfSaleId" + i).val() : null,
                    CompanyId: $("#ddlCompany" + i).val(),
                    ProductID: $("#ddlProducts" + i).val(),
                    Price: $("#txtPrice" + i).val(),
                    SalePrice: $("#txtSalePrice" + i).val(),
                    Discount: $("#txtDiscount" + i).val(),
                    Quantity: $("#txtQty" + i).val(),
                    Expense: "0",
                    Date: $("#<%= txtDate.ClientID%>").val(),
                    InvoiceNo: $("#<%= txtBillNo.ClientID%>").val(),
                    SizeId: (HaveSizes == "True") ? $("#ddlSizes" + i).val() : "0",
                    ColorId: (IsColor == "2") ? $("#ddlColors" + i).val() : "0",
                    SerialNo: '',
                    hdnQuantity: "0"
                });
            }
            var request = {
                BillNo: $("#<%= txtBillNo.ClientID%>").val(),
                Date: $("#<%= txtDate.ClientID%>").val(),
                CustomerId: $("#<%=ddlCustomerType.ClientID %>").val(),
                items: Sales,
                TotalBill: 0,
                Paid: $("#<%=txtPaidAmount.ClientID %>").val(),
                Remaining: $("#<%=txtRemainingAmount.ClientID %>").val(),
                Discount: $("#<%=txtDiscount.ClientID %>").val()
            };
            request = JSON.stringify({ 'request': request });
            //printInvoice();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManualSalesEntry.aspx/SaveSales",
                data: request,
                dataType: "json",
                beforeSend: function () {
                    $("#btnSubmit").attr('disabled', true);
                    $('#<%= divPrintCheck.ClientID%>').attr('disabled', false);
                },
                success: function (data) {
                    if (data.d == true) {
                        Clear();
                        $.notify({ title: 'Sales Status: ', message: 'Sales has been saved', icon: 'fa fa-check' }, { type: 'success' });
                    }
                    else {
                        window.location.href = "<%= PreShop.Common.StoreBackToLoginUrl %>";
                    }
                }
            });
        }

        function Remove(RowId) {
            $('#SaleData tr[id=tr' + RowId + ']').remove();
            CalculateBill();
        }

        function CalculateBill() {
            var TotalBill = 0, TotalDiscount = 0;
            for (var i = 0; i < $("#SaleData > tbody >tr").length; i++) {
                TotalBill += parseFloat($("#txtAmount" + i).val() != '' ? $("#txtAmount" + i).val() : 0);
                TotalDiscount += parseFloat($("#txtDiscount" + i).val() != '' ? $("#txtDiscount" + i).val() : 0);
            }
            $("#<%=txtTotalBill.ClientID%>").val(TotalBill);
            $("#<%=txtDiscount.ClientID%>").val(TotalDiscount);
            $("#<%= txtPaidAmount.ClientID%>").val(TotalBill - TotalDiscount);
            CalBill();
        }

        function CalBill() {
            var TotalBill = document.getElementById("<%= txtTotalBill.ClientID%>").value;
            var Paid = document.getElementById("<%= txtPaidAmount.ClientID%>").value;
            var Discount = document.getElementById("<%= txtDiscount.ClientID%>").value;
            var result = (parseFloat(TotalBill != '' ? TotalBill : 0) - parseFloat(Paid != '' ? Paid : 0) - parseFloat(Discount != '' ? Discount : 0));
            document.getElementById("<%=txtRemainingAmount.ClientID%>").value = result;
        }

        function CalculateItemTotal(Index) {
            var txtQty = "#txtQty" + Index, txtSalePrice = "#txtSalePrice" + Index, txtAmount = "#txtAmount" + Index, txtDiscount = "#txtDiscount" + Index;
            $(txtAmount).val((parseInt($(txtQty).val()) * parseFloat($(txtSalePrice).val())) - parseFloat($(txtDiscount).val()));
            CalculateBill();
        }
        function CheckDiscount() {
            var TotalBill = parseFloat(document.getElementById("<%=txtTotalBill.ClientID%>").value);
            var Discount = parseFloat(document.getElementById("<%=txtDiscount.ClientID%>").value);
            if (TotalBill < Discount) {
                alert("Discount cannot be greater then Subtotal!");
                return false;
            }
            else {
                CalBill();
                return true;
            }
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
        }

        function FillProducts(CompanyId, Index, SelectedValue) {
            if (Products.length == 0)
                GetProducts();
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

        function FillPrices(ProductId, Index) {
            if (Prices.length == 0)
                GetPrices();
            var txtSalePrice = "#txtSalePrice" + Index, txtPrice = "#txtPrice" + Index;
            var FilteredPrice = Prices.filter(function (e) {
                return e.ProductId == ProductId;
            });
            if (FilteredPrice.length > 0) {
                $(txtPrice).val(FilteredPrice[0].Price);
                $(txtSalePrice).val(FilteredPrice[0].SalePrice);
            }
            else {
                 $(txtPrice).val(0);
                $(txtSalePrice).val(0);
            }
            CalculateItemTotal(Index);
        }

        function FillColors(Id, Index, SelectedValue) {
            var IsColor = "<%= Convert.ToInt32(config.IsColor) %>";
            var HaveSizes = "<%= Convert.ToBoolean(config.HaveSizes) %>";
            if (IsColor == "2") {
                var PaletteColors = [];
                if (Color.length == 0)
                    GetColors();
                var ColorDropdownId = "#ddlColors" + Index;
                $(ColorDropdownId).empty();
                $(ColorDropdownId).append($("<option></option>").val("-1").html("Select Color"));
                var FilteredColors = Color.filter(function (e) {
                    if (HaveSizes == "True") {
                        return e.SizeId == Id;
                    }
                    else {
                        return e.ProductID == Id;
                    }
                });
                console.log(FilteredColors);
                $.each(FilteredColors, function (data, value) {
                    $(ColorDropdownId).append($("<option style='background-color:" + value.ColorCode + "'></option>").val(value.ColorID).html(value.ColorName));
                    PaletteColors.push(value.ColorCode);
                })
                $(ColorDropdownId).val(SelectedValue);
                initColorPicker(Index, PaletteColors);
            }
        }

        function initColorPicker(Index, PaletteColors) {
            var ColorDropdownId = "#ddlColors" + Index;
            $("#picker" + Index).colorPick({
                'initialColor': '#3498db',
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

        function GetProductSizes(ProductId, Index, SelectedValue) {
            var HaveSizes ="<%= Convert.ToBoolean(config.HaveSizes) %>";
            if (HaveSizes == "True") {
                if (Sizes.length == 0) {
                    GetSizes();
                }
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
            GetProductConfig(ProductId, Index);
        }


        function GetProductConfig(ProductId, Index) {
            var IsColor = "<%= Convert.ToInt16(config.IsColor) %>";
            if (IsColor == "2") {
                var Config = ProductsConfig.filter(function (e) {
                    return e.ProductID == ProductId;
                });
                if (Config.length > 0) {
                    if (Config[0].IsColor == 1) {
                        $("#<%= thColor.ClientID%>").show();
                        $("#tdColor" + Index).show();
                    }
                    else {
                        $("#<%= thColor.ClientID%>").hide();
                        $("#tdColor" + Index).hide();
                    }
                }
                else {
                    $("#<%= thColor.ClientID%>").hide();
                    $("#tdColor" + Index).hide();
                }
            }
        }

        function GetPrices() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManualSalesEntry.aspx/GetSalePrice",
                dataType: "json",
                success: function (res) {
                    Prices = res.d;

                }
            });
        }

        function GetProductsConfig() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StockEntry.aspx/GetProductConfig",
                dataType: "json",
                success: function (res) {
                    ProductsConfig = res.d;
                }
            });
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
                url: "ManualSalesEntry.aspx/GetProducts",
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
                url: "ManualSalesEntry.aspx/GetColors",
                dataType: "json",
                success: function (res) {
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

        function Clear() {
            $("#SaleData > tbody").empty();
            $("#<%= txtBillNo.ClientID%>").val(null);
            $("#<%= txtTotalBill.ClientID%>").val(null);
            $("#<%= txtPaidAmount.ClientID%>").val(null);
            $("#<%= txtRemainingAmount.ClientID%>").val(null);
            $("#<%= ddlCustomerType.ClientID%>").val("-1").trigger('change');
            $("#<%= txtDate.ClientID%>").val(null);
        }
    </script>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2><i class="fa fa-2x fa-align-justify fa-cart-plus"></i>&nbsp Sales & Billing Form
                    </h2>
                    <div class="row">
                        <div class="col-xs-6 pull-right">
                            <h1>
                                <small class="pull-right">Date: <%= getDateTime().ToString("MMM") %> <%= getDateTime().Day %>, <%= getDateTime().Year %><br />
                                    <span id="clock">&nbsp;</span></small>
                            </h1>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
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
                        <div class="col-sm-4" id="divBillno" runat="server">
                            <div class="form-group">
                                <label>
                                    Invoice no: <span class="required">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ValidationGroup="Validation" ControlToValidate="txtBillNo" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator></span>
                                </label>

                                <asp:TextBox ID="txtBillNo" runat="server" autocomplete='off' onkeypress='return isNumber(event)' CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label>
                                    Date:<span class="required has-error">*</span>
                                </label>
                                <sp:DatePicker ID="txtDate" ClientIDMode="Static" Width="100%" autocomplete="off" runat="server" IconClass="fa fa-calendar"></sp:DatePicker>
                            </div>
                        </div>

                        <div class="col-sm-4" id="divCustomer" runat="server">
                            <div class="form-group">
                                <label>
                                    Customer Type: <span class="required">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Validation" ControlToValidate="ddlCustomerType" InitialValue="-2" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator></span>
                                </label>
                                <asp:DropDownList ID="ddlCustomerType" runat="server" CssClass="form-control Searchable" TabIndex="1">
                                </asp:DropDownList>
                            </div>
                        </div>


                    </div>
                    <div class="ln_solid"></div>
                    <div class="clearfix"></div>
                    <div class="row">
                        <div class="col-sm-12">
                            <table id="SaleData" class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th>Brand</th>
                                        <th>Product</th>
                                        <th runat="server" id="thSzes" visible="false">Size</th>
                                        <th runat="server" id="thColor" style="display: none">Color</th>
                                        <th>Qty</th>
                                        <th>Price(Per Item)</th>
                                        <th>Sale Price</th>
                                        <th>Discount</th>
                                        <th>SubTotal</th>
                                        <th>Action(s)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr id="trFooter">
                                        <td colspan="10">
                                            <button id="btnAddNewRow" disabled="disabled" type="button" onclick="AddNewRow();" class="btn btn-success" style="margin-bottom: 10px">Add new sale</button>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <label>Total Bill:</label>
                            <asp:TextBox ID="txtTotalBill" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>
                        <div id="divPaid" runat="server">
                            <div class="col-sm-2">
                                <label>
                                    Paid: &nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ValidationGroup="Validation" ControlToValidate="txtPaidAmount" Display="Dynamic" ErrorMessage="Required" CssClass="has-error"></asp:RequiredFieldValidator>
                                </label>
                                <asp:TextBox ID="txtPaidAmount" runat="server" autocomplete='off' CssClass="form-control" onkeypress='return isNumber(event)' oninput="CalBill();"></asp:TextBox>
                            </div>
                            <div class="col-sm-2">
                                <label>Remaining:</label>
                                <asp:TextBox ID="txtRemainingAmount" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <label>
                                Discount:&nbsp;
                            </label>
                            <asp:TextBox ID="txtDiscount" runat="server" autocomplete='off' CssClass="form-control" Enabled="false" onkeypress='return isNumber(event)' Text="0" oninput="CheckDiscount();"></asp:TextBox>
                        </div>
                        <div class="col-sm-4">
                            <label>&nbsp</label><br />
                            <button id="btnSubmit" class="btn btn-primary" type="button" disabled="disabled">Submit</button>
                            <%--<div class="checkbox pull-right" style="margin-right: 10px" id="divPrintCheck" runat="server">
                                <input id="chkCheckPrint" runat="server" class="styled" type="checkbox" checked="checked" />
                                <label style="color: #000" for="chkCheckPrint">
                                    Print Invoice
                                </label>
                            </div>--%>
                            <button id="divPrintCheck" runat="server" disabled="disabled" type="button" class="btn btn-info" onclick="printInvoice();"><i class="fa fa-print"></i>Print Invoice</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row hidden" id="InvoiceToPrint">
        <div class="col-md-12 printInvoice">
            <div class="x_panel">
                <div class="x_content">
                    <section class="content invoice">
                        <!-- title row -->
                        <div class="row">
                            <div class="col-xs-12 invoice-header">
                                <h2>
                                    <img src='<%= ResolveUrl(Convert.ToString(Session["Logo"])) %>' alt="Logo Missing" style="height: 35px; width: 30px;" />
                                    <%= Session["StoreName"] %>
                                </h2>
                                <h2>
                                    <small class="pull-right">Date: <%= getDateTime().ToShortDateString() %></small>
                                </h2>
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- info row -->
                        <div class="row invoice-info">
                            <div class="col-sm-4 invoice-col" style="padding-bottom: 25px; padding-top: 25px">
                                <b>Invoice #
                                    <asp:Label ID="lblBillNo" runat="server"></asp:Label></b>
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                        <!-- Table row -->
                        <div class="row">
                            <div class="col-xs-12 table">
                                <table class="table table-striped" id="tblInvoice">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Qty</th>
                                            <th>Price</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                        <div class="row">
                            <!-- /.col -->
                            <div class="col-xs-3">
                            </div>
                            <div class="col-xs-9">
                                <div class="table-responsive">
                                    <table class="table">
                                        <tbody>
                                            <tr>
                                                <th style="width: 50%">Subtotal:</th>
                                                <td>
                                                    <asp:Label ID="lblInvoiceTotal" runat="server"></asp:Label>
                                                    Rs</td>
                                            </tr>
                                            <tr>
                                                <th>Discount:</th>
                                                <td>
                                                    <asp:Label ID="lblDiscount" runat="server"></asp:Label>
                                                    Rs</td>
                                            </tr>
                                            <tr>
                                                <th>Total:</th>
                                                <td>
                                                    <asp:Label ID="lblInvoiceTotalBill" runat="server"></asp:Label>
                                                    Rs</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                        <div class="row">
                            <div class="col-xs-12 text-center">
                                <small>
                                    <img style="height: 35px; width: 35px;" src="http://thepreshop.com/assets/img/logo/logosmall.png" />&nbsp Software Developed By the Preshop Technologies</small>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfPrice" runat="server" />
    <asp:HiddenField ID="hfSubTotal" runat="server" />
    <asp:HiddenField ID="HfBillNo" runat="server" />
    <script>
        $(document).ready(function () {
            $('#datatable-responsive').dataTable({
                "bSort": false
            });
        });
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>

