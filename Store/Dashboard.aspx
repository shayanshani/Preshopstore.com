<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="PreShop.StoreDashBaord.Store.Dashboard" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function Filter(value) {
            switch (parseInt(value)) {
                case 1:
                    HideAllDivs();
                    ChangeValidationGroup("Val1");
                    break;
                case 2:
                    HideAllDivs();
                    $("#Daily").show();
                    ChangeValidationGroup("Val2");
                    break;
                case 3:
                    HideAllDivs();
                    $("#Monthly").show();
                    ChangeValidationGroup("Val3");
                    break;
                case 4:
                    HideAllDivs();
                    $("#Yearly").show();
                    ChangeValidationGroup("Val4");
                    break;
                case 5:
                    HideAllDivs();
                    $('#Todate').show();
                    $('#fromdate').show();
                    ChangeValidationGroup("Val5");
                    break;
                default:
                    HideAllDivs();
                    ChangeValidationGroup("Val1");
                    break;
            }
        }
        function HideAllDivs() {
            $('#Todate').hide();
            $('#fromdate').hide();
            $("#Daily").hide();
            $("#Monthly").hide();
            $("#Yearly").hide();
        }
        function ChangeValidationGroup(ValidationGroup) {
            $('#<%= btnGenerateReport.ClientID %>').attr('ValidationGroup', ValidationGroup);
        }
    </script>
    <div class="row">
        <div class="col-lg-12">
            <button type="button" class="btn btn-round btn-danger pull-right" data-toggle="modal" data-target="#formPopUp">
                <i class="fa fa-line-chart"></i>&nbsp Profit Report</button>

            <!-- Pop up -->
            <div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-hidden="true" id="formPopUp">
                <div class="modal-dialog modal-sm">
                    <div class="modal-content">

                        <div class="modal-header">
                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                <span aria-hidden="true">×</span>
                            </button>
                            <h4 class="modal-title" id="myModalLabel">
                                <asp:Label ID="lblPopUpHeading" runat="server"><i class="fa fa-line-chart"></i>&nbsp Generate Profit Report</asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <!-- Content  -->
                            <div class="x_content" style="float: none!important">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label>
                                                Select Report Type
                                            </label>
                                            <asp:DropDownList ID="ddlReportType" runat="server" onchange="Filter(this.value);" CssClass="form-control">
                                                <asp:ListItem Text="Overall" Value="1" Selected="True" />
                                                <asp:ListItem Text="Daily" Value="2" />
                                                <asp:ListItem Text="Monthly" Value="3" />
                                                <asp:ListItem Text="Yearly" Value="4" />
                                                <asp:ListItem Text="Date Range" Value="5" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="row" id="Yearly" style="display: none">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label>
                                                Year:
                                            </label>
                                            <asp:DropDownList ID="ddlYearlyView" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="row" id="Monthly" style="display: none">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>
                                                Year:
                                            </label>
                                            <asp:DropDownList ID="ddlYears" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>
                                                Month:
                                            </label>
                                            <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control">
                                                <asp:ListItem Text="Janaury" Value="1" />
                                                <asp:ListItem Text="February" Value="2" />
                                                <asp:ListItem Text="March" Value="3" />
                                                <asp:ListItem Text="April" Value="4" />
                                                <asp:ListItem Text="May" Value="5" />
                                                <asp:ListItem Text="June" Value="6" />
                                                <asp:ListItem Text="July" Value="7" />
                                                <asp:ListItem Text="August" Value="8" />
                                                <asp:ListItem Text="September" Value="9" />
                                                <asp:ListItem Text="October" Value="10" />
                                                <asp:ListItem Text="November" Value="11" />
                                                <asp:ListItem Text="December" Value="12" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="row" id="Daily" style="display: none">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label>
                                                Date:
                                            </label>
                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtProfitReportDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                </DateInput>
                                            </telerik:RadDatePicker>
                                        </div>
                                    </div>
                                </div>

                                <div class="row" id="fromdate" style="display: none">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>
                                                From Date:
                                            </label>
                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtFromDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                </DateInput>
                                            </telerik:RadDatePicker>
                                        </div>
                                    </div>
                                </div>

                                <div class="row" id="Todate" style="display: none">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label>
                                                To Date:
                                            </label>
                                            <telerik:RadDatePicker RenderMode="Lightweight" ID="txtToDate" Width="100%" runat="server" DateInput-CssClass="form-control clndr" TabIndex="5">
                                                <DateInput runat="server" DateFormat="dd-MM-yyyy">
                                                </DateInput>
                                            </telerik:RadDatePicker>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" OnClick="btnGenerateReport_Click" CssClass="btn btn-primary" ValidationGroup="Val1" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <fieldset>
                        <div class="control-group">
                            <div class="controls">
                                <div class="col-md-3 xdisplay_inputx form-group has-feedback">
                                    <label>Filter By Date:</label>
                                    <telerik:RadDatePicker Calendar-ClientEvents-OnLoad="onLoad" RenderMode="Lightweight" ClientIDMode="Static" ID="txtDate" Width="100%" autocomplete="off" runat="server" DateInput-CssClass="form-control" TabIndex="5">
                                        <ClientEvents OnDateSelected="FilterGraph" />
                                    </telerik:RadDatePicker>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <center>
                        <h2 id="dateHeading">
                            <%= StartDay %> - <%= EndDay %>
                        </h2>
                    </center>
                    <hr />
                    <div id="SalePurchasesGraph" style="height: 350px; text-align: center"><i style="margin-top: 100px" class='fa fa-4x fa-spin fa-spinner'></i></div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
