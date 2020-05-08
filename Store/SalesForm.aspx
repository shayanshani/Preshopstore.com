<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="SalesForm.aspx.cs" Inherits="PreShop.StockManagement.Store.SalesForm" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
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
            var contents = document.getElementById("InvoiceToPrint").innerHTML;
            var frame1 = document.createElement('iframe');
            frame1.name = "frame1";
            frame1.style.position = "absolute";
            frame1.style.top = "-1000000px";
            document.body.appendChild(frame1);
            var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
            frameDoc.document.open();
            frameDoc.document.write('<html><head><title></title>');
            frameDoc.document.write('<link href="/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" media="print">');
            frameDoc.document.write('<link href="/build/css/custom.min.css" rel="stylesheet" media="print">');
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
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%= btnSubmit.ClientID%>').attr('disabled', true);
            $('#<%= divPrintCheck.ClientID%>').attr('disabled', true);

            var BillNo = $("#<%= HfBillNo.ClientID%>").val();
            if (BillNo != null & BillNo != '' & BillNo != 'undefined')
                BindSalesItems();

            $('#<%= txtBillNo.ClientID%>').on('change', function () {
                $('#<%= lblBillNo.ClientID%>').html($(this).val());
                BindSalesItems();
            });
        });

        $(document).scannerDetection({
            onKeyDetect: false,
            timeBeforeScanTest: 200, //wait for the next character for upto 200ms
            startChar: [120], // Prefix character for the cabled scanner (OPL6845R)
            endChar: [13], // be sure the scan is complete if key 13 (enter) is detected
            avgTimeByChar: 40, // it's not a barcode if a character takes longer than 40ms
            onComplete: function (barcode, qty) {
                Save(barcode);
            }, // main callback function	
        });

        function BindSalesItems() {
            $('#SaleData').focus();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "SalesForm.aspx/BindDatatable",
                data: "{'BillNo':'" + $("#<%= txtBillNo.ClientID%>").val() + "'}",
                dataType: "json",
                beforeSend: Loader,
                success: function (data) {
                    bindData(data);
                }
            });
        }

        function Save(barcode) {
            if ($("#<%= txtBillNo.ClientID%>").val() != "") {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "SalesForm.aspx/Save",
                    data: "{'barcode':'" + barcode + "', 'QuantityPosted':'" + 1 + "', 'BillNo':'" + $("#<%= txtBillNo.ClientID%>").val() + "', 'SalePrice':'0'}",
                    dataType: "json",
                    beforeSend: Loader,
                    success: function (data) {
                        if (data.d == "logout")
                            window.location = "<%= PreShop.Common.StoreBackToLoginUrl %>";
                        else if (data.d == "Qty")
                            alert("Product is out of stock");
                        else
                            BindSalesItems();
                    }
                });
            }
            else {
                alert('Enter Invoice # before scanning');
            }
        }

        $('.ChangeSales').click(function (event) {
            event.preventDefault();
        });

        function Loader() {
            $("#SaleData > tbody").empty();
            $("#SaleData > tbody").append("<tr><td colspan='9'><i class='fa fa-2x fa-spin fa-spinner'></i></td></tr>");
        }

        function bindData(data) {
            $('#<%= txtTotalBill.ClientID%>').val(null);
            $('#<%= txtPaidAmount.ClientID%>').val(null);
            $('#<%= txtDiscount.ClientID%>').val(null);
            $('#<%= HfBillNo.ClientID%>').val(null);
            $('#<%= lblInvoiceTotal.ClientID%>').html(null);
            $('#<%= lblDiscount.ClientID%>').html(null);
            $('#<%= lblInvoiceTotalBill.ClientID%>').html(null);

            if (data.d != null) {
                $("#SaleData > tbody").empty();
                $("#tblInvoice > tbody").empty();
                var saleDataHtml, InvoiceHtml;
                $('#<%= btnSubmit.ClientID%>').attr('disabled', false);
                $('#<%= divPrintCheck.ClientID%>').attr('disabled', false);
                for (var i = 0; i < data.d.length; i++) {
                    var barcode;
                    barcode = '"' + data.d[i].barCode + '"';
                    saleDataHtml += "<tr>" +
                        "<td>" + data.d[i].Date + "</td>" +
                        "<td>" + data.d[i].Product + "</td>" +
                        "<td><input onkeypress='return isNumber(event)' id='txtQuantity" + i + "' class='ChangeSales' oninput='UpdateItem(" + barcode + "," + i + "," + data.d[0].Discount + ");' type='text' value=" + data.d[i].Quantity + " /></td>" +
                        "<td>" + data.d[i].Price + "</td>" +
                        "<td><input type='text' value='" + data.d[i].SalePrice + "' id='txtSalePrice" + i + "' class='ChangeSales' onkeypress='return isNumber(event)' oninput='UpdateItem(" + barcode + "," + i + "," + data.d[0].Discount + ")' /></td>" +
                        "<td><input type='text' disabled='disabled' class='subtotalInput' id='txtSubTotal" + i + "' value='" + data.d[i].SubTotal + "' /></td>" +
                        "<td><a href='javascript:void(0)' onclick='DeleteEntry(" + data.d[i].SaleId + ");'><i class='fa fa-trash'></i></a></td>" +
                        "</tr>";

                    InvoiceHtml += "<tr>" +
                        "<td>" + data.d[i].Product + "</td>" +
                        "<td>" + data.d[i].Quantity + "</td>" +
                        "<td>" + data.d[i].SalePrice + "</td>" +
                        "<td>" + data.d[i].SubTotal + "</td>" +
                        "</tr>";
                }
                $("#SaleData > tbody").append(saleDataHtml);
                $("#tblInvoice > tbody").append(InvoiceHtml);
                $('#<%= txtTotalBill.ClientID%>').val(data.d[0].TotalBill);
                $('#<%= txtPaidAmount.ClientID%>').val(data.d[0].PaidAmount);
                $('#<%= txtDiscount.ClientID%>').val(data.d[0].Discount);
                $('#<%= HfBillNo.ClientID%>').val($("#<%= txtBillNo.ClientID%>").val());
                $('#<%= lblInvoiceTotal.ClientID%>').html(data.d[0].TotalBill);
                $('#<%= lblDiscount.ClientID%>').html(data.d[0].Discount);
                $('#<%= lblInvoiceTotalBill.ClientID%>').html(parseFloat(data.d[0].TotalBill) - parseFloat(data.d[0].Discount));
                CalculateItemTotal();
            }
            else {
                $('#<%= btnSubmit.ClientID%>').attr('disabled', true);
                $('#<%= divPrintCheck.ClientID%>').attr('disabled', true);
                $("#SaleData > tbody").empty();
            }
        }
        function UpdateItem(barcode, index, Discount) {
            var txtSalePrice = $('#txtSalePrice' + index);
            var txtQuantity = $('#txtQuantity' + index);
            var txtSubTotal = $('#txtSubTotal' + index);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "SalesForm.aspx/UpdateItem",
                data: "{'barcode':'" + barcode + "', 'QuantityPosted':'" + txtQuantity.val() + "', 'BillNo':'" + $("#<%= txtBillNo.ClientID%>").val() + "', 'SalePrice':'" + txtSalePrice.val() + "'}",
                dataType: "json",
                success: function (data) {
                    if (data.d == "logout")
                        window.location = "<%= PreShop.Common.StoreBackToLoginUrl %>";
                    else if (data.d == "Qty")
                        alert("Product is out of stock");
                    else {
                        txtSalePrice.val(txtSalePrice.val());
                        txtQuantity.val(txtQuantity.val());
                        txtSubTotal.val(parseInt(txtSalePrice.val()) * parseInt(txtQuantity.val()));
                        var rowCount = $('#SaleData > tbody  > tr').length;
                        if (rowCount > 0) {
                            var TotalBill = 0;
                            for (var i = 0; i < rowCount; i++) {
                                TotalBill += parseFloat($('#txtSubTotal' + i).val());
                            }
                            $('#<%= txtTotalBill.ClientID%>').val(TotalBill);
                            $('#<%= lblInvoiceTotal.ClientID%>').html(TotalBill);
                            $('#<%= lblDiscount.ClientID%>').html(Discount);
                            $('#<%= lblInvoiceTotalBill.ClientID%>').html(parseFloat(TotalBill) - parseFloat(Discount));
                        }
                    }
                }
            });
        }

        function DeleteEntry(SaleID) {
            if (confirm('Are you sure you want to delete this item?')) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "SalesForm.aspx/DeleteSales",
                    data: "{'SaleID':'" + SaleID + "'}",
                    dataType: "json",
                    beforeSend: Loader,
                    success: function (data) {
                        BindSalesItems();
                        $.notify({ title: 'Delete Status: ', message: 'Data has been deleted!', icon: 'fa fa-check' }, { type: 'success' });
                    }
                });
            }
        }
        function CheckDiscount() {
            var TotalBill = parseFloat(document.getElementById("<%=txtTotalBill.ClientID%>").value);
            var Discount = parseFloat(document.getElementById("<%=txtDiscount.ClientID%>").value);
            if (TotalBill < Discount)
                alert("Discount cannot be greater then Subtotal!");
            else {
                $('#<%= lblDiscount.ClientID%>').html(Discount);
                $('#<%= lblInvoiceTotalBill.ClientID%>').html(parseFloat(TotalBill) - parseFloat(Discount));
            }
        }

        function CalculateItemTotal() {
            debugger;
            var TotalBill = parseFloat(document.getElementById("<%=txtTotalBill.ClientID%>").value);
            var Paid = parseFloat(document.getElementById("<%=txtPaidAmount.ClientID%>").value);
            var result = TotalBill - Paid;
            document.getElementById("<%=txtRemainingAmount.ClientID%>").value = result;
        }
    </script>
    <link href="Select2/CustomCss.css" rel="stylesheet" />
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
    </style>
    <asp:HiddenField ID="hfPrice" runat="server" />
    <asp:HiddenField ID="hfSubTotal" runat="server" />
    <asp:HiddenField ID="HfBillNo" runat="server" />
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <center style="font-size: 15px; color: red">
                       <i class="fa fa-info"></i> Scan Product Barcode with your scanner
                    </center>
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
                        <div class="col-sm-4" id="divBillno" runat="server">
                            <div class="form-group">
                                <label>
                                    Invoice no: <span class="required">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ValidationGroup="Validation" ControlToValidate="txtBillNo" Display="Dynamic" ErrorMessage="Required" CssClass="has-error"></asp:RequiredFieldValidator></span>
                                </label>
                                <asp:TextBox ID="txtBillNo" runat="server" onkeypress='return isNumber(event)' autocomplete="off" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-sm-4" id="divCustomer" runat="server">
                            <div class="form-group">
                                <label>
                                    Customer Type: <span class="required">
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Validation" ControlToValidate="ddlCustomerType" InitialValue="-2" Display="Dynamic" ErrorMessage="Required" CssClass="has-error"></asp:RequiredFieldValidator></span>
                                </label>
                                <asp:DropDownList ID="ddlCustomerType" runat="server" CssClass="form-control Searchable" TabIndex="1">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label>
                                    Date:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ValidationGroup="Validation" ControlToValidate="txtDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                </label>

                                <telerik:RadDatePicker RenderMode="Lightweight" ID="txtDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="2">
                                    <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                    </DateInput>
                                </telerik:RadDatePicker>
                            </div>
                        </div>
                    </div>
                    <div class="ln_solid"></div>

                    <div class="clearfix"></div>
                    <div style="height: 200px!important; overflow-y: scroll!important">
                        <table id="SaleData" tabindex="1" class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th style="width: 120px">Date</th>
                                    <th style="width: 250px">Product</th>
                                    <th>Qty</th>
                                    <th style="width: 120px">Price(Per Item)</th>
                                    <th>Sale Price</th>
                                    <th>SubTotal</th>
                                    <th>Action(s)</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                    <div class="row">
                        <div class="col-sm-2">
                            <label>Total Bill:</label>
                            <asp:TextBox ID="txtTotalBill" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>
                        <div id="divTotals" runat="server">
                            <div class="col-sm-2">
                                <label>
                                    Paid: &nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ValidationGroup="Validation" ControlToValidate="txtPaidAmount" Display="Dynamic" ErrorMessage="Required" CssClass="has-error"></asp:RequiredFieldValidator>
                                </label>
                                <asp:TextBox ID="txtPaidAmount" runat="server" autocomplete="off" CssClass="form-control" onkeypress='return isNumber(event)' oninput="CalculateItemTotal();" onchange="CalculateItemTotal();"></asp:TextBox>
                            </div>
                            <div class="col-sm-2">
                                <label>Remaining:</label>
                                <asp:TextBox ID="txtRemainingAmount" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <label>
                                Discount:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ValidationGroup="Validation" ControlToValidate="txtDiscount" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                            </label>
                            <asp:TextBox ID="txtDiscount" autocomplete="off" runat="server" CssClass="form-control" onkeypress='return isNumber(event)' Text="0" oninput="CheckDiscount();"></asp:TextBox>
                        </div>

                        <div class="col-sm-4">
                            <label>&nbsp</label><br />
                            <asp:Button ID="btnSubmit" runat="server" Text="Save" ValidationGroup="Validation" OnClick="btnSubmit_Click" CssClass="btn btn-success" OnClientClick="if (!Page_ClientValidate('Validation')){ return false; } else { this.disabled = true; this.value = 'Saving...';}"
                                UseSubmitBehavior="false" />
                            <button id="divPrintCheck" runat="server" type="button" class="btn btn-info" onclick="printInvoice();"><i class="fa fa-print"></i>Print Invoice</button>
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
                                    <img style="height: 35px; width: 35px;" src="../PreShop.png" />&nbsp Software Developed By the Preshop Technologies</small>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

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

