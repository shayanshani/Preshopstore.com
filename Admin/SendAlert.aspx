<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master.Master" AutoEventWireup="true" CodeBehind="SendAlert.aspx.cs" Inherits="PreShop.Admin.SendAlerts.Admin.SendAlert" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        #DataTables_Table_0_filter {
            text-align: right !important;
        }
    </style>

    <script>
        function change(StoreID) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Admin/SendAlert.aspx/LoadBarnches",
                data: '{StoreID: ' + StoreID + '}',
                dataType: "json",
                success: function (data) {
                    if (data.d != null) {
                        if (parseInt(data.d[0].BranchCount) > 0) {
                            $("#branches").show();
                            $("#<%= ddlBranch.ClientID %>").empty();
                            $("#<%= ddlBranch.ClientID %>").append("<option selected='selected' value='-1'>Select Branch</option>");
                            $("#<%= ddlBranch.ClientID %>").append("<option value='0'>Main Branch</option>");
                            for (var i = 0; i < data.d.length; i++) {
                                $("#<%= ddlBranch.ClientID %>").append($("<option></option>").val(data.d[i].BranchID).html(data.d[i].Branch));
                            }
                            $("#<%= ddlBranch.ClientID %>").trigger("chosen:updated");
                        }
                        else
                            $("#branches").hide();
                    }
                },
            });
        }

        function subchange(BranchID) {
            $("#<%= hfBranchID.ClientID%>").val(BranchID);
        }

    </script>

    <asp:HiddenField ID="hfBranchID" runat="server" />

    <div class="main-content">

        <div class="card bg-white">
            <div class="card-header">
                Send Notifications
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
                                    Select Store:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlStore" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation" InitialValue="-1"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-10">
                                    <asp:DropDownList ID="ddlStore" runat="server" class="chosen" onchange="change(this.value)" Style="width: 100%;">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="form-group" id="branches" style="display: none!important">
                                <div class="col-sm-2 control-label">
                                    Select Branch:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="ddlBranch" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation" InitialValue="-1"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-sm-10">
                                    <asp:DropDownList ID="ddlBranch" runat="server" class="chosen" Style="width: 100%;" onchange="subchange(this.value)">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Subject:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtSubject" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtSubject" runat="server" class="form-control"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">Message:&nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtDescription" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="txtDescription" runat="server" class="form-control" Rows="6" TextMode="MultiLine" Style="resize: none"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <asp:Button ID="btnSubmit" runat="server" Text="Send" OnClick="btnSubmit_Click" ValidationGroup="validation" Style="float: right!important" class="btn btn-dark btn-round " />
                    </div>
                </div>
                <asp:HiddenField ID="hfNotificationID" runat="server" />
            </div>
        </div>
    </div>
</asp:Content>

