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

using namespace std;

/*
  Constructor
  Teo. Mexico 2006
*/
wx_Dialog::wx_Dialog( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
  Create( parent, id, title, pos, size, style, name );
}

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
    wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
    const wxString& title = wxString( hb_parcx(3), wxConvLocal );
    wxPoint point = hb_par_wxPoint(4);
    wxSize size = hb_par_wxSize(5);
    long style = ISNIL(6) ? wxDEFAULT_FRAME_STYLE : hb_parnl(6);
    wxString name = wxString( hb_parcx(7), wxConvLocal );
    dialog = new wx_Dialog( parent, id, title, point, size, style, name );
  }
  else
    dialog = new wx_Dialog( NULL );

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
  int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    dialog->Centre( direction );
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

/*
 * wxDialog::GetReturnCode()
 * Teo. Mexico 2008
 */
HB_FUNC( WXDIALOG_GETRETURNCODE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Dialog* dialog;
  if( pSelf && (dialog = (wx_Dialog *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retni( dialog->GetReturnCode() );
  else
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
