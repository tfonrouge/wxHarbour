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

//REQUEST RDOSENDMESSAGE

FUNCTION Main( ... )
  LOCAL MyApp

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
  LOCAL text := ""

  CREATE FRAME ::oWnd ;
         WIDTH 800 HEIGHT 600 ;
         ID 999 ;
         TITLE "dbExplorer"

  DEFINE MENUBAR STYLE 1 ON ::oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Open database \tCtrl+O" ID wxID_OPEN ACTION ::OpenDB()
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION ::oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION ::GetBrw():gridBrowse:AutoSizeColumns() ENABLED ::GetBrw() != NIL
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    BEGIN AUINOTEBOOK VAR ::auiNotebook SIZERINFO ALIGN EXPAND STRETCH
    END AUINOTEBOOK
    BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
      @ GET text NAME "textCtrl" MULTILINE SIZERINFO ALIGN EXPAND STRETCH
      BEGIN BOXSIZER HORIZONTAL
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
      @ BUTTON ID wxID_EXIT ACTION ::oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER
  END SIZER

//   b:Fit()

  //b:SelectCellBlock := {|| textCtrl:AppendText( b:DataSource:Field_First:AsString + E"\n" ) }

  //b:FillColumns()

  @ STATUSBAR

  SHOW WINDOW ::oWnd CENTRE

RETURN .T.

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
  LOCAL aIndex := {}
  LOCAL oBrwStruct

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

  RECOVER USING oErr

    wxMessageBox( oErr:description, "Error", wxICON_ERROR, ::oWnd )

//   DESTROY fileDlg
    RETURN

  END SEQUENCE

  BEGIN AUINOTEBOOK VAR noteBook ON ::auiNotebook STYLE wxAUI_NB_BOTTOM
    ADD BOOKPAGE "Data Grid" FROM
      @ BROWSE NAME "table" DATASOURCE table ;
        ONKEY {|b,keyEvent| k_Process( b, keyEvent:GetKeyCode() ) } ;
        SIZERINFO ALIGN EXPAND STRETCH
    ADD BOOKPAGE "Indexes" FROM
      @ BROWSE DATASOURCE aIndex
    ADD BOOKPAGE "Structure" FROM
      @ BROWSE VAR oBrwStruct DATASOURCE table:DbStruct
  END AUINOTEBOOK

  oBrwStruct:DeleteAllColumns()
  ADD BCOLUMN TO oBrwStruct "Fieldname" BLOCK {|o| o[ 1 ]  }
  ADD BCOLUMN TO oBrwStruct "Type" BLOCK {|o| o[ 2 ]  }
  ADD BCOLUMN TO oBrwStruct "Size" BLOCK {|o| o[ 3 ]  } PICTURE "99999"
  ADD BCOLUMN TO oBrwStruct "Dec" BLOCK {|o| o[ 4 ]  } PICTURE "99"

  oBrwStruct:gridBrowse:AutoSizeColumns()

  noteBook:SetSelection( 1 )
//   noteBook:ChangeSelection( 1 )

  ::auiNotebook:AddPage( noteBook, fileDlg:GetFileName(), .T. )

  noteBook:FindWindowByName("table"):gridBrowse:AutoSizeColumns()

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
