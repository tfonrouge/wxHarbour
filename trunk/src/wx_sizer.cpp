/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Sizer: Implementation
  Teo. Mexico 2006
*/

/* C++ Abstract Class */

#include "wx/wx.h"

#include "wxh.h"

#include "wx_sizer.h"

/*
  wxSizer:Add Emulates Overload on Harbour method.
  Teo. Mexico 2007
  Compat: wxWidgets 2.4.8
*/
HB_FUNC( WXSIZER_ADD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxSizer* sizer = (wxSizer *) wx_ObjList_wxGet( pSelf );

  if( ISOBJECT( 1 ) )
  {
    wxObject* obj = (wxObject *) hb_par_WX( 1 );
    if( obj->IsKindOf( CLASSINFO( wxWindow ) ) )
      if( hb_pcount() == 2 )
        /*wxSizerItem* Add(wxWindow* window, const wxSizerFlags& flags)*/
        sizer->Add( (wxWindow *) obj, hb_parnl( 2 ) ) ;
      else
        /*wxSizerItem* Add(wxWindow* window, int proportion = 0,int flag = 0, int border = 0, wxObject* userData = NULL)*/
        sizer->Add( (wxWindow *) obj, ISNIL( 2 ) ? 0 : hb_parnl( 2 ), ISNIL( 3 ) ? 0 : hb_parnl( 3 ), ISNIL( 4 ) ? 0 : hb_parnl( 4 ), ISNIL( 5 ) ? NULL : (wxObject *) hb_par_WX( 5 ) );
    else
      if( obj->IsKindOf( CLASSINFO( wxSizer ) ) )
        if( hb_pcount() == 2 )
          /*wxSizerItem* Add(wxSizer* sizer, const wxSizerFlags& flags)*/
          sizer->Add( (wxSizer *) obj, hb_parnl( 2 ) ) ;
        else
          /*wxSizerItem* Add(wxSizer* sizer, int proportion = 0, int flag = 0, int border = 0, wxObject* userData = NULL)*/
          sizer->Add( (wxSizer *) obj, ISNIL( 2 ) ? 0 : hb_parnl( 2 ), ISNIL( 3 ) ? 0 : hb_parnl( 3 ), ISNIL( 4 ) ? 0 : hb_parnl( 4 ), ISNIL( 5 ) ? NULL : (wxObject *) hb_par_WX( 5 ) );
  }
  else
    if( ISNUM( 1 ) )
      /*wxSizerItem* Add(int width, int height, int proportion = 0, int flag = 0, int border = 0, wxObject* userData = NULL)*/
      sizer->Add( hb_parnl( 1 ), hb_parnl( 2 ), ISNIL( 3 ) ? 0 : hb_parnl( 3 ), ISNIL( 4 ) ? 0 : hb_parnl( 4 ), ISNIL( 5 ) ? 0 : hb_parnl( 5 ), ISNIL( 6 ) ? NULL : (wxObject *) hb_par_WX( 6 ) );
}
