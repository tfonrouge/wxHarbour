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
#include "wxbase/wx_font.h"

HB_FUNC_EXTERN( WXFONT );

HB_FUNC( WXWINDOW_CENTRE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
    wnd->Centre( hb_parni( direction ) );
  }
}

HB_FUNC( WXWINDOW_CLOSE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    wnd->Close( hb_parl( 1 ) );
}

HB_FUNC( WXWINDOW_DESTROY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retl( wnd->Destroy() );
}

HB_FUNC( WXWINDOW_FINDWINDOWBYID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    long id = hb_parnl(1);
    wxWindow* parent = (wxWindow *) hb_par_WX( 2, NULL );
    wxWindow* result = wnd->FindWindowById( id, parent );
    if( result )
      hb_itemReturn( wxh_ItemListGetHB( result ) );
  }
}

HB_FUNC( WXWINDOW_FINDWINDOWBYLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    const wxString& label = wxh_parc( 1 );
    wxWindow* parent = (wxWindow *) hb_par_WX( 2, NULL );
    wxWindow* result =  wnd->FindWindowByLabel( label, parent );
    if( result )
      hb_itemReturn( wxh_ItemListGetHB( result ) );
  }
}

HB_FUNC( WXWINDOW_FINDWINDOWBYNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    const wxString& name = wxh_parc( 1 );
    wxWindow* parent = (wxWindow *) hb_par_WX( 2, NULL );
    wxWindow* result =  wnd->FindWindowByName( name, parent );
    if( result )
      hb_itemReturn( wxh_ItemListGetHB( result ) );
  }
}

/*
  GetFont
  Teo. Mexico 2008
*/
HB_FUNC( WXWINDOW_GETFONT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    wxFont *font = new wxFont( wnd->GetFont() );
    HB_FUNC_EXEC( WXFONT );
    PHB_ITEM pFont = hb_itemNew( hb_stackReturnItem() );
    WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pFont );
    //wxh_ItemListAdd( font, pFont, NULL );
    wxh_SetScopeList( font, &wxhScopeList );
    //hb_itemReturnRelease( pFont );
    hb_itemReturn( pFont );
  }
}

HB_FUNC( WXWINDOW_GETLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retc( wnd->GetLabel().mb_str() );
}

HB_FUNC( WXWINDOW_GETNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retc( wnd->GetName().mb_str() );
}

HB_FUNC( WXWINDOW_GETID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retnl( wnd->GetId() );
}

HB_FUNC( WXWINDOW_GETPARENT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    wxWindow* parent =  wnd->GetParent();
    if( parent )
    {
      hb_itemReturn( wxh_ItemListGetHB( parent ) );
    }
  }
}

HB_FUNC( WXWINDOW_GETSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    wxSizer* sizer =  wnd->GetSizer();
    if( sizer )
    {
      hb_itemReturn( wxh_ItemListGetHB( sizer ) );
    }
  }
}

HB_FUNC( WXWINDOW_HIDE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retl( wnd->Hide() );
}

HB_FUNC( WXWINDOW_ISSHOWN )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    hb_retl( wnd->IsShown() );
}

HB_FUNC( WXWINDOW_MAKEMODAL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    wnd->MakeModal( hb_parl( 1 ) );
}

HB_FUNC( WXWINDOW_POPUPMENU )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  wx_Menu* menu = (wx_Menu *) hb_par_WX( 1, &wxhScopeList );

  if( !( wnd && menu ) )
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
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    wnd->Raise();
}

HB_FUNC( WXWINDOW_SETFOCUS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    wnd->SetFocus();
}

HB_FUNC( WXWINDOW_SETID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
    wnd->SetId( hb_parni( 1 ) );
}

HB_FUNC( WXWINDOW_SETLABEL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    const wxString& label = wxh_parc( 1 );
    wnd->SetLabel( label );
  }
}

HB_FUNC( WXWINDOW_SETNAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    const wxString& name = wxh_parc( 1 );
    wnd->SetName( name );
  }
}

HB_FUNC( WXWINDOW_SETSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    wxSizer* sizer = (wxSizer *) hb_par_WX( 1, &wxhScopeList );
    if( sizer )
    {
      wnd->SetSizer( sizer, hb_parl( 2 ) );
    }
  }
}

HB_FUNC( WXWINDOW_SHOW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* wnd = (wxWindow *) wxh_ItemListGetWX( pSelf );

  if( wnd )
  {
    bool show = hb_pcount() > 0 ? hb_parl( 1 ) : FALSE;
    hb_retl( wnd->Show( show ) );
  }
}
