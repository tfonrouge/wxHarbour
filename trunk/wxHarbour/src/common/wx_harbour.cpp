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

/* wxObject* keys, PHBITM_REF values */
WX_DECLARE_HASH_MAP( wxObject*, PHB_BASEARRAY, wxPointerHash, wxPointerEqual, MAP_WXOBJECT );

static MAP_PHB_BASEARRAY map_phbBaseArr;
static MAP_WXOBJECT map_wxObject;
static MAP_PHB_ITEM map_phbItem;

static PHB_ITEM lastTopLevelWindow;

/*
  wxh_ItemListDel_HB
  Teo. Mexico 2009
*/
void wxh_ItemListDel_HB( PHB_ITEM pSelf, bool lDeleteWxObj, bool lReleaseCodeblockItm )
{
  if( pSelf && map_phbBaseArr.find( pSelf->item.asArray.value ) != map_phbBaseArr.end() )
  {
    PWXH_ITEM pwxhItm = map_phbBaseArr[ pSelf->item.asArray.value ];

   /* removes child PHB_ITEMS (if any) */
    while( !pwxhItm->map_childList.empty() )
    {
      wxh_ItemListDel_HB( pwxhItm->map_childList.begin()->first, false );
    }

    map_phbBaseArr.erase( pSelf->item.asArray.value );

    wxObject* wxObj = wxh_ItemListGetWX( pSelf );

    if( wxObj )
    {
      vector<PCONN_PARAMS> evtList = wxh_ItemListGet_PWXH_ITEM( wxObj )->evtList;

      /* release codeblocks stored in event list */
      if( ! evtList.empty() )
      {
        for( vector<PCONN_PARAMS>::iterator it = evtList.begin(); it < evtList.end(); it++ )
        {
          PCONN_PARAMS pConnParams = *it;
          if( pConnParams->pItmActionBlock && lReleaseCodeblockItm )
          {
            hb_itemRelease( pConnParams->pItmActionBlock );
            pConnParams->pItmActionBlock = NULL;
          }
          delete pConnParams;
        }
      }

      //map_wxObject.erase( wxObj );

      if( lDeleteWxObj )
      {
        delete wxObj;
        wxObj = NULL;
      }
    }
  }
}

/*
  wxh_ItemListDel_WX
  Teo. Mexico 2009
*/
void wxh_ItemListDel_WX( wxObject* wxObj )
{
  PHB_ITEM pSelf = wxh_ItemListGetHB( wxObj );

  if( pSelf )
  {
    wxh_ItemListDel_HB( pSelf, false, false );
  }
}

/*
  wxh_ItemListGetHB
  Teo. Mexico 2009
*/
PHB_ITEM wxh_ItemListGetHB( wxObject* wxObj )
{
  PHB_ITEM pSelf = NULL;

  if( wxObj && ( map_wxObject.find( wxObj ) != map_wxObject.end() ) )
  {
    PHB_BASEARRAY hbObjH = map_wxObject[ wxObj ];
    if( hbObjH && ( map_phbBaseArr.find( hbObjH ) != map_phbBaseArr.end() ) )
    {
      pSelf = map_phbBaseArr[ hbObjH ]->pSelf;
    }
  }
  return pSelf;
}

/*
  wxh_ItemListGetWX
  Teo. Mexico 2009
*/
wxObject* wxh_ItemListGetWX( PHB_ITEM pSelf )
{
  if(!pSelf || (map_phbBaseArr.find( pSelf->item.asArray.value ) == map_phbBaseArr.end()) )
    return NULL;

  return map_phbBaseArr[ pSelf->item.asArray.value ]->wxObj;
}

/*
  wxh_ItemListGet_PWXH_ITEM
  Teo. Mexico 2009
*/
PWXH_ITEM wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj )
{
  if( wxObj && ( map_wxObject.find( wxObj ) != map_wxObject.end() ) )
  {
    PHB_BASEARRAY pHbObjH = map_wxObject[ wxObj ];
    if( pHbObjH && ( map_phbBaseArr.find( pHbObjH ) != map_phbBaseArr.end() ) )
    {
      return map_phbBaseArr[ pHbObjH ];
    }
  }
  return NULL;
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
  wxh_SetScopeList
  Teo. Mexico 2009
*/
void wxh_SetScopeList( wxObject* wxObj, WXH_SCOPELIST* wxhScopeList )
{
  PHB_ITEM pSelf = wxhScopeList->pSelf;

  /* checks for a valid new pSelf object */
  if( pSelf && ( map_phbBaseArr.find( pSelf->item.asArray.value ) == map_phbBaseArr.end() ) )
  {
    if( hb_clsIsParent( pSelf->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
    {
      lastTopLevelWindow = pSelf;
    }

    PWXH_ITEM pwxhItm = new WXH_ITEM;
    pwxhItm->wxObj = wxObj;
    pwxhItm->pSelf = pSelf;

    for( MAP_PHB_ITEM::iterator it = wxhScopeList->itmList.begin(); it != wxhScopeList->itmList.end(); it++ )
    {
      PHB_ITEM pItm = hb_itemNew( it->first );
      pwxhItm->map_parentList[ pItm ] = it->second;

      if( map_wxObject.find( it->second ) != map_wxObject.end() )
      {
        map_wxObject[ it->second ] = pItm->item.asArray.value;
      }
    }
    map_phbBaseArr[ pSelf->item.asArray.value ] = pwxhItm;
  }
}

/*
  hb_par_WX
  Teo. Mexico 2009
*/
wxObject* hb_par_WX( const int param, WXH_SCOPELIST* wxhScopeList )
{
  PHB_ITEM pSelf = hb_param( param, HB_IT_OBJECT );
  wxObject* wxObj = wxh_ItemListGetWX( pSelf );

  if( wxObj && wxhScopeList )
  {
    wxhScopeList->AddItm( pSelf, wxObj );
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
