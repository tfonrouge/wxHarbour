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

/*
  Harbour related include files
*/
#ifdef __XHARBOUR__
#include "hbvmopt.h"
#else
#include "hbvmint.h"
#endif

#include "hbapi.h"
#include "hbapiitm.h"
#ifndef __XHARBOUR__
  #include "hbapicls.h"
#endif
#include "hbvm.h"
#include "hbstack.h"
#include "hbapierr.h"

#ifndef __XHARBOUR__
#include "hbchksum.h"
#endif

#include "wx/grid.h"
#include "wxhevtdefs.h"
#include "wx/socket.h"
#include "wx/timer.h"
#include "wx/taskbar.h"

#include <iostream>

#include <vector>

#define WXH_ERRBASE     8000

using namespace std;

typedef struct _CONN_PARAMS
{
  int id;
  int lastId;
  wxEventType eventType;
  PHB_ITEM pItmActionBlock;
} CONN_PARAMS, *PCONN_PARAMS;

/* PHB_ITEM key, wxObject* values */
WX_DECLARE_HASH_MAP( PHB_ITEM, bool, wxPointerHash, wxPointerEqual, MAP_PHB_ITEM );

/*
  wxh_Item class : Holds PHB_ITEM's and the wxObject associated
*/
class wxh_Item
{
public:
  bool delete_WX;
  wxObject* wxObj;
  USHORT uiClass;
  PHB_BASEARRAY objHandle;
  vector<PCONN_PARAMS> evtList;
  PHB_ITEM pSelf;
  USHORT uiRefCount;
  UINT uiProcNameLine;

  wxh_Item() { delete_WX = true; uiClass = 0; pSelf = NULL ; uiRefCount = 0; uiProcNameLine = 0; }
  ~wxh_Item();

};

class wxh_ObjParams
{
private:
  bool paramListProcessed;
  void SetChildItem( const PHB_ITEM pChildItem );
public:

  PHB_ITEM pParamParent;
  MAP_PHB_ITEM map_paramListChild;

  PHB_ITEM pSelf;
  wxh_Item* pWxh_Item;

  wxh_ObjParams();
  wxh_ObjParams( PHB_ITEM pHbObj );
  ~wxh_ObjParams();

  void ProcessParamLists();

  void Return( wxObject* wxObj, bool bItemRelease = false );

  wxObject* param( int param );
  wxObject* paramChild( int param );
  wxObject* paramParent( int param );

  wxObject* Get_wxObject();

};

HB_FUNC_EXTERN( WXACTIVATEEVENT );
HB_FUNC_EXTERN( WXCLOSEEVENT );
HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXINITDIALOGEVENT );
HB_FUNC_EXTERN( WXMENUEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );
HB_FUNC_EXTERN( WXSOCKETEVENT );
HB_FUNC_EXTERN( WXTASKBARICONEVENT );
HB_FUNC_EXTERN( WXTIMEREVENT );

wxObject*     wxh_parWX( int param );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
wxArrayString hb_par_wxArrayString( int param );

wxString      wxh_CTowxStr( const char * szStr );
void          wxh_ItemListDel_WX( wxObject* wxObj, bool bDeleteWxObj = false );
wxh_Item*     wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj );
wxh_Item*     wxh_ItemListGet_PWXH_ITEM( PHB_ITEM pSelf );
PHB_ITEM      wxh_ItemListGet_HB( wxObject* wxObj );
wxObject*     wxh_ItemListGet_WX( PHB_ITEM pSelf );
void          wxh_ItemListReleaseAll();
void          TRACEOUT( const char* fmt, const void* val);
void          TRACEOUT( const char* fmt, long int val);

/* generic qoutf for debug output */
void qoutf( const char* format, ... );

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

  void OnActivateEvent( wxActivateEvent& event );
  void OnCloseEvent( wxCloseEvent& event );
  void OnCommandEvent( wxCommandEvent& event );
  void OnFocusEvent( wxFocusEvent& event );
  void OnGridEvent( wxGridEvent& event );
  void OnInitDialogEvent( wxInitDialogEvent& event );
  void OnMenuEvent( wxMenuEvent& event );
  void OnMouseEvent( wxMouseEvent& event );
  void OnSocketEvent( wxSocketEvent& event );
  void OnTaskBarIconEvent( wxTaskBarIconEvent& event );
  void OnTimerEvent( wxTimerEvent& event );

  void wxhConnect( int evtClass, PCONN_PARAMS pConnParams );

  ~hbEvtHandler<T>();
};

