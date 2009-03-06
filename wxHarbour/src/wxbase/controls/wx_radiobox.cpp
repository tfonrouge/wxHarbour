/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_RadioBox: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_radiobox.h"

/*
  ~wx_RadioBox
  Teo. Mexico 2009
*/
wx_RadioBox::~wx_RadioBox()
{
  wxh_ItemListDel_WX( this );
}

HB_FUNC( WXRADIOBOX_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxString& label = wxh_parc( 3 );
  const wxPoint& pos = hb_par_wxPoint( 4 );
  const wxSize& size = hb_par_wxSize( 5 );
  const wxArrayString& choices = hb_par_wxArrayString( 6 );
  int majorDimension = hb_parni( 7 );
  long style = hb_parnl( 8 );
  const wxValidator& validator = ISNIL( 9 ) ? wxDefaultValidator : (*((wxValidator *) objParams.paramParent( 9 ))) ;
  const wxString& name = wxString( hb_parcx( 10 ), wxConvLocal );

  wx_RadioBox* radioBox = new wx_RadioBox( parent, id, label, pos, size, choices, majorDimension, style, validator, name );

  // Add object's to hash list
  objParams.PushObject( radioBox );

  hb_itemReturn( objParams.pSelf );
}

/*
  GetSelection
  Teo. Mexico 2008
*/
HB_FUNC( WXRADIOBOX_GETSELECTION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_RadioBox* radioBox = (wx_RadioBox *) wxh_ItemListGet_WX( pSelf );

  if( radioBox )
  {
    hb_retni( radioBox->GetSelection() + 1 ); /* zero to one based arrays C++ -> HB */
  }
}

/*
  SetSelection
  Teo. Mexico 2008
*/
HB_FUNC( WXRADIOBOX_SETSELECTION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_RadioBox* radioBox = (wx_RadioBox *) wxh_ItemListGet_WX( pSelf );

  if( radioBox )
  {
    radioBox->SetSelection( hb_parni( 1 ) - 1 ); /* zero to one based arrays C++ -> HB */
  }
}
