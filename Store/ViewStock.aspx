<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewStock.aspx.cs" Inherits="PreShop.StockManagement.Store.ViewStock" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function Filter(value) {
            if (parseInt(value) == 1) {
                //Excel
                //$('#excelSheet').show();
                $('#ExcelReportFooter').show();
                $('#FileName').show();
                $('#ReportFooter').hide();
            }
            else {
                $('#excelSheet').hide();
                $('#ExcelReportFooter').hide();
                $('#FileName').hide();
                $('#ReportFooter').show();
            }
        }
        $('document').ready(function () {
            $('#chkDateRange').on('change', function () {
                if ($(this).is(':checked')) {
                    $("#fromdate").show();
                    $("#Todate").show();
                }
                else {
                    $("#fromdate").hide();
                    $("#Todate").hide();
                }
            });
        });
    </script>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Stock Details</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">

                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <td colspan="9">
                                    <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Export/Generate Report</button>
                                </td>
                            </tr>
                            <tr>
                                <th>Purchase Date</th>
                                <th>Product</th>
                                <th>Company</th>
                                <th>Quantity</th>
                                <th>Price(Per item)</th>
                              <%--  <th>Expense</th>--%>
                                <th>Total Price</th>
                                <th id="ThActions" runat="server" visible="false">Action(s)</th>

                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptStock" runat="server">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hfStockID" runat="server" Value='<%# Eval("StockID") %>' />
                                    <tr class="even gradeX">
                                        <td><%# Convert.ToDateTime(Eval("[Purchase_Date]")).ToShortDateString() %></td>
                                        <td><%# Eval("[Product]") %>  <%# Eval("[Size]") %></td>
                                        <td><%# Eval("[Company]") %></td>
                                        <td><%# Eval("[Quantity]") %></td>
                                        <td><%# FormatCurrencyDisplay(Eval("[ItemPP]").ToString()) %></td>
                                        <%--<td><%# FormatCurrencyDisplay(Eval("[Expense]").ToString()) %></td>--%>
                                        <td><%# FormatCurrencyDisplay(Eval("[Amount]").ToString()) %></td>
                                        <td id="tdActions" runat="server" class="center" visible="false">
                                            <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("StockID") %>'><span class="fa fa-edit" style="font-size: 22px!important;"></span></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>


    <!-- Pop up -->
    <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" id="cls" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        <asp:Label ID="lblPopUpHeading" runat="server">Export/Generate Report</asp:Label></h4>
                </div>
                <div class="modal-body">
                    <!-- Content  -->
                    <div class="x_content" style="float: none!important">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>
                                        Type:
                                    </label>
                                    <asp:DropDownList ID="ddlExportType" runat="server" CssClass="form-control" onchange="Filter(this.value)">
                                        <asp:ListItem Value="-1">Select report type</asp:ListItem>
                                        <asp:ListItem Value="1">Export to excel</asp:ListItem>
                                        <asp:ListItem Value="2">Generate Report</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>
                                        &nbsp
                                    </label>
                                    <input type="checkbox" id="chkDateRange" />
                                    Date Range
                                </div>
                            </div>
                        </div>
                        <div class="row" id="excelSheet" style="display: none">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>
                                            Format:
                                        </label>
                                        <asp:DropDownList ID="ddlFormat" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="0">Excel Spread Sheet(XLS)</asp:ListItem>
                                            <asp:ListItem Value="1">CSV</asp:ListItem>
                                            <asp:ListItem Value="3">XML</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="row" id="fromdate" style="display: none">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <label>
                                            From Date:
                                        </label>
                                    </div>
                                    <br />
                                    <div class="col-md-12">
                                        <telerik:RadDatePicker RenderMode="Lightweight" ID="txtFromDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                            <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                            </DateInput>
                                        </telerik:RadDatePicker>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Todate" style="display: none">
                            <div class="col-md-12">
                                <div class="form-group">

                                    <div class="col-md-12">
                                        <label>
                                            To Date:
                                        </label>
                                    </div>
                                    <div class="col-md-12">
                                        <telerik:RadDatePicker RenderMode="Lightweight" ID="txtToDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                            <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                            </DateInput>
                                        </telerik:RadDatePicker>
                                    </div>

                                </div>
                            </div>

                        </div>
                        <div class="row" id="emptyDataRow" style="display: none!important">
                            <div class="form-group">
                                <div class="col-md-12" style="width: 100%!important;">
                                    <center>
                                         <p style="color:#ff0000;font-size:14px!important">
                                             No data available!
                                         </p>
                                    </center>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="FileName" style="display: none">
                            <div class="form-group">
                                <div class="col-md-12">
                                    <label>
                                        File Name:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="ValidationPop" ControlToValidate="txtFileName" Display="Dynamic" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </label>
                                </div>
                                <br />
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtFileName" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                    <span class="fa fa-file form-control-feedback left" aria-hidden="true"></span>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>
                <div class="modal-footer" id="ExcelReportFooter" style="display: none">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <asp:Button ID="btnExport" runat="server" Text="Export" OnClick="btnExport_Click" CssClass="btn btn-primary" ValidationGroup="ValidationPop" />

                </div>

                <div class="modal-footer" id="ReportFooter" style="display: none!important">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" OnClick="btnGenerateReport_Click" CssClass="btn btn-primary" ValidationGroup="ValidationPop123456" />
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

