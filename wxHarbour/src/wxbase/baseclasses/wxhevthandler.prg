/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#ifdef __XHARBOUR__
  #include "wx_hbcompat.ch"
#endif

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxhevtdefs.h"

/*
  wxEvtHandler
  Teo. Mexico 2009
*/
CLASS wxEvtHandler FROM wxObject
PRIVATE:
  DATA FEventList INIT HB_HSetCaseMatch( {=>}, .F. )
  DATA FEventTypeValue
PROTECTED:
  METHOD ParseConnectParams( evtClass, p1, p2, p3, p4 )
  METHOD wxhConnect( evtClass, id, lastId, eventType )
PUBLIC:
  METHOD __OnEvent( evtClass, event )
  METHOD ConnectCommandEvt( p1, p2, p3, p4 ) INLINE ::ParseConnectParams( WXH_COMMANDEVENT, p1, p2, p3, p4 )
  METHOD ConnectFocusEvt( p1, p2, p3, p4 ) INLINE ::ParseConnectParams( WXH_FOCUSEVENT, p1, p2, p3, p4 )
  METHOD ConnectGridEvt( p1, p2, p3, p4 ) INLINE ::ParseConnectParams( WXH_GRIDEVENT, p1, p2, p3, p4 )
PUBLISHED:
ENDCLASS

/*
  __OnEvent
  Teo. Mexico 2009
*/
METHOD PROCEDURE __OnEvent( evtClass, event ) CLASS wxEvtHandler
  LOCAL itm
  LOCAL id,eventType

  id := event:GetId()
  eventType := event:GetEventType()

  IF !HB_HHasKey( ::FEventList, evtClass ) .OR. !HB_HHasKey( ::FEventList[ evtClass ], eventType )
    //::Skip() ?
    ? "No events..."
    RETURN
  ENDIF

  FOR EACH itm IN ::FEventList[ evtClass ][ eventType ]
    IF itm[ 1 ] = -1 .OR. ( id >= itm[ 1 ] .AND. id <= itm[ 2 ] )
      itm[ 3 ]:Eval( event )
      EXIT
    ENDIF
  NEXT

RETURN

/*
  ParseConnectParams
  Teo. Mexico 2008
*/
METHOD PROCEDURE ParseConnectParams( evtClass, p1, p2, p3, p4 ) CLASS wxEvtHandler
  LOCAL id, lastId, eventType, bAction
  LOCAL vtP2 := ValType( p2 )
  LOCAL vtP3 := ValType( p3 )
  LOCAL vtP4 := ValType( p4 )

  IF !HB_HHasKey( ::FEventList, evtClass )
    ::FEventList[ evtClass ] := HB_HSetCaseMatch( {=>}, .F. )
  ENDIF

  /* Check for codeBlock, Character, or Symbol type */
  IF vtP4 $ "BCS"
    id := p1
    lastId := p2
    eventType := p3
    bAction := p4
  ELSEIF vtP3 $ "BCS"
    id := p1
    lastId := p1
    eventType := p2
    bAction := p3
  ELSEIF vtP2 $ "BCS"
    id := wxID_ANY
    lastId := wxID_ANY
    eventType := p1
    bAction := p2
  ENDIF

  IF bAction == NIL
    //RETURN
  ENDIF

//   TRACE "Connect:",::ClassName,id,lastId

  IF !HB_HHasKey( ::FEventList[ evtClass ], eventType )
    ::FEventList[ evtClass ][ eventType ] := {}
  ENDIF

  AAdd( ::FEventList[ evtClass ][ eventType ], { id, lastId, bAction } )

  ::wxhConnect( evtClass, id, lastId, eventType )

RETURN

/*
  End Class wxEvtHandler
*/
