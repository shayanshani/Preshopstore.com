<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PreShop.AdministrationLogin.Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Master Admin</title>
    <meta name="description" content="" />
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1" />
    <!-- build:css({.tmp,app}) ../styles/app.min.css -->
    <link rel="stylesheet" href="../styles/webfont.css" />
    <link rel="stylesheet" href="../styles/climacons-font.css" />
    <link rel="stylesheet" href="../vendor/bootstrap/dist/css/bootstrap.css" />
    <link rel="stylesheet" href="../styles/font-awesome.css" />
    <link rel="stylesheet" href="../styles/card.css" />
    <link rel="stylesheet" href="../styles/sli.css" />
    <link rel="stylesheet" href="../styles/animate.css" />
    <link rel="stylesheet" href="../styles/app.css" />
    <link rel="stylesheet" href="../styles/app.skins.css" />
    <!-- endbuild -->
</head>
<body>
    <form id="form1" runat="server" class="form-layout">
        <!-- /page loading spinner -->
        <div class="app signin usersession">
            <div class="session-wrapper">
                <div class="page-height-o row-equal align-middle">
                    <div class="column">
                        <div class="card bg-white no-border">
                            <div class="text-center m-b">
                                <%-- <h4 class="text-uppercase">Welcome back</h4>--%>
                                <img src='http://yourpreshop.com/assets/img/logo/logo.png' style="margin-bottom:15px;margin-top:15px" />
                                <p>
                                    <asp:Label ID="lblmsg" runat="server" Text="Please sign in to your account"></asp:Label>
                                </p>
                            </div>
                            <div class="card-block" id="divLogin" runat="server">

                                <div class="form-inputs">
                                    <label class="text-uppercase">username</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtUserName" ErrorMessage="Enter Username" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtUserName" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>

                                    <asp:TextBox ID="txtUserName" runat="server" class="form-control input-lg" placeholder="Email Address"></asp:TextBox>

                                    <label class="text-uppercase">Password</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtPassword" ErrorMessage="Enter Password" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                    <asp:TextBox ID="txtPassword" runat="server" class="form-control input-lg" placeholder="Password" TextMode="Password"></asp:TextBox>

                                </div>
                                <asp:Button ID="btnSignIN" runat="server" class="btn btn-success btn-block btn-lg m-b" OnClick="btnSignIN_Click" Text="Login" ValidationGroup="validation"></asp:Button>
                                <label class="cb-checkbox cb-sm">
                                    <asp:CheckBox ID="chkremember" runat="server" />
                                    Remember me
                               
                                </label>
                                <div class="divider">
                                    <asp:LinkButton ID="btnForGotPass" runat="server" class="bottom-link" OnClick="btnForGotPass_Click">Forgotten password?</asp:LinkButton>
                                </div>

                            </div>


                            <div class="card-block" id="divReset" visible="false" runat="server">

                                <div class="form-inputs">
                                    <label>Enter your Contact</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtContact" ErrorMessage="Enter Contact" ForeColor="Red" ValidationGroup="validation1"></asp:RequiredFieldValidator>

                                    <asp:TextBox ID="txtContact" runat="server" class="form-control input-lg" placeholder="Contact"></asp:TextBox>

                                    <label>Pin Code</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtPinCode" ErrorMessage="Enter Pincode" ForeColor="Red" ValidationGroup="validation1"></asp:RequiredFieldValidator>
                                    <asp:TextBox ID="txtPinCode" runat="server" class="form-control input-lg" placeholder="Pin Code" TextMode="Password"></asp:TextBox>

                                </div>
                                <asp:Button ID="btnSend" runat="server" class="btn btn-success btn-block btn-lg m-b" OnClick="btnSend_Click" Text="Send" ValidationGroup="validation1"></asp:Button>
                            </div>

                            <div class="card-block" id="divPasswordUpdate" visible="false" runat="server">

                                <div class="form-inputs">
                                    <label class="text-uppercase">Enter Code</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtCode" ErrorMessage="Enter Code" ForeColor="Red" ValidationGroup="validation2"></asp:RequiredFieldValidator>

                                    <asp:TextBox ID="txtCode" runat="server" class="form-control input-lg" placeholder="Code"></asp:TextBox>

                                    <label class="text-uppercase">New Password</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtNewPassword" ErrorMessage="New Password" ForeColor="Red" ValidationGroup="validation2"></asp:RequiredFieldValidator>
                                    <asp:TextBox ID="txtNewPassword" runat="server" placeholder="Enter New Password" autocomplete="off" TextMode="Password" class="form-control input-lg"></asp:TextBox>


                                    <label class="text-uppercase">Confirm Paswword</label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtRetypePaswword" ErrorMessage="Confirm Password" ForeColor="Red" ValidationGroup="validation2"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cmpPass" runat="server" ControlToValidate="txtNewPassword" ControlToCompare="txtRetypePaswword" Operator="Equal" ErrorMessage="Passwords mismatched" ValidationGroup="validation2" ForeColor="Red" SetFocusOnError="true"></asp:CompareValidator>

                                    <asp:TextBox ID="txtRetypePaswword" runat="server" placeholder="Confirm Paswword" autocomplete="off" TextMode="Password" class="form-control input-lg"></asp:TextBox>

                                </div>
                                <asp:Button ID="btnChange" runat="server" class="btn btn-success btn-block btn-lg m-b" OnClick="btnChange_Click" Text="Update" ValidationGroup="validation2"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- build:js({.tmp,app}) ../scripts/app.min.js -->
    <script src='<%= ResolveUrl("../scripts/helpers/modernizr.js") %>'></script>
    <script src='<%= ResolveUrl("../vendor/jquery/dist/jquery.js") %>'></script>
    <script src='<%= ResolveUrl("../vendor/bootstrap/dist/js/bootstrap.js") %>'></script>
    <script src='<%= ResolveUrl("../vendor/fastclick/lib/fastclick.js") %>'></script>
    <script src='<%= ResolveUrl("../vendor/perfect-scrollbar/js/perfect-scrollbar.jquery.js") %>'></script>
    <script src='<%= ResolveUrl("../scripts/helpers/smartresize.js") %>'></script>
    <script src='<%= ResolveUrl("../scripts/constants.js") %>'></script>
    <script src='<%= ResolveUrl("../scripts/main.js") %>'></script>
    <!-- endbuild -->
</body>
</html>
