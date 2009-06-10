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

#include "wxbase/wx_StatusBar.h"
#include "wxbase/wx_MenuBar.h"
#include "wxbase/wx_Frame.h"

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
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_Frame* frame;

  if( hb_pcount() > 0 )
  {
    wxWindow* parent = (wxFrame *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& title = wxh_parc( 3 );
    wxPoint point = wxh_par_wxPoint( 4 );
    wxSize size = wxh_par_wxSize( 5 );
    long style = ISNIL( 6 ) ? wxDEFAULT_FRAME_STYLE : hb_parnl( 6 );
    wxString name = wxh_parc( 7 );
    frame = new wx_Frame( parent, id, title, point, size, style, name );
  }
  else
    frame = new wx_Frame( NULL );

  objParams.Return( frame );

}

/*
  wxFrame::Centre( int direction = wxBOTH )
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_CENTRE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Frame* frame = (wx_Frame*) wxh_ItemListGet_WX( pSelf );

  if( frame )
  {
    int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
    frame->Centre( direction );
  }
}

/*
  SetMenuBar: message
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_SETMENUBAR )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_Frame* frame = (wx_Frame *) objParams.Get_wxObject();

  if( frame )
  {
    wx_MenuBar* menuBar = (wx_MenuBar *) objParams.paramChild( 1 );
    if( menuBar )
    {
      frame->SetMenuBar( menuBar );
    }
  }
}

/*
  SetStatusBar: message
  Teo. Mexico 2006
*/
HB_FUNC( WXFRAME_SETSTATUSBAR )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_Frame* frame = (wx_Frame *) objParams.Get_wxObject();

  if( frame )
  {
    wx_StatusBar* statusBar = (wx_StatusBar *) objParams.paramChild( 1 );
    if( statusBar )
    {
      frame->SetStatusBar( statusBar );
    }
  }
}
