/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxh.h
  Teo. Mexico 2006
*/

extern "C"
{
#include "hbvmopt.h"
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

#include <iostream>

using namespace std;

typedef void * PWXH_ITEM;

PWXH_ITEM     hb_par_WX( int param );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
//void          SetxHObj( unsigned int* ptr, PHB_ITEM xHObjFrom, PHB_ITEM* xHObjTo );

void          wxh_ItemListAdd( PWXH_ITEM wxObj, PHB_ITEM pSelf );
void          wxh_ItemListDel( PWXH_ITEM wxObj );
PHB_ITEM      wxh_ItemListGetHB( PWXH_ITEM wxObj );
PWXH_ITEM     wxh_ItemListGetWX( PHB_ITEM pSelf );
void          TRACEOUT( const char* fmt, const void* val);
void          TRACEOUT( const char* fmt, long int val);

/* string manipulation */
wxString wxh_parc( int param );

/*
  template for send event handling to harbour objects
  Teo. Mexico 2008
*/
template <class T>
class hbEvtHandler : public T
{
public:
  void OnCommandEvent( wxCommandEvent& event );
  void OnGridEvent( wxGridEvent& event );
  void OnMouseEvent( wxMouseEvent& event );
  void wxConnect( int id, int lastId, wxEventType eventType, wxEvtHandler* evtHandler );

  ~hbEvtHandler<T>() { wxh_ItemListDel( this ); }
};

/*
  OnCommandEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnCommandEvent( wxCommandEvent& event )
{
  PHB_ITEM pId = hb_itemNew( NULL );
  PHB_ITEM pEventType = hb_itemNew( NULL );

  hb_itemPutNI( pId, event.GetId() );
  hb_itemPutNI( pEventType, event.GetEventType() );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 2, pId, pEventType );
}

/*
  OnGridEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnGridEvent( wxGridEvent& event )
{
  PHB_ITEM pId = hb_itemNew( NULL );
  PHB_ITEM pEventType = hb_itemNew( NULL );

  hb_itemPutNI( pId, event.GetId() );
  hb_itemPutNI( pEventType, event.GetEventType() );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 2, pId, pEventType );
}

/*
  OnMouseEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnMouseEvent( wxMouseEvent& event )
{
  PHB_ITEM pId = hb_itemNew( NULL );
  PHB_ITEM pEventType = hb_itemNew( NULL );

  hb_itemPutNI( pId, event.GetId() );
  hb_itemPutNI( pEventType, event.GetEventType() );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 2, pId, pEventType );
}

/*
  wxConnect
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::wxConnect( int id, int lastId, wxEventType eventType, wxEvtHandler* evtHandler )
{

  if( eventType == wxEVT_GRID_CELL_RIGHT_CLICK )
  {
    cout << "";
    cout << "Connecting wxEVT_GRID_CELL_RIGHT_CLICK" << endl;
    cout << "";
    evtHandler->Connect( wxID_ANY, wxEVT_GRID_CELL_RIGHT_CLICK, wxGridEventHandler( hbEvtHandler<T>::OnGridEvent ) );
    return;
  }
  evtHandler->Connect( id, lastId, eventType, wxCommandEventHandler( hbEvtHandler<T>::OnCommandEvent ) );
}

