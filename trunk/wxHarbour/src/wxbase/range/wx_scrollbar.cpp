/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_ScrollBar: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_scrollbar.h"

/*
  ~wx_ScrollBar
  Teo. Mexico 2008
*/
wx_ScrollBar::~wx_ScrollBar()
{
  wxh_ItemListDel( this );
}

/*
  Constructor: wxScrollBar Object
  Teo. Mexico 2006
*/
HB_FUNC( WXSCROLLBAR_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxSB_HORIZONTAL : hb_parni( 5 );
  const wxValidator& validator = ISNIL(7) ? wxDefaultValidator : (*((wxValidator *) hb_par_WX(7))) ;
  const wxString& name = wxString( hb_parcx( 7 ), wxConvLocal );

  wx_ScrollBar* sb = new wx_ScrollBar( parent, id, pos, size, style, validator, name );

  // Add object's to hash list
  wxh_ItemListAdd( sb, pSelf );

  hb_itemReturn( pSelf );
}

/*
  GetRange
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETRANGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  if( pSelf && sb )
  {
    hb_retni( sb->GetRange() );
  }
  else
    hb_ret();
}

/*
  GetPageSize
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETPAGESIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  if( pSelf && sb )
  {
    hb_retni( sb->GetPageSize() );
  }
  else
    hb_ret();
}

/*
  GetThumbPosition
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETTHUMBPOSITION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  if( pSelf && sb )
  {
    hb_retni( sb->GetThumbPosition() );
  }
  else
    hb_ret();
}

/*
  GetThumbSize
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETTHUMBSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  if( pSelf && sb )
  {
    hb_retni( sb->GetThumbSize() );
  }
  else
    hb_ret();
}

/*
  SetThumbPosition
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_SETTHUMBPOSITION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  int viewStart = hb_parni( 1 );
  if( pSelf && sb )
  {
    sb->SetThumbPosition( viewStart );
  }
}

/*
  SetScrollbar
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_SETSCROLLBAR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGetWX( pSelf );
  int position = hb_parni( 1 );
  int thumbSize = hb_parni( 2 );
  int range = hb_parni( 3 );
  int pageSize = hb_parni( 4 );
  const bool refresh = ISNIL( 5 ) ? true : hb_parnl( 5 );
  if( pSelf && sb )
  {
    sb->SetScrollbar( position, thumbSize, range, pageSize, refresh );
  }
}
