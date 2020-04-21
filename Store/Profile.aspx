<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="PreShop.ManageStockAttributes.Store.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .bootstrap-filestyle.input-group {
            margin-left: 12px !important;
            margin-bottom: -40px;
            z-index: 1 !important;
        }

        .buttonText {
            color: transparent !important;
        }

        label.btn.btn.btn-success.btn-sm {
            width: 33px !important;
            background: transparent !important;
            color: #26B99A !important;
        }
    </style>

    <div class="">
        <div class="page-title">
            <div class="title_left">
                <h3>User Profile</h3>
            </div>
        </div>

        <div class="clearfix"></div>

        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <%-- <div class="x_title">
                        <h2>User Report <small>Activity report</small></h2>
                        <ul class="nav navbar-right panel_toolbox">
                            <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                            </li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                            </li>
                            <li><a class="close-link"><i class="fa fa-close"></i></a>
                            </li>
                        </ul>
                        <div class="clearfix"></div>
                    </div>--%>
                    <div class="x_content">
                        &nbsp&nbsp&nbsp<asp:FileUpload ID="flvUpload" runat="server" Style="margin-top: 3px!important" ClientIDMode="Static" onchange="if (confirm('Are you sure you want to change profile image?')) this.form.submit()" />
                        <div class="col-md-3 col-sm-3 col-xs-12 profile_left">
                            <asp:Repeater ID="rptProfile" runat="server">
                                <ItemTemplate>


                                    <div class="profile_img">
                                        <div id="crop-avatar">
                                            <!-- Current avatar -->
                                            <img id="imgProfile" style="height: 300px!important" class="img-responsive avatar-view" src='<%# ResolveUrl(!String.IsNullOrEmpty(Eval("image").ToString()) ? Convert.ToString(Eval("image")) : "images/user.png") %>' alt="No Image Loaded" title='<%# Eval("[StoreUserName]") %>'>
                                        </div>
                                    </div>
                                    <br />

                                    <h3><%# Eval("[StoreUserName]") %></h3>

                                    <ul class="list-unstyled user_data">
                                        <li>
                                            <i class="fa fa-building user-profile-icon"></i>&nbsp<%# Eval("StoreName") %> (<small><%# String.IsNullOrEmpty(Eval("[BranchName]").ToString()) ? "Main Branch" : Eval("[BranchName]") %></small>)
                                        </li>
                                        <li><i class="fa fa-key user-profile-icon"></i>&nbsp<%# Eval("[UserName]") %>
                                        </li>

                                        <li><i class="fa fa-map-marker user-profile-icon"></i>&nbsp<%# Eval("[Address]") %>
                                        </li>

                                        <li>
                                            <i class="fa fa-briefcase user-profile-icon"></i>&nbsp<%# Convert.ToBoolean(Eval("[isAdmin]")) ? "Administration" : "Worker" %>
                                        </li>

                                        <li>
                                            <i class="fa fa-envelope user-profile-icon"></i>&nbsp<%# Eval("[Email]") %>
                                        </li>

                                        <li>
                                            <i class="fa fa-phone user-profile-icon"></i>&nbsp<%# Eval("[Cellno]") %>
                                        </li>

                                        <li>
                                            <i class="fa fa-adn user-profile-icon"></i>&nbsp<%# Convert.ToBoolean(Eval("[UserStatus]")) ? "Active" : "InActive" %>
                                        </li>

                                    </ul>

                                </ItemTemplate>
                            </asp:Repeater>

                        </div>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                            <div class="" role="tabpanel" data-example-id="togglable-tabs">
                                <ul id="myTab" class="nav nav-tabs bar_tabs" role="tablist">
                                    <li role="presentation" class="active"><a href="#tab_content1" id="home-tab" role="tab" data-toggle="tab" aria-expanded="true"><i class="fa fa-sort-amount-desc"></i>Recent Activity</a>
                                    </li>

                                    <li role="presentation" id="liEditProfile" runat="server" class=""><a href="#tab_content3" role="tab" id="profile-tab2" data-toggle="tab" aria-expanded="false"><i class="fa fa-edit m-right-xs"></i>Edit Profile</a>
                                    </li>
                                </ul>
                                <div id="myTabContent" class="tab-content">

                                    <div role="tabpanel" class="tab-pane fade active in" id="tab_content1" aria-labelledby="home-tab">

                                        <!-- start recent activity -->
                                        <ul class="messages">
                                            <asp:Repeater ID="rptActivity" runat="server">
                                                <ItemTemplate>

                                                    <li>
                                                        <img src='<%# ResolveUrl(!String.IsNullOrEmpty(Eval("image").ToString()) ? "images/"+Eval("image") : "images/user.png") %>' class="avatar" alt="Avatar">
                                                        <div class="message_date">
                                                            <p class="month"><i class="fa fa-clock-o"></i>&nbsp<%# Helper.SpartansHelper.XTimeAgo(Convert.ToDateTime(Eval("Date"))) %></p>
                                                        </div>
                                                        <div class="message_wrapper">
                                                            <h4 class="heading"><%# Eval("Heading") %></h4>
                                                            <blockquote class="message">
                                                                <%# Eval("Description") %>
                                                            </blockquote>
                                                            <br>
                                                            <p class="url">
                                                            </p>
                                                        </div>
                                                    </li>

                                                </ItemTemplate>
                                            </asp:Repeater>


                                        </ul>
                                        <!-- end recent activity -->

                                    </div>

                                    <div role="tabpanel" class="tab-pane fade" id="tab_content3" aria-labelledby="profile-tab">

                                        <p>

                                            <div id="demo-form2" class="form-horizontal form-label-left">

                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">First Name:</label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control col-md-7 col-xs-12"></asp:TextBox>

                                                        <ul class="parsley-errors-list filled">
                                                            <li class="parsley-required">
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtName" ErrorMessage="Enter First Name" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Last Name:</label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>

                                                        <ul class="parsley-errors-list filled">
                                                            <li class="parsley-required">
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtLastName" ErrorMessage="Enter Last Name" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                                                        Email: <span class="required">*</span>
                                                    </label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                                        <asp:TextBox runat="server" ID="txtEamil" class="form-control col-md-7 col-xs-12" TabIndex="4"></asp:TextBox>
                                                        <ul class="parsley-errors-list filled">
                                                            <li class="parsley-required">
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtEamil" ErrorMessage="Enter Email" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="revEmail" ControlToValidate="txtEamil" runat="server" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" ValidationGroup="validation" ForeColor="Red" ErrorMessage="Invalid Email" SetFocusOnError="true"></asp:RegularExpressionValidator>

                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                                                    </label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">


                                                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#ChangePassword">Update Password</button>

                                                        <!-- Pop up -->
                                                        <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="ChangePassword">
                                                            <div class="modal-dialog modal-sm">
                                                                <div class="modal-content">

                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" id="cls" data-dismiss="modal">
                                                                            <span aria-hidden="true">×</span>
                                                                        </button>
                                                                        <h4 class="modal-title" id="myModalLabel">
                                                                            <asp:Label ID="lblPopUpHeading" runat="server">Update Your Password</asp:Label></h4>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <!-- Content  -->
                                                                        <div class="x_content" style="float: none!important">

                                                                            <div class="row">
                                                                                <div class="form-group">
                                                                                    <div class="col-md-12">
                                                                                        <label>
                                                                                            Current Password :&nbsp;
                                                <asp:RequiredFieldValidator ID="req" runat="server" ValidationGroup="ValidationPass" ForeColor="Red" ControlToValidate="txtCurrentPassword" Display="Dynamic"  ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                                        </label>

                                                                                    </div>
                                                                                    <br />
                                                                                    <div class="col-md-12">
                                                                                        <asp:TextBox ID="txtCurrentPassword" TextMode="Password" runat="server" CssClass="form-control has-feedback-left"></asp:TextBox>
                                                                                        <span class="fa fa-key form-control-feedback left" aria-hidden="true"></span>
                                                                                        <ul class="parsley-errors-list filled">
                                                                                            <li class="parsley-required">
                                                                                                <asp:CompareValidator ID="cmpCurrentPass" Display="Dynamic" runat="server" Operator="Equal" ControlToValidate="txtCurrentPassword" ErrorMessage="Invalid Current Password" ForeColor="Red" ValidationGroup="ValidationPass"></asp:CompareValidator>
                                                                                            </li>
                                                                                        </ul>
                                                                                    </div>

                                                                                </div>
                                                                            </div>

                                                                            <div class="row">
                                                                                <div class="form-group">
                                                                                    <div class="col-md-12">
                                                                                        <label>
                                                                                            New Password  :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ValidationGroup="ValidationPass" ForeColor="Red" ControlToValidate="txtNewPassword" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                                        </label>
                                                                                    </div>
                                                                                    <br />
                                                                                    <div class="col-md-12">
                                                                                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control has-feedback-left" TextMode="Password"></asp:TextBox>
                                                                                        <span class="fa fa-key form-control-feedback left" aria-hidden="true"></span>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="row">
                                                                                <div class="form-group">
                                                                                    <div class="col-md-12">
                                                                                        <label>
                                                                                            Re-enter Password:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ValidationGroup="ValidationPass" ForeColor="Red" ControlToValidate="txtReNewPassword" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                                                        </label>
                                                                                    </div>
                                                                                    <br />
                                                                                    <div class="col-md-12">
                                                                                        <asp:TextBox ID="txtReNewPassword" runat="server" CssClass="form-control has-feedback-left" TextMode="Password"></asp:TextBox>
                                                                                        <span class="fa fa-key form-control-feedback left" aria-hidden="true"></span>
                                                                                        <ul class="parsley-errors-list filled">
                                                                                            <li class="parsley-required">
                                                                                                <asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic" Operator="Equal" ControlToValidate="txtNewPassword" ControlToCompare="txtReNewPassword" ErrorMessage="Password mis matched" ForeColor="Red" ValidationGroup="ValidationPass"></asp:CompareValidator>
                                                                                            </li>
                                                                                        </ul>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-default" data-dismiss="modal" style="vertical-align: initial!important">Close</button>
                                                                        <asp:Button ID="btnUpdatePass" runat="server" Text="Update" OnClick="btnUpdatePass_Click" CssClass="btn btn-primary" Style="vertical-align: initial!important" ValidationGroup="ValidationPass" OnClientClick="if (!Page_ClientValidate('ValidationPass')){ return false; } this.disabled = true; this.value = 'updating...';"
                                                                            UseSubmitBehavior="false" />
                                                                    </div>

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                                                        Cellno: <span class="required">*</span>
                                                    </label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                                        <asp:TextBox runat="server" ID="txtContact" class="form-control col-md-7 col-xs-12" TabIndex="4" data-inputmask="'mask': '9999-9999999'"></asp:TextBox>
                                                        <ul class="parsley-errors-list filled">
                                                            <li class="parsley-required">
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtContact" ErrorMessage="Enter Cellno" ValidationGroup="validation"></asp:RequiredFieldValidator>


                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                                                        Address: <span class="required">*</span>
                                                    </label>
                                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                                        <asp:TextBox runat="server" ID="txtAddress" class="form-control col-md-7 col-xs-12" Style="resize: none!important" TabIndex="4" TextMode="MultiLine" Rows="6"></asp:TextBox>
                                                        <ul class="parsley-errors-list filled">
                                                            <li class="parsley-required">
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtAddress" ErrorMessage="Enter Address" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <div class="ln_solid"></div>
                                                <div class="form-group">
                                                    <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">

                                                        <asp:Button ID="btnUpdateProfile" runat="server" class="btn btn-success" OnClick="btnUpdateProfile_Click" ValidationGroup="validation" Text="Save" OnClientClick="if (!Page_ClientValidate('validation')){ return false; } this.disabled = true; this.value = 'Saving...';"
                                                            UseSubmitBehavior="false" />

                                                    </div>
                                                </div>

                                            </div>

                                        </p>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#flvUpload').filestyle({
            input: false,
            buttonName: 'btn btn-success btn-sm',
            iconName: 'fa fa-upload',
            //buttonText: 'Change Image'
        });

    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>

