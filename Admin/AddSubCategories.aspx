<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddSubCategories.aspx.cs" Inherits="PreShop.Categories.Admin.AddSubCategories" %>
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
                Add Sub Categories
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
                                <div class="col-sm-2 control-label">
                                    Select Category:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlCategories" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation" InitialValue="-1"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-10">

                                    <asp:DropDownList ID="ddlCategories" runat="server" class="chosen"  Style="width: 100%;">
                                    </asp:DropDownList>

                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Sub Category:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtSubCategory" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtSubCategory" runat="server" class="form-control"></asp:TextBox>

                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtSubCategory" ValidationExpression="[^$]+" Display="Dynamic" BorderColor="#FF66FF" ForeColor="Red" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>

                                </div>
                            </div>

                            <%--<div class="form-group">

                                <label class="col-sm-2 control-label"></label>

                                <div class="col-sm-8">

                                    <div class="row">
                                        <div class="col-sm-2">
                                            <label class="switch m-b">
                                                For:
                                        <asp:CheckBox ID="ChkFor" runat="server" />
                                                <span>
                                                    <i class="handle"></i>
                                                </span>
                                            </label>
                                        </div>
                                    
                                    </div>

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
                    </div>
                </div>
                <asp:HiddenField ID="hfSubCategoryID" runat="server" />

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
                                                <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive" %>
                                                </td>
                                                <td><%# Eval("[UpdateBy]") %>
                                                </td>
                                                <td><%# Eval("[UpdatedDate]","{0:dd MMM yyyy hh:mm tt}") %>
                                                </td>
                                                <td class="center">
                                                    <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[SubCategoryID]") %>'><span class="fa fa-pencil" style="font-size: 22px!important;"></span></asp:LinkButton>
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

