/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/log.h"
#include "wxh.h"

#include "wxbase/wx_socketbase.h"
#include "wxbase/wx_socketserver.h"

#include "rdodefs.h"

/* USHORT keys ( object handle ) */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, PHB_ITEM, wxPointerHash, wxPointerEqual, RDO_ITMOBJLIST );

PHB_ITEM        rdo_ItmObjListAdd( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle, PHB_ITEM pItmObj );
void            rdo_ItmObjListDel( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle );
PHB_ITEM        rdo_ItmObjListGet( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle );
void            rdo_ItmObjListFree( RDO_ITMOBJLIST rdo_itmObjList );

HB_FUNC_EXTERN( TRDOSOCKETBASE );

/*
  rdo_ItmObjListAdd
  Teo. Mexico 2009
*/
PHB_ITEM rdo_ItmObjListAdd( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle, PHB_ITEM pItmObj )
{

  PHB_ITEM p = hb_itemNew( NULL );

  hb_itemCopy( p, pItmObj );

  rdo_itmObjList[ pObjHandle ] = p;

  return p;

}

/*
  rdo_ItmObjListDel
  Teo. Mexico 2009
*/
void rdo_ItmObjListDel( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle )
{
  PHB_ITEM pItmObj = rdo_ItmObjListGet( rdo_itmObjList, pObjHandle );

  if( pItmObj )
  {
    hb_itemRelease( pItmObj );
  }

  rdo_itmObjList.erase( pObjHandle );

}

/*
  rdo_ItmObjListFree
  Teo. Mexico 2009
*/
void rdo_ItmObjListFree( RDO_ITMOBJLIST rdo_itmObjList )
{
  RDO_ITMOBJLIST::iterator it;
  while( ! rdo_itmObjList.empty() )
  {
    it = rdo_itmObjList.begin();
    rdo_ItmObjListDel( rdo_itmObjList, it->first );
  }
}

/*
  rdo_ItmObjListGet
  Teo. Mexico 2009
*/
PHB_ITEM rdo_ItmObjListGet( RDO_ITMOBJLIST rdo_itmObjList, PHB_BASEARRAY pObjHandle )
{
  if(!pObjHandle || (rdo_itmObjList.find( pObjHandle ) == rdo_itmObjList.end()) )
    return NULL;
  return rdo_itmObjList[ pObjHandle ];
}

/*
  TRDOServer:Accept
  Teo. Mexico 2008
*/
HB_FUNC( TRDOSERVER_ACCEPT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketServer* socketServer = (wx_SocketServer*) wxh_ItemListGetWX( pSelf );
  wxSocketBase* socketBase;

  bool wait = ISLOG( 1 ) ? hb_parl( 1 ) : true;

  if( pSelf && socketServer )
  {
    socketBase = socketServer->Accept( wait );
    if(socketBase)
    {
      PHB_ITEM p = hb_itemNew( NULL );
      HB_FUNC_EXEC( TRDOSOCKETBASE );
      hb_itemCopy( p, hb_stackReturnItem() );
      wxh_ItemListAdd( socketBase, p );
      hb_itemReturnRelease( p );
    }
  }
}

/*
  TRDOServer:ProcessClientRequests
  Teo. Mexico 2009
*/
HB_FUNC( TRDOSOCKETBASE_PROCESSCLIENTREQUESTS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_SocketBase* socketBase = (wx_SocketBase*) wxh_ItemListGetWX( pSelf );

  ULONG bufSize;
  USHORT iPCount;
  char* nameClass;
  char* nameMsg;

  RDO_ITMOBJLIST rdo_itmObjList;

  struct
  {
    PHB_BASEARRAY pObjHandle;
    BYTE   msgLen;
    char   pBuffer[ SND_BUFFERSIZE ];
  } bufHeader;

  if( socketBase )
    while( socketBase->IsOk() && !socketBase->IsDisconnected() )
    {
      if( socketBase->IsData() )
      {
        socketBase->Read( &bufSize, sizeof( bufSize ) );
        bufSize -= sizeof( bufSize );
        if( socketBase->Error() )
        {
          /* TODO: fire some kind of recovery error */
          continue;
        }
        socketBase->Read( &bufHeader, bufSize );
        char* sep = strchr( bufHeader.pBuffer, ':' );
        nameClass = bufHeader.pBuffer;
        sep[ 0 ] = '\0';
        nameMsg = sep + 1;
        memcpy( &iPCount, bufHeader.pBuffer + bufHeader.msgLen, sizeof( iPCount ) );

        PHB_ITEM pItmObj;

        /* if creating a new object then add to hash map */
        if( strcmp( nameMsg, "NEW" ) == 0 )
        {

          PHB_DYNS pDynSym = hb_dynsymFind( nameClass );

          if( ! pDynSym )
          {
            wxLogMessage( _T( "Invalid Object Class name." ), nameClass );
            continue;
          }

          /* Create the Object Class */
          hb_vmPushDynSym( pDynSym );
          hb_vmPushNil();
          hb_vmDo( 0 );
          pItmObj = hb_stackReturnItem();
        }
        else /* get the object from the hash map */
        {
          pItmObj = rdo_ItmObjListGet( rdo_itmObjList, bufHeader.pObjHandle );
        }

        /* the Message to be called */
        hb_vmPushSymbol( hb_dynsymGet( nameMsg )->pSymbol );
        hb_vmPush( pItmObj );

        /* the Params */
        if( iPCount )
        {
          ULONG ulNode,ulResult,uIndex;
          PHB_ITEM pItm;
          uIndex = bufHeader.msgLen + sizeof( iPCount );
          for( USHORT i = 0; i < iPCount; i++ )
          {
            memcpy( &ulNode, bufHeader.pBuffer + uIndex, sizeof( ulNode ) );
            ulResult = ulNode;
            uIndex += sizeof( ulNode );
            const char *pIndex = bufHeader.pBuffer + uIndex;
            pItm = hb_itemDeserialize( &pIndex, &ulResult );
            uIndex += ulNode;
            if( pItm )
            {
              hb_vmPush( pItm );
              hb_itemRelease( pItm );
            }
          }
        }

        /* TODO: Allow to bypass class scope checking */
        hb_vmSend( iPCount ); /* the Message call */

        char *pReturn = hb_itemSerialize( hb_stackReturnItem(), FALSE, &bufSize );

        /* send to Client the header size */
        socketBase->Write( &bufSize, sizeof( bufSize ) );
        /* send to Client the return item */
        socketBase->Write( pReturn, bufSize );

        hb_xfree( pReturn );

      }
    }

    /* free table objects */
    rdo_ItmObjListFree( rdo_itmObjList );

}
