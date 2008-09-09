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
  wx_ObjList_wxDelete( this );
}

/*
wxTextCtrl(wxWindow* parent, wxWindowID id, const wxString& value = "", const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = wxTextCtrlNameStr)
*/

HB_FUNC( WXTEXTCTRL_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  const wxString& value = wxString( hb_parcx(3), wxConvLocal );
  const wxPoint& pos = hb_par_wxPoint(4);
  const wxSize& size = hb_par_wxSize(5);
  long style = hb_parnl(6);
  const wxValidator& validator = ISNIL(7) ? wxDefaultValidator : (*((wxValidator *) hb_par_WX(7))) ;
  const wxString& name = wxString( hb_parcx(8), wxConvLocal );
  wx_TextCtrl* textCtrl = new wx_TextCtrl( parent, id, value, pos, size, style, validator, name );

  // Add object's to hash list
  wx_ObjList_New( textCtrl, pSelf );

  hb_itemReturn( pSelf );
}

/*
  wxTextCtrl:GetValue
  Teo. Mexico 2007
*/
HB_FUNC( WXTEXTCTRL_GETVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxTextCtrl* textCtrl;
  if( pSelf && (textCtrl = (wxTextCtrl *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retc( textCtrl->GetValue().mb_str() );
  else
    hb_ret();
}
