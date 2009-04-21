/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_TextCtrl: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_textctrl.h"

/*
  ~wx_TextCtrl
  Teo. Mexico 2006
*/
wx_TextCtrl::~wx_TextCtrl()
{
  wxh_ItemListDel_WX( this );
}

/*
  wxTextCtrl:New
  Teo. Mexico 2008
*/
HB_FUNC( WXTEXTCTRL_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  const wxString& value = wxh_parc( 3 );
  const wxPoint& pos = hb_par_wxPoint( 4 );
  const wxSize& size = hb_par_wxSize( 5 );
  long style = hb_parnl( 6 );
  const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : (*((wxValidator *) objParams.paramParent( 7 ))) ;
  const wxString& name = wxh_parc( 8 );
  wx_TextCtrl* textCtrl = new wx_TextCtrl( parent, id, value, pos, size, style, validator, name );

  objParams.Return( textCtrl );
}

/*
  wxTextCtrl:AppendText
  Teo. Mexico 2008
*/
HB_FUNC( WXTEXTCTRL_APPENDTEXT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxTextCtrl* textCtrl = (wxTextCtrl *) wxh_ItemListGet_WX( pSelf );

  if( textCtrl )
  {
    const wxString& text = wxh_parc( 1 );
    textCtrl->AppendText( text );
  }
}

/*
  wxTextCtrl:GetValue
  Teo. Mexico 2007
*/
HB_FUNC( WXTEXTCTRL_GETVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxTextCtrl* textCtrl = (wxTextCtrl *) wxh_ItemListGet_WX( pSelf );

  if( textCtrl )
    hb_retc( textCtrl->GetValue().mb_str() );
}

/*
  wxTextCtrl:SetValue
  Teo. Mexico 2009
*/
HB_FUNC( WXTEXTCTRL_SETVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxTextCtrl* textCtrl = (wxTextCtrl *) wxh_ItemListGet_WX( pSelf );

  if( textCtrl )
  {
    const wxString& text = wxh_parc( 1 );
    textCtrl->SetValue( text );
  }
}
