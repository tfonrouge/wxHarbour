/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_EvtHandler
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_frame.h"

/*
  wxConnect
  Teo. Mexico 2008
*/
HB_FUNC( WXEVTHANDLER_WXCONNECT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int id = hb_parni( 1 );
  int lastId = hb_parni( 2 );
  wxEventType eventType = hb_parni( 3 );

  hbEvtHandler<wxEvtHandler>* evtHandler;

  if( !( pSelf && (evtHandler = (hbEvtHandler<wxEvtHandler> *) wx_ObjList_wxGet( pSelf ) ) ) )
    return;

  evtHandler->wxConnect( id, lastId, eventType, evtHandler );

};

