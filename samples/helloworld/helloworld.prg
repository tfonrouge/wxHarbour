/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxarel
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx/wx.ch"
#include "wxharbour.ch"


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

REQUEST DBFCDX

/*
  OnInit
  Teo. Mexico 2006
*/
FUNCTION OnInit() CLASS MyApp
  LOCAL Success := .T.
  LOCAL oWnd := Self
  //LOCAL menuBar,menu1,menu2
  LOCAL boxSizer, button

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 400,200 ;
         ID 999 ;
         TITLE "Hello World Sample"

  CREATE MENUBAR
    CREATE MENU "&Program"
      ADD MENUITEM E"Configuration \tCtrl+C" ACTION WndLogin( oWnd )
      ADD MENUITEM "Security"
      ADD SEPARATOR
      ADD MENUITEM E"Printers \tCtrl+P"
      ADD MENUITEM "Available tasks"
      ADD SEPARATOR
      ADD MENUITEM "Exit \tCtrl+X" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits the program..."
    ENDMENU
    CREATE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENUBAR

  /*
  menuBar := wxMenubar():New()
  menu1 := wxMenu():New()
  menu1:Append( 10, "Configuración del Programa" )
  menu1:Append( 11, "Seguridad del Programa" )
  menu1:AppendSeparator()
  menu1:Append( 12, "Impresoras Disponibles"+Chr(9)+"Ctrl+I" )
  menu1:Append( 13, "Ventanas Activas" )
  menu1:AppendSeparator()
  menu1:Append( wxID_EXIT, "Salir..."+Chr(9)+"Ctrl-X" )
  menu2 := wxMenu():New()
  menu2:Append( 20, "Index"+Chr(9)+"F1" )
  menuBar:Append( menu1, "Programa" )
  menuBar:Append( menu2, "Help" )
  oWnd:Connect( wxID_EXIT, wxEVT_COMMAND_MENU_SELECTED, {|| oWnd:Close } )
  oWnd:SetMenuBar( menuBar )
  */

  oWnd:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )

  boxSizer:Add(5, 5, 1, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5)

  button := wxButton():New( oWnd, wxID_OK )

  boxSizer:Add( button, 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )

  boxSizer:Add( wxTextCtrl():New( oWnd, -1, "Any Value" ), 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )

  CREATE STATUSBAR ON oWnd

  oWnd:Show()

RETURN .T.

PROCEDURE WndLogin( wndParent )
  STATIC oW

  IF oW != NIL
    IF oW:IsShown()
      oW:Hide()
    ELSE
      oW:Show()
    ENDIF
    RETURN
  ENDIF

  CREATE DIALOG oW ;
         FROM 0,0 SIZE 100,200 ;
         TITLE "Acceso" ;
         PARENT wndParent

  oW:Show( .T. )

RETURN


/*
  EndClass MyApp
*/






