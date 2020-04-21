<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewAllExpenses.aspx.cs" Inherits="PreShop.Expenses.Store.ViewAllExpenses" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>View All Expenses</h2>
                    <div class="clearfix"></div>
                </div>

                <div class="x_content">

                    <div class="row">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>

                        <div class="col-lg-6">

                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:Timer runat="server" ID="timer1" Interval="10000" OnTick="timer1_Tick"></asp:Timer>
                                    <div aria-live="assertive" id="msgDiv" runat="server" visible="false" style="width: 300px; right: 36px; top: 36px; cursor: auto; text-align: left">
                                        <div class="ui-pnotify-icon"><span id="icon" runat="server"></span></div>
                                        <div class="ui-pnotify-text">
                                            <asp:Label ID="lblmsg" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-12">

                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Add New Expense</button>
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp1">Add Expense Head</button>
                              <a href="ViewExpenses.aspx" class="btn btn-success">View Daily Expense</a>
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#formPopUp2">Expense Report</button>


                            <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp2">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="Label2" runat="server">Expense Report</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Select Head :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ValidationGroup="Validation" ControlToValidate="ddlHead" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:DropDownList runat="server" ID="ddlReportHead" CssClass="form-control">
                                                            </asp:DropDownList>
                                                        </div>

                                                    </div>
                                                </div>



                                                <div class="clearfix"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                From Date :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ValidationGroup="Val1" ControlToValidate="frmDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="frmDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr">
                                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                                </DateInput>
                                                            </telerik:RadDatePicker>
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                To Date :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ValidationGroup="Val1" ControlToValidate="toDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="toDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr">
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
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                            <asp:Button ID="btnShowReport" runat="server" Text="Show" OnClick="btnShowReport_Click" CssClass="btn btn-primary" ValidationGroup="Val1" />
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
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add Expense</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Select Head :&nbsp;
                                                <asp:RequiredFieldValidator ID="req" runat="server" ValidationGroup="Validation" ControlToValidate="ddlHead" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:DropDownList runat="server" ID="ddlHead" CssClass="form-control">
                                                            </asp:DropDownList>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Description :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="Validation" ControlToValidate="txtDescription" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" Style="resize: none!important"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Date :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="Validation" ControlToValidate="txtDate" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr">
                                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                                </DateInput>
                                                            </telerik:RadDatePicker>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Amount :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Validation" ControlToValidate="txtAmount" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                            <span class="fa fa-sort-amount-asc form-control-feedback left" aria-hidden="true"></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                            <asp:Button ID="btnSave" runat="server" OnClientClick="if (!Page_ClientValidate('Validation')){ return false; } this.disabled = true; this.value = 'Please wait...';" UseSubmitBehavior="false" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-primary" ValidationGroup="Validation" />
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel1">
                                                <asp:Label ID="Label1" runat="server">Add Expense Head</asp:Label></h4>
                                        </div>
                                        <asp:UpdatePanel ID="pnlHeads" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>

                                                <div class="modal-body">
                                                    <!-- Content  -->
                                                    <div class="x_content" style="float: none!important">


                                                        <div class="row">
                                                            <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>
                                                            <div class="col-lg-6">
                                                                <asp:Timer runat="server" ID="timer2" Interval="10000" OnTick="timer2_Tick"></asp:Timer>
                                                                <div aria-live="assertive" id="msgDiv2" runat="server" visible="false" style="width: 300px; right: 36px; top: 36px; cursor: auto; text-align: left">
                                                                    <div class="ui-pnotify-icon"><span id="iconid" runat="server"></span></div>
                                                                    <div class="ui-pnotify-text">
                                                                        <asp:Label ID="lblPopUpMsg" runat="server"></asp:Label>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <div class="row">
                                                            <div class="form-group">
                                                                <div class="col-md-12">
                                                                    <label>
                                                                        Head Name :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ValidationGroup="head" ControlToValidate="txtHeadName" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                    </label>
                                                                </div>
                                                                <br />
                                                                <div class="col-md-12">
                                                                    <asp:TextBox ID="txtHeadName" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                                    <span class="fa fa-sort-amount-asc form-control-feedback left" aria-hidden="true"></span>
                                                                </div>
                                                            </div>
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <table id="datatable-responsive1" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                                                                <thead>
                                                                    <tr>
                                                                        <th>#</th>
                                                                        <th>Head</th>
                                                                        <th id="Thactions" runat="server" >Action(s)</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <asp:Repeater ID="rptExpenseHeads" runat="server" OnItemDataBound="rptExpenseHeads_ItemDataBound">
                                                                        <ItemTemplate>
                                                                            <tr>
                                                                                <td><%# Eval("HeadID") %></td>
                                                                                <td><%# Eval("Head") %></td>
                                                                                <td id="tdActions" runat="server" >
                                                                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Eval("HeadID") %>' OnClick="lnkEdit_Click" Style="font-size: 15px!important">
                                                <i class="fa fa-edit"></i>
                                                                                    </asp:LinkButton>
                                                                                    &nbsp; | &nbsp;
                                            <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# Eval("HeadID") %>' OnClick="lnkDelete_Click" Style="font-size: 15px!important" OnClientClick="return confirm('Are you sure you want to delete this head?')">
                                                <i class="fa fa-trash"></i>
                                            </asp:LinkButton>
                                                                                </td>
                                                                            </tr>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </tbody>
                                                            </table>

                                                        </div>

                                                        <asp:HiddenField ID="hfExpenseHeadID" runat="server" />

                                                        <div class="clearfix"></div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                    <asp:Button ID="Button1" runat="server" Text="Save" OnClientClick="if (!Page_ClientValidate('head')){ return false; } this.disabled = true; this.value = 'Please wait...';" UseSubmitBehavior="false" OnClick="btnAddHead_Click" CssClass="btn btn-primary" ValidationGroup="head" />
                                                </div>

                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <asp:HiddenField ID="hdnExpenseID" runat="server" />
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Head</th>
                                <th>Amount</th>
                                <th>Description</th>
                                <th>Expense Date</th>
                              
                                <th id="ThactionsEx" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptExpenses" runat="server" OnItemDataBound="rptExpenses_ItemDataBound">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%# Eval("ExpenseID") %>
                                        </td>

                                        <td>
                                            <%# Eval("Head") %>
                                        </td>
                                        <td><%# Eval("Amount") %></td>
                                        <td><%# Eval("Description") %></td>
                                        <td><%# Eval("ExpenseDate","{0:dd/MM/yyyy}") %></td>
                                        
                                        <td id="tdActionEx" runat="server">
                                            <asp:LinkButton ID="btnEditEnpense" runat="server" CommandArgument='<%# Eval("ExpenseID") %>' OnClick="btnEditEnpense_Click" Style="font-size: 15px!important">
                                                <i class="fa fa-edit"></i>
                                            </asp:LinkButton>
                                            &nbsp; | &nbsp;
                                            <asp:LinkButton ID="btnDeleteExpense" runat="server" CommandArgument='<%# Eval("ExpenseID") %>' OnClick="btnDeleteExpense_Click" Style="font-size: 15px!important" OnClientClick="return confirm('Are you sure you want to delete this client?')">
                                                <i class="fa fa-trash"></i>
                                            </asp:LinkButton>
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


    <script type="text/javascript">
        function openModal(id) {
            $(id).modal('show');
        }
    </script>


</asp:Content>
