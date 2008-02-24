/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  DbBrowser: Simple browser
  Teo. Mexico 2006
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
  LOCAL grid, boxSizer, gtable, button
  LOCAL panel

  CREATE FRAME oWnd ;
         FROM 10,10 SIZE 600,400 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Open \tCtrl+O"
      ADD SEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION grid:Fit()
      ADD SEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENUBAR

  panel := wxPanel():New( oWnd )

  panel:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )

  grid := wxGrid():New( panel, wxID_ANY, {-1,-1}, {200,150}, HB_BITOR(wxSUNKEN_BORDER,wxHSCROLL,wxVSCROLL) )
  grid:SetDefaultColSize( 50 )
  grid:SetDefaultRowSize( 25 )
  grid:SetColLabelSize(25)
  grid:SetRowLabelSize(50)

  USE "main" //VIA "DBFCDX"
  //OrdSetFocus("X01")

  gtable := wxGridTableBaseDb():New()
  grid:SetTable( gtable )

  boxSizer:Add(grid, 1, HB_BITOR( wxGROW, wxALL ), 5)

  //boxSizer:Add(5, 5, 1, wxALIGN_RIGHT | wxALL, 5)

  button := wxButton():New( panel, wxID_OK )

  boxSizer:Add( button, 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close } )

  CREATE STATUSBAR FIELDS 5 WIDTHS 100,-1,100,-1,-1  ON oWnd

  oWnd:Centre( wxBOTH )

  oWnd:Show()

RETURN .T.
