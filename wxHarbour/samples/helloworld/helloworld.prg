/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxarel
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

/*
  Main : Needed in all wx* apps
  Teo. Mexico 2007
*/
FUNCTION Main()
  LOCAL MyApp

  MyApp := MyApp():New()

  IMPLEMENT_APP( MyApp )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2006
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
  Teo. Mexico 2006
*/
METHOD FUNCTION OnInit() CLASS MyApp
  LOCAL oWnd
  LOCAL edtNombre,edtPassword

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 400,400 ;
         ID 999 ;
         TITLE "Hello World Sample"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      DEFINE MENU "New"
        ADD MENUITEM "From A"
        ADD MENUITEM "From B"
      ENDMENU
      ADD SEPARATOR
      ADD MENUITEM E"Open \tCtrl+O"
      ADD SEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits the program..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENUBAR

  BEGIN BOXSIZER VERTICAL
    @ SAY "Simple Text Label"
    @ SPACER
    BEGIN GRIDSIZER COLS 3 ALIGN LEFT
      @ BUTTON "1" WIDTH 30
      @ BUTTON "2" WIDTH 30
      @ BUTTON "3" WIDTH 30
      @ BUTTON "4" WIDTH 30
      @ BUTTON "5" WIDTH 30
      @ BUTTON "6" WIDTH 30
      @ BUTTON "7" WIDTH 30
      @ BUTTON "8" WIDTH 30
      @ BUTTON "9" WIDTH 30
    END SIZER
    BEGIN BOXSIZER VERTICAL LABEL "Access" ALIGN EXPAND
      @ SAY "Name:" WIDTH 50 STYLE RIGHT GET edtNombre
      @ SAY "Password:" WIDTH 50 STYLE RIGHT GET edtPassword SIDEBORDERS 0x0800
    END SIZER
    @ SAY "More Text"
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_CANCEL
      @ BUTTON ID wxID_OK
    END SIZER
  END SIZER

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )

  CREATE STATUSBAR ON oWnd

  oWnd:Show()

RETURN .T.
