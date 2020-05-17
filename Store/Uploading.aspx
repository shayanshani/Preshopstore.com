<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Uploading.aspx.cs" Inherits="PreShop.ManageProducts.Store.Uploading" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <style>
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
            padding: 5px 10px!important;
            margin-bottom: 0 !important;
            font-size: 12px!important;
            font-weight: 400 !important;
            line-height: 1.5!important;
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
            margin-right:5px!important;
            -webkit-font-smoothing: antialiased;
            content: "\f093";
        }
    </style>
    <script src="vendors/jquery/dist/jquery.min.js"></script>
   
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="scr" />
        <div class="demo-container size-narrow" runat="server" id="DemoContainer1">
            <telerik:RadAsyncUpload ClientIDMode="Static" MultipleFileSelection="Automatic" OnFileUploaded="AsyncUpload1_FileUploaded"
                ToolTip="Upload Images of your product" RenderMode="Lightweight"
                runat="server" ID="AsyncUpload1" ChunkSize="1048576" MaxFileInputsCount="8" HideFileInput="true">
                <Localization Select="Upload Images" />
            </telerik:RadAsyncUpload>
            <telerik:RadProgressArea RenderMode="Lightweight" runat="server" ID="RadProgressArea1" />
            <telerik:RadButton runat="server" Text="Postback" ID="RadButton1" OnClick="RadButton1_Click">
            </telerik:RadButton>
        </div>

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
    </form>
</body>
</html>
