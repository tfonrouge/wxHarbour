/*
 * main
 * Teo. Mexico 2008
 */

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

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

  ? "Login:",Login():ClassName

RETURN .T.

/*
  Login
*/
FUNCTION Login
  LOCAL oWnd
  LOCAL edtNombre
  LOCAL edtPassword
  LOCAL bClassInfo
  LOCAL btn1,btn2,btn3

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 400,500 ;
         ID 999 ;
         TITLE "System Login"

  DEFINE MENUBAR
    DEFINE MENU "&File"
      DEFINE MENU "New"
        ADD MENUITEM "From A"
        ADD MENUITEM "From B"
      ENDMENU
      ADD MENUSEPARATOR
      ADD MENUITEM E"Open \tCtrl+O"
      ADD MENUSEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits the program..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  oWnd:Centre( HB_BITOR( wxVERTICAL, wxHORIZONTAL) )

  BEGIN BOXSIZER VERTICAL
    @ SAY "Simple Text Label"
    @ SPACER
    BEGIN GRIDSIZER COLS 3 /*ALIGN LEFT*/
      @ BUTTON "1" VAR btn1 WIDTH 30
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
      @ SAY "Password:" WIDTH 50 STYLE RIGHT GET edtPassword SIZER SIDEBORDERS 0x0800
    END SIZER
    @ SAY "More Text"
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON VAR btn2 ID wxID_CANCEL
      @ BUTTON VAR btn3 ID wxID_OK
    END SIZER
  END SIZER

  bClassInfo := {|| btn1:ClassInfo(),btn2:ClassInfo(),btn3:ClassInfo(),oWnd:ClassInfo() }

  oWnd:Connect( wxID_CANCEL, wxEVT_COMMAND_BUTTON_CLICKED, bClassInfo )
  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )
//   oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:EndModal() } )

  @ STATUSBAR

  SHOW WINDOW oWnd

  ? "Aqui termina..."

RETURN oWnd
// RETURN oWnd:ShowModal()
