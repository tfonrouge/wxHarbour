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

FUNCTION Main()
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
  LOCAL oWnd
  LOCAL auiNb
  LOCAL b
  //LOCAL a := {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
  LOCAL a := {1,2,3,4,5,6,7,8,9,10,11}

  CREATE FRAME oWnd ;
         WIDTH 800 HEIGHT 600 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Open \tCtrl+O" ACTION AddTable( oWnd, auiNb )
      ADD MENUSEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION b:Fit()
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
      BEGIN BOXSIZER VERTICAL "1" ALIGN EXPAND
        BEGIN PANEL
        END PANEL
      END SIZER
      BEGIN BOXSIZER VERTICAL "2" ALIGN EXPAND STRETCH
        BEGIN NOTEBOOK VAR auiNb SIZERINFO ALIGN EXPAND STRETCH
          @ BROWSE b DATASOURCE "main"
//               @ BROWSE b DATASOURCE a
        END NOTEBOOK
      END SIZER
    END SIZER
    BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
      @ BUTTON "Del Row 1" ACTION b:GetTable():DeleteRows( 0, 1 )
      @ BUTTON "Ins Row 1" ACTION (AIns(a,1), a[1] := "Teo", b:GetTable():InsertRows( 0, 1 ))
      @ BUTTON "Check"
      @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER
  END SIZER

  b:AddAllColumns()
  b:Fit()

//   ADD BCOLUMN b "#" BLOCK {|| a[ b:index ] }

  @ STATUSBAR

  SHOW WINDOW oWnd CENTRE

RETURN .T.

/*
  AddTable
  Teo. Mexico 2008
*/
STATIC PROCEDURE AddTable( oWnd, auiNb )
  LOCAL browseDb
  LOCAL fileDlg
  LOCAL tableName

  fileDlg := wxFileDialog():New( oWnd,,,,"*.dbf", wxFD_MULTIPLE )

  IF fileDlg:ShowModal() != wxID_OK
    RETURN
  ENDIF

  FOR EACH tableName IN fileDlg:GetPaths()
    browseDb := wxhBrowse():New( tableName, auiNb )
    browseDb:AddAllColumns()
    auiNb:AddPage( browseDb, tableName, .T. )
//     browseDb:Fit()
  NEXT

RETURN
