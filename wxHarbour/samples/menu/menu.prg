/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  menu sample
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "wxharbour.ch"

/*
  Main
  Teo. Mexico 2009
*/
FUNCTION Main()
  LOCAL MyApp

  MyApp := MyApp():New()

  IMPLEMENT_APP( MyApp )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2009
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
  DATA oWnd
  DATA Menu
  METHOD OnInit
PUBLISHED:
ENDCLASS

/*
  EndClass MyApp
*/

/*
  OnInit
  Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp

  ::Menu := { NIL, NIL, NIL }

  CREATE FRAME ::oWnd ;
         WIDTH 800 HEIGHT 600 ;
         TITLE "Menu Sample"

  DEFINE MENUBAR  VAR ::Menu[ 1 ]
    DEFINE MENU "&File"  VAR ::Menu[ 2 ]
      ADD MENUITEM E"Open \tF1"  VAR ::Menu[ 3 ] ACTION {|| Open( ::oWnd ) }
//       ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() HELPLINE "Quits this sample..."
    ENDMENU
/*    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU*/
  ENDMENU

  SHOW WINDOW ::oWnd

RETURN .T.

STATIC PROCEDURE Open( parentWnd )
  LOCAL oDlg

  CREATE DIALOG oDlg ;
         PARENT parentWnd

  SHOW WINDOW oDlg MODAL

RETURN
