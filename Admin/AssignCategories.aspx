<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AssignCategories.aspx.cs" Inherits="PreShop.AdminPortal.Admin.AssignCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Assign Categories</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#AddEditClientCategories">Assign New Category</button>
                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditClientCategories">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpClientCategories" runat="server">Assign New Category</asp:Label>
                                            </h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Select Category:&nbsp;
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlCategories" ErrorMessage="Select category" InitialValue="-1" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlCategories" runat="server" class="form-control Searchable">
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Select Store:&nbsp;
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlStores" ErrorMessage="Select store" InitialValue="-1" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlStores" runat="server" class="form-control Searchable">
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
                                <th>Store</th>
                                <th>Category</th>
                                <th>Action(s)
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptClientCategoriess" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><b><%# Eval("[StoreName]") %></b>
                                        </td>
                                        <td><%# Eval("[MainCategory]") %>
                                        </td>
                                        <td class="center">
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this record?');" CommandArgument='<%# Eval("[Id]") %>'><span class="fa fa-trash" style="font-size: 16px!important;"></span></asp:LinkButton>
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
    <asp:HiddenField ID="hfClientCategoriesID" runat="server" />
    <script>
        $(document).ready(function () {
            $('#AddEditClientCategories').on('hide.bs.modal', function (e) {
                var hfClientCategoriesID = $('#<%= hfClientCategoriesID.ClientID%>');
                $('#<%= ddlCategories.ClientID%>').val("-1").trigger('change');
                $('#<%= ddlStores.ClientID%>').val("-1").trigger('change');
                hfClientCategoriesID.val(null);
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
</asp:Content>
