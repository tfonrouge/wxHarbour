/*
  sayget sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"

#define GRANGE  100

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
  LOCAL name
  LOCAL cURL
  LOCAL comm

  name := "Juana la Cubana"
  cURL := ""
  comm := ""

  CREATE FRAME oWnd ;
         TITLE "Say/Get Sample"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL

    @ SAY "Name:" GET name
    @ SAY ABOVE "URL:" GET cURL WIDTH 400

    @ SAY ABOVE "Comment:" GET comm MULTILINE

    @ BUTTON ID wxID_APPLY ACTION wxMessageBox( E"Values entered:\n\nName: " + name + E"\n\nURL: " + cURL + E"\n\nComment:\n" + comm, "Values", wxICON_INFORMATION, oWnd )

    @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

  END SIZER

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
