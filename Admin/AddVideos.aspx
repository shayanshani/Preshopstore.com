<%@ Page Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddVideos.aspx.cs" Inherits="PreShop.CompanySetup.Admin.AddVideos" %>

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
                Submit Video by URL
            </div>
            <div class="card-block">
                <div class="row m-a-0">
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

                        <div class="form-horizontal">

                            <div class="form-group">
                                <label class="col-sm-2 control-label"><i class="icon-social-youtube"></i>&nbsp Video URL:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtUrl" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtUrl" runat="server" class="form-control"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Select Status</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlStatus" runat="server" class="form-control" Style="width: 100%">
                                        <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                        <asp:ListItem Value="2">InActive</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" ValidationGroup="validation" Style="float: right!important" class="btn btn-dark btn-round " />
                    </div>
                </div>
                <asp:HiddenField ID="hfVideoID" runat="server" />

                <div class="row">
                    <div class="col-lg-12">
                        <br />
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">

                        <div class="card-block">
                            <table class="table table-bordered table-striped datatable editable-datatable responsive align-middle bordered">
                                <thead>
                                    <tr>
                                        <th>Heading</th>
                                        <th>Url</th>
                                        <th>Status</th>
                                        <th>Last Update</th>
                                        <th>Updated Date</th>
                                        <th>Action(s)
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <asp:Repeater ID="rptVideos" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><b><%# Eval("[Heading]") %></b>
                                                </td>
                                                <td>
                                                    <%# Eval("[Video]") %>
                                                </td>
                                                <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive" %>
                                                </td>
                                                <td><%# Eval("[UpdatedBy]") %>
                                                </td>
                                                <td><%# Eval("[PostedDate]","{0:dd MMM yyyy hh:mm tt}") %>
                                                </td>
                                                <td class="center">
                                                    <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[VideoID]") %>'><span class="fa fa-pencil" style="font-size: 22px!important;"></span></asp:LinkButton>
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
