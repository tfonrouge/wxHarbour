/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Dialog: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_dialog.h"

/*
  ~wx_Dialog
  Teo. Mexico 2006
*/
wx_Dialog::~wx_Dialog()
{
  wx_ObjList_wxDelete( this );
}

void wx_Dialog::ProcessEvent(wxCommandEvent& event)
{
  PHB_ITEM pId,pEventType;
  pId = hb_itemNew( NULL );
  pEventType = hb_itemNew( NULL );
  pId->type = HB_IT_INTEGER;
  pId->item.asInteger.length = 10;
  pId->item.asInteger.value = event.GetId();
  pEventType->type = HB_IT_INTEGER;
  pEventType->item.asInteger.length = 10;
  pEventType->item.asInteger.value = event.GetEventType();
  hb_objSendMsg( wx_ObjList_hbGet( this ), "ProcessEvent", 2, pId, pEventType );
}

BEGIN_EVENT_TABLE( wx_Dialog, wxDialog )
  EVT_MENU( wxID_ANY, wx_Dialog::ProcessEvent )
  EVT_BUTTON( wxID_ANY, wx_Dialog::ProcessEvent )
END_EVENT_TABLE()

/*
  Constructor: Object
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_Dialog* dialog;

  if(hb_pcount())
  {
    wxWindow* parent = (wxDialog *) hb_par_WX( 1 );
    wxWindowID id = wxWindowID( hb_parnl(2) );
    wxString title = wxString( hb_parcx(3), wxConvLocal );
    wxPoint point = hb_par_wxPoint(4);
    wxSize size = hb_par_wxSize(5);
    long style;
    if( ISNIL(6) ) style = wxDEFAULT_FRAME_STYLE ; else style = hb_parnl(6);
    wxString name = wxString( hb_parcx(7), wxConvLocal );
    dialog = new wx_Dialog( parent, id, title, point, size, style, name );
  }
  else
    dialog = new wx_Dialog;

  // Add object's to hash list
  wx_ObjList_New( dialog, pSelf );

  hb_itemReturn( pSelf );
}

/*
  wxDialog::Centre( int direction = wxBOTH )
  RETURN void
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_CENTRE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    dialog->Centre( hb_parni(1) );
}

/*
  wxDialog::CreateButtonSizer( long flags )
  RETURN NIL (wxSizer*)
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_CREATEBUTTONSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  wxSizer* sizer;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    sizer = dialog->CreateButtonSizer( hb_parnl(1) );
  hb_ret();
}

/*
  wxDialog::CreateStdDialogButtonSizer( long flags )
  RETURN NIL (wxStdDialogButtonSizer*)
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_CREATESTDDIALOGBUTTONSIZER )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  wxSizer* sizer;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    sizer = dialog->CreateStdDialogButtonSizer( hb_parnl(1) );
  hb_ret();
}

/*
  wxDialog::Show( const bool show )
  RETURN bool
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_SHOW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retl( dialog->Show( hb_parl(1) ) );
  else
    hb_ret();
}

/*
  wxDialog::ShowModal()
  RETURN int
  Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_SHOWMODAL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retni( dialog->ShowModal() );
  else
    hb_ret();
}

/*
 * wxDialog::EndModal()
 * Teo. Mexico 2008
 */
HB_FUNC( WXDIALOG_ENDMODAL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    dialog->EndModal( hb_parni( 1 ) );
}
