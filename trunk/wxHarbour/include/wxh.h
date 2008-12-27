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

#include <iostream>

HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );

using namespace std;

typedef wxObject* PWXH_ITEM;

PWXH_ITEM     hb_par_WX( int param );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
//void          SetxHObj( unsigned int* ptr, PHB_ITEM xHObjFrom, PHB_ITEM* xHObjTo );

void          wxh_ItemListAdd( PWXH_ITEM wxObj, PHB_ITEM pSelf );
void          wxh_ItemListDel( PWXH_ITEM wxObj );
PHB_ITEM      wxh_ItemListGetHB( PWXH_ITEM wxObj );
PWXH_ITEM     wxh_ItemListGetWX( PHB_ITEM pSelf );
void	      wxh_ItemListReleaseAll();
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
  void wxhConnect( int id, int lastId, wxEventType eventType );

  ~hbEvtHandler<T>() { wxh_ItemListDel( this ); }
};

/*
  OnCommandEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnCommandEvent( wxCommandEvent& event )
{
  HB_FUNC_EXEC( WXCOMMANDEVENT );
  PHB_ITEM pEvent = hb_itemNew( NULL );
  hb_itemMove( pEvent, hb_stackReturnItem() );
  wxh_ItemListAdd( &event, pEvent );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 1, pEvent );

  wxh_ItemListDel( &event );
  hb_itemRelease( pEvent );

}

/*
  OnGridEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnGridEvent( wxGridEvent& event )
{
  HB_FUNC_EXEC( WXGRIDEVENT );
  PHB_ITEM pEvent = hb_itemNew( NULL );
  hb_itemMove( pEvent, hb_stackReturnItem() );
  wxh_ItemListAdd( &event, pEvent );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 1, pEvent );

  wxh_ItemListDel( &event );
  hb_itemRelease( pEvent );

}

/*
  OnMouseEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnMouseEvent( wxMouseEvent& event )
{
  HB_FUNC_EXEC( WXMOUSEEVENT );
  PHB_ITEM pEvent = hb_itemNew( NULL );
  hb_itemMove( pEvent, hb_stackReturnItem() );
  wxh_ItemListAdd( &event, pEvent );

  hb_objSendMsg( wxh_ItemListGetHB( this ), "OnCommandEvent", 1, pEvent );

  wxh_ItemListDel( &event );
  hb_itemRelease( pEvent );

}

/*
  wxConnect
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::wxhConnect( int id, int lastId, wxEventType eventType )
{

  if( eventType == wxEVT_GRID_CELL_RIGHT_CLICK )
  {
    cout << "";
    cout << "Connecting wxEVT_GRID_CELL_RIGHT_CLICK" << endl;
    cout << "";
    this->Connect( wxID_ANY, wxEVT_GRID_CELL_RIGHT_CLICK, wxGridEventHandler( hbEvtHandler<T>::OnGridEvent ) );
    return;
  }

  this->Connect( id, lastId, eventType, wxCommandEventHandler( hbEvtHandler<T>::OnCommandEvent ) );

}

