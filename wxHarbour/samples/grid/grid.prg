/*
  grid sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"

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
  STATIC oWnd
  LOCAL bsVert,panel,grid,bsHorz,staticLine,sbVert,button

  CREATE FRAME oWnd ;
         WIDTH 800 HEIGHT 600 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION grid:Fit()
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  bsVert := wxBoxSizer():New( wxVERTICAL )
  oWnd:SetSizer( bsVert )

  panel := wxPanel():New( oWnd )

  bsVert:Add( panel, 1, HB_BitOr( wxGROW, wxALL ), 5 )

  bsHorz := wxBoxSizer():New( wxHORIZONTAL )
  panel:SetSizer( bsHorz )

  grid := wxGrid():New( panel, NIL, NIL, NIL, HB_BitOr( wxSUNKEN_BORDER, wxHSCROLL, wxVSCROLL ) )
  grid:CreateGrid( 20, 5 )
  bsHorz:Add( grid, 1, HB_BitOr( wxGROW, wxALL ), 5 )

  staticLine := wxStaticLine():New( panel, NIL, NIL, NIL, wxLI_VERTICAL )
  bsHorz:Add( staticLine, 0, HB_BitOr( wxGROW, wxALL ), 5 )

  sbVert := wxScrollBar():New( panel, NIL, NIL, NIL, wxSB_VERTICAL )
  bsHorz:Add( sbVert, 0, HB_BitOr( wxGROW, wxALL ), 5 )

  button := wxButton():New( oWnd, NIL, "Button" )

  bsVert:Add( button, 0, HB_BitOr( wxALIGN_RIGHT, wxALIGN_RIGHT ), 5 )

  @ STATUSBAR

  SHOW WINDOW oWnd CENTRE

RETURN .T.
