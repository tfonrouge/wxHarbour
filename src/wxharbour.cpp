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

using namespace std;

/* PHB_ITEM keys */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, wxObject*, wxPointerHash, wxPointerEqual, HBOBJLIST );
/* wxObject* keys */
WX_DECLARE_HASH_MAP( wxObject*, PHB_ITEM, wxPointerHash, wxPointerEqual, WXOBJLIST );

static HBOBJLIST hbObjList;
static WXOBJLIST wxObjList;

/*
  wx_ObjList_New: Add wxObject & PHB_ITEM objects to hash list
  Teo. Mexico 2006
*/
void wx_ObjList_New( wxObject* wxObj, PHB_ITEM pSelf )
{

  PHB_ITEM p = hb_itemNew( NULL );

  hb_itemCopy( p, pSelf );

  hbObjList[ p->item.asArray.value ] = wxObj;
  wxObjList[ wxObj ] = p;

}

/*
  wx_ObjList_wxDelete
  Teo. Mexico 2006
*/
void wx_ObjList_wxDelete( wxObject* wxObj )
{
  PHB_ITEM pSelf = wx_ObjList_hbGet( wxObj );

  if (pSelf)
  {
    hbObjList.erase(  pSelf->item.asArray.value );
    hb_itemClear( pSelf );
  }

  wxObjList.erase( wxObj );

}

/*
  wx_ObjList_hbGet
  Teo. Mexico 2006
*/
PHB_ITEM wx_ObjList_hbGet( wxObject* wxObj )
{

  if (!wxObj || (wxObjList.find( wxObj ) == wxObjList.end()) )
    return NULL;
  return wxObjList[ wxObj ];

}

/*
  wx_ObjList_wxGet
  Teo. Mexico 2006
*/
wxObject* wx_ObjList_wxGet( PHB_ITEM pSelf )
{
  if (!pSelf || (hbObjList.find( pSelf->item.asArray.value ) == hbObjList.end()) )
    return NULL;
  return hbObjList[ pSelf->item.asArray.value ];
}

/*
  hb_par_WX
  Teo. Mexico 2006
*/
wxObject* hb_par_WX( const int param )
{
  return wx_ObjList_wxGet( hb_param( param, HB_IT_OBJECT ) );
}

/*
  hb_par_wxPoint
  Teo. Mexico 2006
*/
wxPoint hb_par_wxPoint( int param )
{
  PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
  if ( pStruct && hb_arrayLen( pStruct ) == 2 )
  {
    int x = hb_arrayGetItemPtr( pStruct, 1 )->item.asInteger.value;
    int y = hb_arrayGetItemPtr( pStruct, 2 )->item.asInteger.value;
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
  if ( pStruct && hb_arrayLen( pStruct ) == 2 )
  {
    int x = hb_arrayGetItemPtr( pStruct, 1 )->item.asInteger.value;
    int y = hb_arrayGetItemPtr( pStruct, 2 )->item.asInteger.value;
    return wxSize( x, y );
  }
  else
    return wxSize( -1, -1 );
}

extern "C"
{
  /*
    wxObject:ClassP Read Method
    Teo. Mexico 2006
  */
  HB_FUNC( WXOBJECT_GETCLASSP )
  {
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxObject* wxObj = wx_ObjList_wxGet( pSelf );
    if (wxObj)
      hb_retptr( wxObj );
    else
      hb_ret();
  }

  /*
    TBaseClass::OnDestruct
  */
  HB_FUNC( TBASECLASS_ONDESTRUCT )
  {
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxObject* wxObj = wx_ObjList_wxGet( pSelf );
    if (wxObj)
      wx_ObjList_wxDelete( wxObj );
  }

}
















