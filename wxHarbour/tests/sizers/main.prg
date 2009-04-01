/*
 * main
 * Teo. Mexico 2008
 */

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

#include "wxh/textctrl.ch"

FUNCTION Main()
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

  ? "Login:",Login():ClassName

RETURN .T.

/*
  Login
*/
FUNCTION Login
  LOCAL oWnd
  LOCAL edtNombre
  LOCAL edtPassword
  LOCAL treeCtrl, treeItemId
  LOCAL i

  CREATE FRAME oWnd ;
         WIDTH 500 HEIGHT 400 ;
         ID 999 ;
         TITLE "System Login"

  DEFINE MENUBAR
    DEFINE MENU "&File"
      DEFINE MENU "New"
        ADD MENUITEM "From A"
        ADD MENUITEM "From B"
      ENDMENU
      ADD MENUSEPARATOR
      ADD MENUITEM E"Open \tCtrl+O"
      ADD MENUSEPARATOR
      ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION {|| oWnd:Close() } ;
          HELPLINE "Quits the program..."
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..."
    ENDMENU
  ENDMENU

  oWnd:Centre( HB_BITOR( wxVERTICAL, wxHORIZONTAL) )

  BEGIN BOXSIZER VERTICAL
    BEGIN BOXSIZER VERTICAL ""
      @ SAY "Simple Text Label Title"
    END SIZER
    BEGIN NOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
      ADD PAGE "Main" FROM
        BEGIN PANEL
          BEGIN BOXSIZER VERTICAL
            BEGIN GRIDSIZER COLS 3 /*ALIGN LEFT*/
              @ BUTTON "1" WIDTH 30
              @ BUTTON "2" WIDTH 30
              @ BUTTON "3" WIDTH 30
              @ BUTTON "4" WIDTH 30
              @ BUTTON "5" WIDTH 30
              @ BUTTON "6" WIDTH 30
              @ BUTTON "7" WIDTH 30
              @ BUTTON "8" WIDTH 30
              @ BUTTON "9" WIDTH 30
            END SIZER
            BEGIN BOXSIZER VERTICAL LABEL "Access" ALIGN CENTER
              @ SAY 	"Name:" WIDTH 80 GET edtNombre WIDTH 200
              @ SAY "Password:" WIDTH 80 GET edtPassword WIDTH 200 STYLE wxTE_PASSWORD
            END SIZER
          END SIZER
        END PANEL
      ADD PAGE "Secondary" FROM
        BEGIN PANEL
          BEGIN BOXSIZER HORIZONTAL "Main Box"
            BEGIN BOXSIZER VERTICAL "TreeCtrl" ALIGN EXPAND STRETCH
              @ TREECTRL VAR treeCtrl SIZERINFO STRETCH ALIGN EXPAND
              BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
                @ BUTTON "Expand" ACTION treeCtrl:ExpandAll()
                @ BUTTON "Collapse" ACTION treeCtrl:CollapseAll()
              END SIZER
            END SIZER
            BEGIN BOXSIZER VERTICAL "wxBrowseDb" ALIGN EXPAND STRETCH
              @ BROWSEDB TABLE "main.dbf" SIZERINFO ALIGN EXPAND STRETCH
              @ SAY "Some text"
            END SIZER
          END SIZER
        END PANEL
    END NOTEBOOK
    @ SAY "More Text"
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_CANCEL ACTION oWnd:Close()
      @ BUTTON ID wxID_OK ACTION oWnd:Close()
    END SIZER
  END SIZER

  @ STATUSBAR

  treeItemId := treeCtrl:AddRoot("Root")

  FOR i:=1 TO 10
    treeCtrl:AppendItem( treeItemId, "Item " + LTrim(Str(i)) )
  NEXT

  treeCtrl:AppendItem( treeCtrl:AppendItem( treeItemId, "Item2" ), "SubItem1" )
  treeCtrl:AppendItem( treeCtrl:AppendItem( treeCtrl:AppendItem( treeItemId, "Item3" ), "SubItem2" ), "SubSubItem1" )
  treeCtrl:AppendItem( treeItemId, "Item4" )

  treeCtrl:ExpandAll()

  SHOW WINDOW oWnd FIT CENTRE

RETURN oWnd
