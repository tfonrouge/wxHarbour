/*
 * $Id$
 */

/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxarel
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

#include "wxh/textctrl.ch"

/*
  Main : Needed in all wx* apps
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
  LOCAL oDlg
  LOCAL edtNombre,edtMemo,edtPassword

  edtNombre := wxGetUserId()
  edtMemo := ""
  edtPassword := "password"

  CREATE DIALOG oDlg ;
         WIDTH 640 HEIGHT 400 ;
         TITLE "Text Sample"

  BEGIN BOXSIZER VERTICAL
    BEGIN NOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
      ADD BOOKPAGE " 1 " FROM
        BEGIN PANEL
          BEGIN BOXSIZER VERTICAL ALIGN EXPAND
            @ SAY "Single Line:" WIDTH 70 GET edtNombre ID 999 NAME "Single" STYLE wxTE_PROCESS_ENTER
            @ SAY "Multi Line:" WIDTH 70 GET edtMemo NAME "Multi" MULTILINE STYLE wxTE_PROCESS_ENTER //SIZERINFO STRETCH
            @ SAY "Password:" WIDTH 70 GET edtPassword NAME "Pass" WIDTH 200 STYLE wxTE_PASSWORD
          END SIZER
        END PANEL
    END NOTEBOOK
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_OK ACTION oDlg:Close()
    END SIZER
  END SIZER

  oDlg:ConnectCommandEvt( oDlg:FindWindowByName("Single"):GetId(), wxEVT_COMMAND_TEXT_ENTER, {|| oDlg:FindWindowByName("Pass"):SetFocus() } )
  //oDlg:ConnectCommandEvt( g1:GetId(), wxEVT_COMMAND_TEXT_UPDATED, {|| OnUpdate( g1 ) } )

  SHOW WINDOW oDlg MODAL CENTRE

  oDlg:Destroy()

  ? "edtNombre:", edtNombre
  ? "edtMemo:", edtMemo
  ? "edtPassword:", edtPassword

RETURN .T.