/*
  ~hbEvtHandler
  Teo. Mexico 2009
*/
template <class T>
hbEvtHandler<T>::~hbEvtHandler()
{
  wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( this );

  if( pWxh_Item )
  {
    pWxh_Item->delete_WX = false;
    delete pWxh_Item;
  }
}

/*
  __OnEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::__OnEvent( wxEvent &event )
{
  PHB_ITEM pEvent = hb_itemNew( hb_stackReturnItem() );
  wxh_ObjParams objParams = wxh_ObjParams( pEvent );

  objParams.Return( &event );

  if( objParams.pWxh_Item )
  {
    objParams.pWxh_Item->delete_WX = false;
    wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( this );

    if( pWxh_Item )
    {

      for( vector<PCONN_PARAMS>::iterator it = pWxh_Item->evtList.begin(); it < pWxh_Item->evtList.end(); it++ )
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
    }
  }

  //wxh_ItemListDel_HB( pEvent );
  hb_itemRelease( pEvent ); //this has to be done on above line
}

/*
  OnActivateEvent
  Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnActivateEvent( wxActivateEvent& event )
{
  HB_FUNC_EXEC( WXACTIVATEEVENT );
  __OnEvent( event );
}

/*
  OnCloseEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnCloseEvent( wxCloseEvent& event )
{
  HB_FUNC_EXEC( WXCLOSEEVENT );
  __OnEvent( event );
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
  OnInitDialogEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnInitDialogEvent( wxInitDialogEvent& event )
{
  HB_FUNC_EXEC( WXINITDIALOGEVENT );
  __OnEvent( event );
}

/*
  OnMenuEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnMenuEvent( wxMenuEvent& event )
{
  HB_FUNC_EXEC( WXMENUEVENT );
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
  OnSocketEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnSocketEvent( wxSocketEvent& event )
{
  HB_FUNC_EXEC( WXSOCKETEVENT );
  __OnEvent( event );
}

/*
  OnTaskBarIconEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnTaskBarIconEvent( wxTaskBarIconEvent& event )
{
  HB_FUNC_EXEC( WXTASKBARICONEVENT );
  __OnEvent( event );
}

/*
  OnTimerEvent
  Teo. Mexico 2008
*/
template <class T>
void hbEvtHandler<T>::OnTimerEvent( wxTimerEvent& event )
{
  HB_FUNC_EXEC( WXTIMEREVENT );
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
    case WXH_ACTIVATEEVENT:
      objFunc = wxActivateEventHandler( hbEvtHandler<T>::OnActivateEvent );
      break;
    case WXH_CLOSEEVENT:
      objFunc = wxCloseEventHandler( hbEvtHandler<T>::OnCloseEvent );
      break;
    case WXH_COMMANDEVENT:
      objFunc = wxCommandEventHandler( hbEvtHandler<T>::OnCommandEvent );
      break;
    case WXH_FOCUSEVENT:
      objFunc = wxFocusEventHandler( hbEvtHandler<T>::OnFocusEvent );
      break;
    case WXH_GRIDEVENT:
      objFunc = wxGridEventHandler( hbEvtHandler<T>::OnGridEvent );
      break;
    case WXH_INITDIALOGEVENT:
      objFunc = wxInitDialogEventHandler( hbEvtHandler<T>::OnInitDialogEvent );
      break;
    case WXH_MENUEVENT:
      objFunc = wxMenuEventHandler( hbEvtHandler<T>::OnMenuEvent );
      break;
    case WXH_MOUSEEVENT:
      objFunc = wxMouseEventHandler( hbEvtHandler<T>::OnMouseEvent );
      break;
    case WXH_SOCKETEVENT:
      objFunc = wxSocketEventHandler( hbEvtHandler<T>::OnSocketEvent );
      break;
    case WXH_TASKBARICONEVENT:
      objFunc = wxTaskBarIconEventHandler( hbEvtHandler<T>::OnTaskBarIconEvent );
      break;
    case WXH_TIMEREVENT:
      objFunc = wxTimerEventHandler( hbEvtHandler<T>::OnTimerEvent );
      break;
    default:
      objFunc = NULL;
  }

  if( objFunc )
  {
    wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( this );

    if( pWxh_Item )
    {
      pWxh_Item->evtList.push_back( pConnParams );
      this->Connect( pConnParams->id, pConnParams->lastId, pConnParams->eventType, objFunc );
    }
  }
}
