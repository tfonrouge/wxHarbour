/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_StaticBox: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_staticbox.h"

/*
  ~wx_StaticBox
  Teo. Mexico 2006
*/
wx_StaticBox::~wx_StaticBox()
{
  wx_ObjList_wxDelete( this );
}

/*
  wxStaticBox:New
  Teo. Mexico 2007
*/
HB_FUNC( WXSTATICBOX_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxString& label = wxString( hb_parcx(3), wxConvLocal );
  const wxPoint& pos = ISNIL( 4 ) ? wxDefaultPosition : hb_par_wxPoint( 4 );
  const wxSize& size = ISNIL( 5 ) ? wxDefaultSize : hb_par_wxSize( 5 );
  long style = ISNIL( 6 ) ? 0 : hb_parnl( 6 );
  const wxString& name = wxString( hb_parcx( 7 ), wxConvLocal );
  wx_StaticBox* staticBox = new wx_StaticBox( parent, id, label, pos, size, style, name );

  // Add object's to hash list
  wx_ObjList_New( staticBox, pSelf );

  hb_itemReturn( pSelf );
}
