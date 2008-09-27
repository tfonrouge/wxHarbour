/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxharbour:
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wx/hashset.h"
#include "wxh.h"

/* PHB_ITEM keys */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, PWXH_ITEM, wxPointerHash, wxPointerEqual, HBITEMLIST );
/* PWXH_ITEM keys */
WX_DECLARE_HASH_MAP( PWXH_ITEM, PHB_ITEM, wxPointerHash, wxPointerEqual, WXHITEMLIST );

static HBITEMLIST hbItemList;
static WXHITEMLIST wxItemList;

static PHB_ITEM lastTopLevelWindow;

/*
  wxh_ItemListAdd: Add wxObject & PHB_ITEM objects to hash list
  Teo. Mexico 2006
*/
void wxh_ItemListAdd( PWXH_ITEM wxObj, PHB_ITEM pSelf )
{

  PHB_ITEM p = hb_itemNew( NULL );

  hb_itemCopy( p, pSelf );

  if(hb_clsIsParent( p->item.asArray.value->uiClass, "WXTOPLEVELWINDOW" ) )
  {
    lastTopLevelWindow = p;
  }

  hbItemList[ p->item.asArray.value ] = wxObj;
  wxItemList[ wxObj ] = p;

}

/*
  wxh_ItemListDel
  Teo. Mexico 2006
*/
void wxh_ItemListDel( PWXH_ITEM wxObj )
{
  PHB_ITEM pSelf = wxh_ItemListGetHB( wxObj );

  if(pSelf)
  {
    hbItemList.erase( pSelf->item.asArray.value );
    hb_itemRelease( pSelf );
  }

  wxItemList.erase( wxObj );

  if( wxObj )
  {
    //delete wxObj;
    wxObj = NULL;
  }

}

/*
  wxh_ItemListGetHB
  Teo. Mexico 2006
*/
PHB_ITEM wxh_ItemListGetHB( PWXH_ITEM wxObj )
{

  if(!wxObj || (wxItemList.find( wxObj ) == wxItemList.end()) )
    return NULL;
  return wxItemList[ wxObj ];

}

/*
  wxh_ItemListGetWX
  Teo. Mexico 2006
*/
PWXH_ITEM wxh_ItemListGetWX( PHB_ITEM pSelf )
{
  if(!pSelf || (hbItemList.find( pSelf->item.asArray.value ) == hbItemList.end()) )
    return NULL;
  return hbItemList[ pSelf->item.asArray.value ];
}

/*
  hb_par_WX
  Teo. Mexico 2006
*/
PWXH_ITEM hb_par_WX( const int param )
{
  return wxh_ItemListGetWX( hb_param( param, HB_IT_OBJECT ) );
}

/*
  hb_par_wxPoint
  Teo. Mexico 2006
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
  Teo. Mexico 2006
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
  wxObject:ClassP Read Method
  Teo. Mexico 2006
*/
HB_FUNC( WXOBJECT_GETCLASSP )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  PWXH_ITEM wxObj = wxh_ItemListGetWX( pSelf );
  if(wxObj)
    hb_retptr( wxObj );
  else
    hb_ret();
}

/*
 * wxh_LastTopLevelWindow
 * Teo. Mexico 2008
 */
HB_FUNC( WXH_LASTTOPLEVELWINDOW )
{
  hb_itemReturn( lastTopLevelWindow );
}

#if 0
/*
  TRACEOUT
  Teo. Mexico 2008
*/
void TRACEOUT( const char* fmt, const void* val)
{
  char buff[ 50 ];
  int n;

  n = sprintf( buff, fmt, val );
  hb_gtOutStd( (BYTE *) buff, n );
}

/*
  TRACEOUT
  Teo. Mexico 2008
*/

void TRACEOUT( const char* fmt, long int val)
{
  char buff[ 50 ];
  int n;

  n = sprintf( buff, fmt, val );
  hb_gtOutStd( (BYTE *) buff, n );
}
#endif
