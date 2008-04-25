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

#include "wx_menu.h"

/*
  ~wx_Menu
  Teo. Mexico 2006
*/
wx_Menu::~wx_Menu()
{
  wx_ObjList_wxDelete( this );
}

/*
  Constructor: wxMenu Object
  Teo. Mexico 2006
*/
HB_FUNC( WXMENU_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Menu* menu = new wx_Menu();

  // Add object's to hash list
  wx_ObjList_New( menu, pSelf );

  hb_itemReturn( pSelf );
}

HB_FUNC( WX_MENU_APPEND1 )
{
  wx_Menu* menu = (wx_Menu *) hb_par_WX( 1 );
  menu->Append( hb_parnl(2), wxString( hb_parcx(3), wxConvLocal ), wxString( hb_parcx(4), wxConvLocal ), hb_parnl(5) );
}

HB_FUNC( WX_MENU_APPEND2 )
{
  wx_Menu* menu = (wx_Menu *) hb_par_WX( 1 );
  menu->Append( hb_parnl(2), wxString( hb_parcx(3), wxConvLocal ), (wx_Menu *) hb_par_WX( 4 ), wxString( hb_parcx(5), wxConvLocal ) );  };

HB_FUNC( WX_MENU_APPEND3 )
{
  wx_Menu* menu = (wx_Menu *) hb_par_WX( 1 );
  menu->Append( (wxMenuItem *) hb_par_WX( 2 ) );
}

HB_FUNC( WXMENU_APPENDSEPARATOR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Menu* menu;
  if( pSelf && (menu = (wx_Menu *) wx_ObjList_wxGet( pSelf ) ) )
    menu->AppendSeparator();
}
