/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxwApp: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_app.h"

extern "C"
{
  void HB_FUN_WX_APP_ONINIT( void );
}

/*
  OnInit
  Teo. Mexico 2006
*/
bool wx_App::OnInit()
{

  PHB_ITEM p;

  HB_FUN_WX_APP_ONINIT();

  p = hb_itemNew( NULL );
  hb_itemCopy( p, hb_stackReturnItem() );

  return p->item.asLogical.value;
};
/*
  end class wx_App
*/

DECLARE_APP( wx_App )
IMPLEMENT_APP_NO_MAIN( wx_App )

HB_FUNC( IMPLEMENT_APP )
{
  char **p_args = NULL;
  int i_args = 0;
  wxEntry( i_args, p_args );
};

/*
  Constructor: wxApp Object
  Teo. Mexico 2006
*/
HB_FUNC( WXAPP_NEW )
{
  hb_itemReturn( hb_stackSelfItem() );
}

HB_FUNC( WX_APP_ONINIT )
{
  PHB_ITEM pObjApp = hb_param( 1, HB_IT_OBJECT );
  hb_retl( hb_objSendMsg( pObjApp, "OnInit", 0 )->item.asLogical.value );
};

HB_FUNC( WXEVT_FIRST )
{
  hb_retnl( wxEVT_COMMAND_BUTTON_CLICKED + hb_parnl(1) - 1 );
}
