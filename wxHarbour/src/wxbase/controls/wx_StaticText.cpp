/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_StaticText: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_statictext.h"

/*
  ~wx_StaticText
  Teo. Mexico 2006
*/
wx_StaticText::~wx_StaticText()
{
  wxh_ItemListDel_WX( this );
}

/*
  wxStaticText:New
  Teo. Mexico 2007
  wx-Compat: 2.4.8
*/
HB_FUNC( WXSTATICTEXT_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxString& label = wxh_parc( 3 );
  const wxPoint& pos = ISNIL( 4 ) ? wxDefaultPosition : hb_par_wxPoint( 4 );
  const wxSize& size = ISNIL( 5 ) ? wxDefaultSize : hb_par_wxSize( 5 );
  long style = ISNIL( 6 ) ? 0 : hb_parnl( 6 );
  const wxString& name = wxh_parc( 7 );
  wx_StaticText* staticText = new wx_StaticText( parent, id, label, pos, size, style, name );

  objParams.Return( staticText );
}

/*
  wxStaticText:Wrap
  Teo. Mexico 2007
  wx-Compat: 2.4.8
*/
HB_FUNC( WXSTATICTEXT_WRAP )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxStaticText* staticText = (wxStaticText *) wxh_ItemListGet_WX( pSelf );

  staticText->Wrap( hb_parnl( 1 ) );
}
