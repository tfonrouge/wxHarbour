/*
  button sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"

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

  CREATE FRAME oWnd ;
         WIDTH 800 HEIGHT 600 ;
         TITLE "Button Sample"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER HORIZONTAL
      @ BUTTON ID wxID_OPEN BITMAP "fileopen.xpm"
      @ BUTTON ID wxID_CLOSE
      @ BUTTON "CLOSE" ID wxID_NEW BITMAP "find.xpm" STYLE 4
      @ BUTTON ID wxID_SAVE BITMAP "print.xpm"
      @ BUTTON ID wxID_CANCEL BITMAP "bitmap2.bmp"
      @ BUTTON ID wxID_EXIT BITMAP "quit.xpm" ACTION oWnd:Close() //SIZERINFO ALIGN RIGHT
  END SIZER

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
