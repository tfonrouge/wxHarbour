/*
 * $Id$
 */

/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxh.h
  Teo. Mexico 2009
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

/*
 * type differences between Harbour/xHarbour
 */
#ifdef __XHARBOUR__

typedef BYTE  BYTECHAR;

#else

typedef char  BYTECHAR;

#endif

#ifndef wxVERSION
#define wxVERSION ( wxMAJOR_VERSION * 10000 + wxMINOR_VERSION * 100 + wxRELEASE_NUMBER )
#endif

#include <iostream>

#include <vector>

#define WXH_ERRBASE     8000

using namespace std;

typedef struct _CONN_PARAMS
{
  bool force;
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
  bool nullObj;
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
  bool linkChildParentParams;
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
  wxObject* paramChild( PHB_ITEM pChildItm );
  wxObject* paramChild( int param );
  wxObject* paramParent( PHB_ITEM pParentItm );
  wxObject* paramParent( int param );

  wxObject* Get_wxObject();

};

HB_FUNC_EXTERN( WXACTIVATEEVENT );
HB_FUNC_EXTERN( WXCLOSEEVENT );
HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXINITDIALOGEVENT );
HB_FUNC_EXTERN( WXKEYEVENT );
HB_FUNC_EXTERN( WXMENUEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );
HB_FUNC_EXTERN( WXSOCKETEVENT );
HB_FUNC_EXTERN( WXTASKBARICONEVENT );
HB_FUNC_EXTERN( WXTIMEREVENT );
HB_FUNC_EXTERN( WXUPDATEUIEVENT );

void          wxh_itemNewReturn( const char * szClsName, wxObject* ctrl, wxObject* parent = NULL );
void		  wxh_itemReturn( wxObject* wxObj );
wxObject*     wxh_par_WX( int param );
wxPoint       wxh_par_wxPoint( int param );
wxSize        wxh_par_wxSize( int param );
wxArrayString wxh_par_wxArrayString( int param );
wxString      wxh_parc( int param );
void		  wxh_ret_wxPoint( const wxPoint& point );
void		  wxh_ret_wxSize( wxSize* size );
void		  wxh_retc( const wxString & string );

wxString      wxh_CTowxString( const char * szStr, bool convOEM = false );
void          wxh_ItemListDel_WX( wxObject* wxObj, bool bDeleteWxObj = false );
wxh_Item*     wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj );
wxh_Item*     wxh_ItemListGet_PWXH_ITEM( PHB_ITEM pSelf );
PHB_ITEM      wxh_ItemListGet_HB( wxObject* wxObj );
wxObject*     wxh_ItemListGet_WX( PHB_ITEM pSelf );
void          wxh_ItemListReleaseAll();
PHB_ITEM      wxh_itemNullObject( PHB_ITEM pSelf );
#define		  wxh_wxStringToC( string ) \
			  (string).mb_str( wxConvUTF8 )
void          TRACEOUT( const char* fmt, const void* val);
void          TRACEOUT( const char* fmt, long int val);

/* generic qoutf for debug output */
void qoutf( const char* format, ... );
void qqoutf( const char* format, ... );

/*
  template for send event handling to harbour objects
  Teo. Mexico 2009
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
  void OnKeyEvent( wxKeyEvent& event );
  void OnMenuEvent( wxMenuEvent& event );
  void OnMouseEvent( wxMouseEvent& event );
  void OnSocketEvent( wxSocketEvent& event );
  void OnTaskBarIconEvent( wxTaskBarIconEvent& event );
  void OnTimerEvent( wxTimerEvent& event );
  void OnUpdateUIEvent( wxUpdateUIEvent& event );

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
    //delete pWxh_Item;
  }
}

/*
 template for wxWindow
 Teo. Mexico 2009
 */
template <class tW>
class hbWindow : public hbEvtHandler<tW>
  {
	bool Validate();
  };

/*
 Validate
 Teo. Mexico 2009
 */
template <class tW>
bool hbWindow<tW>::Validate()
{
  PHB_ITEM pObj = wxh_ItemListGet_HB( this );
  bool result = false;

  if( pObj )
  {
	hb_objSendMsg( pObj, "Validate", 0 );
	result = hb_stackReturnItem()->item.asLogical.value;
  }
  return result;
}
