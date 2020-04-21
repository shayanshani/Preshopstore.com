<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="AddRetailers.aspx.cs" Inherits="PreShop.StockManagement.Store.AddRetailers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Supplier</h2>
                    <div class="clearfix"></div>
                </div>

                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">

                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Add New Supplier</button>
                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">

                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add Supplier</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Content  -->
                                            <div class="x_content" style="float: none!important">

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Supplier Name :&nbsp;
                                                <asp:RequiredFieldValidator ID="req" runat="server" ValidationGroup="Validation" ControlToValidate="txtRetailerName" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox ID="txtRetailerName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="reg" runat="server" ControlToValidate="txtRetailerName" Display="Dynamic" ErrorMessage="Invaid Input." CssClass="has-error" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Contact # :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="Validation" ControlToValidate="txtContact" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" data-inputmask="'mask': '9999-9999999'"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Address :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="Validation" ControlToValidate="txtAddress" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" Rows="6" TextMode="MultiLine" Style="resize: none!important"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Status :&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" InitialValue="-1" ValidationGroup="Validation" ControlToValidate="ddlStatus" Display="Dynamic" ErrorMessage="*" CssClass="has-error"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList runat="server" ID="ddlStatus" CssClass="form-control">
                                                                <asp:ListItem Value="-1" Text="Select Status"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Active"></asp:ListItem>
                                                                <asp:ListItem Value="0" Text="Inactive"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal" id="cls1">Close</button>
                                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="if (!Page_ClientValidate('Validation')){ return false; } this.disabled = true; this.value = 'Saving...';" UseSubmitBehavior="false" OnClick="btnSave_Click" CssClass="btn btn-primary" ValidationGroup="Validation" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <asp:HiddenField ID="hfRetailerID" runat="server" />
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Supplier</th>
                                <th>Contact</th>
                                <th>Status</th>
                                <th>Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptRetailer" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <a href='ViewRetailerDetails.aspx<%# Helper.QueryStringModule.Encrypt("SupplierId="+Eval("SupplierId").ToString()) %>' style="color: #0094ff!important"><%# Eval("SupplierName") %></a>
                                        </td>
                                        <td><%# Eval("Contact") %></td>
                                        <td><%# Convert.ToBoolean(Eval("Status"))==true?"Active":"InActive" %></td>
                                        <td>
                                            <asp:LinkButton ID="lnkEdit" runat="server" OnClick="lnkEdit_Click" CommandArgument='<%# Eval("SupplierId") %>' Style="font-size: 15px!important">
                                                <i class="fa fa-edit"></i>
                                            </asp:LinkButton>

                                            <asp:LinkButton ID="lnkDelete" runat="server" OnClick="lnkDelete_Click" Visible="false" CommandArgument='<%# Eval("SupplierId") %>' Style="font-size: 15px!important" OnClientClick="return confirm('Are you sure you want to delete this client?')">
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

