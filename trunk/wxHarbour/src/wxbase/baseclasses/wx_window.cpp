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

#include "wxbase/wx_frame.h"
#include "wxbase/wx_menu.h"

using namespace std;

HB_FUNC( WXWINDOW_CENTRE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->Centre( hb_parni( direction ) );
  hb_ret();
}

HB_FUNC( WXWINDOW_CLOSE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->Close( hb_parl( 1 ) );
  hb_ret();
}

HB_FUNC( WXWINDOW_DESTROY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  bool Result = false;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    Result = wnd->Destroy();
  hb_retl( Result );
}

HB_FUNC( WXWINDOW_FINDWINDOWBYID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  long id = hb_parnl(1);
  wxWindow* parent = (wxWindow *) hb_par_WX( 2 );

  wxWindow* wnd;
  wxWindow* result;

  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && ( result =  wnd->FindWindowById( id, parent ) ) )
    hb_itemReturn( wxh_ItemListGetHB( result ) );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_FINDWINDOWBYLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  const wxString& label = wxString( hb_parcx(1), wxConvLocal );
  wxWindow* parent = (wxWindow *) hb_par_WX( 2 );

  wxWindow* wnd;
  wxWindow* result;

  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && ( result =  wnd->FindWindowByLabel( label, parent ) ) )
    hb_itemReturn( wxh_ItemListGetHB( result ) );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_FINDWINDOWBYNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  const wxString& name = wxString( hb_parcx(1), wxConvLocal );
  wxWindow* parent = (wxWindow *) hb_par_WX( 2 );

  wxWindow* wnd;
  wxWindow* result;

  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && ( result =  wnd->FindWindowByName( name, parent ) ) )
    hb_itemReturn( wxh_ItemListGetHB( result ) );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_GETLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    hb_retc( wnd->GetLabel().mb_str() );
  else
    hb_retc("?");
}

HB_FUNC( WXWINDOW_GETNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    hb_retc( wnd->GetName().mb_str() );
  else
    hb_retc("?");
}

HB_FUNC( WXWINDOW_GETID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    hb_retnl( wnd->GetId() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_GETPARENT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  wxWindow* parent;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && ( parent =  wnd->GetParent() ) )
    hb_itemReturn( wxh_ItemListGetHB( parent ) );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_GETSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  wxSizer* sizer;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && ( sizer =  wnd->GetSizer() ) )
    hb_itemReturn( wxh_ItemListGetHB( sizer ) );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_HIDE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    hb_retl( wnd->Hide() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_ISSHOWN )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    hb_retl( wnd->IsShown() );
  else
    hb_ret();
}

HB_FUNC( WXWINDOW_MAKEMODAL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->MakeModal( hb_parl( 1 ) );
}

HB_FUNC( WXWINDOW_POPUPMENU )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Menu* menu = (wx_Menu *) hb_par_WX( 1 );
  wxWindow* wnd;

  if( !( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) ) )
  {
    return;
  }

  if( hb_pcount() == 1 )
  {
    hb_retl( wnd->PopupMenu( menu ) );
    return;
  }

  if( hb_pcount() == 2 )
  {
    hb_retl( wnd->PopupMenu( menu, hb_par_wxPoint( 2 ) ) );
    return;
  }

  hb_retl( wnd->PopupMenu( menu, hb_parni( 2 ), hb_parni( 3 ) ) );

}

HB_FUNC( WXWINDOW_RAISE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->Raise();
}

HB_FUNC( WXWINDOW_SETFOCUS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->SetFocus();
}

HB_FUNC( WXWINDOW_SETID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->SetId( hb_parni( 1 ) );
}

HB_FUNC( WXWINDOW_SETLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& label = wxString( hb_parcx( 1 ), wxConvLocal );
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->SetLabel( label );
}

HB_FUNC( WXWINDOW_SETNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& name = wxString( hb_parcx( 1 ), wxConvLocal );
  wxWindow* wnd;
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
    wnd->SetName( name );
}

HB_FUNC( WXWINDOW_SETSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  wxSizer* sizer = (wxSizer *) hb_par_WX( 1 );
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) && sizer )
    wnd->SetSizer( sizer, hb_parl(2) );
}

HB_FUNC( WXWINDOW_SHOW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd;
  bool show;
  if( hb_pcount() == 0 )
    show = TRUE;
  else
    show = hb_parl(1);
  if( pSelf && (wnd = (wxWindow *) wxh_ItemListGetWX( pSelf ) ) )
  {
    //hb_objSendMsg( pSelf, "OnShow", 0 );
    hb_retl( wnd->Show( show ) );
  }

}
