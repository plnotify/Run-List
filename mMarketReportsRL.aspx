<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mMarketReportsRL.aspx.vb" Inherits="Cars_mMarketReportsRL" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.css" />
    <script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>
    <style type="text/css">
        .progress {
            position: absolute;
            color: #FFFFFF;
            float: right;
            font: bold medium "Segoe UI", Segoe, sans-serif;
            /*margin-top: 10px;
            top: 100px;
            left: 20px;*/
            text-decoration: none;
        }
        body {
            background-color: #006767;
        }
    </style>
    <script type="text/javascript">
        function pageLoad() {
            $("table").tablesorter();
            //these update spinners work in the pageload or
            //could be placed in a $document.ready(function(){ })
            //because they show() the #spinner until the page reloads
            //and when the page reloads the #spinner is set in the div
            //to display:none
            $("#ddlYear").click(function () {
                $("#spinner").show();
            });
            $("#ddlMake").click(function () {
                $("#spinner").show();
            });
            $('div').trigger('create'); //this line reloads all jquery mobile into all divs on postbacks in updatepanels 
        }
        //to show the spinner for the ddlModel you need to use an asp.net 
        //update progress control because the ddlModel causes a partial page refresh
        //and the page does not reload to cause the #spinner div to display:none
        //in other words the spinner will never stop
        //$("#ddlModel").click(function () {
        //    $("#spinner").show();
        //});
    </script>
    <title>Market Reports Mobile</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <%--unknowst to me tablesorter only works in script manager--%>
                <asp:ScriptReference Path="jquery.tablesorter.min.js" />
            </Scripts>
        </asp:ScriptManager>
        <div data-role="page" data-theme="b" id="Menu">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
            <ContentTemplate>        
            <asp:DropDownList ID="ddlAuction" runat="server" BackColor="Aqua">
                <asp:ListItem Value="Butler Manheim" Selected="True">BM</asp:ListItem>
                <asp:ListItem Value="tblMktReport">All</asp:ListItem>
                <asp:ListItem Value="B">Butler</asp:ListItem>
                <asp:ListItem Value="M">Manheim</asp:ListItem>
                <asp:ListItem Value="H">Harrisburg</asp:ListItem>
                <asp:ListItem Value="D">D-A</asp:ListItem>
            </asp:DropDownList>
            <asp:DropDownList ID="ddlYear" runat="server" DataSourceID="SqlDataSource1" DataTextField="vehYear" AutoPostBack="True"
                DataValueField="vehYear" BackColor="#66FF33" TabIndex="10" AppendDataBoundItems="False">
            </asp:DropDownList>
            <asp:DropDownList ID="ddlMake" runat="server" DataSourceID="SqlDataSource2" DataTextField="Make"
                DataValueField="Make" AutoPostBack="True" BackColor="Aqua" TabIndex="20" AppendDataBoundItems="False">
                <asp:ListItem Value="-1" Selected="True">--Select Make--</asp:ListItem>
            </asp:DropDownList>
            <asp:DropDownList ID="ddlModel" runat="server" DataSourceID="SqlDataSource3" DataTextField="Model"
                DataValueField="Model" AutoPostBack="True" BackColor="#66FF33" TabIndex="30" AppendDataBoundItems="False">
                <asp:ListItem Value="-1" Selected="True">--Select Model--</asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnRefresh" runat="server" Text="Refresh" ToolTip="Press to Refresh"
                TabIndex="40" Height="20px" UseSubmitBehavior="False" />
            <%--see above in jQuery code why both of these img-spinners are needed...--%>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="200">
                <ProgressTemplate>
                    <div class="progress">
                        <img src="../Images/indicator.gif" alt="progress..."/>
                        Updating .....
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <div class="progress" id="spinner" style="display:none;">
                <img id="img-spinner" src="../Images/indicator.gif" alt="Progress"/>
                Updating...
            </div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Label ID="lblSldReg" runat="server" Visible="False" ForeColor="white" /> 
                    <table style="border-collapse: collapse; width: 100%">
                        <asp:Repeater ID="Repeater1" runat="server">
                            <HeaderTemplate>
                                <thead>
                                    <tr style="color: navy; font-weight: bold">
                                        <th>style
                                        </th>
                                        <th>rf
                                        </th>
                                        <th>I
                                        </th>
                                        <th>drs
                                        </th>
                                        <th>color
                                        </th>
                                        <th>mt/t
                                        </th>
                                        <th>adt
                                        </th>
                                        <th style="text-align: right">mls
                                        </th>
                                        <th style="text-align: right">price
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr style="background-color: Aqua; border-bottom: 7px solid aqua">
                                    <td>
                                        <%#Container.DataItem("Subseries")%>
                                    </td>
                                    <td>
                                        <%--<%#Container.DataItem("EW")%>
                                        &nbsp;<%#Container.DataItem("Radio")%>&nbsp;--%><%#Container.DataItem("Top")%>
                                        <td>
                                            <%#Container.DataItem("Int")%>
                                        </td>
                                        <td>
                                            <asp:Literal ID="ltDrs" runat="server" Visible='<%# showDrs(Container.DataItem("Drs")) %>'
                                                Text='<%#Container.DataItem("Drs") & "dr" %>'>dr</asp:Literal>
                                            <%--<%#Container.DataItem("Drs")%>dr--%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("color")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cyl") + Left(Container.DataItem("Fuel"), 1) + "/" + Container.DataItem("Trans")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Auction")%>
                                        </td>
                                        <td style="text-align: right; color: Navy">
                                            <%#String.Format("{0:#}", ((Container.DataItem("Odometer") - 500) / 1000))%>
                                        </td>
                                        <td style="text-align: right">
                                            <b><%#String.Format("{0:#,###}",Container.DataItem("Price"))%></b>
                                        </td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr style="background-color: #CCFFFF; border-bottom: 7px solid #CCFFFF">
                                    <td>
                                        <%#Container.DataItem("Subseries")%>
                                    </td>
                                    <td>
                                        <%--<%#Container.DataItem("EW")%>
                                    &nbsp;<%#Container.DataItem("Radio")%>&nbsp;--%><%#Container.DataItem("Top")%>
                                        <td>
                                            <%#Container.DataItem("Int")%>
                                        </td>
                                        <td>
                                            <asp:Literal ID="ltDrs" runat="server" Visible='<%# showDrs(Container.DataItem("Drs")) %>'
                                                Text='<%#Container.DataItem("Drs") & "dr" %>'>dr</asp:Literal>
                                            <%--<%#Container.DataItem("Drs")%>dr--%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("color")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cyl") + Left(Container.DataItem("Fuel"), 1) + "/" + Container.DataItem("Trans")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Auction")%>
                                        </td>
                                        <td style="text-align: right; color: Navy">
                                            <%#String.Format("{0:#}", ((Container.DataItem("Odometer") - 500) / 1000))%>
                                        </td>
                                        <td style="text-align: right">
                                            <b>
                                                <%#String.Format("{0:#,###}",Container.DataItem("Price"))%></b>
                                        </td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </tbody>
                            </FooterTemplate>
                        </asp:Repeater>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlModel" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="btnRefresh" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
            </ContentTemplate>
        </asp:UpdatePanel>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:sqlfxlimitedConnectionString %>"
            SelectCommand="SELECT DISTINCT [vehYear] FROM [tblMktReport] ORDER BY [vehYear] DESC"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:sqlfxlimitedConnectionString %>"
            SelectCommand="SELECT DISTINCT [Make] FROM [tblMktReport] WHERE ([vehYear] = @vehYear) ORDER BY [Make]">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlYear" Name="vehYear" PropertyName="SelectedValue"
                    Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:sqlfxlimitedConnectionString %>"
            SelectCommand="SELECT DISTINCT [Model] FROM [tblMktReport] WHERE ([vehYear] = @vehYear AND [Make] = @Make) ORDER BY [Model]">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlYear" Name="vehYear" PropertyName="SelectedValue"
                    Type="String" />
                <asp:ControlParameter ControlID="ddlMake" Name="Make" PropertyName="SelectedValue"
                    Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
