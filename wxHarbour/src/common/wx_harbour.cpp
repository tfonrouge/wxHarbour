/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxharbour:
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/hashset.h"
#include "wxh.h"

#ifdef __XHARBOUR__
  ULONG hb_crc32( ULONG crc, const BYTE *buf, size_t size );
#endif

/* PHB_BASEARRAY keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_PHB_BASEARRAY );

/* wxObject* keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( wxObject*, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_WXOBJECT );

/* long keys (crc32), wxh_Item* values */
WX_DECLARE_HASH_MAP( long, wxh_Item*, wxIntegerHash, wxIntegerEqual, MAP_CRC32 );

static MAP_PHB_BASEARRAY map_phbBaseArr;
static MAP_WXOBJECT map_wxObject;
static MAP_CRC32 map_crc32;

static PHB_ITEM lastTopLevelWindow;

#ifdef __XHARBOUR__

void hb_procname( UINT uiProcOffset, char* szName, bool fMethodName )
{
  hb_procinfo( uiProcOffset + 1, szName, NULL, NULL );
}
#endif

/*
  destructor
  Teo. Mexico 2009
*/
wxh_Item::~wxh_Item()
{
  map_phbBaseArr.erase( objHandle );
  map_wxObject.erase( wxObj  );

  if( map_crc32.find( uiProcNameLine ) != map_crc32.end() )
    map_crc32.erase( uiProcNameLine );

  /* release codeblocks stored in event list */
  if( evtList.size() > 0 )
  {
    for( vector<PCONN_PARAMS>::iterator it = evtList.begin(); it < evtList.end(); it++ )
    {
      PCONN_PARAMS pConnParams = *it;
      if( pConnParams->pItmActionBlock )
      {
        hb_itemRelease( pConnParams->pItmActionBlock );
        pConnParams->pItmActionBlock = NULL;
      }
      delete pConnParams;
    }
  }

  if( delete_WX )
  {
    if( wxObj )
      delete wxObj;
  }

  if( pSelf )
  {
    hb_objSendMsg( pSelf, "ClearObjData", 0 );
    hb_itemRelease( pSelf );
    pSelf = NULL;
  }
}

/*
  constructor
  Teo. Mexico 2009
*/
wxh_ObjParams::wxh_ObjParams()
{
  pParamParent = NULL;
  paramListProcessed = false;
  pSelf = hb_stackSelfItem();
  pWxh_Item = wxh_ItemListGet_PWXH_ITEM( pSelf );
}

/*
  constructor
  Teo. Mexico 2009
*/
wxh_ObjParams::wxh_ObjParams( PHB_ITEM pHbObj )
{
  pParamParent = NULL;
  paramListProcessed = false;
  pSelf = pHbObj;
  pWxh_Item = wxh_ItemListGet_PWXH_ITEM( pSelf );
}

/*
  destructor
  Teo. Mexico 2009
*/
wxh_ObjParams::~wxh_ObjParams()
{
  ProcessParamLists();
}

/*
  Get_wxObject
  Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::Get_wxObject()
{
  return wxh_ItemListGet_WX( pSelf );
}

/*
  param
  Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::param( const int param )
{
  return wxh_parWX( param );
}

/*
  paramChild
  Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramChild( const int param )
{
  PHB_ITEM pChildItm = hb_param( param, HB_IT_OBJECT );
  wxObject* wxObj = NULL;

  if( pChildItm )
  {
    wxObj = wxh_ItemListGet_WX( pChildItm );

    if( wxObj )
    {
      map_paramListChild[ pChildItm ] = wxObj;
    }
  }

  return wxObj;
}

/*
  paramParent
  Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramParent( const int param )
{
  PHB_ITEM pParentItm = hb_param( param, HB_IT_OBJECT );
  wxObject* wxObj = NULL;

  if( pParentItm )
  {
    wxObj = wxh_ItemListGet_WX( pParentItm );

    if( wxObj )
    {
      if( this->pParamParent == NULL )
	this->pParamParent = pParentItm;
      else
	hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 3, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
    }
  }

  return wxObj;
}

/*
  ProcessParamLists
  Teo. Mexico 2009
*/
void wxh_ObjParams::ProcessParamLists()
{
  if( !paramListProcessed )
  {
    /* add the Parent object (if any) to the child/parent lists */
//     if( pParamParent )
      SetChildItem( pSelf );

    /* add the Child objects to the child/parent lists */
    while( map_paramListChild.size() > 0 )
    {
      MAP_PHB_ITEM::iterator it = map_paramListChild.begin();
      SetChildItem( it->first );
      map_paramListChild.erase( it );
    }

    paramListProcessed = true;
  }
}

