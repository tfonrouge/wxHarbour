/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  menu sample
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "wxharbour.ch"

/*
  Main
  Teo. Mexico 2009
*/
FUNCTION Main()
  LOCAL MyApp

  MyApp := MyApp():New()

  IMPLEMENT_APP( MyApp )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2009
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
  Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp
  STATIC oWnd
  LOCAL menuBar
  LOCAL menu
  LOCAL sb

  CREATE FRAME oWnd ;
         WIDTH 800 HEIGHT 600 ;
         TITLE "Menu Sample"

  menuBar := wxMenubar():New()
  menu := wxMenu():New()

  menu:Append( wxID_CLOSE, "Opcion 1" )
  menu:Append( wxID_CLOSE, "Opcion 2" )

  menuBar:Append( menu, "Archivo" )

  oWnd:SetMenuBar( menuBar )

  sb := wxStatusBar():New( oWnd )

  oWnd:SetStatusBar( sb )

  SHOW WINDOW oWnd

RETURN .T.

/*
  Open a new Dialog MODAL
*/
STATIC PROCEDURE Open( parentWnd )
  LOCAL oDlg
  parentWnd := NIL

  CREATE DIALOG oDlg ;
         PARENT parentWnd

//   BEGIN BOXSIZER VERTICAL
    @ BUTTON "Cerrar" ID wxID_CLOSE
//   END SIZER

//   wxButton():New( oDlg, wxID_ANY, "CloseT" )

  SHOW WINDOW oDlg MODAL

RETURN
