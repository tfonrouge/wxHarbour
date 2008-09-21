/*
  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxarel
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

#include "wxh/textctrl.ch"

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
  LOCAL edtNombre,edtPassword
  LOCAL boxSizer,staticBoxSizer,noteBook,panel,button

  CREATE FRAME oWnd ;
         TITLE "Hello World Sample"

  DEFINE MENUBAR STYLE 1 ON oWnd
    DEFINE MENU "&File"
      DEFINE MENU "New"
        ADD MENUITEM "From A"
        ADD MENUITEM "From B"
      ENDMENU
      ADD MENUSEPARATOR
      ADD MENUITEM E"Open \tCtrl+O"
      ADD MENUSEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
          HELPLINE "Quits the program..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  ? edtNombre, edtPassword
  ? boxSizer, panel, noteBook, staticBoxSizer, button

/*
  boxSizer := wxStaticBoxSizer():New( wxVERTICAL, oWnd, "Hello" )
  oWnd:SetSizer( boxSizer )
  noteBook := wxNoteBook():New( oWnd )
  noteBook:AddPage( wxPanel():New( noteBook, , , , HB_BITOR( wxSUNKEN_BORDER, wxTAB_TRAVERSAL) ), "Tab1" )
  boxSizer:Add( noteBook, 1, HB_BITOR( wxGROW, wxALL ) )
*/

  BEGIN BOXSIZER VERTICAL
    BEGIN BOXSIZER VERTICAL LABEL "Access" ALIGN EXPAND
      @ SAY "Name:" WIDTH 70 STYLE RIGHT GET edtNombre NAME "Name" STYLE wxTE_PROCESS_ENTER
      @ SAY "Password:" WIDTH 70 STYLE RIGHT GET edtPassword NAME "Pass" STYLE HB_BITOR( wxTE_PASSWORD, wxTE_PROCESS_ENTER )
      @ BUTTON
      @ BUTTON
    END SIZER
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ SPACER WIDTH 30
      @ BUTTON ID wxID_CANCEL
      @ BUTTON ID wxID_OK
    END SIZER
  END SIZER

//   boxSizer := wxBoxSizer():New( wxVERTICAL )
//   oWnd:SetSizer( boxSizer )
//
//   button := wxButton():New( oWnd, -1, "Button 1")
//   boxSizer:Add( button, 0, wxALIGN_CENTER_HORIZONTAL )
//
//   staticBoxSizer := wxStaticBoxSizer():New( wxVERTICAL, oWnd, "Inside" )
//   boxSizer:Add( staticBoxSizer )
//
//   panel := wxPanel():New( oWnd )
//   staticBoxSizer:Add( panel )

/*    BEGIN PANEL VAR panel //SIZER ALIGN EXPAND STRETCH
    END PANEL*/
  //BEGIN NOTEBOOK VAR noteBook
  //END NOTEBOOK
//     noteBook := wxNotebook( panel )
//
//   BEGIN BOXSIZER VERTICAL VAR boxSizer // LABEL "1"
//     @ SAY "Simple Text Label" SIZER ALIGN LEFT
//     @ SPACER
//     BEGIN GRIDSIZER COLS 3 ALIGN CENTER
//       @ BUTTON "1" WIDTH 30
//       @ BUTTON "2" WIDTH 30
//       @ BUTTON "3" WIDTH 30
//       @ BUTTON "4" WIDTH 30
//       @ BUTTON "5" WIDTH 30
//       @ BUTTON "6" WIDTH 30
//       @ BUTTON "7" WIDTH 30
//       @ BUTTON "8" WIDTH 30
//       @ BUTTON "9" WIDTH 30
//     END SIZER
//     BEGIN BOXSIZER VERTICAL LABEL "Access" ALIGN EXPAND
//       @ SAY "Name:" WIDTH 70 STYLE RIGHT GET edtNombre WIDTH 200 SIZER STRETCH
//       @ SAY "Password:" WIDTH 70 STYLE RIGHT SIZER ALIGN EXPAND GET edtPassword WIDTH 200 STYLE wxTE_PASSWORD SIZER STRETCH
//     END SIZER
//     @ SAY "More Text"
//     BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
//       @ BUTTON ID wxID_CANCEL
//       @ BUTTON ID wxID_OK ACTION oWnd:Close()
//     END SIZER
//   END SIZER

//   BEGIN BOXSIZER VERTICAL LABEL "- Main -"
//     @ BUTTON SIZER STRETCH
//     BEGIN BOXSIZER VERTICAL LABEL "- 1 -" STRETCH ALIGN EXPAND
//     END SIZER
//     BEGIN BOXSIZER VERTICAL LABEL "- 2 -"
//     END SIZER
//     BEGIN BOXSIZER VERTICAL LABEL "- 3 -"
//     END SIZER
//   END SIZER

  //@ STATUSBAR ON oWnd

  SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
