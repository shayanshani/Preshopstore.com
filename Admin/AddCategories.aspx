<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Master.Master" CodeBehind="AddCategories.aspx.cs" Inherits="PreShop.AdminPortal.AddCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Add?Edit Main category </h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#AddEditCategory">Add New Category</button>
                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditCategory">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add New Category</asp:Label>
                                            </h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Category Name:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtCategoryName" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox ID="txtCategoryName" runat="server" class="form-control"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtCategoryName" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <asp:FileUpload ID="flvCategoryImage" runat="server" />
                                                            <asp:RequiredFieldValidator ID="reqfile" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="flvCategoryImage" ErrorMessage="Choose any image" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Store Type:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator5" SetFocusOnError="true" runat="server" ControlToValidate="ddlStoreType" InitialValue="-1" ForeColor="Red" ErrorMessage="*" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlStoreType" runat="server" class="form-control Searchable"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" id="divStatus" runat="server" visible="false">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Select Status:&nbsp;
                                                 <asp:RequiredFieldValidator ID="reqStatus" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlStatus" ErrorMessage="Select status" InitialValue="-1" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlStatus" runat="server" class="form-control">
                                                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                                                <asp:ListItem Value="0">InActive</asp:ListItem>
                                                                <asp:ListItem disabled="disabled" Value="2">Deleted</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" OnClick="btnSubmit_Click" ValidationGroup="validation" Text="Submit" OnClientClick="if (!Page_ClientValidate()){ return false; } this.disabled = true; this.value = 'Saving...';" UseSubmitBehavior="false" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Last Update</th>
                                <th>Updated Date</th>
                                <th>Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptCategories" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <img src='<%# Eval("Image") %>' width="75" height="75" alt="" />
                                            <%# Eval("[Category]") %>
                                        </td>
                                        <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : Convert.ToInt32(Eval("[isActive]"))==2 ? "Deleted" : "InActive" %>
                                        </td>
                                        <td><%# Eval("[PostedBy]") %>
                                        </td>
                                        <td><%# Eval("[PostedDate]","{0:dd MMM yyyy hh:mm tt}") %>
                                        </td>
                                        <td class="center">
                                            <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[CategoryID]") %>'><span class="fa fa-pencil" style="font-size: 16px!important;"></span></asp:LinkButton>&nbsp;|
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this record?');" CommandArgument='<%# Eval("[CategoryID]") %>'><span class="fa fa-trash" style="font-size: 16px!important;"></span></asp:LinkButton>
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
    <asp:HiddenField ID="hfCategoryID" runat="server" />
    <asp:HiddenField ID="hfImagePath" runat="server" />
    <script>
        $(document).ready(function () {
            $('#AddEditCategory').on('hide.bs.modal', function (e) {
                var hfCategoryID = $('#<%= hfCategoryID.ClientID%>');
                var hfImagePath = $('#<%= hfImagePath.ClientID%>');
                $('#<%= ddlStatus.ClientID%>').val("-1").trigger('change');
                $('#<%= ddlStoreType.ClientID%>').val("-1").trigger('change');
                $('#<%= txtCategoryName.ClientID%>').val(null);
                hfCategoryID.val(null);
                hfImagePath.val(null);
                document.getElementById("<%=reqfile.ClientID%>").enabled = true;
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
        $('#<%= flvCategoryImage.ClientID %>').filestyle({
            input: false,
            buttonName: 'btn btn-success btn-sm',
            iconName: 'fa fa-upload',
            buttonText: 'Upload Image'
        });
    </script>
</asp:Content>
