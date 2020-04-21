<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Master.Master" CodeBehind="AddAboutUsInfo.aspx.cs" Inherits="PreShop.AboutUs.Admin.AddAboutUsInfo" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content runat="server" ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1">

    <div class="main-content">

        <div class="card bg-white">
            <div class="card-header">
                Add About Us Info 
            </div>
            <div class="card-block">
                <div class="row m-a-0">
                    <div class="col-lg-12">
                        <asp:Label ID="lblmsg" runat="server"></asp:Label>
                      <%--  <asp:UpdatePanel ID="pnlMsg" runat="server">
                            <ContentTemplate>
                                <asp:Timer runat="server" ID="timerNews" Interval="10000" OnTick="timerNews_Tick"></asp:Timer>
                                <div id="msgDiv" runat="server" visible="false" style="width: 50%; margin: auto; margin-top: 10px;">

                                    <div class="message">
                                        <span id="icon" runat="server"></span>&nbsp&nbsp
                                        
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>--%>
                        <br />
                        <br />

                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">About: &nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtAbout" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtAbout" style="resize:none" Rows="5" runat="server" TextMode="MultiLine" class="form-control"></asp:TextBox>

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">Mission: &nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtMission" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtMission" style="resize:none" Rows="5" runat="server" TextMode="MultiLine" class="form-control"></asp:TextBox>

                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">History: &nbsp&nbsp<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" BorderColor="#FF66FF" SetFocusOnError="true" ControlToValidate="txtHistory" ErrorMessage="*" ForeColor="Red" ValidationGroup="validation"></asp:RequiredFieldValidator></label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtHistory" style="resize:none" Rows="5" runat="server" TextMode="MultiLine" class="form-control"></asp:TextBox>

                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-12">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" ValidationGroup="validation" Style="float: right!important" class="btn btn-dark btn-round " />
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
