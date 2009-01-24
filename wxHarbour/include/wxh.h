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
} CONN_PARAMS, * PCONN_PARAMS;

typedef struct _PHBITM_REF
{
  PHB_ITEM pLocal;
  PHB_ITEM pStatic;
  vector<PCONN_PARAMS> evtList;
} HBITM_REF, *PHBITM_REF;

/*
  Class to hold HB items associated on a C++ object
*/
class TLOCAL_ITM_LIST
{
private:
  vector<PHB_ITEM> itmList;
public:
  void AddItm( PHB_ITEM pSelf ) { itmList.push_back( hb_itemNew( pSelf ) ); }

  ~TLOCAL_ITM_LIST()
  {
    vector<PHB_ITEM>::iterator it;
    for( it = itmList.begin(); it < itmList.end(); it++ )
    {
      PHB_ITEM itm = *it;
      hb_itemRelease( itm );
    }
  }
};

HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );

wxObject*     hb_par_WX( int param, TLOCAL_ITM_LIST* pLocalList );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
//void          SetxHObj( unsigned int* ptr, PHB_ITEM xHObjFrom, PHB_ITEM* xHObjTo );

void          wxh_ItemListAdd( wxObject* wxObj, PHB_ITEM pSelf, TLOCAL_ITM_LIST* pLocalList );
void          wxh_ItemListSetStaticItm( wxObject* wxObj, PHB_ITEM pSelf );
void          wxh_ItemListDel_WX( wxObject* wxObj );
void          wxh_ItemListDel_HB( PHB_ITEM pSelf, bool lDeleteWxObj = FALSE, bool lReleaseCodeblockItm = FALSE );
PHB_ITEM      wxh_ItemListGetHB( wxObject* wxObj );
PHBITM_REF    wxh_ItemListGetHBREF( wxObject* wxObj );
wxObject*     wxh_ItemListGetWX( PHB_ITEM pSelf );
void	      wxh_ItemListReleaseAll();
void          wxh_SetWXLocalList( wxObject* wxObj, TLOCAL_ITM_LIST* pLocalList );
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
  wxh_ItemListAdd( &event, pEvent, NULL );

  PHBITM_REF pItmRef = wxh_ItemListGetHBREF( this );
  PCONN_PARAMS pConnParams;
  vector<PCONN_PARAMS> v = pItmRef->evtList;

  vector<PCONN_PARAMS>::iterator it;
  for( it = v.begin(); it < v.end(); it++ )
  {
    pConnParams = *it;
    int id;
    if( event.GetEventType() == pConnParams->eventType ) /* TODO: this check is needed ? */
    {
      id = event.GetId();
      if( id == wxID_ANY || ( id >= pConnParams->id && id <= pConnParams->lastId ) )
      {
        hb_vmEvalBlockV( pConnParams->pItmActionBlock, 1 , pEvent );
      }
    }
  }

  wxh_ItemListDel_HB( pEvent );
  hb_itemRelease( pEvent );
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
    PHB_ITEM pSelf = hb_stackSelfItem();
    PHBITM_REF pItmRef = wxh_ItemListGetHBREF( wxh_ItemListGetWX( pSelf ) );

    pItmRef->evtList.push_back( pConnParams );

    this->Connect( pConnParams->id, pConnParams->lastId, pConnParams->eventType, objFunc );
  }
}
