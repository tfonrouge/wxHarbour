/*
  wxhBrowse sample
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
  LOCAL bsVert,browse,button
  LOCAL x,y,a := {}
  LOCAL nCols := 5
  LOCAL nRows := 2

  FOR x := 1 TO nRows
    AAdd( a, {} )
    FOR y := 1 TO nCols
      AAdd( ATail( a ), HB_Random( 1000 ) )
    NEXT
  NEXT

  CREATE FRAME oWnd ;
         WIDTH 800 HEIGHT 600 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

//   DEFINE MENUBAR STYLE 1 ON oWnd
//     DEFINE MENU "&File"
//       ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
//           HELPLINE "Quits this sample..."
//     ENDMENU
//     DEFINE MENU "Help"
//       ADD MENUITEM "Fit Grid" //ACTION browse:Fit()
//       ADD MENUSEPARATOR
//       ADD MENUITEM "About..."
//     ENDMENU
//   ENDMENU

  bsVert := wxBoxSizer():New( wxVERTICAL )
  oWnd:SetSizer( bsVert )

  browse := wxhBrowse():New( a, oWnd )
//   browse := wxPanel():New( oWnd )

  bsVert:Add( browse, 1, HB_BitOr( wxGROW, wxALL ), 5 )

  button := wxButton():New( oWnd, 100,"Close" )

  bsVert:Add( button, 0, HB_BitOr( wxALIGN_RIGHT, wxALIGN_RIGHT ), 5 )

  button:ConnectCommandEvt( 100, wxEVT_COMMAND_BUTTON_CLICKED, {|evt| evt:GetEventObject():GetParent():Close() } )

//   @ STATUSBAR

  SHOW WINDOW oWnd CENTRE

RETURN .T.
