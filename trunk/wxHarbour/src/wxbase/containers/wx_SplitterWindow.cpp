/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_SplitterWindow: Implementation
    Teo. Mexico 2010
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_SplitterWindow.h"

/*
    ~wx_SplitterWindow
    Teo. Mexico 2010
*/
wx_SplitterWindow::~wx_SplitterWindow()
{
    wxh_ItemListDel_WX( this );
}

/*
    New
    Teo. Mexico 2010
*/
HB_FUNC( WXSPLITTERWINDOW_NEW )
{
    wxh_ObjParams objParams = wxh_ObjParams( NULL );

    wx_SplitterWindow* panel;

    if( hb_pcount() )
    {
        wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
        const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
        long style = ISNIL( 5 ) ? wxTAB_TRAVERSAL : hb_parnl( 5 );
        const wxString& name = ISNIL( 6 ) ? wxString( _T("panel") ) : wxh_parc( 6 );
        panel = new wx_SplitterWindow( parent, id, pos, size, style, name );
    }
    else
        panel = new wx_SplitterWindow();

    objParams.Return( panel );
}