/*
  Return
  Teo. Mexico 2009
*/
void wxh_ObjParams::Return( wxObject* wxObj, bool bItemRelease )
{
  /* checks for a valid new pSelf object */
  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) == map_phbBaseArr.end() ) )
  {
    pWxh_Item = NULL;
    PHB_ITEM pItem = NULL;

    pWxh_Item = new wxh_Item;
    pWxh_Item->wxObj = wxObj;
    pWxh_Item->uiClass = pSelf->item.asArray.value->uiClass;
    pWxh_Item->objHandle = pSelf->item.asArray.value;

    /* Objs derived from wxTopLevelWindow are not volatile to local */
    if( hb_clsIsParent( pSelf->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
    {
      /* calculate the crc32 for the procname/procline/uiClass that created this obj */
      char szName[ HB_SYMBOL_NAME_LEN + HB_SYMBOL_NAME_LEN + 5 ];
      UINT uiProcOffset = 1;
      USHORT usProcLine = 0;

      hb_procname( uiProcOffset, szName, TRUE );
      if( strncmp( "__WXH_", szName, 6 ) == 0 )
        hb_procname( ++uiProcOffset, szName, TRUE );

#ifdef __XHARBOUR__
      hb_procinfo( uiProcOffset + 1, NULL, &usProcLine, NULL );
#else
      long lOffset = hb_stackBaseProcOffset( uiProcOffset );
      if( lOffset > 0 )
        usProcLine = hb_stackItem( lOffset )->item.asSymbol.stackstate->uiLineNo;
#endif
      UINT uiCrc32 = hb_crc32( (long) pSelf->item.asArray.value->uiClass + usProcLine, (const BYTE *) szName, strlen( szName ) );

//       qoutf("METHODNAME: %s:%d, crc32: %u", szName, usProcLine, uiCrc32 );

      /* check if we are calling again the obj creation code and a wxh_Item exists */
      if( map_crc32.find( uiCrc32 ) != map_crc32.end() )
      {
        delete map_crc32[ uiCrc32 ];
      }

      map_crc32[ uiCrc32 ] = pWxh_Item;
      pWxh_Item->uiProcNameLine = uiCrc32;

      pItem = hb_itemNew( pSelf );
      lastTopLevelWindow = pItem;
    }

    if( pItem )
    {
      pWxh_Item->pSelf = pItem;
    }

    map_phbBaseArr[ pSelf->item.asArray.value ] = pWxh_Item;
    map_wxObject[ wxObj ] = pWxh_Item;

    ProcessParamLists();

    if( hb_stackReturnItem() != pSelf )
    {
      if( bItemRelease )
        hb_itemReturnRelease( pSelf );
      else
        hb_itemReturn( pSelf );
    }

  }else
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 4, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
  SetChildItem
  Teo. Mexico 2009
*/
void wxh_ObjParams::SetChildItem( const PHB_ITEM pChildItm )
{
  wxh_Item* pWxh_ItemChild = wxh_ItemListGet_PWXH_ITEM( pChildItm );

  if( pWxh_ItemChild )
  {
    if( pWxh_ItemChild->pSelf == NULL )
    {
      pWxh_ItemChild->pSelf = hb_itemNew( pChildItm );
    }
    else
      pWxh_ItemChild->uiRefCount++;
  }else
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 2, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
  End Class wxh_ObjParams
*/

/*
  wxh_ItemListDel_WX
  Teo. Mexico 2009
*/
void wxh_ItemListDel_WX( wxObject* wxObj, bool bDeleteWxObj )
{
  wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( wxObj );

  if( pWxh_Item )
  {
    pWxh_Item->delete_WX = bDeleteWxObj;
    delete pWxh_Item;
  }
}

/*
  wxh_ItemListGet_HB
  Teo. Mexico 2009
*/
PHB_ITEM wxh_ItemListGet_HB( wxObject* wxObj )
{
  PHB_ITEM pSelf = NULL;
  wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( wxObj );

  if( pWxh_Item )
  {
    pSelf = pWxh_Item->pSelf;
    if( hb_itemType( pSelf ) != HB_IT_OBJECT )
      pSelf = NULL;
  }

  if( pSelf == NULL )
  {
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 2, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
  }

  return pSelf;
}

/*
  wxh_ItemListGet_PWXH_ITEM
  Teo. Mexico 2009
*/
wxh_Item* wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj )
{
  wxh_Item* pWxh_Item = NULL;

  if( wxObj && ( map_wxObject.find( wxObj ) != map_wxObject.end() ) )
  {
    pWxh_Item = map_wxObject[ wxObj ];
  }

  return pWxh_Item;
}

/*
  wxh_ItemListGet_PWXH_ITEM
  Teo. Mexico 2009
*/
wxh_Item* wxh_ItemListGet_PWXH_ITEM( PHB_ITEM pSelf )
{
  wxh_Item* pWxh_Item = NULL;

  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) != map_phbBaseArr.end() ) )
  {
    pWxh_Item = map_phbBaseArr[ pSelf->item.asArray.value ];
  }

  return pWxh_Item;
}

