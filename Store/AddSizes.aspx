<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="AddSizes.aspx.cs" Inherits="PreShop.ManageStoreAttributes.Store.AddSizes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function HideLabel() {
            var seconds = 10;
            setTimeout(function () {
                document.getElementById("<%=msgDiv.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };

        function checkUncheck(checked, divID, oldDiv) {
            if (checked == true) {
                $(oldDiv).hide();
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }

        function displayHide(checked, divID) {
            if (checked == true) {
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }
    </script>
    <div class="clearfix"></div>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Add Size for product</h2>

                    <div class="clearfix"></div>
                </div>

                <div class="x_content">
                    <br>
                    <div class="row">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>

                        <div class="col-lg-6">

                            <div aria-live="assertive" id="msgDiv" runat="server" visible="false" style="width: 300px; right: 36px; top: 36px; cursor: auto; text-align: left">
                                <div class="ui-pnotify-icon"><span id="icon" runat="server"></span></div>
                                <div class="ui-pnotify-text">
                                    <asp:Label ID="lblmsg" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <div id="demo-form2" class="form-horizontal form-label-left">

                   <%-- <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Select Company:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <asp:DropDownList ID="ddlCompany" runat="server" class="select2_single form-control" TabIndex="2">
                            </asp:DropDownList>

                            <ul class="parsley-errors-list filled">
                                <li class="parsley-required">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlCompany" ErrorMessage="Select Company" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                </li>
                            </ul>
                        </div>
                    </div>--%>

                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Select Product:</label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <asp:DropDownList ID="ddlProduct" runat="server" class="select2_single form-control" TabIndex="1">
                            </asp:DropDownList>
                            <ul class="parsley-errors-list filled">
                                <li class="parsley-required">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlProduct" ErrorMessage="Select Product" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Size:<span class="required">*</span></label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <asp:TextBox runat="server" ID="txtSizeName" class="form-control col-md-7 col-xs-12" TabIndex="2"></asp:TextBox>

                            <ul class="parsley-errors-list filled">
                                <li class="parsley-required">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtSizeName" ErrorMessage="Enter Size" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                            Select Status:
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">

                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" TabIndex="3">
                                <asp:ListItem Selected="True" Value="-1">Select</asp:ListItem>
                                <asp:ListItem Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Inactive</asp:ListItem>
                            </asp:DropDownList>

                            <ul class="parsley-errors-list filled">
                                <li class="parsley-required">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlStatus" ErrorMessage="Select status" InitialValue="-1" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="ln_solid"></div>
                    <div class="form-group">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                            <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" OnClick="btnSubmit_Click" ValidationGroup="validation" Text="Submit" OnClientClick="if (!Page_ClientValidate()){ return false; } this.disabled = true; this.value = 'Saving...';"
                                UseSubmitBehavior="false" />
                        </div>
                    </div>

                </div>
            </div>
            <asp:HiddenField ID="hfSizeID" runat="server" />
        </div>
    </div>

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Size</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">

                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Size</th>
                                <th>Status</th>
                                <th id="trActions" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptSize" runat="server">
                                <ItemTemplate>
                                    <tr class="even gradeX">
                                        <td><%# Eval("[Product]") %></td>
                                        <td><%# Eval("[Size]") %></td>
                                        <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive"  %></td>

                                        <td class="center" id="thActions" runat="server">
                                            <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("SizeID") %>'><span class="fa fa-edit" style="font-size: 22px!important;"></span></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" CommandArgument='<%# Eval("SizeID") %>'><span class="fa fa-trash" style="font-size: 22px!important;"></span></asp:LinkButton>
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


    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />

</asp:Content>

