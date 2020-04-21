<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="StoreList.aspx.cs" Inherits="PreShop.AdminPortal.StoreList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Shops</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Shop Name</th>
                                <th>Address</th>
                                <th>Status</th>
                                <th>Registration Date</th>
                                <th>Logo</th>
                                <th>Action(s)
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptStores" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><b><%# Eval("[StoreName]") %></b>&nbsp<%# Convert.ToBoolean(string.IsNullOrEmpty(Eval("IsClient").ToString()) ? false :Eval("IsClient")) ? "<small style='color:red'>(Live)</small>" : "<small>(Dev)</small>" %>
                                        </td>
                                        <td>
                                            <%# Eval("[StoreAddress]") %><br />
                                            (<%# Eval("City") %>)
                                        </td>
                                        <td>
                                            <a style="color: #0094ff" href="StoreConfiguration.aspx<%# Helper.QueryStringModule.Encrypt("StoreId="+Eval("StoreID")) %>">
                                                <%# Convert.ToInt32(Eval("[isActive]"))==0 ? "Configuration Pending" : "View Configuration"%>
                                            </a>
                                        </td>
                                        <td>
                                            <%# Eval("RegistrationDate","{0:dd MMM yyyy hh:mm tt}") %>
                                        </td>
                                        <td>
                                            <img src='<%# HttpContext.Current.Request.IsSecureConnection ? "https://thepreshop.com" + Eval("Logo") : "http://thepreshop.com" + Eval("Logo") %>' style="height: 80px; width: 80px" />
                                        </td>
                                        <td class="center">
                                            <asp:LinkButton ID="btnBlock" runat="server" OnClick="btnBlock_Click" CommandArgument='<%# Eval("[StoreID]") %>' ToolTip="Block this store"><span class="fa fa-pencil" style="font-size: 22px!important;"></span></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" CommandArgument='<%# Eval("[StoreID]") %>' ToolTip="Delete this store"><span class="fa fa-trash" style="font-size: 22px!important;"></span></asp:LinkButton>
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
    <asp:HiddenField ID="hfStoreID" runat="server" />
    <script>
        $(document).ready(function () {
            $("#datatable-responsive").dataTable({
                "bSort": false,
            });
        });
    </script>
</asp:Content>
