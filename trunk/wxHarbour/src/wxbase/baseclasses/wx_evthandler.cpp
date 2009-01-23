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

#include "wxbase/wx_frame.h"

typedef struct _CONN_PARAMS
{
  int id,lastId,eventType;
  PHB_ITEM pItmActionBlock;
} CONN_PARAMS, * PCONN_PARAMS;

void ParseConnectParams( PCONN_PARAMS pConnParams );

/*
  Connect
  Teo. Mexico 2009
*/
void Connect( int evtClass )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  PCONN_PARAMS pConnParams = new _CONN_PARAMS;

  ParseConnectParams( pConnParams );

  hbEvtHandler<wxEvtHandler>* evtHandler = (hbEvtHandler<wxEvtHandler> *) wxh_ItemListGetWX( pSelf );

  if( !( pSelf && evtHandler ) )
    return;

  evtHandler->wxhConnect( evtClass, pConnParams->id, pConnParams->lastId, pConnParams->eventType );

}

/*
  ParseConnectParams
  Teo. Mexico 2009
*/
void ParseConnectParams( PCONN_PARAMS pConnParams )
{
  //PHB_ITEM p1 = hb_param( 1, HB_IT_ANY );
  PHB_ITEM p2 = hb_param( 2, HB_IT_ANY );
  PHB_ITEM p3 = hb_param( 3, HB_IT_ANY );
  PHB_ITEM p4 = hb_param( 4, HB_IT_ANY );

  if( HB_IS_BLOCK( p4 ) )
  {
    pConnParams->id = hb_parni( 1 );
    pConnParams->lastId = hb_parni( 2 );
    pConnParams->eventType = hb_parni( 3 );
    pConnParams->pItmActionBlock = hb_param( 4, HB_IT_BLOCK );
  }else if( HB_IS_BLOCK( p3 ) )
  {
    pConnParams->id = hb_parni( 1 );
    pConnParams->lastId = hb_parni( 1 );
    pConnParams->eventType = hb_parni( 2 );
    pConnParams->pItmActionBlock = hb_param( 3, HB_IT_BLOCK );
  }else if( HB_IS_BLOCK( p2 ) )
  {
    pConnParams->id = wxID_ANY;
    pConnParams->lastId = wxID_ANY;
    pConnParams->eventType = hb_parni( 1 );
    pConnParams->pItmActionBlock = hb_param( 2, HB_IT_BLOCK );
  }
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
  wxConnect
  Teo. Mexico 2008
*/
HB_FUNC( WXEVTHANDLER_WXHCONNECT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int evtClass = hb_parni( 1 );
  int id = hb_parni( 2 );
  int lastId = hb_parni( 3 );
  wxEventType eventType = hb_parni( 4 );

  hbEvtHandler<wxEvtHandler>* evtHandler = (hbEvtHandler<wxEvtHandler> *) wxh_ItemListGetWX( pSelf );

  if( !( pSelf && evtHandler ) )
    return;

  evtHandler->wxhConnect( evtClass, id, lastId, eventType );

}
