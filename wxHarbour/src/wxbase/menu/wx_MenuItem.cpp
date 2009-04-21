/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_MenuItem: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_MenuItem.h"

/*
  ~wx_MenuItem
  Teo. Mexico 2006
*/
wx_MenuItem::~wx_MenuItem()
{
  wxh_ItemListDel_WX( this );
}

/*
  New
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxMenu* parentMenu = (wxMenu *) objParams.paramParent( 1 );
  int id = hb_parni( 2 );
  const wxString& text = wxh_parc( 3 );
  const wxString& helpString = wxh_parc( 4 );
  wxItemKind kind = (wxItemKind) hb_parni( 5 );
  wxMenu* subMenu = (wxMenu *) objParams.paramChild( 6 );

  wx_MenuItem* menuItem = new wx_MenuItem( parentMenu, id, text, helpString, kind, subMenu );

  objParams.Return( menuItem );
}

/*
  Enable
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_ENABLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_MenuItem* menuItem = (wx_MenuItem *) wxh_ItemListGet_WX( pSelf );

  if( menuItem )
    menuItem->Enable( hb_parl( 1 ) );
}

/*
  wxMenuItem:GetItemLabel
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_GETITEMLABEL )
{
  wx_MenuItem* menuItem = (wx_MenuItem *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( menuItem )
    hb_retc( menuItem->GetItemLabel().mb_str() );
}

/*
  wxMenuItem:GetItemLabelText
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_GETITEMLABELTEXT )
{
  wx_MenuItem* menuItem = (wx_MenuItem *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( menuItem )
    hb_retc( menuItem->GetItemLabelText().mb_str() );
}
