<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="frmEmailLog.aspx.cs" Inherits="PreShop.AdminPortal.Admin.frmEmailLog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Logged Emails</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Mail Send To</th>
                                <%--<th>Message Body</th>--%>
                                <th>Status</th>
                                <th>Machine IP Address</th>
                                <th>Send Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptEmailLog" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("[LogID]") %></td>
                                        <td><b><%# Eval("[SentTo]") %></b></td>
                                        <%--<td><%# Eval("MessageBody") %></td>--%>
                                        <td><%# Convert.ToInt32(Eval("[MailSendingStatus]"))==1 ? "Sent" : Convert.ToInt32(Eval("[Failed]"))==2 ? "Deleted" : "InActive" %>
                                            <td><%# Eval("[MachineIPAddress]") %>
                                            </td>
                                            <td><%# Eval("[SendDate]","{0:dd MMM yyyy hh:mm tt}") %>
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
</asp:Content>
