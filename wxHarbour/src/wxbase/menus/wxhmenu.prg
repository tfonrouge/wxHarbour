/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxMenu
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"

#include "wx.ch"

/*
  DefineMenu: Wrapper for wxMenu
  Teo. Mexico 2006
*/
PROCEDURE wxh_DefineMenu( title )
  LOCAL hData := {=>}

  IF Global():g_menuList = NIL
    Global():g_menuList := {}
  ENDIF

  hData["menu"] := wxMenu():New()
  hData["title"] := title
  AAdd( Global():g_menuList, hData )

RETURN

/*
  EndMenu
  Teo. Mexico 2006
*/
PROCEDURE wxh_EndMenu
  LOCAL hData
  LOCAL menuListSize
  LOCAL menuItem
  LOCAL nLast

  IF Empty( Global():g_menuList )
    RETURN
  ENDIF

  nLast := Global():lenMenuList

  hData := Global():g_menuList[ nLast ]

  menuListSize := Len( Global():g_menuList )

  IF menuListSize = 1 /* Append to menuBar */
    Global():g_menuBar:Append( hData["menu"], hData["title"] )
  ELSE                /* Append SubMenu */
    menuItem := wxMenuItem():New( Global():g_menuList[ nLast -1 ]["menu"], Global():g_menuID++, hData["title"], "", wxITEM_NORMAL, hData["menu"] )
    Global():g_menuList[ nLast - 1 ]["menu"]:Append( menuItem )
  ENDIF

  ASize( Global():g_menuList, menuListSize - 1)

RETURN

/*
  wxMenu
  Teo. Mexico 2006
*/
CLASS wxMenu FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New()
  METHOD Append( /* overloaded */ )
  METHOD AppendSeparator
PUBLISHED:
ENDCLASS

/*
  Append
  Teo. Mexico 2006
*/
METHOD FUNCTION Append( p1, p2, p3, p4 ) CLASS wxMenu

  /* Simulates overloaded method */
  DO CASE
  CASE ValType(p3)="O" .AND. p3:IsDerivedFrom("wxMenu")
    RETURN wx_Menu_Append2( Self, p1, p2, p3, p4 )
  CASE ValType(p1)="O" .AND. p1:IsDerivedFrom("wxMenuItem")
    RETURN wx_Menu_Append3( Self, p1 )
  OTHERWISE
    RETURN wx_Menu_Append1( Self, p1, p2, p3, p4 )
  ENDCASE

RETURN NIL

/*
  EndClass wxMenu
*/
