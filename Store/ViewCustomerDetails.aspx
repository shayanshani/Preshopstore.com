<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewCustomerDetails.aspx.cs" Inherits="PreShop.SalesManagement.Store.ViewCustomerDetails" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script>
        $(document).ready(function () {
            var refDataTable = $("#datatable-responsive").dataTable({
                processing: true,
                bserverSide: true,
                "bSort": false,
                "language":
                {
                    "processing": "<div class='overlay custom-loader-background'><i class='fa fa-2x fa-spin fa-spinner'></i></div>"
                },
                ajax: {
                    data: {},
                    type: "POST",
                    url: "ViewCustomerDetails.aspx/GetCustomerDetails",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    dataSrc: function (response) {
                        return response.d;
                    }
                },
                "columns": [
                    { "data": "RNo" },
                    { "data": "Date" },
                    { "data": "BillNo" },
                    { "data": "Description" },
                    { "data": "Discount" },
                    { "data": "TotalBill" },
                    { "data": "Received" },
                    { "data": "Remaining" }
                    //,
                    //{
                    //    "data": 'RNo',
                    //    "render": function (data, type, full, meta) {
                    //        return "<a onclick=\"alert('" + data + "');\" title='View more information'><i class=\"fa fa-info-circle\"></i></a>";
                    //    }
                    //}
                ]
            })
        });
    </script>

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h1>Customers Detail </h1>
                    <br />

                    <div class="row" id="CustomerHeaderInfo" runat="server">
                        <div class="col-lg-2" style="font-size: 20px; color: black;">
                            Name:
                        </div>
                        <div class="col-lg-4" style="font-size: 20px; color: black;">
                            <code>
                                <asp:Label ID="lblCustomerName" runat="server" Style="color: #000!important"></asp:Label>
                            </code>
                        </div>
                        <br />
                        <br />

                        <div class="col-lg-2" style="font-size: 20px; color: black;">
                            Contact:
                        </div>
                        <div class="col-lg-4" style="font-size: 20px; color: black;">
                            <code>
                                <asp:Label ID="lblCustomerContact" runat="server" Style="color: #000!important"></asp:Label>
                            </code>
                        </div>
                    </div>

                    <div class="clearfix"></div>
                </div>

                <asp:HiddenField ID="hfSerialNo" runat="server" />
                <div class="x_content">
                    <div class="row">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>
                        <div class="col-lg-12">
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-lg-12">
                            <!--Bill Items -->
                            <div class="modal fade bs-example-modal-lg" role="dialog" aria-hidden="true" id="BillItems">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls5" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title">
                                                <asp:Label ID="Label3" runat="server">View Bill Items</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">


                                                <div class="row">
                                                    <div style="height: 200px!important; overflow-y: scroll!important">
                                                        <table class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                                                            <thead>
                                                                <tr>
                                                                    <th>Date</th>
                                                                    <th>Item Type</th>
                                                                    <th>Product</th>
                                                                    <th>Qty</th>
                                                                    <th>Price(Per Item)</th>
                                                                    <th>Sale Price</th>
                                                                    <th>Shop</th>

                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <asp:Repeater ID="rptItems" runat="server">
                                                                    <ItemTemplate>
                                                                        <tr>
                                                                            <td><%# Convert.ToDateTime( Eval("Date")).ToString("dd-MM-yyyy") %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("ItemType").ToString()) ? "-" : Eval("ItemType") %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("Product").ToString()) ? "-" : Eval("Product") %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("Qty").ToString()) ? "-" : Eval("Qty") %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("ItemPP").ToString()) ? "-" :String.Format("{0:0}",Eval("ItemPP")) %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("Total").ToString()) ? "-" :String.Format("{0:0}",Eval("Total")) %></td>
                                                                            <td><%# String.IsNullOrEmpty(Eval("ShopName").ToString()) ? "-" :String.Format("{0:0}",Eval("ShopName")) %></td>

                                                                        </tr>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls2">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--Paid Ammount Pop up -->
                            <div class="modal fade bs-example-modal-sm openPaidPopUp" role="dialog" aria-hidden="true" id="PaidformPopUp">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Paid Amount</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">





                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Amount :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ValidationGroup="ValidationPaid" ControlToValidate="txtPaidAmmount" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtPaidAmmount" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                            <span class="fa fa-money form-control-feedback left" aria-hidden="true"></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Date:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ValidationGroup="ValidationPaid" ControlToValidate="txtPaidDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtPaidDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr">
                                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                                </DateInput>
                                                            </telerik:RadDatePicker>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Description:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ValidationGroup="ValidationPaid" ControlToValidate="txtPaidDescription" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtPaidDescription" runat="server" CssClass="form-control" Rows="4" TextMode="MultiLine" Style="resize: none!important"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>

                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                            <asp:Button ID="btnPaidAmmount" runat="server" OnClick="btnPaidAmmount_Click" Text="Save" CssClass="btn btn-primary" ValidationGroup="ValidationPaid" />
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- Recieved Ammount Pop up -->
                            <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="RecivedformPopUp">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls3" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title">
                                                <asp:Label ID="Label1" runat="server">Received Amount</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">



                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Amount :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ValidationGroup="ValidationRecieved" ControlToValidate="txtRecivedAmmount" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtRecivedAmmount" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                            <span class="fa fa-money form-control-feedback left" aria-hidden="true"></span>
                                                        </div>

                                                    </div>


                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Description:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ValidationGroup="ValidationRecieved" ControlToValidate="txtRecivedDescription" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtRecivedDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" Style="resize: none!important"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Date:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ValidationGroup="ValidationRecieved" ControlToValidate="txtRecivedDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtRecivedDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr">
                                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                                </DateInput>
                                                            </telerik:RadDatePicker>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls2">Close</button>
                                            <asp:Button ID="btnRecieveAmmount" runat="server" OnClick="btnRecieveAmmount_Click" Text="Save" CssClass="btn btn-primary" ValidationGroup="ValidationRecieved" />
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- Report PopUp -->
                            <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="GenerateReport">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title">
                                                <asp:Label ID="Label2" runat="server">Customer Detail Report</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <asp:UpdatePanel ID="pnl" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>

                                                                <div class="row">
                                                                    <div class="form-group">
                                                                        <div class="col-md-12">
                                                                            <label>
                                                                                Select Report:<asp:RequiredFieldValidator ValidationGroup="rpt1" runat="server" ID="rqddlReportTpye" ControlToValidate="ddlReportType" ErrorMessage="*" ForeColor="Red" InitialValue="-1"></asp:RequiredFieldValidator>
                                                                            </label>
                                                                        </div>
                                                                        <br />
                                                                        <div class="col-md-12">
                                                                            <asp:DropDownList runat="server" CssClass="form-control" ID="ddlReportType" AutoPostBack="true">
                                                                                <asp:ListItem Value="-1">Select Report Type</asp:ListItem>
                                                                                <asp:ListItem Value="0">Bill Report</asp:ListItem>
                                                                                <asp:ListItem Value="1">Statment Report</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>

                                                                </div>
                                                                <div id="divBillNo" runat="server" visible="false">
                                                                    <div class="row">
                                                                        <div class="form-group">
                                                                            <div class="col-md-12">
                                                                                <label>
                                                                                    Bill No:<%--<asp:RequiredFieldValidator ValidationGroup="rpt1" runat="server" ID="RequiredFieldValidator5" ControlToValidate="txtRVehicleNo" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>--%></label>
                                                                            </div>
                                                                            <br />
                                                                            <div class="col-md-12">
                                                                                <asp:TextBox ID="txtBillNo" runat="server" CssClass="form-control" TabIndex="7"></asp:TextBox>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>

                                                        <div class="row">
                                                            <div class="form-group">
                                                                <div class="col-md-12">
                                                                    <label>
                                                                        Select Report size:<asp:RequiredFieldValidator ValidationGroup="rpt1" runat="server" ID="RequiredFieldValidator18" ControlToValidate="ddlReportType" ErrorMessage="*" ForeColor="Red" InitialValue="-1"></asp:RequiredFieldValidator>
                                                                    </label>
                                                                </div>
                                                                <br />
                                                                <div class="col-md-12">

                                                                    <asp:DropDownList runat="server" CssClass="form-control" ID="ddlReportSize">
                                                                        <asp:ListItem Value="1">Small</asp:ListItem>
                                                                        <asp:ListItem Value="2" Selected="True">Medium</asp:ListItem>
                                                                        <asp:ListItem Value="3">Large</asp:ListItem>
                                                                    </asp:DropDownList>

                                                                </div>
                                                            </div>

                                                        </div>

                                                        <div class="row">
                                                            <div class="form-group">
                                                                <div class="col-md-12">

                                                                    <label>
                                                                        Select Date:
                                                                    </label>
                                                                </div>
                                                                <br />
                                                                <div class="col-md-12">

                                                                    <div class="form-horizontal">
                                                                        <fieldset>
                                                                            <div class="form-group">
                                                                                <div class="controls">
                                                                                    <div class="input-prepend input-group">
                                                                                        <span class="add-on input-group-addon"><i class="glyphicon glyphicon-calendar fa fa-calendar"></i></span>
                                                                                        <input type="text" style="width: 100%" name="txtReportDate" id="reservation" class="form-control" />
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </fieldset>
                                                                    </div>

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>



                                                </div>
                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <asp:Button ID="btnShowReport" runat="server" Text="Show Report" CssClass="btn btn-primary" ValidationGroup="rpt1" />
                                        </div>

                                    </div>
                                </div>
                            </div>
                            &nbsp&nbsp&nbsp&nbsp
                            <button type="button" class="btn btn-round btn-danger pull-right hidden" data-toggle="modal" data-target="#GenerateReport">Generate Report</button>
                            &nbsp
                                 <button type="button" class="btn btn-round btn-success pull-right" data-toggle="modal" data-target="#PaidformPopUp">Paid Cash to Customer</button>
                            &nbsp
                            
                            <button type="button" class="btn btn-round btn-info pull-right" data-toggle="modal" data-target="#RecivedformPopUp">Receive Cash from Customer</button>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>

                <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" style="text-align: center!important" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Date</th>
                            <th>BillNo</th>
                            <th>Description</th>
                            <th>Discount</th>
                            <th>Debit</th>
                            <th>Credit</th>
                            <th>Balance</th>
                            <%-- <th>Action(s)</th>--%>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="6"></td>
                            <td align="right">
                                <b>Remaining:</b>
                            </td>
                            <td>
                                <asp:Label ID="lblRemainingAmount" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <%-- <td>
                                        <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Eval("SerialNo") %>' Style="font-size: 15px!important">
                                                <i class="fa fa-edit"></i>
                                        </asp:LinkButton>
                                        &nbsp; | &nbsp;
                                            <asp:LinkButton ID="lnkDelete" runat="server" Visible='<%# String.IsNullOrEmpty(Eval("BillNo").ToString())%>' CommandArgument='<%# Eval("SerialNo") %>' OnClientClick="return confirm('Are you sure you want to delete this record?')" Style="font-size: 15px!important">
                                                <i class="fa fa-trash"></i>
                                            </asp:LinkButton>
                                        <asp:LinkButton runat="server" ID="btnViewItems" Visible='<%# !String.IsNullOrEmpty(Eval("BillNo").ToString())%>'
                                            CommandArgument='<%# Eval("BillNo") %>'> <i class="fa fa-eye"></i></asp:LinkButton>
                                    </td>--%>

    <script type="text/javascript">
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>
