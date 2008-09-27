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

#include "wxbase/wx_menuitem.h"

/*
  ~wx_MenuItem
  Teo. Mexico 2006
*/
wx_MenuItem::~wx_MenuItem()
{
  wxh_ItemListDel( this );
}

/*
  New
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxMenu* parentMenu = (wxMenu *) hb_par_WX(1);
  int id = hb_parni(2);
  const wxString& text = wxString( hb_parcx(3), wxConvLocal );
  const wxString& helpString = wxString( hb_parcx(4), wxConvLocal );
  wxItemKind kind = (wxItemKind) hb_parni(5);
  wxMenu* subMenu = (wxMenu *) hb_par_WX(6);

  wx_MenuItem* menuItem = new wx_MenuItem( parentMenu, id, text, helpString, kind, subMenu );

  // Add object's to hash list
  wxh_ItemListAdd( menuItem, pSelf );

  hb_itemReturn( pSelf );
}

/*
  Enable
  Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_ENABLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_MenuItem* menuItem;
  if( pSelf && (menuItem = (wx_MenuItem *) wxh_ItemListGetWX( pSelf ) ) )
    menuItem->Enable( hb_parl( 1 ) );
}
