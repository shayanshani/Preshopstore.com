<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddColors.aspx.cs" Inherits="PreShop.CompanySetup.Admin.AddColors" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
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
                Add Color
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
                                <label class="col-sm-2 control-label">Select Color:</label>
                                <div class="col-sm-10">
                                    <telerik:RadColorPicker ID="txtColor" runat="server"></telerik:RadColorPicker>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-4">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" ValidationGroup="validation" Style="float: right!important" class="btn btn-dark btn-round " />
                    </div>
                </div>
                <asp:HiddenField ID="hfColorID" runat="server" />

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
                                        <th>Color Name</th>
                                        <th>Color</th>
                                        <th>Action(s)
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <asp:Repeater ID="rptColors" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <%# Eval("[ColorName]") %>
                                                </td>
                                                <td>
                                                    <div style='height: 20px; width: 20px; margin-bottom: 3px; <%# "background:" + Eval("ColorCode") + ";" %>'></div>
                                                </td>
                                                <td class="center">
                                                    <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" OnClientClick="return confirm('Are you sure you want to delete this color?')" CommandArgument='<%# Eval("[ColorID]") %>'><span class="fa fa-trash" style="font-size: 22px!important;"></span></asp:LinkButton>
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
