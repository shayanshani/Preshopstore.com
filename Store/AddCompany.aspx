<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="~/Store/AddCompany.aspx.cs" Inherits="PreShop.ManageProducts.Store.AddBrand" %>

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
                    <h2>Brands</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#AddEditBrand">Add New Brand</button>
                            <!-- Pop up -->
                            <div class="modal fade bs-example-modal-sm" role="dialog" aria-hidden="true" id="AddEditBrand">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add New Brand</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Brand Name:&nbsp;
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtBrandName" ErrorMessage="Enter Brand Name" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:TextBox runat="server" ID="txtBrandName" class="form-control" TabIndex="1"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" id="rowStatus" runat="server" visible="false">
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">
                                                            <label>
                                                                Select Status:&nbsp;
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlStatus" ErrorMessage="Select status" InitialValue="-1" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" TabIndex="5">
                                                                <asp:ListItem Value="-1">Select</asp:ListItem>
                                                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                                                <asp:ListItem Value="0">Inactive</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" OnClick="btnSubmit_Click" ValidationGroup="validation" Text="Submit" OnClientClick="if (!Page_ClientValidate()){ return false; } this.disabled = true; this.value = 'Saving...';"
                                                UseSubmitBehavior="false" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>Brand Name</th>
                                <th id="trActions" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptBrands" runat="server">
                                <ItemTemplate>
                                    <tr class="even gradeX">
                                        <td><%# Eval("[Company]") %></td>
                                        <td class="center" id="thActions" runat="server">
                                            <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("CompanyID") %>'><span class="fa fa-edit" style="font-size: 22px!important;"></span></asp:LinkButton>
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
