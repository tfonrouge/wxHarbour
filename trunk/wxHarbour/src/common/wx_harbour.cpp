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

/* PHB_BASEARRAY keys, PWXH_ITEM values */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, PWXH_ITEM, wxPointerHash, wxPointerEqual, MAP_PHB_BASEARRAY );

/* wxObject* keys, PWXH_ITEM values */
WX_DECLARE_HASH_MAP( wxObject*, PWXH_ITEM, wxPointerHash, wxPointerEqual, MAP_WXOBJECT );

static MAP_PHB_BASEARRAY map_phbBaseArr;
static MAP_WXOBJECT map_wxObject;

static PHB_ITEM lastTopLevelWindow;

/*
  SetParentChildKey
  Teo. Mexico 2009
*/
static void SetParentChildKey( PWXH_ITEM pwxhItm, PHB_ITEM pParentItm, PHB_ITEM pChildItm )
{
  PWXH_ITEM pwxhParentItm = wxh_ItemListGet_PWXH_ITEM( pParentItm );
  PWXH_ITEM pwxhChildItm;

  if( pwxhParentItm )
  {
    PHB_ITEM pRefItm = hb_itemNew( pChildItm );

    pwxhItm->map_refList[ pRefItm ] = true;
    pwxhParentItm->map_childList[ pRefItm ] = true;
    pwxhChildItm = wxh_ItemListGet_PWXH_ITEM( pChildItm );
  }
}

/*
  constructor
  Teo. Mexico 2009
*/
WXH_SCOPELIST::WXH_SCOPELIST( PHB_ITEM pSelf )
{
  this->pSelf = pSelf;
}

