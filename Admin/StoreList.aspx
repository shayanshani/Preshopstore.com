<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="StoreList.aspx.cs" Inherits="PreShop.ManageStores.Admin.StoreList" %>

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
                Store Registrations
            </div>
            <div class="card-block">

                <div class="row">
                    <div class="col-lg-12">
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

                        <div class="card-block">
                            <table class="table table-bordered table-striped datatable editable-datatable responsive align-middle bordered">
                                <thead>
                                    <tr>
                                        <th>Store Name</th>
                                        <th>Address</th>
                                        <th>Status</th>
                                        <th>Land line</th>
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

                                                <td><%# Eval("[LandLine]") %>
                                                </td>
                                                <td>
                                                    <%# Eval("RegistrationDate","{0:dd MMM yyyy hh:mm tt}") %>
                                                </td>
                                                <td>
                                                    <img src='http://yourpreshop.com/<%# Eval("Logo").ToString().Replace("~","..") %>' style="height: 80px; width: 80px" />
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
        </div>
    </div>
</asp:Content>

