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

HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );

using namespace std;

wxObject*     hb_par_WX( int param );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
//void          SetxHObj( unsigned int* ptr, PHB_ITEM xHObjFrom, PHB_ITEM* xHObjTo );

void          wxh_ItemListAdd( wxObject* wxObj, PHB_ITEM pSelf );
void          wxh_ItemListDel( wxObject* wxObj, bool lDelete = FALSE );
PHB_ITEM      wxh_ItemListGetHB( wxObject* wxObj );
wxObject*     wxh_ItemListGetWX( PHB_ITEM pSelf );
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
  void call__OnEvent( int evtClass, wxEvent &event );
public:
  void OnCommandEvent( wxCommandEvent& event );
  void OnFocusEvent( wxFocusEvent& event );
  void OnGridEvent( wxGridEvent& event );
  void OnMouseEvent( wxMouseEvent& event );
  void wxhConnect( int evtClass, int id, int lastId, wxEventType eventType );

  ~hbEvtHandler<T>() { wxh_ItemListDel( this ); }
};

/*
  call__OnEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::call__OnEvent( int evtClass, wxEvent &event )
{
  PHB_ITEM pSelf = wxh_ItemListGetHB( this );
  PHB_ITEM pEvtClass = hb_itemPutNI( NULL, evtClass );
  PHB_ITEM pEvent = hb_itemNew( NULL );
  hb_itemMove( pEvent, hb_stackReturnItem() );
  wxh_ItemListAdd( &event, pEvent );

  if( pSelf )
    hb_objSendMsg( pSelf, "__OnEvent", 2, pEvtClass, pEvent );

  wxh_ItemListDel( &event );
  hb_itemRelease( pEvent );
  hb_itemRelease( pEvtClass );
}

/*
  OnCommandEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnCommandEvent( wxCommandEvent& event )
{
  HB_FUNC_EXEC( WXCOMMANDEVENT );
  call__OnEvent( WXH_COMMANDEVENT, event );
}

/*
  OnFocusEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnFocusEvent( wxFocusEvent& event )
{
  HB_FUNC_EXEC( WXFOCUSEVENT );
  call__OnEvent( WXH_FOCUSEVENT, event );
}

/*
  OnGridEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnGridEvent( wxGridEvent& event )
{
  HB_FUNC_EXEC( WXGRIDEVENT );
  call__OnEvent( WXH_GRIDEVENT, event );
}

/*
  OnMouseEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnMouseEvent( wxMouseEvent& event )
{
  HB_FUNC_EXEC( WXMOUSEEVENT );
  call__OnEvent( event );
}

/*
  wxConnect
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::wxhConnect( int evtClass, int id, int lastId, wxEventType eventType )
{

  wxObjectEventFunction objFunc;

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
    this->Connect( id, lastId, eventType, objFunc );

}
