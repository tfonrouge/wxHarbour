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
  LOCAL boxSizer, button, grid, gtable

  CREATE WINDOW oWnd ;
         FROM 10,10 SIZE 200,400 ;
         ID 999 ;
         TITLE "Arel v8.0 Linux"

  DEFINE MENUBAR //menuBar
    DEFINE MENU "&Programa"
      ADD MENUITEM "Configuracion del Programa"+Chr(9)+"Ctrl+P" ACTION WndLogin( oWnd )
      ADD MENUITEM "Seguridad del Programa"
      ADD SEPARATOR
      ADD MENUITEM "Impresoras Disponibles Ctrl+P"
      ADD MENUITEM "Ventanas Activas"
      ADD SEPARATOR
      ADD MENUITEM "Salir..."+Chr(9)+"Ctrl+X" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Sale del Arel..."
    ENDMENU
    DEFINE MENU "Help"
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

  boxSizer:Add(5, 5, 1, wxALIGN_RIGHT | wxALL, 5)

  button := wxButton():New( oWnd, wxID_OK )

  boxSizer:Add( button, 0, wxALIGN_RIGHT | wxALL, 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close } )

  DEFINE STATUSBAR ON oWnd

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

  CREATE WINDOW oW ;
         FROM 0,0 SIZE 100,200 ;
         TITLE "Acceso" ;
         PARENT wndParent

  oW:Show()

RETURN


/*
  EndClass MyApp
*/






