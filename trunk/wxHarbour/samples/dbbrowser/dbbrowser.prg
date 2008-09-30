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
  LOCAL b
  LOCAL auiNb

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
      END SIZER
      BEGIN BOXSIZER VERTICAL "2" ALIGN EXPAND STRETCH
        BEGIN AUINOTEBOOK VAR auiNb SIZERINFO ALIGN EXPAND STRETCH
        END AUINOTEBOOK
      END SIZER
    END SIZER
    BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
      @ BUTTON "Add" ACTION AddTable( oWnd, auiNb )
      @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER
  END SIZER

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
    browseDb := wxhBrowseDb():New( tableName, auiNb )
    browseDb:AddAllColumns()
    auiNb:AddPage( browseDb, tableName, .T. )
//     browseDb:Fit()
  NEXT

RETURN
