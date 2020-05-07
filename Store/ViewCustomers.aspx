<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewCustomers.aspx.cs" Inherits="PreShop.StockManagement.Store.ViewCustomers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function open(url) {
            window.open(url, '_blank');
        }
    </script>

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>View Customers</h2>
                    <div class="clearfix"></div>
                </div>
                
                <div class="x_content">

                    <div class="row">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>

                        <div class="col-lg-6">
                            <asp:updatepanel id="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:Timer runat="server" ID="timer1" Interval="10000" OnTick="timer1_Tick"></asp:Timer>
                                    <div aria-live="assertive" id="msgDiv" runat="server" visible="false" style="width: 300px; right: 36px; top: 36px; cursor: auto; text-align: left">
                                        <div class="ui-pnotify-icon"><span id="icon" runat="server"></span></div>
                                        <div class="ui-pnotify-text">
                                            <asp:Label ID="lblmsg" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                     </ContentTemplate>
                            </asp:updatepanel>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">

                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Add New Customer</button>

                        <button type="button" class="btn btn-primary hidden" data-toggle="modal" data-target="#formPopUpReport">View Report</button>

                        <!-- Pop up -->
                        <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp">
                            <div class="modal-dialog modal-sm">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <button type="button" class="close" id="cls" data-dismiss="modal">
                                            <span aria-hidden="true">×</span>
                                        </button>
                                        <h4 class="modal-title" id="myModalLabel">
                                            <asp:label id="lblPopUpHeading" runat="server">Add Customer</asp:label>
                                        </h4>
                                    </div>
                                    <div class="modal-body">
                                        <!-- Content  -->
                                        <div class="x_content" style="float: none!important">
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-12">
                                                        <label>
                                                            Name :&nbsp;
                                                <asp:requiredfieldvalidator id="req" runat="server" validationgroup="Validation" controltovalidate="txtName" display="Dynamic" errormessage="*" cssclass="has-error"></asp:requiredfieldvalidator>
                                                        </label>

                                                    </div>
                                                    <br />
                                                    <div class="col-md-12">
                                                        <asp:textbox id="txtName" runat="server" cssclass="form-control has-feedback-left"></asp:textbox>
                                                        <span class="fa fa-user form-control-feedback left" aria-hidden="true"></span>
                                                        <%--<asp:RegularExpressionValidator ID="reg" runat="server" ControlToValidate="txtName" Display="Dynamic" ErrorMessage="Invaid Input." CssClass="has-error" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>--%>
                                                    </div>

                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-12">
                                                        <label>
                                                            Contact # :&nbsp;
                                                <asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" validationgroup="Validation" controltovalidate="txtContact" display="Dynamic" errormessage="*" cssclass="has-error"></asp:requiredfieldvalidator>
                                                        </label>
                                                    </div>
                                                    <br />
                                                    <div class="col-md-12">
                                                        <asp:textbox id="txtContact" runat="server" cssclass="form-control has-feedback-left" data-inputmask="'mask': '9999-9999999'"></asp:textbox>
                                                        <span class="fa fa-phone form-control-feedback left" aria-hidden="true"></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="clearfix"></div>
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-12">
                                                        <label>
                                                            CNIC :&nbsp;
                                              <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="Validation" ControlToValidate="txtCNIC" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>--%>
                                                        </label>
                                                    </div>
                                                    <br />
                                                    <div class="col-md-12">
                                                        <asp:textbox id="txtCNIC" runat="server" cssclass="form-control has-feedback-left" data-inputmask="'mask': '99999-9999999-9'"></asp:textbox>
                                                        <span class="fa fa-user form-control-feedback left" aria-hidden="true"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="clearfix"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                        <asp:button id="btnSubmit" runat="server" onclick="btnSave_Click" text="Save" validationgroup="Validation" cssclass="btn btn-primary" onclientclick="if (!Page_ClientValidate('Validation2')){ return false; } this.disabled = true; this.value = 'Saving...';"
                                            usesubmitbehavior="false" />
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <asp:hiddenfield id="hfCustomerID" runat="server" />
                <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Customer Name</th>
                            <th>Contact</th>
                            <th>CNIC</th>
                            <%-- <th>Amount</th>--%>
                            <th>Posted Date</th>
                            <th>Action(s)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:repeater id="rptCustomers" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <a href='ViewCustomerDetails.aspx<%# Helper.QueryStringModule.Encrypt("CustomerID="+Eval("CustomerID").ToString()) %>' style="color: #0094ff!important"><%# Eval("CustomerName") %></a>
                                        </td>
                                        <td><%# Eval("Contact") %></td>
                                        <td><%# Eval("CNIC") %></td>
                                        <%--<td><%#String.Format("{0:0}",Eval("Remaining"))   %></td>--%>
                                        <td><%# Eval("Date") %></td>
                                        <td>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Eval("Customerid") %>' OnClick="lnkEdit_Click" Style="font-size: 15px!important">
                                                <i class="fa fa-edit"></i>
                                            </asp:LinkButton>
                                            &nbsp; | &nbsp;
                                            <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# Eval("Customerid") %>' OnClick="lnkDelete_Click" Style="font-size: 15px!important" OnCustomerClick="return confirm('Are you sure you want to delete this Customer?')">
                                                <i class="fa fa-trash"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function openModal(id) {
            $(id).modal('show');
        }
    </script>

    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>


