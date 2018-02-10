Imports System.Data
Imports System.Data.SqlClient

Partial Class Cars_mMarketReportsRL
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlYear.DataSourceID = "SqlDataSource1"
            ddlYear.Text = Request.QueryString("yr")
            ddlYear.DataBind()
        End If
    End Sub
    Protected Sub ddlModel_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModel.SelectedIndexChanged
        Get_Report(ddlAuction.Text)
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Get_Report(ddlAuction.Text)
    End Sub
    Protected Sub Get_Report(ByVal auction As String)
        Dim yrrS As String = ddlYear.Text
        Dim makeS As String = ddlMake.Text
        Dim makeS2 As String = "x_y_z" 'this is a sequence that would not appear
        Dim modelS As String = ddlModel.Text
        Dim modelS2 As String = "x_y_z" 'this is a sequence that would not appear

'''''''''''
        ''If InStr(makeS.ToUpper, "CHEVROLET") > 0 Then
        ''    makeS2 = "CHEV TRUCK"
        ''End If
        'compensates for the mulitiple ways manheim reports TOWN & COUNTRY and GRAND CHEROKEEs etc
        ''If InStr(modelS.ToUpper, "COUNTRY") > 0 Then
            'Response.Write("I GOT ONE")
            'Response.End()
        ''    modelS = "COUNTRY"
        ''End If
        ''If InStr(modelS.ToUpper, "CARAVAN") > 0 Then
        ''    modelS = "CARAVAN"
        ''End If
        '''If InStr(modelS.ToUpper, "GRAND CHEROKEE") > 0 Or _
        '''   InStr(modelS, "GR CHER") > 0 Then
        '''    modelS = "GR CHERO"
		'''	modelS2 = "CHEROKEE"
        '''End If
        'these handle subaru's
        ''If InStr(modelS.ToUpper, "FORESTER") > 0 Then
        ''    modelS2 = "FORSTR "
        ''End If
        ''If InStr(modelS.ToUpper, "IMPREZA") > 0 Then
        ''    modelS2 = "IMP "
        ''End If
        'handles Trailblazer TRAILBLZ
        ''If InStr(modelS.ToUpper, "TRAILBLAZER") > 0 Then
        ''    modelS2 = "TRAILBLZ "
        ''End If
        'handles Rendezvous RENDEZVS
        ''If InStr(modelS.ToUpper, "RENDEZVOUS") > 0 Then
        ''    modelS2 = "RENDEZVS "
        ''End If
