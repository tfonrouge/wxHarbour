/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Window: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"

#include "wxh.h"

#include "wx_frame.h"

using namespace std;

HB_FUNC( WXWINDOW_CLOSE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) )
    wnd->Close( hb_parl( 1 ) );
  hb_ret();
}

HB_FUNC( WXWINDOW_GETID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retnl( wnd->GetId() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_HIDE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retl( wnd->Hide() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_ISSHOWN )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retl( wnd->IsShown() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_SETSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  wxSizer* sizer = (wxSizer *) hb_par_WX( 1 );
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) && sizer )
    wnd->SetSizer( sizer, hb_parl(2) );
}

HB_FUNC( WXWINDOW_SHOW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  bool show;
  if ( hb_pcount() == 0 )
    show = TRUE;
  else
    show = hb_parl(1);
  if ( pSelf && (wnd = (wxWindow *) wx_ObjList_wxGet( pSelf ) ) )
  {
    //hb_objSendMsg( pSelf, "OnShow", 0 );
    hb_retl( wnd->Show( show ) );
  }

}











