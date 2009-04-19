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
#include "wx.ch"
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
METHOD FUNCTION OnInit() CLASS MyApp
  LOCAL oWnd
  LOCAL menuBar,menu1,menu2
  LOCAL boxSizer, boxSizer1
  LOCAL buttonOk, button1
  LOCAL panel
  LOCAL noteBook
  LOCAL itemStaticText6
  LOCAL statusBar
  LOCAL textCtrl
  LOCAL text1

  oWnd := wxFrame():New( , 999, "Hello World Sample 1", {10,10}, {400,400} )

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
  oWnd:ConnectCommandEvt( wxID_EXIT, wxEVT_COMMAND_MENU_SELECTED, {|| oWnd:Close } )
  oWnd:SetMenuBar( menuBar )

  panel := wxPanel():New( oWnd, , , , _hb_BitOr( wxSUNKEN_BORDER, wxTAB_TRAVERSAL) )

  boxSizer := wxBoxSizer():New( wxVERTICAL )//, oWnd, "Hello" )

  panel:SetSizer( boxSizer )

  noteBook := wxNoteBook():New( panel )
  noteBook:AddPage( wxPanel():New( noteBook, , , , _hb_BitOr( wxSUNKEN_BORDER, wxTAB_TRAVERSAL) ), "Tab1" )
  noteBook:AddPage( wxPanel():New( noteBook, , , , _hb_BitOr( wxSUNKEN_BORDER, wxTAB_TRAVERSAL) ), "Tab2" )
  noteBook:AddPage( wxPanel():New( noteBook, , , , _hb_BitOr( wxSUNKEN_BORDER, wxTAB_TRAVERSAL) ), "Tab3" )

  boxSizer:Add( noteBook, 1, _hb_BitOr( wxGROW, wxALL ) )

  /* spacer */
  //boxSizer:Add(5, 5, 1, _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL ), 5)

  boxSizer1 := wxBoxSizer():New( wxHORIZONTAL )

  boxSizer:Add( boxSizer1, 0, _hb_BitOr( wxGROW, wxALL ), 5 )

  itemStaticText6 := wxStaticText():New( panel, -1, "Enter Your Name NIÑO:" )

  boxSizer1:Add( itemStaticText6, 0, _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL ), 5 )

  text1 := "NI" + Chr( 165 ) + "OS"
  text1 := _( text1 )

  boxSizer1:Add( textCtrl := wxTextCtrl():New( panel, -1, text1 ), 1, _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL ), 5 )

  button1 := wxButton():New( panel , 100 )
  buttonOk := wxButton():New( panel, wxID_OK )

  boxSizer:Add( button1, 0, _hb_BitOr( wxALIGN_RIGHT, wxALL ), 5 )
  boxSizer:Add( buttonOk, 0, _hb_BitOr( wxALIGN_RIGHT, wxALL ), 5 )

  oWnd:ConnectCommandEvt( 100, wxEVT_COMMAND_BUTTON_CLICKED, {|| PrintValue( textCtrl ) } )
  oWnd:ConnectCommandEvt( wxID_OK, wxEVT_COMMAND_BUTTON_CLICKED, {|| oWnd:Close() } )

  statusBar := wxStatusBar():New( oWnd )
  statusBar:SetFieldsCount( 5 )
  oWnd:SetStatusBar( statusBar )

  oWnd:Show()

RETURN .T.

/*
  PrintValue
  Teo. Mexico 2007
*/
PROCEDURE PrintValue( textCtrl )
  ? textCtrl:GetValue()
RETURN

FUNCTION _( s )
RETURN HB_StrToUTF8( s )
