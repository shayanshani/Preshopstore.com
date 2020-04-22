<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" EnableEventValidation="False" CodeBehind="EmployeeHiringWizard.aspx.cs" Inherits="PreShop.CompanySetup.Admin.Employee.EmployeeHiringWizard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        $(function () {
            $('#<%= ddlDesignations.ClientID%>').on('change', function () {
                var storediv = $("#divStores");
                var value = $(this).val();
                if (value == 10)
                    storediv.show();
                else {
                    $("#divBranches").hide();
                    $('#<%= ddlStores.ClientID%>').val(-1);
                    $('#<%= ddlBranches.ClientID%>').val(0);
                    storediv.hide();
                }
            });
            $('#<%= ddlStores.ClientID%>').on('change', function () {
                AjaxCall("EmployeeHiringWizard.aspx/GetBranches", '{StoreId: ' + $(this).val() + '}', GetBranches);
            });
        });

        function GetBranches(data) {
            if (data.d != null) {
                var BranchID, Branch;
                $("#<%= ddlBranches.ClientID %>").empty();
                if (data.d[0].BranchID != null) {
                    BranchID = data.d[0].BranchID.split(',');
                    Branch = data.d[0].Branch.split(',');
                    $("#<%= ddlBranches.ClientID %>").append($("<option selected='selected'></option>").val("0").html("None"));
                    for (var i = 0; i < BranchID.length; i++) {
                        $("#<%= ddlBranches.ClientID %>").append($("<option></option>").val(BranchID[i]).html(Branch[i]));
                    }
                    $("#divBranches").show();
                }
                else {
                    $("#divBranches").hide();
                    alert("No Branches for this Store");
                }
            }
        }
        function ValidateForm() {
            var txtFirstName = $('#<%= txtFirstName.ClientID %>');
            var txtlastName = $('#<%= txtLastName.ClientID %>');
            var Designation = $('#<%= ddlDesignations.ClientID %>');
            var txtCnic = $('#<%= txtCnic.ClientID %>');
            var txtEmail = $('#<%= txtEmail.ClientID %>');
            var txtContact = $('#<%= txtContact.ClientID %>');
            var txtAddress = $('#<%= txtAddress.ClientID %>');
            var Store = $('#<%= ddlStores.ClientID %>');
            
            if (txtFirstName.val() == '') {
                alert("First Name is required");
                txtFirstName.focus();
                return false;
            }
            else if (txtlastName.val() == '') {
                alert("Last Name is required");
                txtlastName.focus();
                return false;
            }
            else if (Designation.val() == '-1') {
                alert("Job Description is required");
                Designation.focus();
                return false;
            }
            else if (txtCnic.val() == '') {
                alert("CNIC is required");
                txtCnic.focus();
                return false;
            }
            else if (txtEmail.val() == '') {
                alert("Email is required");
                txtEmail.focus();
                return false;
            }
            else if (txtContact.val() == '') {
                alert("Contact is required");
                txtContact.focus();
                return false;
            }
            else if (txtAddress.val() == '') {
                alert("Address is required");
                txtAddress.focus();
                return false;
            }
            if ($('#divStores').css('display') != 'none') {
                if (Store.val() == '-1') {
                    alert("Please select any store");
                    Store.focus();
                    return false;
                }
            }
            return true;
        }
    </script>
    <style>
        .form-control {
            width: 100% !important;
        }
    </style>
    <!-- main area -->
    <div class="main-content">
        <div class="page-title">
            <div class="title">Wizard</div>
            <div class="sub-title">Steps wizard</div>
        </div>
        <div id="wizardForm" class="form-horizontal">
            <div class="card">
                <div class="card-block p-a-0">
                    <asp:UpdatePanel ID="pnlMsg" runat="server">
                        <ContentTemplate>
                            <asp:Timer runat="server" ID="timerNews" Interval="10000" OnTick="timerNews_Tick"></asp:Timer>
                            <div id="msgDiv" runat="server" visible="false" style="width: 50%; margin: auto; margin-top: 10px;">

                                <div class="message">
                                    <span id="icon" runat="server"></span>&nbsp&nbsp
                                        <asp:Label ID="lblmsg" runat="server"></asp:Label>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                    <br />
                    <div class="box-tab m-b-0" id="rootwizard">
                        <ul class="wizard-tabs">
                            <li><a href="#tab1" data-toggle="tab">Account details</a>
                            </li>
                            <li><a href="#tab2" data-toggle="tab">Contact details</a>
                            </li>
                            <%-- <li><a href="#tab3" data-toggle="tab">Billing</a>
                            </li>--%>
                            <li><a href="#tab4" data-toggle="tab">Additional information</a>
                            </li>
                        </ul>

                        <div class="tab-content">
                            <div class="tab-pane p-x-lg active" id="tab1">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">First Name:</label>
                                    <div class="col-sm-4">
                                         <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                   </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Last Name:</label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Job description</label>
                                    <div class="col-sm-4">
                                        <asp:DropDownList ID="ddlDesignations" runat="server" class="form-control">
                                            <asp:ListItem Value="-1">Select</asp:ListItem>
                                            <asp:ListItem Value="1">Senior Software Engineer</asp:ListItem>
                                            <asp:ListItem Value="2">Software Engineer</asp:ListItem>
                                            <asp:ListItem Value="3">Desinger</asp:ListItem>
                                            <asp:ListItem Value="4">Android Developer</asp:ListItem>
                                            <asp:ListItem Value="5">Branch Manager</asp:ListItem>
                                            <asp:ListItem Value="6">Team Lead</asp:ListItem>
                                            <asp:ListItem Value="7">Database adminstrator</asp:ListItem>
                                            <asp:ListItem Value="8">Security Analyst</asp:ListItem>
                                            <asp:ListItem Value="9">QA</asp:ListItem>
                                            <asp:ListItem Value="10">Delivery Boy</asp:ListItem>
                                            <asp:ListItem Value="11">Office Boy</asp:ListItem>
                                            <asp:ListItem Value="12">Security Guard</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Short bio <small>(Optional)</small></label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtShortBio" TextMode="MultiLine" Rows="3" Style="resize: none" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane p-x-lg" id="tab2">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">CNIC</label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtCnic" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Email address</label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Contact</label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtContact" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Address</label>
                                    <div class="col-sm-4">
                                        <asp:TextBox ID="txtAddress" TextMode="MultiLine" Rows="4" Style="resize: none" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <%--<div class="tab-pane p-x-lg" id="tab3">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">Card number</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control" name="number">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">Full name</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control" name="name">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">Expiration date</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control" name="expiry">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">CVC number</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control" name="cvc">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="credit-card"></div>
                                    </div>
                                </div>
                            </div>--%>

                            <div class="tab-pane p-x-lg" id="tab4">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Gender</label>
                                    <div class="col-sm-4 pt5 mt2">
                                        <div class="cs-radio m-b">
                                            <asp:RadioButton ID="rdMale" runat="server" GroupName="gender" Checked="true" />
                                            <label for="<%= rdMale.ClientID %>">Male</label>
                                        </div>
                                        <div class="cs-radio m-b">
                                            <asp:RadioButton ID="rdFemale" runat="server" GroupName="gender" />
                                            <label for="<%= rdFemale.ClientID %>">Female</label>
                                        </div>
                                    </div>

                                    <div id="divStores" style="display: none">
                                        <label class="col-sm-2 control-label">Assign To Store</label>
                                        <div class="col-sm-4">
                                            <asp:DropDownList ID="ddlStores" runat="server" class="form-control"></asp:DropDownList>
                                        </div>
                                    </div>

                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Martial Status</label>
                                    <div class="col-sm-4 pt5 mt2">
                                        <div class="cs-radio m-b">
                                            <asp:RadioButton ID="rdSingle" runat="server" GroupName="Martial" Checked="true" />
                                            <label for="<%= rdSingle.ClientID %>">Single</label>
                                        </div>
                                        <div class="cs-radio m-b">
                                            <asp:RadioButton ID="rdMarried" runat="server" GroupName="Martial" />
                                            <label for="<%= rdMarried.ClientID %>">Married</label>
                                        </div>
                                    </div>
                                    <div id="divBranches" style="display: none">
                                        <label class="col-sm-2 control-label">Assign To Branch</label>
                                        <div class="col-sm-4">
                                            <asp:DropDownList ID="ddlBranches" runat="server" class="form-control"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12 pull-right">
                                        <div class="form-group">
                                            <asp:LinkButton ID="btnHire" runat="server" OnClick="btnHire_Click" OnClientClick="return ValidateForm();" class="btn btn-primary button-next pull-right">Hire</asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="wizard-pager">
                                <%-- <div class="pull-right">
                                    <button type="button" class="btn btn-primary button-next">Next</button>
                                </div>
                                <div class="pull-left">
                                    <button type="button" class="btn btn-default button-previous">Previous</button>
                                </div>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /main area -->

</asp:Content>
