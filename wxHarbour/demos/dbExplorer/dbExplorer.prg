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
  DATA auiNotebook
  DATA oWnd

  METHOD GetBrw INLINE NIL
  METHOD OpenDB

PROTECTED:
PUBLIC:
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
      ADD MENUITEM "Fit Grid" ACTION ::GetBrw():Fit()
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    BEGIN NOTEBOOK VAR ::auiNotebook SIZERINFO ALIGN EXPAND STRETCH
    END NOTEBOOK
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
  OpenDB
  Teo. Mexico 2009
*/
METHOD PROCEDURE OpenDB CLASS MyApp
  LOCAL fileDlg
  LOCAL noteBook

  fileDlg := wxFileDialog():New( ::oWnd, "Choose a Dbf...", NIL, NIL, "*.dbf;*.DBF" )

  IF ::curDirectory != NIL
    fileDlg:SetDirectory( ::curDirectory )
  ENDIF

  IF ! fileDlg:ShowModal() == wxID_OK
//     DESTROY fileDlg
    RETURN
  ENDIF

  ::curDirectory := fileDlg:GetDirectory()

  BEGIN AUINOTEBOOK VAR noteBook ON ::auiNotebook STYLE wxAUI_NB_BOTTOM
    ADD BOOKPAGE "Data Grid" FROM
      @ BROWSE DATASOURCE fileDlg:GetPath() ;
        ONKEY {|b,keyEvent| k_Process( b, keyEvent:GetKeyCode() ) } ;
        SIZERINFO ALIGN EXPAND STRETCH
    ADD BOOKPAGE "Indexes" FROM
      @ BUTTON "Indexes"
    ADD BOOKPAGE "Structure" FROM
      @ BUTTON "Structure"
  END AUINOTEBOOK

  ::auiNotebook:AddPage( noteBook, fileDlg:GetFileName(), .T. )

  DESTROY fileDlg

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
