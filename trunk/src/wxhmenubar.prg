/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxMenuBar
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"

STATIC oGlobal

/*
  TGlobal class to hold global vars...
  Teo. Mexico 2007
*/
CLASS TGlobal
PRIVATE:
PROTECTED:
PUBLIC:
  DATA g_menuID INIT 1
  DATA g_menuList
  DATA g_menuBar
  DATA g_window
  METHOD lenMenuList INLINE Len( ::g_menuList )
PUBLISHED:
ENDCLASS

/*
  EndClass TGlobal
*/

/*
  Global function
  Teo. Mexico 2007
*/
FUNCTION Global
RETURN oGlobal

/*
  DefineMenu: Wrapper for wxMenuBar
  Teo. Mexico 2006
*/
FUNCTION DefineMenuBar( window, style )
  oGlobal := TGlobal():New()
  oGlobal:g_menuID := 1
  oGlobal:g_menuBar := wxMenuBar():New( style )
  IF window = NIL
    oGlobal:g_window := wxh_LastTopLevelWindow()
  ELSE
    oGlobal:g_window := window
  ENDIF
RETURN oGlobal:g_menuBar

/*
  EndMenuBar
  Teo. Mexico 2006
*/
PROCEDURE EndMenuBar
  oGlobal:g_window:SetMenuBar( oGlobal:g_menuBar )
  oGlobal := NIL
RETURN

/*
  wxMenuBar
  Teo. Mexico 2006
*/
CLASS wxMenuBar FROM wxWindow
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( style )
  METHOD Append( menu, title )
PUBLISHED:
ENDCLASS

/*
  End Class wxMenuBar
*/