/*
  PushObject
  Teo. Mexico 2009
*/
void WXH_SCOPELIST::PushObject( wxObject* wxObj )
{

  /* checks for a valid new pSelf object */
  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) == map_phbBaseArr.end() ) )
  {
    if( hb_clsIsParent( pSelf->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
    {
      lastTopLevelWindow = pSelf;
    }

    PWXH_ITEM pwxhItm = new WXH_ITEM;
    pwxhItm->wxObj = wxObj;
    pwxhItm->objHandle = pSelf->item.asArray.value;

    /* this object is the Harbour var created in the ::New() method
       and the Harbour programmer is responsible to keep it alive */
//     pwxhItm->pSelf = pSelf;
    pwxhItm->pSelf = hb_itemNew( pSelf );

    map_phbBaseArr[ pSelf->item.asArray.value ] = pwxhItm;
    map_wxObject[ wxObj ] = pwxhItm;

    /* add the Parent objects to the child/parent lists */
    while( map_paramList.size() > 0 )
    {
      MAP_PHB_ITEM::iterator it = map_paramList.begin();
      SetParentChildKey( pwxhItm, it->first, pSelf );
      map_paramList.erase( it );
    }
  }
}
/*
  wxh_ItemListDel_HB
  Teo. Mexico 2009
*/
void wxh_ItemListDel_HB( PHB_ITEM pSelf, bool lDeleteWxObj )
{
  PWXH_ITEM pwxhItm = wxh_ItemListGet_PWXH_ITEM( pSelf );

  if( pwxhItm && pwxhItm->wxObj && lDeleteWxObj )
  {
//     qout( "In wxh_ItemListDel_HB." );
    //map_wxObject.erase( wxObj );
//     delete pwxhItm->wxObj;
//     pwxhItm->wxObj = NULL;
//     qout( "Out wxh_ItemListDel_HB." );
  }
}

/*
  wxh_ItemListDel_WX
  Teo. Mexico 2009
*/
void wxh_ItemListDel_WX( wxObject* wxObj )
{
  PWXH_ITEM pwxhItm = wxh_ItemListGet_PWXH_ITEM( wxObj );


  if( pwxhItm )
  {
//     qout( "In wxh_ItemListDel_WX.");

    map_phbBaseArr.erase( pwxhItm->objHandle );
    map_wxObject.erase( pwxhItm->wxObj  );

    /* scan a map_childList to release hb items */
    for( MAP_PHB_ITEM::iterator it = pwxhItm->map_childList.begin(); it != pwxhItm->map_childList.end(); it++ )
    {
      PWXH_ITEM pwxhChildItm = wxh_ItemListGet_PWXH_ITEM( it->first );

      if( pwxhChildItm )
      {
        wxh_ItemListDel_WX( pwxhChildItm->wxObj );
      }

      if( it->second )
      {
        it->second = false;
        hb_itemRelease( it->first );
      }
    }

    /* release codeblocks stored in event list */
    if( pwxhItm && ( pwxhItm->evtList.size() > 0 ) )
    {
      for( vector<PCONN_PARAMS>::iterator it = pwxhItm->evtList.begin(); it < pwxhItm->evtList.end(); it++ )
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

    delete pwxhItm;
  }
}

/*
  wxh_ItemListGet_HB
  Teo. Mexico 2009
*/
PHB_ITEM wxh_ItemListGet_HB( wxObject* wxObj )
{
  PHB_ITEM pSelf = NULL;
  PWXH_ITEM pwxhItm = wxh_ItemListGet_PWXH_ITEM( wxObj );

  if( pwxhItm )
  {
    /* search on the parent objects for a reference on his childList */
    if( pwxhItm->map_refList.size() > 0 )
    {
      pSelf = pwxhItm->map_refList.begin()->first;
    }else
      pSelf = pwxhItm->pSelf;
  }
//   qout( hb_clsName( pSelf->item.asArray.value->uiClass ) );
  return pSelf;
}

/*
  wxh_ItemListGet_PWXH_ITEM
  Teo. Mexico 2009
*/
PWXH_ITEM wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj )
{
  PWXH_ITEM pwxhItm = NULL;

  if( wxObj && ( map_wxObject.find( wxObj ) != map_wxObject.end() ) )
  {
    pwxhItm = map_wxObject[ wxObj ];
  }

  return pwxhItm;
}

/*
  wxh_ItemListGet_PWXH_ITEM
  Teo. Mexico 2009
*/
PWXH_ITEM wxh_ItemListGet_PWXH_ITEM( PHB_ITEM pSelf )
{
  PWXH_ITEM pwxhItm = NULL;

  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) != map_phbBaseArr.end() ) )
  {
    pwxhItm = map_phbBaseArr[ pSelf->item.asArray.value ];
  }

  return pwxhItm;
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
  wxh_param_WX_Child
  Teo. Mexico 2009
*/
wxObject* wxh_param_WX_Child( const int param, PHB_ITEM pParentItm )
{
  PHB_ITEM pChildItm = hb_param( param, HB_IT_OBJECT );
  PWXH_ITEM pwxhItm = wxh_ItemListGet_PWXH_ITEM( pChildItm );

  if( pwxhItm && pParentItm )
  {
    SetParentChildKey( pwxhItm, pParentItm, pChildItm );
    return pwxhItm->wxObj;
  }

  return NULL;
}

/*
  wxh_param_WX_Parent
  Teo. Mexico 2009
*/
wxObject* wxh_param_WX_Parent( const int param, WXH_SCOPELIST* wxhScopeList )
{
  PHB_ITEM pParentItm = hb_param( param, HB_IT_OBJECT );
  wxObject* wxObj = wxh_ItemListGet_WX( pParentItm );

  if( wxObj )
  {
    wxhScopeList->map_paramList[ pParentItm ] = wxObj;
  }

  return wxObj;
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
  qout
  Teo. Mexico 2009
*/
void qout( const char* text )
{
  static PHB_DYNS s___qout = NULL;

  if( s___qout == NULL )
  {
    s___qout = hb_dynsymGetCase( "QOUT" );
  }

  hb_vmPushDynSym( s___qout );
  hb_vmPushNil();
  hb_vmPushString( text, strlen( text ) );
  hb_vmDo( 1 );
}
