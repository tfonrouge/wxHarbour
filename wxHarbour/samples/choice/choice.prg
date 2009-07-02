/*
  choice sample
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
  LOCAL choiceVal1 := 0
  LOCAL choiceVal2 := 1
  LOCAL choiceVal3 := 2
  LOCAL bAction

  bAction := {|event| wxMessageBox( "Value Selected: " + event:GetEventObject():GetStringSelection(), "Status", wxICON_INFORMATION, oWnd ) }

  CREATE FRAME oWnd ;
         TITLE "Choice Sample"

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

    @ CHOICE choiceVal1 ITEMS {"one","two","three"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT
    @ CHOICE choiceVal2 ITEMS {"Windows","GNU Linux","Mac OS"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT
    @ CHOICE choiceVal3 ITEMS {"FTP","HTTP","RSYNC"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT

    @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

  END SIZER

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
