/*
 * $Id$
 */

/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  DbBrowser: Simple browser
  Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

#include "wxh/filedlg.ch"

#include "dbinfo.ch"

//REQUEST RDOSENDMESSAGE
REQUEST DBFCDX
REQUEST DBFFPT

FUNCTION Main( ... )
  LOCAL MyApp

  rddSetDefault("DBFCDX")

  MyApp := MyApp():New()

  IMPLEMENT_APP( MyApp )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2008
*/
CLASS MyApp FROM wxApp
PRIVATE:

  DATA curDirectory

  METHOD Configure
  METHOD GetBrw
  METHOD OpenDB

PROTECTED:
PUBLIC:

  DATA auiNotebook
  DATA oWnd

  METHOD OnInit

PUBLISHED:
ENDCLASS

/*
  EndClass MyApp
*/

/*
  OnInit
  Teo. Mexico 2008
*/
METHOD FUNCTION OnInit() CLASS MyApp

  CREATE FRAME ::oWnd ;
         WIDTH 800 HEIGHT 600 ;
         ID 999 ;
         TITLE "dbExplorer"

  DEFINE MENUBAR STYLE 1
    DEFINE MENU "&File"
      ADD MENUITEM E"Open database \tCtrl+O" ID wxID_OPEN ACTION ::OpenDB()
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION ::oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU E"&Preferences"
      ADD MENUITEM "Configure dbExplorer" ACTION ::Configure()
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION ::GetBrw():grid:AutoSizeColumns() ENABLED ::GetBrw() != NIL
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    BEGIN AUINOTEBOOK VAR ::auiNotebook SIZERINFO ALIGN EXPAND STRETCH
    END AUINOTEBOOK
    BEGIN PANEL NAME "panel2" ENABLED ::GetBrw != NIL SIZERINFO ALIGN EXPAND
      BEGIN BOXSIZER VERTICAL //"" ALIGN EXPAND
        BEGIN BOXSIZER HORIZONTAL "Nav"
          @ BUTTON "GoTop" ACTION ::GetBrw():GoTop()
          @ BUTTON "GoBottom" ACTION ::GetBrw():GoBottom()
          @ BUTTON "PgUp" ACTION ::GetBrw():PageUp()
          @ BUTTON "PgDown" ACTION ::GetBrw():PageDown()
          @ BUTTON "Up" ACTION ::GetBrw():Up()
          @ BUTTON "Down" ACTION ::GetBrw():Down()
          @ BUTTON "RefreshAll" ACTION ::GetBrw():RefreshAll()
        END SIZER
  /*      BEGIN BOXSIZER HORIZONTAL
          @ BUTTON "Stop Server" ACTION wxGetApp():RDOServer:Stop()
        END SIZER*/
      END SIZER
    END PANEL
    @ BUTTON ID wxID_EXIT ACTION ::oWnd:Close() SIZERINFO ALIGN RIGHT
  END SIZER

//   b:Fit()

  //b:SelectCellBlock := {|| textCtrl:AppendText( b:DataSource:Field_First:AsString + E"\n" ) }

  //b:FillColumns()

  @ STATUSBAR

  SHOW WINDOW ::oWnd CENTRE

RETURN .T.

/*
  Configure
  Teo. Mexico 2009
*/
METHOD PROCEDURE Configure CLASS MyApp
  LOCAL oDlg
  LOCAL rddName := rddSetDefault()
  LOCAL oErr

  CREATE DIALOG oDlg ;
         PARENT ::oWnd ;
         TITLE "Configure"

  BEGIN BOXSIZER VERTICAL
    BEGIN BOXSIZER HORIZONTAL
      @ SAY "RDD Default:"
      @ COMBOBOX rddName ITEMS rddList()
    END SIZER
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_CANCEL ACTION oDlg:EndModal( wxID_CANCEL )
      @ BUTTON ID wxID_OK ACTION oDlg:EndModal( wxID_OK )
    END SIZER
  END SIZER

  SHOW WINDOW oDlg MODAL FIT CENTRE

  IF oDlg:GetReturnCode() = wxID_OK

    BEGIN SEQUENCE WITH {|oErr| BREAK( oErr ) }

      rddSetDefault( rddName )

    RECOVER USING oErr

      wxMessageBox( oErr:description, "Error", wxICON_ERROR, oDlg )

    END SEQUENCE

  ENDIF

  DESTROY oDlg

RETURN

/*
  GetBrw
  Teo. Mexico 2009
*/
METHOD FUNCTION GetBrw CLASS MyApp

  IF ::auiNotebook == NIL .OR. ::auiNotebook:GetSelection() < 0
    RETURN NIL
  ENDIF

RETURN ::auiNotebook:GetPage( ::auiNotebook:GetSelection() ):GetPage( 0 )

/*
  OpenDB
  Teo. Mexico 2009
*/
METHOD PROCEDURE OpenDB CLASS MyApp
  LOCAL fileDlg
  LOCAL noteBook
  LOCAL table
  LOCAL oErr
  LOCAL hIndex,aStruDbf
  LOCAL oBrwStruct,oBrwIndexList
  LOCAL n,l
