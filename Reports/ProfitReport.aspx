<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProfitReport.aspx.cs" Inherits="PreShop.StoreDashBaord.Store.Reports.ProfitReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="style.css" media="all" />
    <link href="../vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <style>
        .TextBox {
            display: block;
            width: 96%;
            height: 22px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }

        .Disabled {
            background: rgba(0,0,0,.075);
            cursor: not-allowed;
        }

        #Totals td {
            text-align: center !important;
        }

        #PMGHSD td {
            text-align: center !important;
        }

        @media print {
            .noPrint {
                display: none;
            }

            @page {
                size: A5;
                max-height: 100%;
                max-width: 100%;
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
                        <span class="noPrint" style="float: right; margin-right: 20px">
                            <a href="#" onclick="printDiv();" title="Print this report">
                                <i class="fa fa-print fa-2x"></i>
                            </a>
                        </span>
                    </h3>
                    <h3>
                        <asp:Label runat="server" ID="lblContact"></asp:Label></h3>
                    <h3>Profit Report
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
                <table style="font-size: 16px!important">
                    <tbody>
                        <tr>
                            <th colspan="12" class="grand total" style="text-align: center!important">
                                <h1 style="background: none; font-size: 2em">Expenses</h1>
                            </th>
                        </tr>

                        <asp:Repeater runat="server" ID="rptExpense">
                            <HeaderTemplate>
                                <tr>
                                    <th colspan="6" style="text-align: left!important">Expense Head</th>
                                    <th colspan="6" style="text-align: right!important">Amount</th>
                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td colspan="6" style="text-align: left!important">
                                        <%# Eval("Head") %> 
                                    </td>
                                    <td colspan="6" style="text-align: right!important">
                                        <%# Eval("Amount") %>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        <tr>
                            <td colspan="10" class="grand total">Total Expense:</td>
                            <td colspan="2" class="grand total" style="text-align: right !important">
                                <asp:Literal runat="server" ID="ltrTotalExpense"></asp:Literal>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <table id="Totals" style="text-align: center!important">
                    <tr>
                        <th>Total Sales
                        </th>
                        <th>Total Purchases
                        </th>

                        <th>Total Expense
                        </th>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblTotalSales" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblTotalPurchases" runat="server"></asp:Label>
                        </td>

                        <td>
                            <asp:Label ID="lblTotalExpense" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Gross Profit :</b> &nbsp;&nbsp;&nbsp;
                    <asp:Label ID="lblGrossProfit" runat="server"></asp:Label>
                            &nbsp<i id="GrossProfitIcon" runat="server"></i></td>
                        <td colspan="2"><b>Net Profit :</b> &nbsp;&nbsp;&nbsp;
                    <asp:Label ID="lblNetProfit" runat="server"></asp:Label>
                            &nbsp<i id="NetProfitIcon" runat="server" style="font-size: 14px;"></i>
                        </td>
                    </tr>
                </table>

                <div id="notices">
                    <div class="notice">Software Developed By the Preshop Technologies</div>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
