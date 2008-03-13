/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_SocketServer: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wx_socketserver.h"

extern "C"
{
  void HB_FUN_WXSOCKETBASE( void );
}

using namespace std;

/*
  ~wx_SocketServer
  Teo. Mexico 2008
*/
wx_SocketServer::~wx_SocketServer()
{
  wx_ObjList_wxDelete( this );
}

/*
  Constructor: Object
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETSERVER_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketServer* socketServer;
  wxSockAddress* address;
  wxSocketFlags flags = ISNUM( 2 ) ? hb_parni( 2 ) : wxSOCKET_NONE;

  address = (wxSockAddress *) hb_par_WX( 1 );

  if( !address )
  {
    hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }
  socketServer = new wx_SocketServer( *address, flags );

  // Add object's to hash list
  wx_ObjList_New( socketServer, pSelf );

  hb_itemReturn( pSelf );

}

/*
  wxSocketBase Accept
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETSERVER_ACCEPT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketServer* socketServer;
  wxSocketBase* socketBase;

  bool wait = ISLOG( 1 ) ? hb_parl( 1 ) : true;

  if( pSelf && (socketServer = (wx_SocketServer*) wx_ObjList_wxGet( pSelf ) ) )
  {
    socketBase = socketServer->Accept( wait );
    if(socketBase)
    {
      PHB_ITEM p = hb_itemNew( NULL );
      HB_FUN_WXSOCKETBASE();
      hb_itemCopy( p, &(hb_stack.Return) );
      wx_ObjList_New( socketBase, p );
      hb_itemReturn( p );
    }
  }
}

/*
  bool AcceptWith
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETSERVER_ACCEPTWITH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketServer* socketServer;
  wxSocketBase* socket;

  bool wait = ISLOG( 2 ) ? hb_parl( 2 ) : true;

  socket = (wxSocketBase *) hb_par_WX( 1 );

  if( !socket )
  {
    hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }

  if( pSelf && (socketServer = (wx_SocketServer*) wx_ObjList_wxGet( pSelf ) ) )
    hb_retl( socketServer->AcceptWith( *socket, wait ) );
}

/*
  bool WaitForAccept
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETSERVER_WAITFORACCEPT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketServer* socketServer;
  long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
  long millisecond = hb_parnl( 2 );
  if( pSelf && (socketServer = (wx_SocketServer*) wx_ObjList_wxGet( pSelf ) ) )
    hb_retl( socketServer->WaitForAccept( seconds, millisecond ) );
}