//   LOCAL ordKey
  LOCAL key := ""

  fileDlg := wxFileDialog():New( ::oWnd, "Choose a Dbf...", NIL, NIL, "*.dbf;*.DBF" )

  IF ::curDirectory != NIL
    fileDlg:SetDirectory( ::curDirectory )
  ENDIF

  IF ! fileDlg:ShowModal() == wxID_OK
//     DESTROY fileDlg
    RETURN
  ENDIF

  ::curDirectory := fileDlg:GetDirectory()

  BEGIN SEQUENCE WITH {|oErr| BREAK( oErr ) }

    table := TTable():New( NIL, fileDlg:GetPath() )

    aStruDbf := table:DbStruct

    hIndex := {=>}

    l := dbOrderInfo( DBOI_ORDERCOUNT )

    IF l > 0

      FOR n:=1 TO l
        hIndex[ dbOrderInfo( DBOI_NAME, NIL, n ) ]:= ;
          { ;
            "Expression" => dbOrderInfo( DBOI_EXPRESSION, NIL, n ),;
            "Condition" => dbOrderInfo( DBOI_CONDITION, NIL, n ),;
            "IsDesc" => dbOrderInfo( DBOI_ISDESC, NIL, n ),;
            "Unique" => dbOrderInfo( DBOI_UNIQUE, NIL, n ) ;
          }
      NEXT

      ordSetFocus( 1 )
//       ordKey := ordKey( 1 )

    ENDIF

  RECOVER USING oErr

    wxMessageBox( oErr:description, "Error", wxICON_ERROR, ::oWnd )

//   DESTROY fileDlg
    RETURN

  END SEQUENCE

  BEGIN AUINOTEBOOK VAR noteBook ON ::auiNotebook STYLE wxAUI_NB_BOTTOM
    ADD BOOKPAGE "Data Grid" FROM
    BEGIN PANEL SIZERINFO ALIGN EXPAND STRETCH
      BEGIN BOXSIZER VERTICAL
        @ BROWSE NAME "table" DATASOURCE table ;
          ONKEY {|b,keyEvent| k_Process( b, keyEvent:GetKeyCode() ) } ;
          SIZERINFO ALIGN EXPAND STRETCH
        @ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
        @ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
/*        BEGIN BOXSIZER VERTICAL  "Index Info" ALIGN LEFT
          BEGIN BOXSIZER HORIZONTAL
            @ SAY "Index:"
            @ CHOICE oErr ITEMS HB_HKeys( hIndex ) WIDTH 100
            @ SPACER
            @ SAY "RecNo:"
            @ GET table:RecNo
            @ SAY "/"
            @ GET table:RecCount
          END SIZER
          @ SAY "KeyExp:" GET ordKey
          @ SAY "KeyVal:" GET table:KeyVal
        END SIZER*/
        BEGIN BOXSIZER HORIZONTAL "Seek" ALIGN LEFT
          @ SAY "Key to seek:"
          @ GET key
        END SIZER
      END SIZER
    END PANEL
    ADD BOOKPAGE "Indexes" FROM
      @ BROWSE VAR oBrwIndexList DATASOURCE hIndex
    ADD BOOKPAGE "Structure" FROM
      @ BROWSE VAR oBrwStruct DATASOURCE aStruDbf
  END AUINOTEBOOK

  oBrwIndexList:DeleteAllColumns()
  ADD BCOLUMN ZERO TO oBrwIndexList "Tag" BLOCK {|key| key  }
  ADD BCOLUMN TO oBrwIndexList "Expression" BLOCK {|key| hIndex[ key, "Expression" ] }
  ADD BCOLUMN TO oBrwIndexList "Condition" BLOCK {|key| hIndex[ key, "Condition" ] }
  ADD BCOLUMN TO oBrwIndexList "IsDesc" BLOCK {|key| hIndex[ key, "IsDesc" ] }
  ADD BCOLUMN TO oBrwIndexList "Unique" BLOCK {|key| hIndex[ key, "Unique" ] }

  oBrwIndexList:grid:AutoSizeColumns()

  oBrwStruct:DeleteAllColumns()
  ADD BCOLUMN TO oBrwStruct "Fieldname" BLOCK {|n| aStruDbf[ n, 1 ]  }
  ADD BCOLUMN TO oBrwStruct "Type" BLOCK {|n| aStruDbf[ n, 2 ]  }
  ADD BCOLUMN TO oBrwStruct "Size" BLOCK {|n| aStruDbf[ n, 3 ]  } PICTURE "99999" AS NUMBER
  ADD BCOLUMN TO oBrwStruct "Dec" BLOCK {|n| aStruDbf[ n, 4 ]  } PICTURE "99" AS NUMBER

  oBrwStruct:grid:AutoSizeColumns()

  noteBook:SetSelection( 0 )
//   noteBook:ChangeSelection( 1 )

  ::auiNotebook:AddPage( noteBook, fileDlg:GetFileName(), .T. )

  noteBook:FindWindowByName("table"):grid:AutoSizeColumns()

  ::oWnd:FindWindowByName("panel2"):Enable()

//   DESTROY fileDlg

RETURN

/*
  k_Process
  Teo. Mexico 2008
*/
STATIC FUNCTION k_Process( b, nKey )

  DO CASE
  CASE nKey = 127
    ? "Delete on",b:DataSource:RecNo(),"First",b:DataSource:Field_First:Value
  OTHERWISE
    RETURN .F.
  ENDCASE

  b:RefreshAll()

RETURN .T.
