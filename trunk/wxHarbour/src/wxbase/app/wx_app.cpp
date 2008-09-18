/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxwApp: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_app.h"

static PHB_ITEM hb_wxApp;

/*
  OnInit
  Teo. Mexico 2006
*/
bool wx_App::OnInit()
{
  return hb_retl( hb_objSendMsg( hb_wxApp, "OnInit", 0 )->item.asLogical.value );
}

/*
  end class wx_App
*/

IMPLEMENT_APP_NO_MAIN( wx_App )
IMPLEMENT_CLASS( wx_App, wxApp )

/*! \brief wxApp initializacion, we don't link here the wxApp c++ because we can get it right from the wxGetApp function
    \param wxApp HBCLASS
    \return The wxApp Harbour object
  Constructor: wxApp Object
  Teo. Mexico 2006
*/
HB_FUNC( IMPLEMENT_APP )
{
  hb_wxApp = hb_param( 1, HB_IT_OBJECT );
  int i_args = 0;
  char **p_args = NULL;

  wxEntry( i_args, p_args );
}

/*
  wxApp::ExitMainLoop
  Teo. Mexico 2008
*/
HB_FUNC( WXAPP_EXITMAINLOOP )
{
  wxGetApp().ExitMainLoop();
}

/*!
  wxGetApp
  Teo. Mexico 2008
*/
HB_FUNC( WXGETAPP )
{
  hb_itemReturn( hb_wxApp );
}

HB_FUNC( WXEVT_FIRST )
{
  hb_retnl( wxEVT_COMMAND_BUTTON_CLICKED + hb_parnl(1) - 1 );
}
