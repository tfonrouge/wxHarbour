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

/* PHB_ITEM keys */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, wxObject*, wxPointerHash, wxPointerEqual, HBITEMLIST );

/* PWXH_ITEM keys */
WX_DECLARE_HASH_MAP( wxObject*, PHBITM_REF, wxPointerHash, wxPointerEqual, WXITEMLIST );

static HBITEMLIST hbItemList;
static WXITEMLIST wxItemList;

static PHB_ITEM lastTopLevelWindow;

/*
  wxh_ItemListAdd: Add wxObject & PHB_ITEM objects to hash list
  Teo. Mexico 2009
*/
void wxh_ItemListAdd( wxObject* wxObj, PHB_ITEM pSelf )
{
  PHBITM_REF pItmRef = new HBITM_REF;
  pItmRef->pLocal = pSelf;
  pItmRef->pStatic = NULL;

  if( hb_clsIsParent( pSelf->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
  {
    lastTopLevelWindow = pSelf;
  }

  hbItemList[ pSelf->item.asArray.value ] = wxObj;
  wxItemList[ wxObj ] = pItmRef;
}

/*
  wxh_ItemListDel_HB
  Teo. Mexico 2009
*/
void wxh_ItemListDel_HB( PHB_ITEM pSelf, bool lDeleteWxObj, bool lReleaseCodeblockItm )
{
  if( pSelf )
  {
    wxObject* wxObj = wxh_ItemListGetWX( pSelf );

    if( hbItemList.find( pSelf->item.asArray.value ) != hbItemList.end() )
    {
      hbItemList.erase( pSelf->item.asArray.value );
    }

    if( wxObj )
    {
      PHBITM_REF pItmRef = wxh_ItemListGetHBREF( wxObj );

      /* release codeblocks stored in event list */
      if( pItmRef )
      {
        PCONN_PARAMS pConnParams;
        vector<PCONN_PARAMS> v = pItmRef->evtList;

        vector<PCONN_PARAMS>::iterator it;
        for( it = v.begin(); it < v.end(); it++ )
        {
          pConnParams = *it;
          if( pConnParams->pItmActionBlock && lReleaseCodeblockItm )
          {
            hb_itemRelease( pConnParams->pItmActionBlock );
            pConnParams->pItmActionBlock = NULL;
          }
          delete pConnParams;
        }
      }

      wxItemList.erase( wxObj );

      if( wxObj && lDeleteWxObj )
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
  PHBITM_REF pItmRef;
  PHB_ITEM pSelf = NULL;

  pItmRef = wxh_ItemListGetHBREF( wxObj );

  if( pItmRef )
  {
    if( pItmRef->pStatic )
      pSelf = pItmRef->pStatic;
    else
      pSelf = pItmRef->pLocal;
  }
  return pSelf;
}

/*
  wxh_ItemListGetHBREF
  Teo. Mexico 2009
*/
PHBITM_REF wxh_ItemListGetHBREF( wxObject* wxObj )
{
  if( !wxObj || ( wxItemList.find( wxObj ) == wxItemList.end() ) )
    return NULL;

  return wxItemList[ wxObj ];
}

/*
  wxh_ItemListGetWX
  Teo. Mexico 2009
*/
wxObject* wxh_ItemListGetWX( PHB_ITEM pSelf )
{
  if(!pSelf || (hbItemList.find( pSelf->item.asArray.value ) == hbItemList.end()) )
    return NULL;

  return hbItemList[ pSelf->item.asArray.value ];
}

/*
  wxh_ItemListSetStaticItm
  Teo. Mexico 2009
*/
void wxh_ItemListSetStaticItm( wxObject* wxObj, PHB_ITEM pSelf )
{
  PHBITM_REF pItmRef = wxh_ItemListGetHBREF( wxObj );

  if( pItmRef && pItmRef->pStatic == NULL )
  {
    pItmRef->pStatic = hb_itemNew( pSelf );
  }
}

/*
  wxh_ItemListReleaseAll
  Teo. Mexico 2009
*/
void wxh_ItemListReleaseAll()
{
  WXITEMLIST::iterator it;
  while( ! wxItemList.empty() )
  {
    it = wxItemList.begin();
    wxh_ItemListDel_WX( it->first );
  }
}

/*
  wxh_SetWXLocalList
  Teo. Mexico 2009
*/
void wxh_SetWXLocalList( wxObject* wxObj, TLOCAL_ITM_LIST* pLocalList )
{
}
/*
  hb_par_WX
  Teo. Mexico 2009
*/
wxObject* hb_par_WX( const int param, TLOCAL_ITM_LIST* pLocalList )
{
  PHB_ITEM pSelf = hb_param( param, HB_IT_OBJECT );
  wxObject* wxObj = wxh_ItemListGetWX( pSelf );

  if( wxObj && pLocalList )
  {
    //wxh_ItemListSetStaticItm( wxObj, pSelf );
    pLocalList->AddItm( pSelf );
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
