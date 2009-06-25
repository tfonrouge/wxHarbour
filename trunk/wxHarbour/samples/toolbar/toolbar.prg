/*
  toolBar sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"

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
  LOCAL oWnd
  LOCAL toolBar

  CREATE FRAME oWnd ;
         WIDTH 640 HEIGHT 400 ;
         TITLE "ToolBar Sample"
		 
  toolBar := oWnd:CreateToolBar()
  toolBar:AddControl( wxTextCtrl():New( toolBar ) )
  toolBar:AddSeparator()
  toolBar:AddControl( wxChoice():New( toolBar ) )
  toolBar:AddSeparator()
  toolBar:AddTool( -1, "File Open", wxBitmap():New( "fileopen.xpm", wxBITMAP_TYPE_XPM ), wxBitmap():New() )
  toolBar:AddTool( -1, "Help", wxBitmap():New( "helpicon.xpm", wxBITMAP_TYPE_XPM ), wxBitmap():New() )
  toolBar:Realize()
  
  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits this sample..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  SHOW WINDOW oWnd CENTRE

RETURN .T.
