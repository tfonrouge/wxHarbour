/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_MDIChildFrame: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wx/docview.h"

#include "wxbase/wx_mdichildframe.h"

using namespace std;

/*
  Constructor
  Teo. Mexico 2006
*/
wx_MDIChildFrame::wx_MDIChildFrame( wxMDIParentFrame* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
  Create( parent, id, title, pos, size, style, name );
}

/*
  Constructor: Object
  Teo. Mexico 2006
*/
HB_FUNC( WXMDICHILDFRAME_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_MDIChildFrame* frame;

  wxMDIParentFrame* parent = (wxMDIParentFrame *) hb_par_WX( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  wxString title = wxString( hb_parcx(3), wxConvLocal );
  wxPoint point = hb_par_wxPoint(4);
  wxSize size = hb_par_wxSize(5);
  long style = ISNIL(6) ? wxDEFAULT_FRAME_STYLE : hb_parnl(6);
  wxString name = wxString( hb_parcx(7), wxConvLocal );
  frame = new wx_MDIChildFrame( parent, id, title, point, size, style, name );

  // Add object's to hash list
  wxh_ItemListAdd( frame, pSelf );

  hb_itemReturn( pSelf );

}

/*
  Activate
  Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_ACTIVATE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_MDIChildFrame* frame;
  if( pSelf && (frame = (wx_MDIChildFrame *) wxh_ItemListGetWX( pSelf ) ) )
    frame->Activate();
}

/*
  Maximize
  Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_MAXIMIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  bool maximize = hb_parl( 1 );
  wx_MDIChildFrame* frame;
  if( pSelf && (frame = (wx_MDIChildFrame *) wxh_ItemListGetWX( pSelf ) ) )
    frame->Maximize( maximize );
}

/*
  Restore
  Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_RESTORE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_MDIChildFrame* frame;
  if( pSelf && (frame = (wx_MDIChildFrame *) wxh_ItemListGetWX( pSelf ) ) )
    frame->Restore();
}
