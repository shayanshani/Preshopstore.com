<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" ValidateRequest="false" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="PreShop.ManageProducts.Store.AddProduct" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%= ddlCateogory.ClientID %>").select2({
            });
            $("#<%= ddlCompany.ClientID %>").select2({
            });
        });

        function SaveDescription() {
            var descriptionHtml = $('#txtDescription').html();
            $("#<%= txtDescroption.ClientID%>").val(descriptionHtml);
        }

        function LoadDescription() {
            $('#txtDescription').html($("#<%= txtDescroption.ClientID%>").val());
        }

        function AssignSearchUrl(Name) {
            var ddlCompany = document.getElementById('<%= ddlCompany.ClientID%>');
            var CompanyName = ddlCompany.options[ddlCompany.selectedIndex].text;
            Name = CompanyName + " " + Name;
            var value = Name.replace(" ", "+");
            document.getElementById('imageLink').href = "https://www.google.com.pk/search?hl=en&tbm=isch&source=hp&biw=1366&bih=626&ei=HkMKXL6zIsyYlwSvgKfgDQ&q=" + value + "&oq=" + value + "&gs_l=img.3..0l10.2214.3746..3947...0.0..0.759.3542.2-2j1j0j2j2......0....1..gws-wiz-img.....0.dxuEkpztc80";
        }
    </script>
    <link href="Select2/CustomCss.css" rel="stylesheet" />
    <style>
        .select2 {
            width: 100% !important;
        }

        .editor-wrapper {
            min-height: 190px !important;
        }

        #example {
            text-align: center;
        }

            #example .demo-container {
                display: inline-block;
                text-align: left;
            }

        .demo-container .RadUpload .ruUploadProgress {
            width: 210px;
            display: inline-block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: top;
        }

        .ruBrowse {
            color: #fff !important;
            background-color: #26B99A !important;
            border-color: #169F85 !important;
            background-image: none !important;
            margin-bottom: 5px !important;
            margin-right: 5px !important;
            display: inline-block !important;
            padding: 5px 10px !important;
            margin-bottom: 0 !important;
            font-size: 12px !important;
            font-weight: 400 !important;
            line-height: 1.5 !important;
            text-align: center !important;
            white-space: nowrap !important;
            vertical-align: middle !important;
            touch-action: manipulation !important;
            cursor: pointer !important;
            -webkit-user-select: none !important;
            -moz-user-select: none !important;
            -ms-user-select: none !important;
            user-select: none !important;
            background-image: none !important;
            border: 1px solid transparent !important;
            border-radius: 4px !important;
        }

        .RadUpload_Default .ruSelectWrap .ruBrowse:hover {
            background-color: #398439 !important;
            cursor: pointer;
        }

        div.RadUpload_Default .ruBrowse::before {
            display: inline-block;
            font: normal normal normal 14px/1 FontAwesome;
            font-size: inherit;
            text-rendering: auto;
            margin-right: 5px !important;
            -webkit-font-smoothing: antialiased;
            content: "\f093";
        }
    </style>
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
            <div class="x_panel">
                <div class="x_title">
                    <h2>Products</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div class="row">
                        <label class="control-label col-md-12 col-sm-12 col-xs-12"></label>
                        <div class="col-lg-12">
                            <div aria-live="assertive" id="msgDiv" runat="server" visible="false" style="width: 100%; right: 36px; top: 36px; cursor: auto; text-align: left">
                                <div class="ui-pnotify-icon"><span id="icon" runat="server"></span></div>
                                <div class="ui-pnotify-text">
                                    <asp:Label ID="lblmsg" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#AddEditProduct">Add New Product</button>
                            <!-- Pop up -->
                            <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "modal fade bs-example-modal-sm" : "modal fade bs-example-modal-lg" %>' role="dialog" aria-hidden="true" id="AddEditProduct">
                                <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "modal-dialog modal-sm" : "modal-dialog modal-lg" %>'>
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" id="cls" data-dismiss="modal">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                            <h4 class="modal-title" id="myModalLabel">
                                                <asp:Label ID="lblPopUpHeading" runat="server">Add New Product</asp:Label></h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="x_content" style="float: none!important">
                                                <div class="row">
                                                    <div class="col-sm-6 col-md-6 col-lg-6" id="DivCategory" runat="server" style="display: none">
                                                        <div class="form-group">
                                                            <label>
                                                                Select Category:&nbsp;
                                                <asp:RequiredFieldValidator ID="reqCategory" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlCateogory" ErrorMessage="*" CssClass="has-error" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlCateogory" runat="server" class="form-control" TabIndex="2">
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <div class='<%=Convert.ToBoolean(config.StandAlonePortal) ? "col-sm-12 col-md-12 col-lg-12" : "col-sm-6 col-md-6 col-lg-6" %>'>
                                                        <div class="form-group">
                                                            <label>
                                                                Select Brand:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlCompany" ErrorMessage="*" CssClass="has-error" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <asp:DropDownList ID="ddlCompany" runat="server" class="form-control" TabIndex="2">
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class='col-sm-12 col-md-12 col-lg-12'>
                                                        <div class="form-group">
                                                            <label>
                                                                Product Name:&nbsp;
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" CssClass="has-error" SetFocusOnError="true" ControlToValidate="txtProductName" ErrorMessage="*" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="$ symbol is not allowed" ControlToValidate="txtProductName" ValidationExpression="[^$]+" Display="Dynamic" SetFocusOnError="true" ValidationGroup="validation"></asp:RegularExpressionValidator>

                                                            </label>
                                                            <asp:TextBox runat="server" ID="txtProductName" onpaste="AssignSearchUrl(this.value);" oninput="AssignSearchUrl(this.value);" onchange="AssignSearchUrl(this.value);" class="form-control col-md-7 col-xs-12" TabIndex="4"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-4" id="divColorOnly" runat="server" style="display: none">
                                                        <div class="form-group">
                                                            <label></label>
                                                            <p>
                                                                Color:
                                                                <input type="checkbox" class="flat" name="gender" id="chkColorOnly" runat="server" checked="" />&nbsp&nbsp
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-4" id="rowFlavourColor" runat="server" style="display: none">
                                                        <div class="form-group">
                                                            <label></label>
                                                            <p>
                                                                Color:
                                                               
                                                                <input type="radio" class="flat" name="gender" id="chkColor" runat="server" checked="" />&nbsp&nbsp
                                                                Flavour:
                                                               
                                                                <input type="radio" class="flat" name="gender" id="chkFlavour" runat="server" />
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-4" id="divFlavourOnly" runat="server" style="display: none">
                                                        <div class="form-group">
                                                            <label></label>
                                                            <p>
                                                                Falvour:
                                                                <input type="checkbox" class="flat" name="gender" id="chkFlavourOnly" runat="server" checked="" />&nbsp&nbsp
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" id="uploadingArea" runat="server">
                                                    <div class="col-sm-6">
                                                        <div class="form-group">
                                                            <label>
                                                                &nbsp<span class="required">
                                                                    <asp:RequiredFieldValidator ID="reqFileUpload" runat="server" CssClass="has-error" Display="Dynamic" SetFocusOnError="true" ControlToValidate="flvProductUpload" ErrorMessage="Choose an image" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                                    <asp:RegularExpressionValidator ID="fileUploadReg" runat="server" Display="Dynamic" ControlToValidate="flvProductUpload" ValidationExpression="^.*\.((j|J)(p|P)(e|E)?(g|G)|(p|P)(n|N)(g|G))$" CssClass="has-error" ErrorMessage="Please choose only PNG or JPG format" ValidationGroup="validation"></asp:RegularExpressionValidator>
                                                                </span>
                                                            </label>
                                                            <asp:FileUpload ID="flvProductUpload" Visible="false" runat="server" AllowMultiple="true" ClientIDMode="Static" />

                                                            <div class="demo-container size-narrow" runat="server" id="DemoContainer1">
                                                                <telerik:RadAsyncUpload ClientIDMode="Static" MultipleFileSelection="Automatic" OnFileUploaded="AsyncUpload1_FileUploaded"
                                                                    ToolTip="Upload Images of your product" RenderMode="Lightweight"
                                                                    runat="server" ID="AsyncUpload1" ChunkSize="1048576" MaxFileInputsCount="8" HideFileInput="true">
                                                                    <Localization Select="Upload Images" />
                                                                </telerik:RadAsyncUpload>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <telerik:RadProgressArea RenderMode="Lightweight" runat="server" ID="RadProgressArea1" />
                                                        <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
                                                            <AjaxSettings>
                                                                <telerik:AjaxSetting AjaxControlID="ConfiguratorPanel1">
                                                                    <UpdatedControls>
                                                                        <telerik:AjaxUpdatedControl ControlID="ConfiguratorPanel1" />
                                                                        <telerik:AjaxUpdatedControl ControlID="DemoContainer1" />
                                                                    </UpdatedControls>
                                                                </telerik:AjaxSetting>
                                                            </AjaxSettings>
                                                        </telerik:RadAjaxManager>
                                                        <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" />
                                                    </div>
                                                    <div id="DivProductImage" runat="server" clientidmode="Static" style="display: none" class="col-sm-4">
                                                        <img id="ProductImage" runat="server" clientidmode="Static" src="#" style="height: 115px;" />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-6 col-md-6 col-lg-6" style='<%=Convert.ToBoolean(config.StandAlonePortal) ? "display: none": "display: block" %>; padding-top: 10px; padding-bottom: 10px;'>
                                                        <span class="pull-right" style="margin-right: 92px;">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <b><i class="fa fa-arrow-down"></i></b>
                                                            <br />
                                                            <a href="#" id="imageLink" target="_blank" style="color: #0094ff">Click here to find & download Image from google</a>
                                                        </span>
                                                    </div>
                                                    <div class="col-sm-6 col-md-6 col-lg-6" id="DivUnits" runat="server">
                                                        <div class="form-group">
                                                            <label>
                                                                Select unit:&nbsp;
                                                            <asp:RequiredFieldValidator ID="reqUnits" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="ddlUnits" ErrorMessage="*" CssClass="has-error" InitialValue="-1" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <p>
                                                                <asp:DropDownList ID="ddlUnits" runat="server" CssClass="form-control">
                                                                </asp:DropDownList>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" style='<%=Convert.ToBoolean(config.StandAlonePortal) ? "display: none": "display: block" %>'>
                                                    <div class="col-sm-12 col-md-12 col-lg-12">
                                                        <div class="form-group">

                                                            <label>
                                                                Description:&nbsp;
                                             <asp:RequiredFieldValidator ID="reqDescription" runat="server" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtDescroption" ErrorMessage="*" CssClass="has-error" ValidationGroup="validation"></asp:RequiredFieldValidator>
                                                            </label>
                                                            <div class="btn-toolbar editor" data-role="editor-toolbar" data-target="#txtDescription">
                                                                <div class="btn-group">
                                                                    <a class="btn dropdown-toggle" data-toggle="dropdown" title="Font Size"><i class="fa fa-text-height"></i>&nbsp;<b class="caret"></b></a>
                                                                    <ul class="dropdown-menu">
                                                                        <li>
                                                                            <a data-edit="fontSize 5">
                                                                                <p style="font-size: 17px">Huge</p>
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <a data-edit="fontSize 3">
                                                                                <p style="font-size: 14px">Normal</p>
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <a data-edit="fontSize 1">
                                                                                <p style="font-size: 11px">Small</p>
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                                <div class="btn-group">
                                                                    <a class="btn" data-edit="bold" title="Bold (Ctrl/Cmd+B)"><i class="fa fa-bold"></i></a>
                                                                    <a class="btn" data-edit="italic" title="Italic (Ctrl/Cmd+I)"><i class="fa fa-italic"></i></a>
                                                                    <a class="btn" data-edit="strikethrough" title="Strikethrough"><i class="fa fa-strikethrough"></i></a>
                                                                    <a class="btn" data-edit="underline" title="Underline (Ctrl/Cmd+U)"><i class="fa fa-underline"></i></a>
                                                                </div>

                                                                <div class="btn-group">
                                                                    <a class="btn" data-edit="insertunorderedlist" title="Bullet list"><i class="fa fa-list-ul"></i></a>
                                                                    <a class="btn" data-edit="insertorderedlist" title="Number list"><i class="fa fa-list-ol"></i></a>
                                                                    <a class="btn" data-edit="outdent" title="Reduce indent (Shift+Tab)"><i class="fa fa-dedent"></i></a>
                                                                    <a class="btn" data-edit="indent" title="Indent (Tab)"><i class="fa fa-indent"></i></a>
                                                                </div>

                                                                <div class="btn-group">
                                                                    <a class="btn" data-edit="justifyleft" title="Align Left (Ctrl/Cmd+L)"><i class="fa fa-align-left"></i></a>
                                                                    <a class="btn" data-edit="justifycenter" title="Center (Ctrl/Cmd+E)"><i class="fa fa-align-center"></i></a>
                                                                    <a class="btn" data-edit="justifyright" title="Align Right (Ctrl/Cmd+R)"><i class="fa fa-align-right"></i></a>
                                                                    <a class="btn" data-edit="justifyfull" title="Justify (Ctrl/Cmd+J)"><i class="fa fa-align-justify"></i></a>
                                                                </div>

                                                                <div class="btn-group">
                                                                    <a class="btn" data-edit="undo" title="Undo (Ctrl/Cmd+Z)"><i class="fa fa-undo"></i></a>
                                                                    <a class="btn" data-edit="redo" title="Redo (Ctrl/Cmd+Y)"><i class="fa fa-repeat"></i></a>
                                                                </div>
                                                            </div>
                                                            <div id="txtDescription" onkeyup="SaveDescription();" class="editor-wrapper"></div>
                                                            <asp:TextBox runat="server" ID="txtDescroption" class="form-control col-md-7 col-xs-12" Style="display: none; resize: none!important" TabIndex="4" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" OnClick="btnSubmit_Click" EnableViewState="false" TabIndex="4" ValidationGroup="validation" Text="Save" OnClientClick="if (!Page_ClientValidate()){ return false; } this.disabled = true; this.value = 'Saving...';"
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
                                <th runat="server" id="thCategory">Category</th>
                                <th>Brand</th>
                                <th>Product Name</th>
                                <%--<th runat="server" id="thDescription" style="display:none">Description</th>--%>
                                <th id="thActions" runat="server">Action(s)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptProducts" runat="server" OnItemDataBound="rptProducts_ItemDataBound">
                                <ItemTemplate>
                                    <tr class="even gradeX">
                                        <td runat="server" visible='<%# Convert.ToInt32(config.SingleCategory) <= 0 & !Convert.ToBoolean(config.StandAlonePortal) %>'><%# Eval("[Category]") %></td>
                                        <td><%# Eval("[Company]") %></td>
                                        <td>
                                            <table style="width:100%!important">
                                                <tr>
                                                    <td style="white-space: pre-wrap!important;">
                                                        <%# Eval("[Product]") %> 
                                                    </td>
                                                    <td>
                                                        <img src='<%# PreShop.Common.StoreHostName+Eval("Image") %>' runat="server" visible='<%# !Convert.ToBoolean(config.StandAlonePortal) %>' style="height: 115px; width: 100px;" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <%--<td style="display:none;white-space: pre-line!important"><%# Eval("[Description]") %></td>--%>
                                        <td class="center" id="tdActions" runat="server">
                                            <asp:LinkButton ID="btnEdit" runat="server" OnClick="btnEdit_Click" CommandArgument='<%# Eval("ProductID") %>'><span class="fa fa-edit" style="font-size: 22px!important;"></span></asp:LinkButton>
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

    <asp:HiddenField ID="hfProductID" runat="server" />
    <asp:HiddenField ID="hfSubCategoryID" runat="server" />
    <asp:HiddenField ID="hfDescription" runat="server" />
    <asp:HiddenField ID="hfImagePath" runat="server" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#datatable-responsive').dataTable({
                "bSort": false
            });
            $('#AddEditProduct').on('hide.bs.modal', function (e) {
                var hfProductID = $('#<%= hfProductID.ClientID%>');
                var hfDescription = $('#<%= hfDescription.ClientID%>');
                var hfImagePath = $('#<%= hfImagePath.ClientID%>');
                $('#<%= ProductImage.ClientID%>').attr('src', null);
                $("#<%= DivProductImage.ClientID%>").hide();
                $('#<%= ddlCateogory.ClientID%>').val("-1").trigger('change');
                $('#<%= ddlCompany.ClientID%>').val("-1").trigger('change');
                $('#<%= txtProductName.ClientID%>').val(null);
                $('#<%= txtDescroption.ClientID%>').val(null);
                $('#txtDescription').html(null);
                hfProductID.val(null);
                hfDescription.val(null);
                hfImagePath.val(null);
                document.getElementById('imageLink').href = "#";
                <%--document.getElementById("<%=reqFileUpload.ClientID%>").enabled = true;--%>
            });
        });
        function openModal(id) {
            $(id).modal('show');
        }
        $('#<%= flvProductUpload.ClientID %>').filestyle({
            input: false,
            buttonName: 'btn btn-success btn-sm',
            iconName: 'fa fa-upload',
            buttonText: 'Upload Image'
        });

        function readURL(input) {

            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%= ProductImage.ClientID%>').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        $('#<%= flvProductUpload.ClientID %>').change(function () {
            readURL(this);
            $("#<%= DivProductImage.ClientID%>").show();
        });
    </script>
    <script src='<%= ResolveUrl("../CustomFiles/bootstrap-notify.min.js") %>'></script>
    <link href='<%= ResolveUrl("../CustomFiles/CustomNotify.css") %>' rel="stylesheet" />

</asp:Content>
