/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  DbBrowser: Simple browser
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
/*
  EndClass MyApp
*/

REQUEST DBFCDX

/*
  OnInit
  Teo. Mexico 2006
*/
FUNCTION OnInit() CLASS MyApp
  LOCAL Success := .T.
  LOCAL oWnd := Self
  LOCAL grid, boxSizer, gtable, button

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 600,400 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

  CREATE MENUBAR STYLE 1
    CREATE MENU "&Program"
      ADD MENUITEM "Open Another window"+Chr(9)+"Ctrl+O" ACTION WndLogin( oWnd )
      ADD SEPARATOR
      ADD MENUITEM "Printers"+Chr(9)+"Ctrl+P"
      ADD SEPARATOR
      ADD MENUITEM "Exit..."+Chr(9)+"Ctrl+X" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    CREATE MENU "Help"
      ADD MENUITEM "About..."
      ADD MENUITEM "Fit Grid" ACTION grid:Fit()
    ENDMENU
  ENDMENUBAR

  oWnd:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )

  grid := wxGrid():New( oWnd, wxID_ANY, {-1,-1}, {200,150}, wxSUNKEN_BORDER|wxHSCROLL|wxVSCROLL  )
  grid:SetDefaultColSize( 50 )
  grid:SetDefaultRowSize( 25 )
  grid:SetColLabelSize(25)
  grid:SetRowLabelSize(50)

  USE "main" VIA "DBFCDX"
  OrdSetFocus("X01")

  gtable := wxGridTableBaseDb():New()
  grid:SetTable( gtable )

  boxSizer:Add(grid, 1, wxGROW|wxALL, 5)

  //boxSizer:Add(5, 5, 1, wxALIGN_RIGHT | wxALL, 5)

  button := wxButton():New( oWnd, wxID_OK )

  boxSizer:Add( button, 0, wxALIGN_RIGHT | wxALL, 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close } )

  CREATE STATUSBAR FIELDS 5 WIDTHS 100,-1,100,-1,-1  //ON oWnd

  oWnd:Center( wxBOTH )

  oWnd:Show()

RETURN .T.

/*
  WndLogin: A simple dialog
  Teo. Mexico 2006
*/
PROCEDURE WndLogin( wndParent )
  LOCAL oW
  STATIC n := 0

  IF oW != NIL
    IF oW:IsShown()
      oW:Hide()
    ELSE
      oW:Show()
    ENDIF
    RETURN
  ENDIF

  CREATE DIALOG oW ;
         FROM -1,-1 SIZE 200,100 ;
         TITLE "Acceso: " + LTrim(Str( ++ n )) ;
         PARENT wndParent

  oW:Show(.T.)

RETURN





