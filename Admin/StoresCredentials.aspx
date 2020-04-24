<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="StoresCredentials.aspx.cs" Inherits="PreShop.AdminPortal.StoresCredentials" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Single Sign In</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Store Name</th>
                                <th>City</th>
                                <th>User Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Action(s)
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptStores" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><b><%# Eval("[StoreName]") %></b>
                                            <%# String.IsNullOrEmpty(Eval("[BranchName]").ToString()) ? "(Main Branch)" : "("+Eval("[BranchName]")+")" %>&nbsp<%# Convert.ToBoolean(string.IsNullOrEmpty(Eval("IsClient").ToString()) ? false :Eval("IsClient")) ? "<small style='color:red'>(Live)</small>" : "<small>(Dev)</small>" %>
                                        </td>
                                        <td>
                                            <%# Eval("[City]") %>
                                        </td>

                                        <td>
                                            <%# Eval("[StoreUserName]") %>
                                        </td>

                                        <td>
                                            <%# Eval("[Email]") %>
                                        </td>

                                        <td>
                                            <%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive" %>
                                        </td>

                                        <td class="center">
                                            <asp:LinkButton ID="btnAssume" runat="server" Style="color: #0094ff" OnClick="btnAssume_Click" CommandArgument='<%# Eval("[UserName]") %>' CommandName='<%# Eval("[Password]") %>'>Assume</asp:LinkButton>
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
    <asp:HiddenField ID="hfHeadingID" runat="server" />
    <script>
        $(document).ready(function () {
            $("#datatable-responsive").dataTable({
                "bSort": false,
            });
        });
    </script>
</asp:Content>
