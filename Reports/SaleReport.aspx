<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleReport.aspx.cs" Inherits="PreShop.SalesManagement.Store.Reports.SaleReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="style.css" media="all" />
    <link href="../vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <style>
        @media print {
            #PrintArea {
                display: none;
            }
        }
    </style>
    <script>
        function printDiv() {
            var printContents = document.getElementById("DivToPrint").innerHTML;
            var originalContents = document.body.innerHTML;
            document.body.innerHTML = printContents;
            window.print();
            document.body.innerHTML = originalContents;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="DivToPrint">
            <header class="clearfix">
                <div id="logo">
                    <h1>
                        <asp:Label runat="server" ID="lblStoreName"></asp:Label></h1>
                    <h3>
                        <asp:Label runat="server" ID="lblAddress"></asp:Label>
                        <span id="PrintArea" style="float: right; margin-right: 20px">
                            <a href="#" onclick="printDiv();" title="Print this report">
                                <i class="fa fa-print fa-2x"></i>
                            </a>
                        </span>
                    </h3>
                    <h3>
                        <asp:Label runat="server" ID="lblContact"></asp:Label></h3>
                    <h3>Sales Details
                    </h3>
                </div>

                <div id="company" class="clearfix">
                    <b>Date:</b>
                    <asp:Label runat="server" ID="lblDate"></asp:Label>
                </div>
                <div id="project">
                </div>
            </header>
            <div>
                <table>
                    <thead>
                        <tr>
                            <th class="service">#</th>
                            <th class="service">Date</th>
                            <th class="service">Product</th>
                            <th class="service">Company</th>
                            <th class="service">Quantity</th>
                            <th class="service">Item Price x Qty</th>
                            <th class="service">Sub Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptSaleReport" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="desc">
                                        <%# Eval("RNo") %>
                                    </td>
                                    <td class="desc"><%# Convert.ToDateTime(Eval("[Date]")).ToShortDateString() %></td>
                                    <td class="desc"><%# Eval("[Product]") %></td>
                                    <td class="desc"><%# Eval("[Company]") %></td>
                                    <td class="desc"><%# Eval("[Quantity]") %></td>
                                    <td class="desc"><%# FormatCurrencyDisplay(Eval("[Price]").ToString()) + " x " + Eval("[Quantity]") %></td>
                                    <td class="desc"><%# FormatCurrencyDisplay(Eval("[SubTotal]").ToString()) %></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                <tr runat="server" visible='<%# rptSaleReport.Items.Count == 0 %>'>
                                    <td colspan="7">No date found
                                    </td>
                                </tr>
                            </FooterTemplate>
                        </asp:Repeater>
                        <tr>
                            <%--<td  class="grand total"></td>--%>
                            <td colspan="8" class="grand total">Total :
                            <asp:Literal runat="server" ID="ltrTotal"></asp:Literal>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div id="notices">
                    <div class="notice">Software Developed By the Preshop Technologies</div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
