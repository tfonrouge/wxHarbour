/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_IPV4address: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ipv4address.h"

/*
  ~wx_IPV4address
  Teo. Mexico 2008
*/
wx_IPV4address::~wx_IPV4address()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: Object
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_IPV4address* ipv4Address;

  ipv4Address = new wx_IPV4address();

  // Add object's to hash list
  //wxh_ItemListAdd( ipv4Address, pSelf );
  objParams.PushObject( ipv4Address );

  hb_itemReturn( objParams.pSelf );

}

/*
  bool AnyAddress
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_ANYADDRESS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
    hb_retl( ipv4Address->AnyAddress() );
}

/*
  void Clear
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_CLEAR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
    ipv4Address->Clear();
}

/*
  bool Hostname
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_HOSTNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
  {
    if( hb_pcount() == 0 )
      hb_retc( ipv4Address->Hostname().mb_str() );
    else
    {
      wxString hostname = wxh_parc( 1 );
      hb_retl( ipv4Address->Hostname( hostname ) );
    }
  }
}

/*
  wxString IPAddress
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_IPADDRESS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
    hb_retc( ipv4Address->IPAddress().mb_str() );
}

/*
  bool IsLocalHost
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_ISLOCALHOST )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
    hb_retl( ipv4Address->IsLocalHost() );
}

/*
  bool LocalHost
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_LOCALHOST )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
    hb_retl( ipv4Address->LocalHost() );
}

/*
  bool Service
  Teo. Mexico 2008
*/
HB_FUNC( WXIPV4ADDRESS_SERVICE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_IPV4address* ipv4Address = (wx_IPV4address*) wxh_ItemListGet_WX( pSelf );

  if( ipv4Address )
  {
    if( ISCHAR( 1 ) )
      hb_retl( ipv4Address->Service( wxh_parc( 1 ) ) );
    if( ISNUM( 1 ) )
      hb_retl( ipv4Address->Service( hb_parnl( 1 ) ) );
    if( hb_pcount() == 0 )
      hb_retnl( ipv4Address->Service() );
  }
}
