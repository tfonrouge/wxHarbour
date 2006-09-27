/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxMenuItem
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"

#include "wx/wx.ch"

GLOBAL EXTERNAL g_menuList
GLOBAL EXTERNAL g_menuID
/*
  AddMenuItem: Wrapper for wxMenuItem
  Teo. Mexico 2006
*/
FUNCTION AddMenuItem( text, id, helpString, kind, bAction )
  LOCAL menuItem

  IF id=NIL
    id := g_menuID++
  ENDIF

  menuItem := wxMenuItem():New( g_menuList[-1]:menu, id, text, helpString, kind )

  g_menuList[-1]:menu:Append( menuItem )

  IF bAction != NIL
    GetLastFrame():Connect( id, wxEVT_COMMAND_MENU_SELECTED, bAction )
  ENDIF

RETURN menuItem

/*
  wxMenuItem
  Teo. Mexico 2006
*/
CLASS wxMenuItem FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parentMenu, id, text, helpString, kind, subMenu )
PUBLISHED:
ENDCLASS

/*
  End Class wxMenuItem
*/











