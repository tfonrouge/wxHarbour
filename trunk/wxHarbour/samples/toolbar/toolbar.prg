/*
  toolBar sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"

FUNCTION Main
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
  LOCAL name := wxGetUserName()
  LOCAL ch1
  LOCAL cb1

  CREATE FRAME oWnd ;
         WIDTH 640 HEIGHT 400 ;
         TITLE "ToolBar Sample"

  BEGIN FRAME TOOLBAR
	@ SAY "Your Name is:"
	@ GET name
	@ TOOL SEPARATOR
	@ CHOICE ch1 ITEMS {"One","Two","Three"}
	@ TOOL SEPARATOR
	@ TOOL CHECK ID 500 LABEL "Check Tool" BITMAP "find.xpm" SHORTHELP "This is a Check Tool" LONGHELP "LongHelp" ACTION {|| wxMessageBox("","Check Tool Executed...") }
	@ TOOL SEPARATOR
	@ TOOL RADIO ID 900 BITMAP "find.xpm" SHORTHELP "Tool Radio 1" ACTION {|| wxMessageBox("Tool Radio 1") }
	@ TOOL RADIO ID 901 BITMAP "find.xpm" SHORTHELP "Tool Radio 2" ACTION {|| wxMessageBox("Tool Radio 2") }
	@ TOOL RADIO ID 902 BITMAP "find.xpm" SHORTHELP "Tool Radio 3" ACTION {|| wxMessageBox("Tool Radio 3") }
	@ TOOL SEPARATOR
	@ TOOL BUTTON ID 1000 BITMAP "find.xpm"  SHORTHELP "Tool Button" ACTION {|| wxMessageBox("","Tool Button Executed...") }
	@ TOOL SEPARATOR
	@ COMBOBOX cb1 ITEMS {"MacOS","Linux","Windows"}
  END TOOLBAR
  
  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
