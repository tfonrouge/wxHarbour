/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
  helloworld1 : OOP approach.
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
  LOCAL menuBar,menu1,menu2
  LOCAL boxSizer, button
  LOCAL panel
  LOCAL sb

  oWnd := wxFrame():New( , 999, "Hello World Sample 1", {10,10}, {400,200} )

  menuBar := wxMenubar():New()
  menu1 := wxMenu():New()
  menu1:Append( 10, "New" )
  menu1:AppendSeparator()
  menu1:Append( 11, E"Open \tCtrl+O" )
  menu1:AppendSeparator()
  menu1:Append( wxID_EXIT, E"Quit \tCtrl-Q" )
  menu2 := wxMenu():New()
  menu2:Append( 20, "About..." )
  menuBar:Append( menu1, "&File" )
  menuBar:Append( menu2, "Help" )
  oWnd:Connect( wxID_EXIT, wxEVT_COMMAND_MENU_SELECTED, {|| oWnd:Close } )
  oWnd:SetMenuBar( menuBar )

  panel := wxPanel():New( oWnd )

  panel:SetSizer( boxSizer := wxBoxSizer():New( wxVERTICAL ) )

  /* spacer */
  boxSizer:Add(5, 5, 1, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5)

  boxSizer:Add( wxTextCtrl():New( panel, -1, "Any Value" ), 0, HB_BITOR( wxGROW, wxALL ), 5 )

  button := wxButton():New( panel, wxID_OK )

  boxSizer:Add( button, 0, HB_BITOR( wxALIGN_RIGHT, wxALL ), 5 )

  oWnd:Connect( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )

  sb := wxStatusBar():New( oWnd )
  oWnd:SetStatusBar( sb )

  oWnd:Show()

RETURN .T.