'''''''''''


        Dim SqlDataSource4 As New SqlDataSource
        SqlDataSource4.ConnectionString = ConfigurationManager.ConnectionStrings("sqlfxlimitedConnectionString").ConnectionString
        Repeater1.DataSource = SqlDataSource4

        If auction = "tblMktReport" Then 'select all auctions except harrisburg because of " [AuctionCode] <> 'H' ORDER BY" & _
            SqlDataSource4.SelectCommand = "SELECT * FROM tblMktReport WHERE ([vehYear] = '" & yrrS & "' AND " & _
                                            "([Make] = '" & makeS & "' OR" & _
                                            " [Make] = '" & makeS2 & "') AND " & _
                                            "([Model] LIKE '%" & modelS & "%' OR" & _
                                            " [Model] LIKE '%" & modelS2 & "%')) AND" & _
                                            " [AuctionCode] <> 'H' ORDER BY " & _
                                            "[Subseries], " & _
                                            "CAST(Odometer AS INT)"
            '                               	"Model, subseries, Odometer"
        Else if auction = "Butler Manheim" Then
            SqlDataSource4.SelectCommand = "SELECT * FROM tblMktReport WHERE (AuctionCode = 'B' OR " & _
                                			"AuctionCode = 'M') AND ([vehYear] = '" & yrrS & "' AND " & _
                                            "([Make] = '" & makeS & "' OR" & _
                                            " [Make] LIKE '" & makeS2 & "%') AND " & _
                                            "([Model] LIKE '%" & modelS & "%' OR" & _
                                            " [Model] LIKE '%" & modelS2 & "%')) ORDER BY " & _
                                            "[Subseries], " & _
                                            "CAST(Odometer AS INT)"
            '                               	"Model, subseries, Odometer"
        Else
            SqlDataSource4.SelectCommand = "SELECT * FROM tblMktReport WHERE AuctionCode = '" & auction & "' AND ([vehYear] = '" & yrrS & "' AND " & _
                                            "([Make] = '" & makeS & "' OR" & _
                                            " [Make] = '" & makeS2 & "') AND " & _
                                            "([Model] LIKE '%" & modelS & "%' OR" & _
                                            " [Model] LIKE '%" & modelS2 & "%')) ORDER BY " & _
                                            "[Subseries], " & _
                                            "CAST(Odometer AS INT)"
            '                               	"Model, subseries, Odometer"
        End If

        'Use the code below when the AceessDataSource4 is coded in the aspx file
        'AccessDataSource4.SelectParameters("Model").DefaultValue = modelS.ToString
        'AccessDataSource4.SelectParameters("Make").DefaultValue = makeS.ToString
        'AccessDataSource4.SelectParameters("vehYear").DefaultValue = yrrS.ToString
        'GridView2.Visible = False
        Repeater1.Visible = True
        Repeater1.DataBind()

        Dim conn As New SqlConnection
        Dim cmd As New SqlCommand
        Dim sql As String
        lblSldReg.Text = ""

        If auction = "B" Then
            Try 'gets number sold
                conn.ConnectionString = ConfigurationManager.ConnectionStrings("sqlfxlimitedConnectionString").ConnectionString

                conn.Open()
                cmd.Connection = conn

                sql = "SELECT [vehYear], " & _
                                           "COUNT(Model) AS Sold " & _
                                           "FROM tblMktReport " & _
                                           "WHERE AuctionCode = 'B' AND " & _
                                            "[vehYear] = '" & yrrS & "' AND " & _
                                            "([Make] = '" & makeS & "' OR" & _
                                            " [Make] = '" & makeS2 & "') AND " & _
                                            "([Model] LIKE '%" & modelS & "%' OR" & _
                                            " [Model] LIKE '%" & modelS2 & "%') " & _
                                            "GROUP BY [vehYear]"

                cmd.CommandText = sql
                Dim mreader As SqlDataReader = cmd.ExecuteReader()
                If mreader.HasRows Then
                    'lblSldReg.Text = "<font color='red'><b>Market Report Already Exists</b></font> with date: " & tbxInsertDate.Text & "<br />" & _
                    '                  "No records inserted.  Delete market report date first."
                    mreader.Read()
                    lblSldReg.Text = mreader("Sold").ToString + "/"
                    lblSldReg.Visible = True
                    mreader.Close()
                    conn.Close()
                Else
                    mreader.Close()
                End If
            Catch ex As Exception
                Response.Write(ex.ToString())
            End Try


            Try 'gets number Registered
                conn.ConnectionString = ConfigurationManager.ConnectionStrings("sqlfxlimitedConnectionString").ConnectionString

                conn.Open()
                cmd.Connection = conn

                sql = "SELECT [Year], " & _
                                           "COUNT(Model) AS Registered " & _
                                           "FROM tblRegistered " & _
                                           "WHERE [Year] = '" & yrrS & "' AND " & _
                                            "([Make] = '" & makeS & "' OR" & _
                                            " [Make] = '" & makeS2 & "') AND " & _
                                            "([Model] LIKE '%" & modelS & "%' OR" & _
                                            " [Model] LIKE '%" & modelS2 & "%') " & _
                                            "GROUP BY [Year]"

                cmd.CommandText = sql
                Dim mreader As SqlDataReader = cmd.ExecuteReader()
                If mreader.HasRows Then
                    'lblSldReg.Text = "<font color='red'><b>Market Report Already Exists</b></font> with date: " & tbxInsertDate.Text & "<br />" & _
                    '                  "No records inserted.  Delete market report date first."
                    mreader.Read()
                    lblSldReg.Text = lblSldReg.Text + mreader("Registered").ToString
                    lblSldReg.Visible = True
                    mreader.Close()
                    conn.Close()
                Else
                    mreader.Close()
                End If
            Catch ex As Exception
                Response.Write(ex.ToString())
            End Try
        Else
            lblSldReg.Visible = False
        End If


    End Sub

    Function showDrs(ByVal Drs As String) As Boolean
        If Drs = "2" Or Drs = "4" Then
            Return True
        Else
            Return False
        End If
    End Function

    Protected Sub ddlYear_DataBound(sender As Object, e As EventArgs) Handles ddlYear.DataBound
        'this keeps year to querystring yr in pageload event unless it is a postback then it sets make to --Select Year--
        If IsPostBack Then
            If ddlYear.Items.Count > 0 Then
                ddlYear.Items.Insert(0, "--Select Year--")
                ddlYear.Items(0).Value = ""
                ddlYear.SelectedIndex = 0
                Repeater1.Visible = False  'hides repeater when selections change
            End If
        End If
    End Sub

    Protected Sub ddlMake_DataBound(sender As Object, e As EventArgs) Handles ddlMake.DataBound
        'this sets make to querystring make unless it is a postback then it sets make to --Select Make--
        If IsPostBack Then
            If ddlMake.Items.Count > 0 Then
                ddlMake.Items.Insert(0, "--Select Make--")
                ddlMake.Items(0).Value = ""
                ddlMake.SelectedIndex = 0
                Repeater1.Visible = False  'hides repeater when selections change
            End If
        Else
            ddlMake.Items.Insert(0, Request.QueryString("make"))
            ddlMake.Items(0).Value = Request.QueryString("make")
            ddlMake.SelectedIndex = 0
        End If
        Repeater1.Visible = False  'hides repeater when selections change
    End Sub
    Protected Sub ddlModel_DataBound(sender As Object, e As EventArgs) Handles ddlModel.DataBound
        If ddlModel.Items.Count > 0 Then
            ddlModel.Items.Insert(0, "--Select Model--")
            ddlModel.Items(0).Value = ""
            ddlModel.SelectedIndex = 0
            Repeater1.Visible = False 'hides repeater when selections change
        End If

    End Sub
    'simulates a delay
    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    '    If IsPostBack Then
    '        System.Threading.Thread.Sleep(5000)
    '    End If
    'End Sub

End Class


