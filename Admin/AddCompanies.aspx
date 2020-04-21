<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddCompanies.aspx.cs" Inherits="PreShop.CompanySetup.Admin.AddCompanies" %>
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
                Add Company Details
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
                                <label class="col-sm-2 control-label">Company:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtCompanyName" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtCompanyName" runat="server" class="form-control"></asp:TextBox>

                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtCompanyName" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>

                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Company Description:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtCompanyDescription" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtCompanyDescription" runat="server" class="form-control" Rows="6" TextMode="MultiLine" Style="resize: none"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtCompanyDescription" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <%-- <div class="form-group">
                                <label class="col-sm-2 control-label">Upload Logo: &nbsp&nbsp<asp:RequiredFieldValidator ID="reqFile" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="flvLogo" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <span class="btn btn-success fileinput-button">
                                        <i class="icon-plus"></i>
                                        <span>Upload Logo...</span>
                                        <asp:FileUpload ID="flvLogo" runat="server" />
                                    </span>
                                    <br />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator21" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.jpeg|.jpg|.png)$"
                                        ControlToValidate="flvLogo" runat="server" ForeColor="Red" ErrorMessage="Select (.jpeg|.jpg|.png|.JPEG|.JPG|.PNG) Image" Display="Dynamic" ValidationGroup="validation" />

                                </div>
                            </div>--%>

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
                        <%--           <asp:Button ID="btnPrint" runat="server" OnClick="btnPrint_Click" Text="Print" />
                        --%>
                    </div>
                </div>
                <asp:HiddenField ID="hfCompanyID" runat="server" />

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
                                        <th>Company</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Last Update</th>
                                        <th>Updated Date</th>
                                        <th>Action(s)
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <asp:Repeater ID="rptCompanies" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("[Company]") %>
                                                </td>
                                                <td>
                                                    <%# Eval("[Description]") %>
                                                </td>
                                                <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive" %>
                                                </td>
                                                <td><%# Eval("[UpdatedBy]") %>
                                                </td>
                                                <td><%# Eval("[PostedDate]","{0:dd MMM yyyy hh:mm tt}") %>
                                                </td>
                                                <td class="center">
                                                    <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[CompanyID]") %>'><span class="fa fa-pencil" style="font-size: 22px!important;"></span></asp:LinkButton>
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

