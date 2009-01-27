/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxh.h
  Teo. Mexico 2008
*/

extern "C"
{
#include "hbvmint.h"
#include "hbapi.h"
#include "hbapiitm.h"
#ifndef __XHARBOUR__
  #include "hbapicls.h"
#endif
#include "hbvm.h"
#include "hbstack.h"
#include "hbapierr.h"
}

#include "wx/grid.h"
#include "wxhevtdefs.h"

#include <iostream>

#include <vector>

using namespace std;

typedef struct _CONN_PARAMS
{
  int id;
  int lastId;
  wxEventType eventType;
  PHB_ITEM pItmActionBlock;
} CONN_PARAMS, *PCONN_PARAMS;

/* PHB_ITEM key, wxObject* values */
WX_DECLARE_HASH_MAP( PHB_ITEM, wxObject*, wxPointerHash, wxPointerEqual, MAP_PHB_ITEM );

typedef struct _WXH_ITEM
{
  wxObject* wxObj;
  vector<PCONN_PARAMS> evtList;
  MAP_PHB_ITEM map_childList;
  MAP_PHB_ITEM map_parentList;
  PHB_ITEM pSelf;
} WXH_ITEM, *PWXH_ITEM;

class WXH_SCOPELIST
{
public:
  MAP_PHB_ITEM itmList;
  PHB_ITEM pSelf;
  WXH_SCOPELIST( PHB_ITEM pSelf );
  ~WXH_SCOPELIST();
  void AddItm( PHB_ITEM pSelf, wxObject* wxObj );
};

HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );

wxObject*     hb_par_WX( int param, WXH_SCOPELIST* pLocalList );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );

void          wxh_ItemListDel_WX( wxObject* wxObj );
void          wxh_ItemListDel_HB( PHB_ITEM pSelf, bool lDeleteWxObj = FALSE, bool lReleaseCodeblockItm = FALSE );
PWXH_ITEM     wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj );
PHB_ITEM      wxh_ItemListGetHB( wxObject* wxObj );
wxObject*     wxh_ItemListGetWX( PHB_ITEM pSelf );
void          wxh_ItemListReleaseAll();
void          wxh_SetScopeList( wxObject* wxObj, WXH_SCOPELIST* pLocalList );
void          TRACEOUT( const char* fmt, const void* val);
void          TRACEOUT( const char* fmt, long int val);

/* generic qout for debug output */
void qout( const char* text );

/* string manipulation */
wxString wxh_parc( int param );

/*
  template for send event handling to harbour objects
  Teo. Mexico 2008
*/
template <class T>
class hbEvtHandler : public T
{
private:
  void __OnEvent( wxEvent &event );
public:
  void OnCommandEvent( wxCommandEvent& event );
  void OnFocusEvent( wxFocusEvent& event );
  void OnGridEvent( wxGridEvent& event );
  void OnMouseEvent( wxMouseEvent& event );
  void wxhConnect( int evtClass, PCONN_PARAMS pConnParams );

  ~hbEvtHandler<T>();
};

/*
  ~hbEvtHandler
  Teo. Mexico 2009
*/
template <class T>
hbEvtHandler<T>::~hbEvtHandler<T>()
{
  wxh_ItemListDel_WX( this );
}

/*
  __OnEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::__OnEvent( wxEvent &event )
{
  PHB_ITEM pEvent = hb_itemNew( NULL );
  hb_itemMove( pEvent, hb_stackReturnItem() );
  WXH_SCOPELIST* wxhScopeList = new WXH_SCOPELIST( pEvent );
  wxh_SetScopeList( &event, wxhScopeList );
  //wxh_ItemListAdd( &event, pEvent, NULL );

  vector<PCONN_PARAMS> evtList = wxh_ItemListGet_PWXH_ITEM( this )->evtList;

  for( vector<PCONN_PARAMS>::iterator it = evtList.begin(); it < evtList.end(); it++ )
  {
    PCONN_PARAMS pConnParams = *it;
    if( event.GetEventType() == pConnParams->eventType ) /* TODO: this check is needed ? */
    {
      if( event.GetId() == wxID_ANY || ( event.GetId() >= pConnParams->id && event.GetId() <= pConnParams->lastId ) )
      {
        hb_vmEvalBlockV( pConnParams->pItmActionBlock, 1 , pEvent );
      }
    }
  }

  wxh_ItemListDel_HB( pEvent );
  //hb_itemRelease( pEvent ); this has to be done on above line
}

/*
  OnCommandEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnCommandEvent( wxCommandEvent& event )
{
  HB_FUNC_EXEC( WXCOMMANDEVENT );
  __OnEvent( event );
}

/*
  OnFocusEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnFocusEvent( wxFocusEvent& event )
{
  HB_FUNC_EXEC( WXFOCUSEVENT );
  __OnEvent( event );
}

/*
  OnGridEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnGridEvent( wxGridEvent& event )
{
  HB_FUNC_EXEC( WXGRIDEVENT );
  __OnEvent( event );
}

/*
  OnMouseEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnMouseEvent( wxMouseEvent& event )
{
  HB_FUNC_EXEC( WXMOUSEEVENT );
  __OnEvent( event );
}

/*
  wxConnect
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::wxhConnect( int evtClass, PCONN_PARAMS pConnParams )
{
  wxObjectEventFunction objFunc = NULL;

  switch( evtClass )
  {
    case WXH_FOCUSEVENT:
      objFunc = wxFocusEventHandler( hbEvtHandler<T>::OnFocusEvent );
      break;
    case WXH_GRIDEVENT:
      objFunc = wxGridEventHandler( hbEvtHandler<T>::OnGridEvent );
      break;
    case WXH_COMMANDEVENT:
      objFunc = wxCommandEventHandler( hbEvtHandler<T>::OnCommandEvent );
      break;
    default:
      objFunc = NULL;
  }

  if( objFunc )
  {
    /* pLocalList not needed here, we will just send the event as parameter to the codeblock */
    vector<PCONN_PARAMS> evtList = wxh_ItemListGet_PWXH_ITEM( this )->evtList;

    evtList.push_back( pConnParams );

    this->Connect( pConnParams->id, pConnParams->lastId, pConnParams->eventType, objFunc );
  }
}
