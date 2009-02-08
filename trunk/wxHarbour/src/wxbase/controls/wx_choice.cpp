/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Choice: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_choice.h"

/*
  ~wx_Choice
  Teo. Mexico 2009
*/
wx_Choice::~wx_Choice()
{
  wxh_ItemListDel_WX( this );
}

HB_FUNC( WXCHOICE_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wxWindow* parent = (wxWindow *) wxh_param_WX_Parent( 1, &wxhScopeList );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxPoint& pos = hb_par_wxPoint( 3 );
  const wxSize& size = hb_par_wxSize( 4 );
  const wxArrayString& choices = hb_par_wxArrayString( 5 );
  long style = hb_parnl( 6 );
  const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : (*((wxValidator *) wxh_param_WX_Parent( 7, &wxhScopeList ))) ;
  const wxString& name = wxString( hb_parcx( 8 ), wxConvLocal );

  wx_Choice* choice = new wx_Choice( parent, id, pos, size, choices, style, validator, name );

  // Add object's to hash list
  wxhScopeList.PushObject( choice );

  hb_itemReturn( pSelf );
}

/*
  GetCurrentSelection
  Teo. Mexico 2008
*/
HB_FUNC( WXCHOICE_GETCURRENTSELECTION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Choice* choice = (wx_Choice *) wxh_ItemListGet_WX( pSelf );

  if( choice )
  {
    hb_retni( choice->GetCurrentSelection() + 1 ); /* zero to one based arrays C++ -> HB */
  }
}
