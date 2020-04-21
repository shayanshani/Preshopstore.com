<%@ Page Title="" Language="C#" MasterPageFile="~/Store/Master.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="PreShop.ManageStockAttributes.Store.Help" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <meta name="viewport" content="width=470, maximum-scale=1, user-scalable=no, target-densitydpi=device-dpi">
    <link rel="stylesheet" href="Channel/font-awesome.min.css">
    <style type="text/css">
        /*  VIDEO PLAYER CONTAINER
 		############################### */
        .vid-container {
            position: relative;
            padding-bottom: 52%;
            padding-top: 30px;
            height: 0;
        }

            .vid-container iframe,
            .vid-container object,
            .vid-container embed {
                position: absolute;
                top: 0;
                left: 0;
                width: 100% !important;
                height: 100% !important;
                margin: auto !important;
            }


        /*  VIDEOS PLAYLIST 
 		############################### */
        .vid-list-container {
            width: 92%;
            overflow: hidden;
            margin-top: 20px;
            margin-left: 4%;
            padding-bottom: 20px;
        }

        .vid-list {
            width: 1344px;
            position: relative;
            top: 0;
            left: 0;
        }

        .vid-item {
            display: block;
            width: 148px;
            height: 148px;
            float: left;
            margin: 0;
            padding: 10px;
        }

        .thumb {
            /*position: relative;*/
            overflow: hidden;
            height: 84px;
        }

            .thumb img {
                width: 100%;
                position: relative;
                /*top: -13px;*/
            }

        .vid-item .desc {
            color: #21A1D2;
            font-size: 15px;
            margin-top: 5px;
        }

        .vid-item:hover {
            background: #eee;
            cursor: pointer;
        }

        .arrows {
            position: relative;
            width: 100%;
        }

        .thumb img {
            height: 112px !important;
            border-radius: 0 !important;
        }

        .arrow-left {
            color: #fff;
            position: absolute;
            background: #777;
            padding: 15px;
            left: -25px;
            top: -130px;
            z-index: 99;
            cursor: pointer;
        }

        .arrow-right {
            color: #fff;
            position: absolute;
            background: #777;
            padding: 15px;
            right: -25px;
            top: -130px;
            z-index: 100;
            cursor: pointer;
        }

        .arrow-left:hover {
            background: #CC181E;
        }

        .arrow-right:hover {
            background: #CC181E;
        }

        .caption {
            margin-top: 40px;
        }

        .vid-list-container {
            padding-bottom: 20px;
        }

        /* reposition left/right arrows */
        .arrows {
            position: relative;
            margin: 0 auto;
            width: 96px;
        }

        .arrow-left {
            left: 0;
            top: -17px;
        }

        .arrow-right {
            right: 0;
            top: -17px;
        }

        }

        #overlay {
            position: fixed;
            z-index: 99;
            top: 0px;
            left: 0px;
            background-color: #f8f8f8;
            width: 100%;
            height: 100%;
            filter: Alpha(Opacity=90);
            opacity: 0.9;
            -moz-opacity: 0.9;
        }

        #theprogress {
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 10px;
            width: 300px;
            height: 30px;
            line-height: 30px;
            text-align: center;
            filter: Alpha(Opacity=100);
            opacity: 1;
            -moz-opacity: 1;
        }

        #modalprogress {
            position: absolute;
            top: 40%;
            left: 50%;
            margin: -11px 0 0 -150px;
            color: #990000;
            font-weight: bold;
            font-size: 14px;
        }
    </style>

    <script type="text/javascript" async="" src="Channel/ga.js.download"></script>
    <script src="Channel/jquery.min.js.download"></script>
    <script src="Channel/bfnov1125.js.download"></script>
    <script src="Channel/client"></script>
    <script src="Channel/SharedApp.js.download"></script>
    <script src="Channel/json3_2.js.download"></script>
    <script src="Channel/NWPLegacy_v3.js.download"></script>
    <script src="Channel/bloomfilter.js.download"></script>
    <script src="Channel/nlp_compromise.min.2.js.download"></script>
    <script src="Channel/jquery.xdr.js.download"></script>
    <script src="Channel/jquery.dotdotdot.js.download"></script>
    <link rel="stylesheet" type="text/css" href="Channel/combinedRibbon.css" class="ver1559800">
    <link rel="stylesheet" type="text/css" href="Channel/font-awesome.min(1).css" class="ver5155057">
    <link rel="stylesheet" type="text/css" href="Channel/rightSlider.css" class="ver4012495" />

    <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Video Help</h2>

                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <br>
                    <div class="row">
                        <center>

  		                 <div class="vid-container">
		    <iframe id="vid_frame" runat="server" frameborder="0" width="560" height="315" allowfullscreen></iframe>
		</div>
                         </center>

                        <!-- THE PLAYLIST -->
                        <div class="vid-list-container">
                            <div class="vid-list">
                                <asp:Repeater ID="rptVideoList" runat="server">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnItem" runat="server" CommandArgument='<%# Eval("VideoID") %>' OnClick="btnItem_Click">
                         <div class="vid-item">
 	                          <div class="thumb">
                                   <img class="video-thumbnail" src="http://img.youtube.com/vi/<%# PreShop.PreShopHelper.PreShophelper.GetYouTubeURL(Eval("Video").ToString())  %>/0.jpg" alt="">
 	                          </div>
 	                          <div class="desc">
                                   <%# Eval("Heading") %>
 	                          </div>
 	                        </div>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>

                        <!-- LEFT AND RIGHT ARROWS -->
                        <div class="arrows">
                            <div class="arrow-left"><i class="fa fa-chevron-left fa-lg"></i></div>
                            <div class="arrow-right"><i class="fa fa-chevron-right fa-lg"></i></div>
                        </div>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $(".arrow-right").bind("click", function (event) {
                                    event.preventDefault();
                                    $(".vid-list-container").stop().animate({
                                        scrollLeft: "+=336"
                                    }, 750);
                                });
                                $(".arrow-left").bind("click", function (event) {
                                    event.preventDefault();
                                    $(".vid-list-container").stop().animate({
                                        scrollLeft: "-=336"
                                    }, 750);
                                });
                            });
                        </script>
                    </div>
                </div>

            </div>
        </div>
    </div>


</asp:Content>

