/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_CheckBox: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_checkbox.h"

/*
  ~wx_CheckBox
  Teo. Mexico 2009
*/
wx_CheckBox::~wx_CheckBox()
{
  wxh_ItemListDel_WX( this );
}

HB_FUNC( WXCHECKBOX_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wxWindow* parent = (wxWindow *) wxh_param_WX_Parent( 1, &wxhScopeList );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxString& label = wxh_parc( 3 );
  const wxPoint& pos = hb_par_wxPoint( 4 );
  const wxSize& size = hb_par_wxSize( 5 );
  long style = hb_parnl( 6 );
  const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : (*((wxValidator *) wxh_param_WX_Parent( 7, &wxhScopeList ))) ;
  const wxString& name = wxString( hb_parcx( 8 ), wxConvLocal );

  wx_CheckBox* checkBox = new wx_CheckBox( parent, id, label, pos, size, style, validator, name );

  // Add object's to hash list
  wxhScopeList.PushObject( checkBox );

  hb_itemReturn( pSelf );
}

/*
  Get3StateValue
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_GET3STATEVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    wxCheckBoxState cbs = checkBox->Get3StateValue();
    int value;

    switch( cbs )
    {
      case wxCHK_UNCHECKED : value = 0;
      case wxCHK_CHECKED : value = 1;
      case wxCHK_UNDETERMINED : value = 2;
    }

    hb_retnl( value );
  }
}

/*
  Is3rdStateAllowedForUser
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_IS3RDSTATEALLOWEDFORUSER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    hb_retl( checkBox->Is3rdStateAllowedForUser() );
  }
}

/*
  Is3State
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_IS3STATE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    hb_retl( checkBox->Is3State() );
  }
}

/*
  IsChecked
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_ISCHECKED )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    hb_retl( checkBox->IsChecked() );
  }
}

/*
  Set3StateValue
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_SET3STATEVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    wxCheckBoxState cbs = wxCHK_UNDETERMINED;

    switch ( hb_parni( 1 ) )
    {
      case 0 : cbs = wxCHK_UNCHECKED;
      case 1 : cbs = wxCHK_CHECKED;
    }
    checkBox->Set3StateValue( cbs );
  }
}

/*
  SetValue
  Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_SETVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_CheckBox* checkBox = (wx_CheckBox *) wxh_ItemListGet_WX( pSelf );

  if( checkBox )
  {
    checkBox->SetValue( hb_parl( 1 ) );
  }
}
