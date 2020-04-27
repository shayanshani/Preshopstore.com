<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Uploading.aspx.cs" Inherits="PreShop.ManageProducts.Store.Uploading" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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

        html .demo-container .ruFakeInput {
            width: 220px;
        }
    </style>
    <script>
        function Upload() {
            console.log("Upload");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
         <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
        <div class="demo-container size-narrow" runat="server" id="DemoContainer1">
            <telerik:RadAsyncUpload MultipleFileSelection="Automatic" OnFileUploaded="AsyncUpload1_FileUploaded"
                ToolTip="Upload Images of your product" RenderMode="Native" 
                runat="server" ID="AsyncUpload1" ChunkSize="1048576" />
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
