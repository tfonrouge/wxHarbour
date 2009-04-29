/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_EvtHandler
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Frame.h"

#include "wx/timer.h"

static void ParseConnectParams( PCONN_PARAMS pConnParams );

/*
  Connect
  Teo. Mexico 2009
*/
static void Connect( int evtClass )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  PCONN_PARAMS pConnParams = new CONN_PARAMS;

  ParseConnectParams( pConnParams );

  hbEvtHandler<wxEvtHandler>* evtHandler = (hbEvtHandler<wxEvtHandler> *) wxh_ItemListGet_WX( pSelf );

  if( !( pSelf && evtHandler ) )
    return;

  evtHandler->wxhConnect( evtClass, pConnParams );

}

/*
  ParseConnectParams
  Teo. Mexico 2009
*/
static void ParseConnectParams( PCONN_PARAMS pConnParams )
{
  int iParams = hb_pcount();

  if( iParams == 4 )
  {
    pConnParams->id = hb_parni( 1 );
    pConnParams->lastId = hb_parni( 2 );
    pConnParams->eventType = hb_parni( 3 );
    pConnParams->pItmActionBlock = hb_itemNew( hb_param( 4, HB_IT_BLOCK ) );
  }else if( iParams == 3 )
  {
    pConnParams->id = hb_parni( 1 );
    pConnParams->lastId = hb_parni( 1 );
    pConnParams->eventType = hb_parni( 2 );
    pConnParams->pItmActionBlock = hb_itemNew( hb_param( 3, HB_IT_BLOCK ) );
  }else if( iParams == 2 )
  {
    pConnParams->id = wxID_ANY;
    pConnParams->lastId = wxID_ANY;
    pConnParams->eventType = hb_parni( 1 );
    pConnParams->pItmActionBlock = hb_itemNew( hb_param( 2, HB_IT_BLOCK ) );
  }
}

/*
  ConnectActivateEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTACTIVATEEVT )
{

  Connect( WXH_ACTIVATEEVENT );

}

/*
  ConnectCommandEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTCOMMANDEVT )
{

  Connect( WXH_COMMANDEVENT );

}

/*
  ConnectCommandEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTFOCUSEVT )
{
  Connect( WXH_FOCUSEVENT );
}

/*
  ConnectCommandEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTGRIDEVT )
{
  Connect( WXH_GRIDEVENT );
}

/*
  ConnectInitDialogEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTINITDIALOGEVT )
{
  Connect( WXH_INITDIALOGEVENT );
}

/*
  ConnectMenuEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTMENUEVT )
{
  Connect( WXH_MENUEVENT );
}

/*
  ConnectMouseEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTMOUSEEVT )
{
  Connect( WXH_MOUSEEVENT );
}

/*
  ConnectSocketEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTSOCKETEVT )
{
  Connect( WXH_SOCKETEVENT );
}

/*
  ConnectTimerEvt
  Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTTIMEREVT )
{
  Connect( WXH_TIMEREVENT );
}
