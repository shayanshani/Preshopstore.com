<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddSubCategories.aspx.cs" Inherits="PreShop.AdminPortal.AddSubCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Add/Edit SubCategories</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#AddEditSubCategory">Add New SubCategory</button>
                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditSubCategory">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add New SubCategory</asp:Label>
                                            </h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Category:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator5" SetFocusOnError="true" runat="server" ControlToValidate="ddlCategories" InitialValue="-1" ForeColor="Red" ErrorMessage="*" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlCategories" runat="server" class="form-control Searchable"></asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Sub Category:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtSubCategory" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox ID="txtSubCategory" runat="server" class="form-control"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtSubCategory" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>
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
                                <th>Main Category</th>
                                <th>Sub Category</th>
                                <th>Status</th>
                                <th>Last Update</th>
                                <th>Updated Date</th>
                                <th>Action(s)
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptSubCategory" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%# Eval("Category") %>
                                        </td>
                                        <td><b><%# Eval("[SubCategory]") %></b>

                                        </td>
                                        <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : Convert.ToInt32(Eval("[isActive]"))==2 ? "Deleted" : "InActive" %>
                                            <td><%# Eval("[UpdateBy]") %>
                                            </td>
                                            <td><%# Eval("[UpdatedDate]","{0:dd MMM yyyy hh:mm tt}") %>
                                            </td>
                                            <td class="center">
                                                <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[SubCategoryID]") %>'><span class="fa fa-pencil" style="font-size: 16px!important;"></span></asp:LinkButton>&nbsp;|
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this record?');" CommandArgument='<%# Eval("[SubCategoryID]") %>'><span class="fa fa-trash" style="font-size: 16px!important;"></span></asp:LinkButton>
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
    <asp:HiddenField ID="hfSubCategoryID" runat="server" />
    <script>
        $(document).ready(function () {
            $('#AddEditSubCategory').on('hide.bs.modal', function (e) {
                var hfSubCategoryID = $('#<%= hfSubCategoryID.ClientID%>');
                $('#<%= ddlStatus.ClientID%>').val("-1").trigger('change');
                $('#<%= ddlCategories.ClientID%>').val("-1").trigger('change');
                $('#<%= txtSubCategory.ClientID%>').val(null);
                hfSubCategoryID.val(null);
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
</asp:Content>
