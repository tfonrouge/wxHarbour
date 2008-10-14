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
  LOCAL profiler := HBProfile():New()
  LOCAL MyApp

  MyApp := MyApp():New()

  __setProfiler( .T. )

  IMPLEMENT_APP( MyApp )

  profiler:Gather()
  ? HBProfileReportToString():new( profiler:timeSort() ):generate( {|o| o:nTicks > 10000 } )
  ? Replicate("=",40)
  ? "  Total Calls: " + str( profiler:totalCalls() )
  ? "  Total Ticks: " + str( profiler:totalTicks() )
  ? "Total Seconds: " + str( profiler:totalSeconds() )

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
  LOCAL text
  LOCAL b1,b2
  LOCAL oldPos
//   LOCAL a := {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
  LOCAL a := {1,2,3,4,5,6}

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
      ADD MENUITEM "Fit Grid" ACTION b1:Fit()
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
        BEGIN AUINOTEBOOK VAR auiNb SIZERINFO ALIGN EXPAND STRETCH
          @ BROWSE b1 DATASOURCE a
          @ BROWSE b2 DATASOURCE "main"
        END AUINOTEBOOK
      END SIZER
    END SIZER
    BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
      @ GET text MULTILINE SIZERINFO ALIGN EXPAND STRETCH
      BEGIN BOXSIZER HORIZONTAL
        @ BUTTON "GoTop" ACTION b1:GoTop()
        @ BUTTON "GoBottom" ACTION b1:GoBottom()
        @ BUTTON "PgUp" ACTION b1:PageUp()
        @ BUTTON "PgDown" ACTION b1:PageDown()
        @ BUTTON "Up" ACTION b1:Up()
        @ BUTTON "Down" ACTION b1:Down()
        @ BUTTON "RefreshAll" ACTION b1:RefreshAll()
      END SIZER
      @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER
  END SIZER

//   b1:Fit()

  b1:GoTopBlock := {|| b1:cargo := 1 }
  b1:GoBottomBlock := {|| b1:cargo := Len( a ) }
  b1:SkipBlock := {|n| oldPos := b1:cargo, b1:cargo := iif( n < 0, Max( 1, b1:cargo + n ), Min( Len( a ), b1:cargo + n ) ), b1:cargo - oldPos }

//   ADD BCOLUMN b1 "#" BLOCK {|| a[ b1:RecNo ] }
  ADD BCOLUMN ZERO b1 BLOCK {|| b1:cargo }
  ADD BCOLUMN b1 "#" BLOCK {|| a[ b1:cargo ] }

  b2:AddAllColumns()

  @ STATUSBAR

  SHOW WINDOW oWnd CENTRE

RETURN .T.

/*
  AddTable
  Teo. Mexico 2008
*/
STATIC PROCEDURE AddTable( oWnd, auiNb )
  LOCAL b1
  LOCAL fileDlg
  LOCAL tableName

  fileDlg := wxFileDialog():New( oWnd,,,,"*.dbf", wxFD_MULTIPLE )

  IF fileDlg:ShowModal() != wxID_OK
    RETURN
  ENDIF

  FOR EACH tableName IN fileDlg:GetPaths()
    b1 := wxhBrowse():New( tableName, auiNb )
    auiNb:AddPage( b1, tableName, .T. )
    b1:AddAllColumns()
  NEXT

RETURN
