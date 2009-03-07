/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Menu: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_menu.h"

/*
  ~wx_Menu
  Teo. Mexico 2006
*/
wx_Menu::~wx_Menu()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxMenu Object
  Teo. Mexico 2006
*/
HB_FUNC( WXMENU_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_Menu* menu = new wx_Menu();

  objParams.Return( menu );
}

HB_FUNC( WXMENU_APPEND1 )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( pSelf );

  menu->Append( hb_parnl( 1 ), wxh_parc( 2 ), wxh_parc( 3 ), hb_parnl( 4 ) );
}

HB_FUNC( WXMENU_APPEND2 )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_Menu* menu = (wx_Menu *) objParams.Get_wxObject();

  menu->Append( hb_parnl( 1 ), wxh_parc( 2 ), (wx_Menu *) objParams.paramChild( 3 ), wxh_parc( 4 ) );
}

HB_FUNC( WXMENU_APPEND3 )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_Menu* menu = (wx_Menu *) objParams.Get_wxObject();

  menu->Append( (wxMenuItem *) objParams.paramChild( 1 ) );
}

HB_FUNC( WXMENU_APPENDSEPARATOR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( pSelf );

  if( menu )
    menu->AppendSeparator();
}
