/*
 * $Id$
 */

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

#include "wxh/textctrl.ch"

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

  edtNombre := wxGetUserId()
  edtPassword := Space( 20 )

  CREATE FRAME oWnd ;
         TITLE "Hello World Sample"

  DEFINE MENUBAR STYLE 1 ON oWnd
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

  BEGIN BOXSIZER VERTICAL
    BEGIN NOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
      BEGIN PANEL
        BEGIN BOXSIZER VERTICAL LABEL "Access" ALIGN EXPAND
          @ SAY "Name:" WIDTH 70 GET edtNombre NAME "Name" STYLE wxTE_PROCESS_ENTER
          ? "Password:", edtPassword
          @ SAY "Password:" WIDTH 70 GET edtPassword NAME "Pass" STYLE _hb_BitOr( wxTE_PASSWORD, wxTE_PROCESS_ENTER )
          @ BUTTON ID wxID_APPLY ACTION DoStuff( oWnd ) SIZERINFO ALIGN RIGHT
        END SIZER
      END PANEL
      BEGIN NOTEBOOK
        @ BUTTON
        @ BUTTON
        @ BUTTON
        @ BUTTON
        @ BUTTON
        @ BUTTON
        @ BUTTON
        @ BUTTON
      END NOTEBOOK
    END NOTEBOOK
    BEGIN BOXSIZER VERTICAL "uno"
      @ SAY "HOLA" //SIZERINFO STRETCH //GET edtNombre
    END SIZER
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_CANCEL ACTION {|| NIL }
      @ BUTTON ID wxID_OK ACTION oWnd:Close()
    END SIZER
  END SIZER


  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.

STATIC PROCEDURE DoStuff( oWnd )
  LOCAL i
  LOCAL frame
  LOCAL s

  FOR i:=1 TO 10

    CREATE FRAME frame ;
	   PARENT oWnd ;
	   TITLE "Window # " + NTrim( i )

    SHOW WINDOW frame

    //wxGetApp():NoRelease()
    //s := HB_Serialize( "Esta es uns Prueba. # " + NTrim( i ) )
    s := HB_Serialize( frame )
    ? "Serialize",i,Len( s ),s, "=", HB_DeSerialize( s ):ClassName

  NEXT

RETURN
