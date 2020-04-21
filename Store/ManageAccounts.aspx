<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ManageAccounts.aspx.cs" Inherits="PreShop.ManageAccounts.Store.ManageAccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        #ContentPlaceHolder1_chkSale {
            display: none !important;
        }
        /*.col-md-12
        {
            float:none!important
        }*/
    </style>

    <script>

        function checkUncheck(divID, oldDiv) {
            $(oldDiv).hide();
            $(divID).show();
        }

    </script>


    <div class="clearfix"></div>

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Manage User Accounts</h2>
                    <div class="clearfix"></div>
                </div>

                <div class="x_content">

                    <div class="row">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>

                        <div class="col-lg-6">

                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:Timer runat="server" ID="timer1" Interval="10000" OnTick="timer1_Tick1"></asp:Timer>
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

                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Add New User</button>

                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add Branch User</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">

                                                <div class="row" id="rowBranch" runat="server" visible="false">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Branch :<%--&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Validation" InitialValue="-1" ControlToValidate="ddlBranches" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>--%>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:DropDownList ID="ddlBranches" runat="server" CssClass="form-control"></asp:DropDownList>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Name :&nbsp;
                                                <asp:RequiredFieldValidator ID="req" runat="server" ValidationGroup="Validation" ControlToValidate="txtName" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                            <span class="fa fa-user form-control-feedback left" aria-hidden="true"></span>
                                                            <asp:RegularExpressionValidator ID="reg" runat="server" ControlToValidate="txtName" Display="Dynamic" ErrorMessage="Invaid Input." CssClass="has-error" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Email  :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ValidationGroup="Validation" ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                            <span class="fa fa-phone form-control-feedback left" aria-hidden="true"></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Contact # :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="Validation" ControlToValidate="txtContact" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control has-feedback-left" data-inputmask="'mask': '9999-9999999'"></asp:TextBox>
                                                            <span class="fa fa-phone form-control-feedback left" aria-hidden="true"></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Address :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="Validation" ControlToValidate="txtAddress" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" Style="resize: none!important"></asp:TextBox>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-12">
                                                            <label>
                                                                Status :
                                                            </label>

                                                        </div>
                                                        <br />
                                                        <div class="col-md-12">
                                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                                                <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                                                                <asp:ListItem Value="0">InActive</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>

                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-primary" ValidationGroup="Validation" />
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-12">
                            <a title="Table View" onclick="checkUncheck('#datatable-responsive_wrapper','#rowTabView');" style="float: right"><i class="fa fa-th-list" style="font-size: 20px; cursor: pointer"></i></a>
                            <a title="Tab View" onclick="checkUncheck('#rowTabView','#datatable-responsive_wrapper');" style="float: right; margin-right: 6px;"><i class="fa fa-th" style="font-size: 20px; cursor: pointer"></i></a>
                        </div>
                    </div>

                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>UserName</th>
                                <th>Branch</th>
                                <th>Cellno</th>
                                <th>Registration Date</th>
                                <th>Address</th>
                                <th>Status</th>
                                <th id="thActions" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAccounts" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <a href="Profile.aspx<%# Helper.QueryStringModule.Encrypt(Eval("UserID").ToString()) %>" style="color: #0094ff!important"><%# Eval("StoreUserName") %></a>
                                        </td>
                                        <td><%# Eval("UserName") %></td>
                                        <td>
                                            <%# String.IsNullOrEmpty(Convert.ToString(Eval("BranchName"))) ? "Main Branch" : Eval("BranchName")  %>
                                        </td>

                                        <td><%# Eval("Cellno") %></td>
                                        <td><%# Eval("RegistrationDate") %></td>
                                        <td>
                                            <%# Eval("Address") %>
                                        </td>

                                        <td>
                                            <%# Convert.ToBoolean(Eval("isActive"))==true & Convert.ToBoolean(Eval("isBlocked"))==false ? "Active" : Convert.ToBoolean(Eval("isActive"))==true & Convert.ToBoolean(Eval("isBlocked"))==true ? "Blocked" : "InActive" %>
                                        </td>


                                        <td id="tdActions" runat="server">
                                            <asp:LinkButton ID="lnkBlock" runat="server" CommandArgument='<%# Eval("UserID") %>' OnClick="lnkBlock_Click" Visible='<%# Convert.ToBoolean(Eval("isBlocked"))==false %>' ToolTip="Block" OnClientClick="return confirm('Are you sure you want to block this account?')" Style="font-size: 15px!important">
                                                <i class="fa fa-ban"></i>
                                            </asp:LinkButton>

                                            <asp:LinkButton ID="btnUnblock" runat="server" CommandArgument='<%# Eval("UserID") %>' OnClick="btnUnblock_Click" Visible='<%# Convert.ToBoolean(Eval("isBlocked"))==true %>' ToolTip="UnBlock" OnClientClick="return confirm('Are you sure you want to unblock this account?')" Style="font-size: 15px!important">
                                                <i class="fa fa-undo"></i>
                                            </asp:LinkButton>

                                            &nbsp; | &nbsp;
                                            <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# Eval("UserID") %>' OnClick="lnkDelete_Click" Style="font-size: 15px!important" ToolTip="Edit">
                                                <i class="fa fa-pencil"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>



                    <div class="row" id="rowTabView" style="display: none!important">
                        <div class="col-lg-12">

                            <div class="row">
                                <%--   <div class="col-md-12 col-sm-12 col-xs-12 text-center">
                                    <ul class="pagination pagination-split">
                                        <li><a href="#">A</a></li>
                                        <li><a href="#">B</a></li>
                                        <li><a href="#">C</a></li>
                                        <li><a href="#">D</a></li>
                                        <li><a href="#">E</a></li>
                                        <li>...</li>
                                        <li><a href="#">W</a></li>
                                        <li><a href="#">X</a></li>
                                        <li><a href="#">Y</a></li>
                                        <li><a href="#">Z</a></li>
                                    </ul>
                                </div>--%>

                                <div class="clearfix"></div>

                                <asp:Repeater ID="rptTabView" runat="server">
                                    <ItemTemplate>

                                        <div class="col-md-4 col-sm-4 col-xs-12 profile_details">
                                            <div class="well profile_view">
                                                <div class="col-sm-12">
                                                    <%--<h4 class="brief"><i>Digital Strategist</i></h4>--%>
                                                    <div class="left col-xs-7">
                                                        <h2><%# Eval("StoreUserName") %></h2>
                                                        <p><strong>About: </strong>&nbsp <%# Convert.ToBoolean(Eval("[isAdmin]")) ? "Administration" : "Worker" %></p>
                                                        <ul class="list-unstyled">
                                                            <li><i class="fa fa-building"></i>Address:  <%# Eval("Address") %></li>
                                                            <li><i class="fa fa-phone"></i>Phone #: <%# Eval("Cellno") %> </li>
                                                            <li><i class="fa fa-building user-profile-icon"></i>&nbsp<%# Eval("StoreName") %> (<small><%# String.IsNullOrEmpty(Eval("[BranchName]").ToString()) ? "Main Branch" : Eval("[BranchName]") %></small>)</li>
                                                        </ul>
                                                    </div>
                                                    <div class="right col-xs-5 text-center">
                                                        <img src='<%# ResolveUrl(!String.IsNullOrEmpty(Eval("image").ToString()) ? "images/"+Eval("image") : "images/user.png") %>' alt="" class="img-circle img-responsive" style="height: 111px!important; width: 105px!important;" />
                                                    </div>
                                                </div>
                                                <div class="col-xs-12 bottom text-center">
                                                    <%-- <div class="col-xs-12 col-sm-6 emphasis">
                                                        <p class="ratings">
                                                            <a>4.0</a>
                                                            <a href="#"><span class="fa fa-star"></span></a>
                                                            <a href="#"><span class="fa fa-star"></span></a>
                                                            <a href="#"><span class="fa fa-star"></span></a>
                                                            <a href="#"><span class="fa fa-star"></span></a>
                                                            <a href="#"><span class="fa fa-star-o"></span></a>
                                                        </p>
                                                    </div>--%>
                                                    <div class="col-xs-12 col-sm-12 emphasis">
                                                        <%--<button type="button" class="btn btn-success btn-xs">
                                                            <i class="fa fa-user"></i><i class="fa fa-comments-o"></i>
                                                        </button>--%>
                                                        <a href="Profile.aspx<%# Helper.QueryStringModule.Encrypt(Eval("UserID").ToString()) %>" class="btn btn-primary btn-xs" style="float: right!important">
                                                            <i class="fa fa-user"></i>View Profile
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <center>
                                            <asp:Label ID="lbl" runat="server" Text="No Record found!" Visible="<%# rptTabView.Items.Count==0 %>"></asp:Label>
                                        </center>
                                    </FooterTemplate>
                                </asp:Repeater>

                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>


    <asp:HiddenField ID="hfUserID" runat="server" />


    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />

    <script type="text/javascript">
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
</asp:Content>

