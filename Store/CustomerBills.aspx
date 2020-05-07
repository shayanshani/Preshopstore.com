<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="CustomerBills.aspx.cs" Inherits="PreShop.StockManagement.Store.CustomerBills" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function open(url) {
            window.open(url, '_blank');
        }
        function openModal(id) {
            $(id).modal('show');
        }
        $(document).ready(function () {
            var refDataTable = $("#dtBills").dataTable({
                processing: true,
                "bSort": false,
                ajax: {
                    data: {},
                    type: "POST",
                    url: "CustomerBills.aspx/GetCustomerBills",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    dataSrc: function (response) {
                        return response.d;
                    }
                },
                "columns": [
                    {
                        "data": 'BillNo',
                        "render": function (data, type, full, meta) {
                            return "<a href='" + full.Url + "' style='color: #0094ff!important'>" + full.Customer + " &nbsp&nbsp-&nbsp&nbsp (# " + full.BillnoToShow + ")</a>";
                        }
                    },
                    { "data": "TotalBill" },
                    { "data": "PaidAmount" },
                    { "data": "Remaining" },
                    { "data": "Date" },
                    {
                        "data": 'BillNo',
                        "render": function (data, type, full, meta) {
                            return "<a href='#' onclick='PrintBill(" + data + ");'><i class='fa fa-print'></i>Print</a>";
                        }
                    }
                ]
            })
        });

        function PrintBill(Billno) {
            var lblBillNo = $('#<%= lblBillNo.ClientID%>'), InvoiceHtml = '';
            lblBillNo.html(Billno);
            $("#tblInvoice > tbody").empty();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "CustomerBills.aspx/GetBillItems",
                data: "{'BillNo':'" + Billno + "'}",
                dataType: "json",
               // beforeSend: Loader,
                success: function (data) {
                    if (data.d != null) {
                        for (var i = 0; i < data.d.length; i++) {
                            InvoiceHtml += "<tr>" +
                                "<td>" + data.d[i].Product + "</td>" +
                                "<td>" + data.d[i].Quantity + "</td>" +
                                "<td>" + data.d[i].SalePrice + "</td>" +
                                "<td>" + data.d[i].SubTotal + "</td>" +
                                "</tr>";
                        }
                        $("#tblInvoice > tbody").append(InvoiceHtml);
                        $('#<%= lblInvoiceTotal.ClientID%>').html(data.d[0].TotalBill);
                        $('#<%= lblDiscount.ClientID%>').html(data.d[0].BillDiscount);
                        $('#<%= lblInvoiceTotalBill.ClientID%>').html(parseFloat(data.d[0].TotalBill) - parseFloat(data.d[0].BillDiscount));

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
                }
            });
        }
    </script>
    <asp:HiddenField runat="server" ID="hfProductID" />
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Billing Detail</h2>
                    <div class="clearfix"></div>
                </div>
                <table id="dtBills" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Customer (Invoice No)</th>
                            <th>Total Bill</th>
                            <th>Paid Amount - Discount</th>
                            <th>Remaining</th>
                            <th>Date</th>
                            <th>Print</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
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

</asp:Content>

