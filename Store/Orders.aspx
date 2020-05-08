<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="PreShop.StockManagement.Store.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #datatable-responsive tr td {
            vertical-align: middle;
        }
    </style>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Online Orders</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div id="CheckboxesRepeater">
                        <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <td colspan="10">
                                        <a href="#" class="btn btn-success hidden" onclick='validateCheckBoxes();'>
                                            <i class="fa fa-check-circle-o"></i>&nbsp&nbsp Confirm all
                                        </a>
                                        <asp:LinkButton Id="btnConfirmAllOrders" CssClass="btn btn-success" OnClientClick='return validateCheckBoxes();' OnClick="btnConfirmAllOrders_Click" runat="server">
                                            <i class="fa fa-check-circle-o"></i>&nbsp&nbsp Confirm all
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <th>Date</th>
                                    <th>Invoice #</th>
                                    <th>Name</th>
                                    <th>Contact</th>
                                    <th>Address</th>
                                    <th>Email</th>
                                    <th>Total Items
                                    </th>
                                    <th>Order Status</th>
                                    <th>Action(s)
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hfOrderId" runat="server" Value='<%# Eval("OrderUserId") %>' />
                                        <tr class="even gradeX">
                                            <td>
                                                <input type="checkbox" id="chkConfirmOrder" visible='<%# Convert.ToString(Eval("[Status]")).Equals("Pending") %>' runat="server" value='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' />
                                            </td>
                                            <td><%# Convert.ToDateTime(Eval("[OrderDate]")).ToShortDateString() %></td>
                                            <td><%# Eval("InvoiceNo") %></td>
                                            <td><%# Eval("[Name]") %></td>
                                            <td><%# Eval("[Contact]") %></td>
                                            <td style="white-space: pre-wrap; width: 20%;"><%# Eval("[Address]") %></td>
                                            <td><%# Eval("[Email]") %></td>
                                            <td align="center" style="font-size: 15px">
                                                <a href="#" class="list-group-item-danger" data-toggle="modal" data-target="#formPopUp<%# Eval("OrderUserId") %>">
                                                    <i class="fa fa-cart-plus"></i>&nbsp=&nbsp<%# Eval("[TotalOrders]") %>
                                                </a>
                                                <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp<%# Eval("OrderUserId") %>">
                                                    <div class="modal-dialog modal-lg">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close" data-dismiss="modal">
                                                                    <span aria-hidden="true">×</span>
                                                                </button>
                                                                <h4 class="modal-title" id="myModalLabel1">Items</h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <!-- Content  -->
                                                                <div class="x_content" style="float: none!important">
                                                                    <div class="row">
                                                                        <div class="col-sm-12">
                                                                            <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>Product</th>
                                                                                        <th>Qty</th>
                                                                                        <th>Price</th>
                                                                                        <th>Sub Total</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <asp:Repeater ID="rptItems" runat="server">
                                                                                        <ItemTemplate>
                                                                                            <tr>
                                                                                                <td><%# Eval("Product") %></td>
                                                                                                <td><%# Eval("Qty") %></td>
                                                                                                <td><%# FormatCurrencyDisplay(Eval("Price").ToString()) %></td>
                                                                                                <td><%# FormatCurrencyDisplay(Eval("SubTotal").ToString()) %></td>
                                                                                            </tr>
                                                                                        </ItemTemplate>
                                                                                    </asp:Repeater>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                        <div class="clearfix"></div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><%# Eval("[Status]") %></td>
                                            <td align="center">
                                                <ul style="list-style: none">
                                                    <li runat="server" visible='<%# Convert.ToString(Eval("[Status]")).Equals("Pending") %>'>
                                                        <a href="#" class="btn btn-success btn-sm hidden" style="width: 90px;" onclick='FillHiddenFields("<%# Eval("OrderUserId") %>","<%# Eval("Email") %>","<%# Eval("Contact") %>");'>
                                                            <i class="fa fa-check"></i>Confirm
                                                        </a>
                                                        <asp:LinkButton ID="btnConfirmOrder" CssClass="btn btn-success btn-sm" Style="width: 90px" runat="server" CommandArgument='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' OnClientClick="return confirm('Are you sure you want to Confirm this order?');" OnClick="btnConfirmOrder_Click">
                                                            <i class="fa fa-check"></i>Confirm
                                                        </asp:LinkButton>
                                                    </li>
                                                    <li>
                                                        <asp:LinkButton ID="btnDenyOrder" Visible="false" CommandArgument='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' OnClick="btnDenyOrder_Click" OnClientClick="return confirm('Are you sure you want to deny this order?');" CssClass="btn btn-danger btn-sm" Style="width: 90px" runat="server">
                                                <i class="fa fa-ban"></i> Deny
                                                        </asp:LinkButton>
                                                    </li>
                                                    <li>
                                                        <asp:LinkButton ID="btnCancelOrder" Visible='<%# Convert.ToString(Eval("[Status]")).Equals("Pending") %>' CommandArgument='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' OnClick="btnCancelOrder_Click" OnClientClick="return confirm('Are you sure you want to cancel this order?');" CssClass="btn btn-dark btn-sm" Style="width: 90px" runat="server">
                                                <i class="fa fa-close"></i> Cancel
                                                        </asp:LinkButton>
                                                    </li>
                                                    <li>
                                                        <asp:LinkButton ID="btnDeliverd" Visible='<%# Convert.ToString(Eval("[Status]")).Equals("Approved") %>' CommandArgument='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' OnClick="btnDeliverd_Click" OnClientClick="return confirm('Are you sure this order has been delivered propely?');" CssClass="btn btn-success btn-sm" Style="width: 90px" runat="server">
                                                <i class="fa fa-bicycle"></i> Delivered
                                                        </asp:LinkButton>
                                                    </li>
                                                    <li>
                                                        <asp:LinkButton ID="btnReturnOrder" Visible='<%# Convert.ToString(Eval("[Status]")).Equals("Shipped") %>' CommandArgument='<%# Eval("OrderUserId")+","+Eval("Email")+","+Eval("Contact") %>' OnClick="btnReturnOrder_Click" OnClientClick="return confirm('Are you sure this order has been returned?');" CssClass="btn btn-info btn-sm" Style="width: 90px" runat="server">
                                                <i class="fa fa-undo"></i> Retrun
                                                        </asp:LinkButton>
                                                    </li>
                                                </ul>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <asp:HiddenField ID="hfOrderUserId" runat="server" />
                    <asp:HiddenField ID="hfEmail" runat="server" />
                    <asp:HiddenField ID="hfContact" runat="server" />
                    <asp:HiddenField ID="hfConfirmAllStatus" runat="server" />
                    <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true" id="assignEmployees">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span aria-hidden="true">×</span>
                                    </button>
                                    <h4 class="modal-title" id="myModalLabel1">Assign Order</h4>
                                </div>
                                <div class="modal-body">
                                    <!-- Content  -->
                                    <div class="x_content" style="float: none!important">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <label>
                                                        Select:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlDeliveryBoy" ErrorMessage="Required" CssClass="has-error" InitialValue="-1" ValidationGroup="valDeliveryBoy"></asp:RequiredFieldValidator>
                                                    </label>
                                                    <asp:DropDownList ID="ddlDeliveryBoy" runat="server" class="form-control">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:LinkButton ID="btnAssignOrder" OnClick="btnAssignOrder_Click" ValidationGroup="valDeliveryBoy" CssClass="btn btn-success btn-sm" runat="server">
                                                <i class="fa fa-check"></i> Assign
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            $('#datatable-responsive').dataTable({
                "bSort": false
            });
            $('#assignEmployees').on('hide.bs.modal', function (e) {
                ClearHiddenFields();
                ClearCheckBoxes();
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
        function ClearHiddenFields() {
            var hfOrderId = $('#<%= hfOrderUserId.ClientID%>');
            var hfEmail = $('#<%= hfEmail.ClientID%>');
            var hfContact = $('#<%= hfContact.ClientID%>');
            var hfConfirmAllStatus = $('#<%= hfConfirmAllStatus.ClientID%>');
            hfOrderId.val(null);
            hfEmail.val(null);
            hfContact.val(null);
            hfConfirmAllStatus.val(null);
        }
        function FillHiddenFields(OrderId, Email, Contact) {
            if (confirm('Are you sure you want to confirm this order?')) {
                var hfOrderId = $('#<%= hfOrderUserId.ClientID%>');
                var hfEmail = $('#<%= hfEmail.ClientID%>');
                var hfContact = $('#<%= hfContact.ClientID%>');
                ClearHiddenFields();
                hfOrderId.val(OrderId);
                hfEmail.val(Email);
                hfContact.val(Contact);
                return true;//openModal("#assignEmployees");
            }
            else {
                return false;
            }
        }

        function ClearCheckBoxes() {
            $('#CheckboxesRepeater input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    $(this).prop('checked', false);
                }
            });
        }

        function validateCheckBoxes() {
            var isValid = false;
            $('#CheckboxesRepeater input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    isValid = true;
                }
            });
            if (isValid == true) {
                if (confirm('Are you sure you want to confirm selected orders?')) {
                    var hfConfirmAllStatus = $('#<%= hfConfirmAllStatus.ClientID%>');
                    hfConfirmAllStatus.val("1");
                    return true; //openModal("#assignEmployees");
                }
            }
            if (isValid == false) {
                alert("Please select at least one order..");
                return false;
            }
        }
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />

</asp:Content>

