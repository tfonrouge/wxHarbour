/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
/*
  wxEvtHandler
  Teo. Mexico 2006
*/
CLASS wxEvtHandler FROM wxObject
PRIVATE:
  DATA FEventHashList INIT HB_HSetCaseMatch( {=>}, .F. )
  DATA FEventTypeValue
PROTECTED:
  METHOD wxConnect( id, lastId, eventType )
PUBLIC:
  METHOD Connect( p1, p2, p3, p4 )
  METHOD OnCommandEvent( event )
  PROPERTY EventHashList READ FEventHashList
PUBLISHED:
ENDCLASS

/*
  Connect
  Teo. Mexico 2008
*/
METHOD PROCEDURE Connect( p1, p2, p3, p4 ) CLASS wxEvtHandler
  LOCAL id, lastId, eventType, bAction
  LOCAL vtP1 := ValType( p1 )
  LOCAL vtP2 := ValType( p2 )
  LOCAL vtP3 := ValType( p3 )
  LOCAL vtP4 := ValType( p4 )

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

  IF bAction != NIL
    IF !HB_HHasKey( ::FEventHashList, eventType )
      ::FEventHashList[ eventType ] := {}
    ENDIF
    AAdd( ::FEventHashList[ eventType ], { id, lastId, bAction } )
  ENDIF

  ::wxConnect( id, lastId, eventType )

RETURN

/*
  OnCommandEvent
  Teo. Mexico 2006
*/
METHOD PROCEDURE OnCommandEvent( id, eventType ) CLASS wxEvtHandler
  LOCAL itm

  ? ::ClassName
  ?? " Id: "+LTrim(Str(::GetId()))
  ?? ", Event #: "+LTrim(Str(id))
  ?? " type: "+LTrim(Str(eventType))
  ?

  IF !HB_HHasKey( ::FEventHashList, eventType )
    //::Skip() ?
    ? "No events..."
    RETURN
  ENDIF

  FOR EACH itm IN ::FEventHashList[ eventType ]
    ? "Testing:",itm[1],itm[2]
    IF id >= itm[1] .AND. id <= itm[2]
      itm[3]:Eval( Self )
      EXIT
    ENDIF
  NEXT

RETURN

/*
  End Class wxEvtHandler
*/
