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
    wx_Menu: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Menu.h"
#include "wxbase/wx_MenuItem.h"

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
    wxh_ObjParams objParams = wxh_ObjParams( NULL );

    wx_Menu* menu = new wx_Menu();

    objParams.Return( menu );
}

HB_FUNC( WXMENU_APPEND1 )
{
    wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( hb_stackSelfItem() );

    menu->Append( hb_parnl( 1 ), wxh_parc( 2 ), wxh_parc( 3 ), hb_parnl( 4 ) );
}

HB_FUNC( WXMENU_APPEND2 )
{
    wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    wxMenuItem* menuItem = menu->Append( hb_parnl( 1 ), wxh_parc( 2 ), (wx_Menu *) wxh_par_WX( 3 ), wxh_parc( 4 ) );

    wxh_itemNewReturn( "wxMenuItem", menuItem, menu );
}

HB_FUNC( WXMENU_APPEND3 )
{
    wxh_ObjParams objParams = wxh_ObjParams( NULL );
    wx_Menu* menu = (wx_Menu *) objParams.Get_wxObject();
    wxMenuItem* menuItem = (wxMenuItem *) objParams.paramChild( 1 );

    menu->Append( menuItem );
    wxh_itemReturn( menuItem );
}

HB_FUNC( WXMENU_APPENDSEPARATOR )
{
    wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( hb_stackSelfItem() );

    if( menu )
        wxh_itemNewReturn( "wxMenuItem", menu->AppendSeparator(), menu ) ;
}

/*
    FindItem
    Teo. Mexico 2009
*/
HB_FUNC( WXMENU_FINDITEM )
{
    wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( hb_stackSelfItem() );

    if( menu )
    {
        wxh_itemReturn( menu->FindItem( hb_parni( 1 ), (wxMenu **) wxh_par_WX( 2 ) ) );
    }
}

/*
    GetMenuItems
    Teo. Mexico 2009
*/
HB_FUNC( WXMENU_GETMENUITEMS )
{
    wx_Menu* menu = (wx_Menu *) wxh_ItemListGet_WX( hb_stackSelfItem() );

    if( menu )
    {
        wxMenuItemList menuItemList = menu->GetMenuItems();
        wxMenuItemList::iterator it;

        PHB_ITEM pArray = hb_itemArrayNew( menuItemList.GetCount() );
        UINT index = 0;

        for( it = menuItemList.begin(); it != menuItemList.end(); it++ )
        {
            hb_arraySet( pArray, ++index, wxh_ItemListGet_HB( *it ) );
        }

        hb_itemReturnRelease( pArray );
    }
}
