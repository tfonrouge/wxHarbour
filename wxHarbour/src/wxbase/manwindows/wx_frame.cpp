/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Frame: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_statusbar.h"
#include "wxbase/wx_menubar.h"
#include "wxbase/wx_frame.h"

using namespace std;

/*
  Constructor
  Teo. Mexico 2006
*/
wx_Frame::wx_Frame( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
  Create( parent, id, title, pos, size, style, name );
}

/*
  Constructor: Object
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_Frame* frame;

  if(hb_pcount())
  {
    wxWindow* parent = (wxFrame *) hb_par_WX( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxString title = wxString( hb_parcx(3), wxConvLocal );
    wxPoint point = hb_par_wxPoint(4);
    wxSize size = hb_par_wxSize(5);
    long style = ISNIL(6) ? wxDEFAULT_FRAME_STYLE : hb_parnl(6);
    wxString name = wxString( hb_parcx(7), wxConvLocal );
    frame = new wx_Frame( parent, id, title, point, size, style, name );
  }
  else
    frame = new wx_Frame( NULL );

  // Add object's to hash list
  wx_ObjList_New( frame, pSelf );

  // OnCreate...
  hb_objSendMsg( pSelf, "OnCreate", 0 );

  hb_itemReturn( pSelf );

}

/*
  wxFrame::Centre( int direction = wxBOTH )
  RETURN void
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_CENTRE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Frame* frame;
  if( pSelf && (frame = (wx_Frame*) wx_ObjList_wxGet( pSelf ) ) )
    frame->Centre( hb_parni(1) );
}

/*
  SetMenuBar: message
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_SETMENUBAR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Frame* frame;
  wx_MenuBar* menuBar = (wx_MenuBar *) hb_par_WX( 1 );
  if( pSelf && (frame = (wx_Frame *) wx_ObjList_wxGet( pSelf ) ) )
    frame->SetMenuBar( menuBar );
}

/*
  SetStatusBar: message
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_SETSTATUSBAR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Frame* frame;
  wx_StatusBar* statusBar = (wx_StatusBar *) hb_par_WX( 1 );
  if( pSelf && (frame = (wx_Frame *) wx_ObjList_wxGet( pSelf ) ) )
    frame->SetStatusBar( statusBar );
}
