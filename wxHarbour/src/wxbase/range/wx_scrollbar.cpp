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
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxScrollBar Object
  Teo. Mexico 2006
*/
HB_FUNC( WXSCROLLBAR_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxSB_HORIZONTAL : hb_parni( 5 );
  const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : (*((wxValidator *) objParams.paramParent( 7 ))) ;
  const wxString& name = wxh_parc( 7 );

  wx_ScrollBar* sb = new wx_ScrollBar( parent, id, pos, size, style, validator, name );

  objParams.Return( sb );
}

/*
  GetRange
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETRANGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );

  if( sb )
  {
    hb_retni( sb->GetRange() );
  }
}

/*
  GetPageSize
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETPAGESIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );

  if( sb )
  {
    hb_retni( sb->GetPageSize() );
  }
}

/*
  GetThumbPosition
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETTHUMBPOSITION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );
  
  if( sb )
  {
    hb_retni( sb->GetThumbPosition() );
  }
}

/*
  GetThumbSize
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_GETTHUMBSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );

  if( sb )
  {
    hb_retni( sb->GetThumbSize() );
  }
}

/*
  SetThumbPosition
  Teo. Mexico 2008
*/
HB_FUNC( WXSCROLLBAR_SETTHUMBPOSITION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );

  if( sb )
  {
    int viewStart = hb_parni( 1 );
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

  wx_ScrollBar* sb = (wx_ScrollBar *) wxh_ItemListGet_WX( pSelf );

  if( sb )
  {
    int position = hb_parni( 1 );
    int thumbSize = hb_parni( 2 );
    int range = hb_parni( 3 );
    int pageSize = hb_parni( 4 );
    const bool refresh = ISNIL( 5 ) ? true : hb_parnl( 5 );

    sb->SetScrollbar( position, thumbSize, range, pageSize, refresh );
  }
}
