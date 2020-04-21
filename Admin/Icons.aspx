<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="Icons.aspx.cs" Inherits="PreShop.Categories.Admin.Icons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="main-content">
        <div class="page-title">
            <div class="title">Choose Icon</div>
            <div class="sub-title">Choose icon for category</div>
        </div>
        <div class="fontawesome-list">
            <section id="web-application">
                <div class="row fontawesome-icon-list">
                    <asp:Repeater ID="rptIcons" runat="server">
                        <ItemTemplate>
                            <div class="fa-hover col-md-3 col-sm-4">
                        <a href="AddCategories.aspx<%# Helper.QueryStringModule.Encrypt("icon="+Eval("Icon")) %>"><i class='<%# Eval("Icon") %>'></i><%# Eval("Icon").ToString().Replace("fa fa-","").ToUpper() %></a>
                         </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </section>
        </div>
    </div>
</asp:Content>