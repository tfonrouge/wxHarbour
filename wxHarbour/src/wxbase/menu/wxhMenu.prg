/*
 * $Id$
 */

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
    wxMenu
    Teo. Mexico 2006
*/
CLASS wxMenu FROM wxEvtHandler
PRIVATE:
PROTECTED:
    METHOD Append1
    METHOD Append2
    METHOD Append3
PUBLIC:
    CONSTRUCTOR New()
    METHOD Append( p1, p2, p3, p4 )
    METHOD AppendSeparator
    METHOD FindItem( id, menu )
    METHOD GetMenuItems()
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
        RETURN ::Append2( p1, p2, p3, p4 )
    CASE ValType(p1)="O" .AND. p1:IsDerivedFrom("wxMenuItem")
        RETURN ::Append3( p1 )
    OTHERWISE
        RETURN ::Append1( p1, p2, p3, p4 )
    ENDCASE

RETURN NIL

/*
    EndClass wxMenu
*/
