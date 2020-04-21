<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="AddSlider.aspx.cs" Inherits="PreShop.CompanySetup.Admin.AddSlider" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .bootstrap-filestyle.input-group {
            margin-left: 12px !important;
            margin-bottom: -40px;
            z-index: 1 !important;
        }

        /*.buttonText {
            color: transparent !important;
        }*/

        label.btn.btn.btn-success.btn-sm {
            /*width: 33px !important;*/
            color: white;
            background-color: #44425B;
            border: 1px solid #44425B;
        }

            label.btn.btn.btn-success.btn-sm:hover {
                background: #fff !important;
                color: #44425B !important;
            }

        .btn-success .badge {
            background: #fff !important;
            color: #44425B !important;
        }
    </style>


    <style>
        #DataTables_Table_0_filter {
            text-align: right !important;
        }
    </style>
    <div class="main-content">

        <div class="card bg-white">
            <div class="card-header">
                Add/Edit Slider
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
                                <label class="col-sm-2 control-label">Slider Image:&nbsp&nbsp<asp:RequiredFieldValidator ID="reqImage" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="flvLogo" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-2">
                                    <asp:FileUpload ID="flvLogo" runat="server" ClientIDMode="Static" />
                                </div>
                                <div class="col-lg-6">
                                    <asp:Image ID="Sliderimg" runat="server" Style="height: 100px!important; width: 120px!important" />
                                </div>
                            </div>


                            <div class="form-group">
                                <label class="col-sm-2 control-label">Heading1:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtHeading1" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtHeading1" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Heading2:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtHeading2" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtHeading2" runat="server" CssClass="form-control"></asp:TextBox>
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
                <asp:HiddenField ID="hfSliderID" runat="server" />
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
                                        <th>Slider Image</th>
                                        <th>Heading 1</th>
                                        <th>Heading 2</th>
                                        <th>Status</th>
                                        <th>Action(s)
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <asp:Repeater ID="rptlider" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <img src='<%# ResolveUrl(Eval("[SliderImage]").ToString()) %>' style="height: 100px!important; width: 200px!important" />
                                                </td>
                                                <td><%# Eval("[Heading1]") %>
                                                </td>
                                                <td><%# Eval("[Heading2]") %>
                                                </td>
                                                <td><%# Convert.ToInt32(Eval("[isActive]"))==1 ? "Active" : "InActive" %>
                                                </td>

                                                <td class="center">
                                                    <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("[SliderID]") %>'><span class="fa fa-pencil" style="font-size: 22px!important;"></span></asp:LinkButton>
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

