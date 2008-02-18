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
FUNCTION OnInit() CLASS MyApp
  LOCAL oWnd
  LOCAL boxSizer, button

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 400,200 ;
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

  oWnd:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )

  boxSizer:Add( 5, 5, 1, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5)

  boxSizer:Add( wxStaticText():New( oWnd, , "Enter Your Name:"), 0, HB_BITOR( wxGROW, wxALL ), 5 )
  boxSizer:Add( wxTextCtrl():New( oWnd, -1, "" ), 0, HB_BITOR( wxGROW, wxALL ), 5 )

  button := wxButton():New( oWnd, wxID_OK )

  boxSizer:Add( button, 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )

  CREATE STATUSBAR ON oWnd

  oWnd:Show()

RETURN .T.
