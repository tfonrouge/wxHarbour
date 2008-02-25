/*
 * Login
 * Teo. Mexico 2008
 */

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

FUNCTION Login()
  LOCAL oWnd
  LOCAL edtNombre
  LOCAL edtPassword

  CREATE DIALOG oWnd ;
         FROM 10,10 SIZE 400,500 ;
         ID 999 ;
         TITLE "System Login"

  /*
  DEFINE MENUBAR
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
  */

  oWnd:Centre( HB_BITOR( wxVERTICAL, wxHORIZONTAL) )

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

  // oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:EndModal() } )
  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:EndModal() } )

  // CREATE STATUSBAR

  oWnd:Show( .F. )

RETURN oWnd:ShowModal()
