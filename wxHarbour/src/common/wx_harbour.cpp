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

/* PHB_BASEARRAY keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_PHB_BASEARRAY );

/* wxObject* keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( wxObject*, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_WXOBJECT );

static MAP_PHB_BASEARRAY map_phbBaseArr;
static MAP_WXOBJECT map_wxObject;

static PHB_ITEM lastTopLevelWindow;

/*
  destructor
  Teo. Mexico 2009
*/
wxh_Item::~wxh_Item()
{
  const char *hbClassName;
  if( this->pSelf )
    hbClassName = hb_clsName( this->pSelf->item.asArray.value->uiClass );
  else
    hbClassName = "<unknown>";
  //const char *wxClassName = (char *) (wxString( this->wxObj->GetClassInfo()->GetClassName() ).c_str() );
  const char *c1 = wxString( this->wxObj->GetClassInfo()->GetClassName(), wxConvISO8859_1 ).mb_str();
  char text[ 50 ] ;
  strcpy( text, c1 );
  qoutf("~wxh_Item = hb: %s, wx: %s", hbClassName, text );

  map_phbBaseArr.erase( this->objHandle );
  map_wxObject.erase( this->wxObj  );

  /* release codeblocks stored in event list */
  if( this->evtList.size() > 0 )
  {
    for( vector<PCONN_PARAMS>::iterator it = this->evtList.begin(); it < this->evtList.end(); it++ )
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
    qoutf("deleting wx...");
    delete this->wxObj;
  }

  if( pSelf )
  {
    qoutf("releasing item...");
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
  pSelf = hb_stackSelfItem();
  pWxh_Item = wxh_ItemListGet_PWXH_ITEM( pSelf );
}

/*
  constructor
  Teo. Mexico 2009
*/
wxh_ObjParams::wxh_ObjParams( PHB_ITEM pHbObj )
{
  pSelf = pHbObj ;
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
  return wxh_param_WX( param );
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
      map_paramListParent[ pParentItm ] = wxObj;
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
  /* add the Parent objects to the child/parent lists */
  while( map_paramListParent.size() > 0 )
  {
    MAP_PHB_ITEM::iterator it = map_paramListParent.begin();
    SetChildItem( pSelf );
    map_paramListParent.erase( it );
  }

  /* add the Child objects to the child/parent lists */
#if 1
  while( map_paramListChild.size() > 0 )
  {
    MAP_PHB_ITEM::iterator it = map_paramListChild.begin();
    SetChildItem( it->first );
    map_paramListChild.erase( it );
  }
#endif

}

/*
  Return
  Teo. Mexico 2009
*/
void wxh_ObjParams::Return( wxObject* wxObj, bool bItemRelease )
{
  pWxh_Item = NULL;

  /* checks for a valid new pSelf object */
  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) == map_phbBaseArr.end() ) )
  {
    if( hb_clsIsParent( pSelf->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
    {
      lastTopLevelWindow = pSelf;
    }

    pWxh_Item = new wxh_Item;
    pWxh_Item->wxObj = wxObj;
    pWxh_Item->objHandle = pSelf->item.asArray.value;

    map_phbBaseArr[ pSelf->item.asArray.value ] = pWxh_Item;
    map_wxObject[ wxObj ] = pWxh_Item;

    ProcessParamLists();

    if( bItemRelease )
      hb_itemReturnRelease( pSelf );
    else
      hb_itemReturn( pSelf );

  }else
    qoutf("Problemas.");

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
      pWxh_ItemChild->pSelf = hb_itemNew( pChildItm );
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
  else
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 2, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
//   qout( hb_clsName( pSelf->item.asArray.value->uiClass ) );
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
    //wxh_ItemListDel_WX( it->first );
  }
}

/*
  wxh_param_WX
  Teo. Mexico 2009
*/
wxObject* wxh_param_WX( const int param )
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
        arrayString.Add( wxString( pItm->item.asString.value, wxConvLocal) );
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
  wxh_parc
  Teo. Mexico 2009
*/
wxString wxh_parc( int param )
{
  return wxString( hb_parc( param ), wxConvUTF8 );
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
