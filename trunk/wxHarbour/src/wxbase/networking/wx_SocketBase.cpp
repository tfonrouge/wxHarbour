/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_SocketBase: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_SocketBase.h"

using namespace std;

/*
  Constructor
  Teo. Mexico 2008
*/
wx_SocketBase::wx_SocketBase()
{
}

/*
  ~wx_SocketBase
  Teo. Mexico 2008
*/
wx_SocketBase::~wx_SocketBase()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: Object
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_SocketBase* socketBase;

  socketBase = new wx_SocketBase;

  objParams.Return( socketBase );
}

/*
  void Close
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_CLOSE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->Close();
}

/*
  bool Destroy
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_DESTROY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->Destroy() );
}

/*
  self Discard
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_DISCARD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    socketBase->Discard();
    hb_itemReturn( pSelf );
  }
}

/*
  bool Error
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WXERROR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->Error() );
}

/*
  void GetClientData
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_GETCLIENTDATA )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retptr( socketBase->GetClientData() );
}

/*
  bool GetLocal
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_GETLOCAL )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_wxObject();

  wxObject* object = (wxObject *) objParams.param( 1 );

  if( socketBase && object )
    hb_retl( socketBase->GetLocal( (wxSockAddress &) *object ) );
}

/*
  wxSocketFlags GetFlags
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_GETFLAGS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retnl( socketBase->GetFlags() );
}

/*
  bool GetPeer
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_GETPEER )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_wxObject();

  wxObject* object = (wxObject *) objParams.param( 1 );

  if( socketBase && object )
    hb_retl( socketBase->GetPeer( (wxSockAddress &) *object ) );
}

/*
  void InterruptWait
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_INTERRUPTWAIT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->InterruptWait();
}

/*
  bool IsConnected
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_ISCONNECTED )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->IsConnected() );
}

/*
  bool IsData
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_ISDATA )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->IsData() );
}

/*
  bool IsDisconnected
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_ISDISCONNECTED )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->IsDisconnected() );
}

/*
  wxUint32 LastCount
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_LASTCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retnl( socketBase->LastCount() );
}

/*
  wxSocketError LastError
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_LASTERROR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retnl( socketBase->LastError() );
}

/*
  void Notify
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_NOTIFY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->Notify( hb_parl( 1 ) );
}

/*
  bool IsOk
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_ISOK )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    hb_retl( socketBase->IsOk() );
}

/*
  void RestoreState
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_RESTORESTATE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->RestoreState();
}

/*
  void SaveState
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SAVESTATE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->SaveState();
}

/*
  void SetClientData
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETCLIENTDATA )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
    socketBase->SetClientData( hb_parptr( 1 ) );
}

/*
  void SetEventHandler
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETEVENTHANDLER )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_wxObject();

  wxEvtHandler* evtHandler = (wxEvtHandler *) objParams.paramParent( 1 );

  if( socketBase && evtHandler )
  {
    int id = ISNUM( 2 ) ? hb_parni( 2 ) : -1 ;
    socketBase->SetEventHandler( *evtHandler, id );
  }
}

/*
  void SetFlags
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETFLAGS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  wxSocketFlags flags = hb_parnl( 1 );
  if( socketBase )
    socketBase->SetFlags( flags );
}

/*
  bool SetLocal
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETLOCAL )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_wxObject();

  wxIPV4address* local = (wxIPV4address *) objParams.param( 1 );

  if( socketBase && local )
  {
    hb_retl( socketBase->SetLocal( *local ) );
  }
}

/*
  void SetNotify
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETNOTIFY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    wxSocketEventFlags flags = hb_parnl( 1 );
    socketBase->SetNotify( flags );
  }
}

/*
  void SetTimeOut
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_SETTIMEOUT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    int seconds = hb_parni( 1 );
    socketBase->SetTimeout( seconds );
  }
}

/*
  wxSocketBase Peek
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_PEEK )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
  wxUint32 nbytes = hb_parnl( 2 );

  if( pBuffer == NULL || !ISBYREF( 1 ) )
  {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }

  pBuffer = hb_itemUnShareString( pBuffer );

  if( socketBase )
  {
    socketBase->Peek( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}

/*
  wxSocketBase Read
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_READ )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
  wxUint32 nbytes = hb_parnl( 2 );

  if( pBuffer == NULL || !ISBYREF( 1 ) )
  {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }

  pBuffer = hb_itemUnShareString( pBuffer );

  if( socketBase )
  {
    socketBase->Read( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}

/*
  wxSocketBase ReadMsg
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_READMSG )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
  wxUint32 nbytes = hb_parnl( 2 );

  if( pBuffer == NULL || !ISBYREF( 1 ) )
  {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }

  pBuffer = hb_itemUnShareString( pBuffer );

  if( socketBase )
  {
    socketBase->ReadMsg( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}

/*
  wxSocketBase Unread
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_UNREAD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
  wxUint32 nbytes = hb_parnl( 2 );

  if( pBuffer == NULL || !ISBYREF( 1 ) )
  {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
    return;
  }

  pBuffer = hb_itemUnShareString( pBuffer );

  if( socketBase )
  {
    socketBase->Unread( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}

/*
  bool Wait
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WAIT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
    long millisecond = hb_parnl( 2 );
    hb_retl( socketBase->Wait( seconds, millisecond ) );
  }
}

/*
  bool WaitForLost
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WAITFORLOST )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
    long millisecond = hb_parnl( 2 );
    hb_retl( socketBase->WaitForLost( seconds, millisecond ) );
  }
}

/*
  bool WaitForRead
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WAITFORREAD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
    long millisecond = hb_parnl( 2 );
    hb_retl( socketBase->WaitForRead( seconds, millisecond ) );
  }
}

/*
  bool WaitForWrite
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WAITFORWRITE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
    long millisecond = hb_parnl( 2 );
    hb_retl( socketBase->WaitForWrite( seconds, millisecond ) );
  }
}

/*
  wxSocketBase Write
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WRITE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
    wxUint32 nbytes = hb_parnl( 2 );
    socketBase->Write( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}

/*
  wxSocketBase WriteMsg
  Teo. Mexico 2008
*/
HB_FUNC( WXSOCKETBASE_WRITEMSG )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGet_WX( pSelf );

  if( socketBase )
  {
    PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
    wxUint32 nbytes = hb_parnl( 2 );
    socketBase->WriteMsg( (BYTE *) hb_itemGetCPtr( pBuffer ), nbytes );
    hb_itemReturn( pSelf );
  }
}