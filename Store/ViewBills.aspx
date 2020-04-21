<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewBills.aspx.cs" Inherits="PreShop.StockManagement.Store.ViewBills" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function open(url) {
            window.open(url, '_blank');
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
                <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Supplier (Invoice No)</th>
                            <th>Total Bill</th>
                            <th>Paid Amount</th>
                            <th>Remaining</th>
                            <th>Date</th>
                            <th>Print</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptBills" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <a href="StockEntry.aspx<%# Helper.QueryStringModule.Encrypt("BillNo="+Eval("BillNo").ToString()) %>" style="color: #0094ff!important"><%# Eval("SupplierName") %> &nbsp&nbsp-&nbsp&nbsp (# <%# Eval("BillNo") %>)</a>
                                    </td>
                                    <td>
                                        <%# Helper.SpartansHelper.FormatCurrencyDisplay(Eval("Amount").ToString()) %>
                                    </td>
                                    <td>
                                        <%# Helper.SpartansHelper.FormatCurrencyDisplay(Eval("TotalPaid").ToString()) %>
                                    </td>
                                    <td>
                                        <%# Helper.SpartansHelper.FormatCurrencyDisplay(Eval("Remaining").ToString()) %>
                                    </td>

                                    <td>
                                        <%# Eval("Date") %>
                                    </td>
                                    <td>
                                        <a href="#"><i class="fa fa-print"></i> Print</a>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
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
</asp:Content>

