<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="rptExpense.aspx.cs" Inherits="PreShop.Expenses.Store.Reports.rptExpense" %>

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
                <h3>
                    Expenses
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
                        <th class="desc">Head</th>
                        <th class="desc">Description</th>
                        <th class="desc">Amount</th>
                        <th class="desc">Expense Date</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptExpenses" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="desc">
                                    <%# Eval("RNo") %>
                                </td>
                                <td class="desc">
                                    <%# Eval("Head") %>
                                </td>
                                <td class="desc"><%# Eval("Description") %></td>
                                <td class="desc"><%# FormatCurrencyDisplay(Convert.ToString(Eval("Amount"))) %></td>
                                <td class="desc"><%# Eval("ExpenseDate","{0:dd/MM/yyyy}") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <tr>
                        <td colspan="4" class="grand total">Total :</td>
                        <td class="grand total">
                            <asp:Literal runat="server" ID="ltrTotal"></asp:Literal>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div id="notices">
                <br />
                <div class="notice">Software Developed By the Preshop Technologies</div>
            </div>
        </div>

    </form>
</body>
</html>
