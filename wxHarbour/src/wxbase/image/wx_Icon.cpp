/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Icon: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Icon.h"

#include "wxwin32x32.xpm"

/*
  ~wx_Icon
  Teo. Mexico 2009
*/
wx_Icon::~wx_Icon()
{
  wxh_ItemListDel_WX( this );
}

/*
  New
  Teo. Mexico 2009
*/
HB_FUNC( WXICON_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_Icon* icon;

  switch( hb_pcount() )
  {
  case 0 :
    {
      /* TODO: Check & solve why this fails on mingw-windows */
      icon = new wx_Icon( wxwin32x32_xpm );
    }
    break;
  case 1 :
    {
      char * bits = hb_parc( 1 );
      icon = new wx_Icon( &bits );
    }
    break;
  case 2:
    {
      const wxString& name = wxh_parc( 1 );
      wxBitmapType type = wxBitmapType( hb_parni( 2 ) );
      int desiredWidth = hb_parni( 3 );
      int desiredHeight = hb_parni( 4 );

      icon = new wx_Icon( name, type, desiredWidth, desiredHeight );
    }
    break;
  default :
    icon = new wx_Icon();
    break;
  }

  objParams.Return( icon );
}

/*
  wxIcon:IsOk
  Teo. Mexico 2009
*/
HB_FUNC( WXICON_ISOK )
{
  wxIcon* icon = (wxIcon *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( icon )
  {
    hb_retl( icon->IsOk() );
  }
}

/*
  wxIcon:LoadFile
  Teo. Mexico 2009
*/
HB_FUNC( WXICON_LOADFILE )
{
  wxIcon* icon = (wxIcon *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( icon )
  {
    if( HB_ISNIL( 2 ) )
      hb_retl( icon->LoadFile( wxh_parc( 1 ) ) );
    else
      hb_retl( icon->LoadFile( wxh_parc( 1 ), wxBitmapType( hb_parni( 2 ) ) ) );
  }
}

