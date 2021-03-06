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
    wxNotebook
    Teo. Mexico 2007
*/

#include "hbclass.ch"
#include "property.ch"

#include "wx.ch"

/*
    wxNotebook
    Teo. Mexico 2006
*/
CLASS wxNotebook FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( parent, id, pos, size, style, name )

    METHOD AddPage( page, text, select, imageId ) AS LOGICAL
    METHOD AdvanceSelection( forward /*= true*/ )
    METHOD AssignImageList( imageList )
    METHOD ChangeSelection( nPage )
    METHOD DeleteAllPages
    METHOD DeletePage( nPage )
    METHOD GetCurrentPage
    METHOD GetImageList
    METHOD GetPage( nPage )
    METHOD GetPageCount
    METHOD GetPageImage( nPage )
    METHOD GetPageText( nPage )
    METHOD GetRowCount
    METHOD GetSelection
//   METHOD GetThemeBackgroundColor
    METHOD HitTest( pt, flags )
    METHOD InsertPage( index, page, text, select, imageId )
    METHOD OnSelChange( event ) VIRTUAL
    METHOD RemovePage( nPage )
    METHOD SetImageList( imageList )
    METHOD SetPadding( padding )
    METHOD SetPageSize( size )
    METHOD SetPageImage( nPage, image )
    METHOD SetPageText( nPage, text )
    METHOD SetSelection( page )

PUBLISHED:
ENDCLASS

/*
    EndClass wxNotebook
*/
