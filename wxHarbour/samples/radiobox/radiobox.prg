/*
  radiobox sample
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
  LOCAL radioVal1
  LOCAL radioVal2
  LOCAL radioVal3
  LOCAL bAction

  bAction := {|event| wxMessageBox( event:GetEventObject():GetLabel() + ": " + event:GetEventObject():GetStringSelection(), "Status", wxICON_INFORMATION, oWnd ) }

  CREATE FRAME oWnd ;
         WIDTH 200 HEIGHT 100 ;
         ID 999 ;
         TITLE "RadioBox Sample"

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

    BEGIN BOXSIZER HORIZONTAL

      @ RADIOBOX radioVal1 LABEL "Number Selection" ITEMS {"one","two","three"} ACTION {|event| bAction:Eval( event ) }

      @ RADIOBOX radioval2 LABEL "OS Selection" ITEMS {"Windows","GNU Linux","Mac OS"} ACTION {|event| bAction:Eval( event ) }

    END SIZER

    @ RADIOBOX radioval3 LABEL "Upload VIA" MAJORDIM 1 ITEMS {"FTP","HTTP","RSYNC"} ACTION {|event| bAction:Eval( event ) }

    @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

  END SIZER

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
