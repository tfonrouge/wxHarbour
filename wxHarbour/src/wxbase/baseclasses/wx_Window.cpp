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

#include "wxbase/wx_Frame.h"
#include "wxbase/wx_Menu.h"
#include "wxbase/wx_Font.h"

HB_FUNC_EXTERN( WXFONT );

/*
 Centre
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_CENTRE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
    wnd->Centre( hb_parni( direction ) );
  }
}

/*
 Close
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_CLOSE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->Close( hb_parl( 1 ) ) );
}

/*
  Disable
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_DISABLE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->Disable() );
}

/*
 Destroy
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_DESTROY )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->Destroy() );
}

/*
  wxWindow:Enable
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_ENABLE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    hb_retl( wnd->Enable( enable ) );
  }
}

/*
  wxWindow:FindFocus
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_FINDFOCUS )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
	wxh_itemReturn( wnd->FindFocus() );
}

/*
 FindWindowById
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYID )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wxWindow* wnd = (wxWindow *) objParams.Get_wxObject();

  if( wnd )
  {
    long id = hb_parnl(1);
    wxWindow* parent = (wxWindow *) objParams.param( 2 );
    wxWindow* result = wnd->FindWindowById( id, parent );
	wxh_itemReturn( result );
  }
}

/*
 FindWindowByLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYLABEL )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wxWindow* wnd = (wxWindow *) objParams.Get_wxObject();

  if( wnd )
  {
    const wxString& label = wxh_parc( 1 );
    wxWindow* parent = (wxWindow *) objParams.param( 2 );
    wxWindow* result =  wnd->FindWindowByLabel( label, parent );
	wxh_itemReturn( result );
  }
}

/*
 FindWindowByName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYNAME )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wxWindow* wnd = (wxWindow *) objParams.Get_wxObject();

  if( wnd )
  {
    const wxString& name = wxh_parc( 1 );
    wxWindow* parent = (wxWindow *) objParams.param( 2 );
    wxWindow* result =  wnd->FindWindowByName( name, parent );
	wxh_itemReturn( result );
  }
}

/*
  Freeze
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_FREEZE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->Freeze();
}

/*
  GetChildren
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_GETCHILDREN )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wxWindowList windowList = wnd->GetChildren();
    wxWindowList::iterator iter;
    wxWindow* window;
    PHB_ITEM pList = hb_itemArrayNew( windowList.GetCount() );
    PHB_ITEM pItm;
    UINT index = 0;
    for( iter = windowList.begin(); iter != windowList.end(); ++iter )
    {
      window = *iter;
      pItm = wxh_ItemListGet_HB( window );
      if( pItm )
        hb_arraySet( pList, ++index, pItm );
    }
    hb_itemReturnRelease( pList );
  }
}

/*
  GetFont
  Teo. Mexico 2008
*/
HB_FUNC( WXWINDOW_GETFONT )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wxFont *font = new wxFont( wnd->GetFont() );
    HB_FUNC_EXEC( WXFONT );
    PHB_ITEM pFont = hb_stackReturnItem();
    wxh_ObjParams objParams = wxh_ObjParams( pFont );
    objParams.Return( font, true );
  }
}

/*
 GetId
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETID )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( wnd )
    hb_retnl( wnd->GetId() );
}

/*
 GetLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETLABEL )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wxh_retc( wnd->GetLabel() );
}

/*
 GetName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETNAME )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wxh_retc( wnd->GetName() );
}

/*
 GetParent
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETPARENT )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wxWindow* parent =  wnd->GetParent();
    if( parent )
    {
	  wxh_itemReturn( parent );
    }
  }
}

/*
 GetPointSize
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETPOINTSIZE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( wnd )
    hb_retni( wnd->GetFont().GetPointSize() );
}

/*
 GetSizer
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETSIZER )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wxSizer* sizer =  wnd->GetSizer();
    if( sizer )
    {
	  wxh_itemReturn( sizer );
    }
  }
}

/*
 Hide
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_HIDE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->Hide() );
}

/*
  wxWindow:IsEnabled
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_ISENABLED )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->IsEnabled() );
}

/*
 IsShown
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_ISSHOWN )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    hb_retl( wnd->IsShown() );
}

/*
 MakeModal
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_MAKEMODAL )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->MakeModal( hb_parl( 1 ) );
}

/*
 PopupMenu
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_POPUPMENU )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* wnd = (wxWindow *) objParams.Get_wxObject();

  wx_Menu* menu = (wx_Menu *) objParams.paramParent( 1 );

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
    hb_retl( wnd->PopupMenu( menu, wxh_par_wxPoint( 2 ) ) );
    return;
  }

  hb_retl( wnd->PopupMenu( menu, hb_parni( 2 ), hb_parni( 3 ) ) );

}

/*
 Raise
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_RAISE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->Raise();
}

/*
 SetFocus
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETFOCUS )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->SetFocus();
}

/*
 SetId
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETID )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->SetId( hb_parni( 1 ) );
}

/*
 SetLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETLABEL )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    const wxString& label = wxh_parc( 1 );
    wnd->SetLabel( label );
  }
}

/*
  SetMaxSize
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_SETMAXSIZE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wnd->SetMaxSize( wxh_par_wxSize( 1 ) );
  }
}

/*
  SetMinSize
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_SETMINSIZE )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wnd->SetMinSize( wxh_par_wxSize( 1 ) );
  }
}

/*
 SetName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETNAME )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    const wxString& name = wxh_parc( 1 );
    wnd->SetName( name );
  }
}

/*
 SetSizer
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETSIZER )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wxWindow* wnd = (wxWindow *) objParams.Get_wxObject();

  if( wnd )
  {
    wxSizer* sizer = (wxSizer *) objParams.paramChild( 1 );
    if( sizer )
    {
      wnd->SetSizer( sizer, hb_parl( 2 ) );
    }
  }
}

/*
 SetToolTip
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETTOOLTIP )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    wnd->SetToolTip( wxh_parc( 1 ) );
  }
}

/*
 Show
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SHOW )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
  {
    bool show = hb_pcount() > 0 ? hb_parl( 1 ) : FALSE;
    hb_retl( wnd->Show( show ) );
  }
}

/*
  Thaw
  Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_THAW )
{
  wxWindow* wnd = (wxWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( wnd )
    wnd->Thaw();
}
