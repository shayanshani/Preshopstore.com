<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ManualSalesEntry.aspx.cs" Inherits="PreShop.SalesManagement.Store.ManualSalesEntry" %>

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
        var Brands = [];
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

        $(document).ready(function () {
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
            GetBrands();
        });

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
                        "<td><select class='form-control Searchable' id='ddlProducts" + i + "' onchange='GetPrices(this.value," + i + ")'></select></td>" +
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
                var saleDataHtml = '';
                saleDataHtml += "<tr id='tr" + RowId + "'>";
                saleDataHtml += "<td align='center'><select id='ddlCompany" + RowId + "' class='form-control Searchable' onchange='FillProducts(this.value," + RowId + ",-1)'></select></td>";
                saleDataHtml += "<td align='center'><select id='ddlProducts" + RowId + "' class='form-control Searchable' onchange='GetPrices(this.value," + RowId + ")'></select></td>";
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
            var ProductsDropDown = "#ddlProducts" + Index;
            $(ProductsDropDown).empty();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManualSalesEntry.aspx/GetProducts",
                data: '{CompanyID: ' + CompanyId + '}',
                beforeSend: function () {
                    $(ProductsDropDown).prepend($('<option></option>').html('Loading products...'));
                },
                dataType: "json",
                success: function (res) {
                    $(ProductsDropDown).empty();
                    $(ProductsDropDown).append($("<option></option>").val("-1").html("Select Product"));
                    $.each(res.d, function (data, value) {
                        $(ProductsDropDown).append($("<option></option>").val(value.ProductID).html(value.ProductName));
                    })
                    $(ProductsDropDown).val(SelectedValue);
                }
            });
        }

        function GetPrices(PorductId, Index) {
            var txtSalePrice = "#txtSalePrice" + Index, txtPrice = "#txtPrice" + Index;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: '{ProductId: ' + PorductId + '}',
                url: "ManualSalesEntry.aspx/GetSalePrice",
                dataType: "json",
                success: function (res) {
                    $(txtPrice).val(res.d.Price);
                    $(txtSalePrice).val(res.d.SalePrice);
                    CalculateItemTotal(Index);
                }
            });
        }

        function GetBrands() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ManualSalesEntry.aspx/FillBrands",
                dataType: "json",
                success: function (res) {
                    Brands = res.d;
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
                                        <td colspan="8">
                                            <button id="btnAddNewRow" type="button" onclick="AddNewRow();" class="btn btn-success" style="margin-bottom: 10px">Add new sale</button>
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