/*
  wxh_ItemListGet_WX
  Teo. Mexico 2009
*/
wxObject* wxh_ItemListGet_WX( PHB_ITEM pSelf )
{
  wxObject* wxObj = NULL;

  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) != map_phbBaseArr.end() ) )
  {
    wxObj = map_phbBaseArr[ pSelf->item.asArray.value ]->wxObj;
  }

  return wxObj;
}

/*
  wxh_ItemListReleaseAll
  Teo. Mexico 2009
*/
void wxh_ItemListReleaseAll()
{
  MAP_WXOBJECT::iterator it;
  while( ! map_wxObject.empty() )
  {
    it = map_wxObject.begin();
    it->second->delete_WX = false;
    delete it->second;
    //wxh_ItemListDel_WX( it->first );
  }
}

/*
  wxh_parWX
  Teo. Mexico 2009
*/
wxObject* wxh_parWX( const int param )
{
  return wxh_ItemListGet_WX( hb_param( param, HB_IT_OBJECT ) );
}

/*
  hb_par_wxArrayString
  Teo. Mexico 2009
*/
wxArrayString hb_par_wxArrayString( int param )
{
  wxArrayString arrayString;

  if( ISARRAY( param ) )
  {
    PHB_ITEM pArray = hb_param( param, HB_IT_ARRAY );
    PHB_ITEM pItm;
    ULONG ulLen = pArray->item.asArray.value->ulLen;
    for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
    {
      pItm = hb_arrayGetItemPtr( pArray, ulI );
      if( hb_itemType( pItm ) && ( HB_IT_STRING || HB_IT_MEMO ) )
      {
        arrayString.Add( wxh_CTowxStr( pItm->item.asString.value ) );
      }
    }
  }

  return arrayString;
}

/*
  hb_par_wxPoint
  Teo. Mexico 2009
*/
wxPoint hb_par_wxPoint( int param )
{
  PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
  if( pStruct && hb_arrayLen( pStruct ) == 2 )
  {
    PHB_ITEM p1,p2;
    p1 = hb_arrayGetItemPtr( pStruct, 1 );
    p2 = hb_arrayGetItemPtr( pStruct, 2 );
    int x = HB_IS_NUMERIC( p1 ) ? p1->item.asInteger.value : -1;
    int y = HB_IS_NUMERIC( p2 ) ? p2->item.asInteger.value : -1;
    return wxPoint( x, y );
  }
  else
    return wxPoint( -1, -1 );
}

/*
  hb_par_wxSize
  Teo. Mexico 2009
*/
wxSize hb_par_wxSize( int param )
{
  PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
  if( pStruct && hb_arrayLen( pStruct ) == 2 )
  {
    PHB_ITEM p1,p2;
    p1 = hb_arrayGetItemPtr( pStruct, 1 );
    p2 = hb_arrayGetItemPtr( pStruct, 2 );
    int x = HB_IS_NUMERIC( p1 ) ? p1->item.asInteger.value : -1;
    int y = HB_IS_NUMERIC( p2 ) ? p2->item.asInteger.value : -1;
    return wxSize( x, y );
  }
  else
    return wxSize( -1, -1 );
}

/*
  wxh_CTowxStr
  Teo. Mexico 2009
*/
wxString wxh_CTowxStr( const char * szStr )
{
  return wxString( szStr, wxConvLocal );
}

/*
  wxh_parc
  Teo. Mexico 2009
*/
wxString wxh_parc( int param )
{
  return wxh_CTowxStr( hb_parc( param ) );
}

/*
 * wxh_LastTopLevelWindow
 * Teo. Mexico 2009
 */
HB_FUNC( WXH_LASTTOPLEVELWINDOW )
{
  hb_itemReturn( lastTopLevelWindow );
}

/*
  wxMutexGuiEnter
  Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUIENTER )
{
  wxMutexGuiEnter();
}

/*
  wxMutexGuiLeave
  Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUILEAVE )
{
  wxMutexGuiLeave();
}

/*
  qoutf
  Teo. Mexico 2009
*/
void qoutf( const char* format, ... )
{
  static char text[512];
  static PHB_DYNS s___qout = NULL;

  va_list argp;

  va_start( argp, format );
  vsprintf( text, format, argp );
  va_end( argp );

  if( s___qout == NULL )
  {
    s___qout = hb_dynsymGetCase( "QOUT" );
  }
  hb_vmPushDynSym( s___qout );
  hb_vmPushNil();
  hb_vmPushString( text, strlen( text ) );
  hb_vmDo( 1 );
}
