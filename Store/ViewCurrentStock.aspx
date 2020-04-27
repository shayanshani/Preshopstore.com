<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="ViewCurrentStock.aspx.cs" Inherits="PreShop.StockManagement.Store.ViewCurrentStock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #tblAtt th {
            border-bottom: 1px solid #000 !important;
            text-align: center !important;
        }
               td {
    vertical-align: middle!important;
}
    </style>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Current Stock Details</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">

                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr style="display:none">
                                <td colspan="8">
                                    <button type="button" class="btn btn-success" data-toggle="modal" data-target="#formPopUp">Export/Generate Report</button>
                                </td>
                            </tr>
                            <tr>
                                <th>Product</th>
                                <th>Company</th>
                                <th>Total Items</th>
                                <th id="thAttributes" runat="server">Stock Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:repeater id="rptCurrentStock" runat="server" onitemdatabound="rptCurrentStock_ItemDataBound">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hfProductID" runat="server" Value='<%# Eval("ProductID") %>' />
                                    <asp:HiddenField ID="hfCompanyID" runat="server" Value='<%# Eval("CompanyID") %>' />
                                    <tr class="even gradeX">
                                        <td><%# Eval("[Product]") %></td>
                                        <td><%# Eval("[Company]") %></td>
                                        <td><%# Convert.ToInt32(Eval("[Qty]"))==0 ? "<span style='color:red'>No items available</span>" : Eval("[Qty]") %></td>
                                        <td id="tdAttributes" runat="server">
                                            <table id="tblAtt" style="width: 100%!important; height: 82px; text-align: center;">
                                                <asp:Repeater ID="rptSizes" runat="server" OnItemDataBound="rptSizes_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <tr>
                                                            <th><asp:Label ID="lblAttributeHeading" runat="server">Size</asp:Label></th>
                                                            <th>Quantity</th>
                                                            <th id="thColorsOrFlavor" runat="server" visible="false"><asp:Label id="lblHeading" runat="server"></asp:Label><span style="float: right!important">Quantity</span></th>
                                                        </tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hfSizeID" runat="server" Value='<%# Eval("SizeID") %>' />
                                                        <asp:HiddenField ID="hfProductID" runat="server" Value='<%# Eval("ProductId") %>' />
                                                        <tr>
                                                            <td style="width: 25%!important;background-color:<%# Eval("ColorCode")%>">
                                                                <%# Eval("Size") %>
                                                            </td>
                                                            <td><%# Eval("Qty") %>
                                                            </td>
                                                            <td runat="server" id="tdColors" visible="false">
                                                                <%# Container.ItemIndex > 0 ? "<hr />" : "" %>
                                                                <table style="width: 100%!important; height: 82px; text-align: center;">
                                                                    <asp:Repeater ID="rptColors" runat="server">
                                                                        <ItemTemplate>
                                                                            <tr>
                                                                                <td style='background-color:<%# Eval("ColorCode")%>;color:white'><%# Eval("Color") %></td>
                                                                                <td><%# Eval("Qty") %></td>
                                                                            </tr>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <asp:Label ID="lblAtt" runat="server"></asp:Label>
                                            </table>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            $('#datatable-responsive').dataTable({
                "bSort": false
            });
        });
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />

</asp:Content>

