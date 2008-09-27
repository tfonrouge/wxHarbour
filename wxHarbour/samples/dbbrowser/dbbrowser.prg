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
METHOD FUNCTION OnInit() CLASS MyApp
  LOCAL oWnd
  LOCAL b

  CREATE FRAME oWnd ;
         WIDTH 600 HEIGHT 400 ;
         ID 999 ;
         TITLE "Simple Dbf Browser"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Open \tCtrl+O"
      ADD MENUSEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "Fit Grid" ACTION b:Fit()
      ADD MENUSEPARATOR
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
      BEGIN BOXSIZER VERTICAL "1"
      END SIZER
      BEGIN BOXSIZER VERTICAL "2" ALIGN EXPAND STRETCH
	BEGIN AUINOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
          @ BUTTON "Uno"
          @ BUTTON "Dos"
	END AUINOTEBOOK
      END SIZER
    END SIZER
    BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
      @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER
  END SIZER

//   panel := wxPanel():New( oWnd )
// 
//   panel:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )
// 
//   grid := wxGrid():New( panel, wxID_ANY, {-1,-1}, {200,150}, HB_BITOR(wxSUNKEN_BORDER,wxHSCROLL,wxVSCROLL) )
//   grid:SetDefaultColSize( 50 )
//   grid:SetDefaultRowSize( 25 )
//   grid:SetColLabelSize(25)
//   grid:SetRowLabelSize(50)
// 
//   USE "main" //VIA "DBFCDX"
//   //OrdSetFocus("X01")
// 
//   gtable := wxGridTableBaseDb():New()
//   grid:SetTable( gtable )
// 
//   boxSizer:Add(grid, 1, HB_BITOR( wxGROW, wxALL ), 5)
// 
//   //boxSizer:Add(5, 5, 1, wxALIGN_RIGHT | wxALL, 5)
// 
//   button := wxButton():New( panel, wxID_OK )
// 
//   boxSizer:Add( button, 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )
// 
//   oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close } )
// 
//   @ STATUSBAR
// 
//   oWnd:Centre( wxBOTH )
// 
//   oWnd:Show()

  @ STATUSBAR

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
