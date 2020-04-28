<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ProductImages.aspx.cs" Inherits="PreShop.ManageProducts.Store.ProductImages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function HideLabel() {
            var seconds = 10;
            setTimeout(function () {
                document.getElementById("<%=msgDiv.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };

        function checkUncheck(checked, divID, oldDiv) {
            if (checked == true) {
                $(oldDiv).hide();
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }

        function displayHide(checked, divID) {
            if (checked == true) {
                $(divID).show();
            }
            else {
                $(divID).hide();
            }
        }
    </script>
    <style>
        td {
            vertical-align: middle !important
        }
    </style>
    <div class="clearfix"></div>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="row">
                <label class="control-label col-md-3 col-sm-3 col-xs-12"></label>
                <div class="col-lg-6">
                    <div aria-live="assertive" id="msgDiv" runat="server" visible="false" style="width: 300px; right: 36px; top: 36px; cursor: auto; text-align: left">
                        <div class="ui-pnotify-icon"><span id="icon" runat="server"></span></div>
                        <div class="ui-pnotify-text">
                            <asp:Label ID="lblmsg" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="x_panel">
                <div class="x_title">
                    <h2>Product Images</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Default</th>
                                <th id="trActions" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptImages" runat="server">
                                <ItemTemplate>
                                    <tr class="even gradeX">
                                        <td align="center">
                                            <img src='<%# PreShop.Common.StoreHostName+Eval("ImageUrl") %>' style="height: 115px; width: 100px;" />
                                        </td>
                                        <td>
                                            <%# Eval("DefaultImage") %>
                                        </td>
                                        <td class="center" id="thActions" runat="server">
                                            <asp:LinkButton ID="btnMakeDefault" ToolTip="Make Default" runat="server" OnClientClick="return confirm('Are your sure you want to make this image as default?');" OnClick="btnMakeDefault_Click" CommandArgument='<%# Eval("Id") %>'><span class="fa fa-check-circle" style="font-size:14px"></span></asp:LinkButton>&nbsp
                                            <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click" OnClientClick="return confirm('Are your sure you want to delete this image?');" CommandArgument='<%# Eval("Id") %>'><span class="fa fa-trash" style="font-size:14px"></span></asp:LinkButton>
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
    <asp:HiddenField ID="hfBrandID" runat="server" />
    <script>
        function openModal(id) {
            $(id).modal('show');
        }
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />
</asp:Content>
