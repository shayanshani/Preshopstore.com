<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="StoresCredentials.aspx.cs" Inherits="PreShop.ManageStores.Admin.StoresCredentials" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        #DataTables_Table_0_filter {
            text-align: right !important;
        }
    </style>
    <div class="main-content">

        <div class="card bg-white">
            <div class="card-header">
                Add City
            </div>
            <div class="card-block">
                 <div class="row m-a-0">
                    <div class="col-lg-12">
                              <asp:Label ID="lblmsg" runat="server"></asp:Label>
                        </div>
                     </div>
                <div class="row">
                    <div class="col-lg-12">

                        <div class="card-block">
                            <table class="table table-bordered table-striped datatable editable-datatable responsive align-middle bordered">
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
                                                    <asp:LinkButton ID="btnAssume" runat="server" style="color: #0094ff" OnClick="btnAssume_Click" CommandArgument='<%# Eval("[UserName]") %>' CommandName='<%# Eval("[Password]") %>'>Assume</asp:LinkButton>
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
        </div>

    </div>

</asp:Content>

