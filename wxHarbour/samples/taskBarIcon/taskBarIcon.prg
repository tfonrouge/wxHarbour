/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxTaskBarIcon sample
  Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"

/*
  Main : Needed in all wx* apps
  Teo. Mexico 2009
*/
FUNCTION Main()

  IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2009
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
  DATA taskBarIcon
PUBLIC:
  DATA mainWnd
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
  LOCAL icon
  LOCAL bmType

  CREATE FRAME ::mainWnd ;
         WIDTH 640 HEIGHT 400 ;
         TITLE "TaskBarIcon Sample"

  BEGIN BOXSIZER VERTICAL
    @ SPACER STRETCH
    @ BUTTON ID wxID_CLOSE ACTION ::mainWnd:Close() SIZERINFO ALIGN RIGHT
  END SIZER

  SHOW WINDOW ::mainWnd FIT CENTRE

  icon := wxIcon():New()
#ifdef HB_OS_WIN_32
  bmType := wxBITMAP_TYPE_ICO
#else
  bmType :=wxBITMAP_TYPE_XPM
#endif
  icon:LoadFile("sample.ico",bmType)

  ::taskBarIcon := MyTaskBarIcon():New()
  ::taskBarIcon:SetIcon( icon, "This is the TaskBarIcon Sample tooltip" )

RETURN .T.

CLASS MyTaskBarIcon FROM wxTaskBarIcon
  METHOD CreatePopupMenu
ENDCLASS

METHOD FUNCTION CreatePopupMenu CLASS MyTaskBarIcon
  LOCAL menu

  DEFINE MENU VAR menu ON Self
    ADD MENUITEM "Open" ACTION wxGetApp():mainWnd:Show( .T. )
    DEFINE MENU "Sub"
      ADD MENUITEM "Sub-Item"
      ADD MENUITEM "Sub-Item"
      ADD MENUITEM "Sub-Item"
    ENDMENU
    ADD MENUITEM "About" ACTION wxMessageBox("Close","TaskBarIcon",wxICON_INFORMATION)
    ADD MENUSEPARATOR
    ADD MENUITEM "Remove Tray Icon" ACTION ::RemoveIcon()
    ADD MENUITEM "Hide Window" ACTION wxGetApp():mainWnd:Hide()
  ENDMENU

RETURN menu
