/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

/*
  wxhGET
  Teo. Mexico 2009
*/
CLASS wxhGET
PRIVATE:
  DATA FBlock
  DATA FField
  DATA FName
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( varName, block )

  METHOD AsString

  PROPERTY Block READ FBlock
  PROPERTY Field READ FField
  PROPERTY Name READ FName

  PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2009
*/
METHOD New( name, var, block )

  ::FName  := name

  IF HB_IsObject( var ) .AND. var:IsDerivedFrom("TField")
    ::FField := var
    block := {|__localVal| iif( PCount() > 0, ::FField:Value := __localVal, ::FField:Value ) }
  ENDIF

  ::FBlock := block

RETURN Self

/*
  AsString
  Teo. Mexico 2009
*/
METHOD FUNCTION AsString CLASS wxhGET
  LOCAL value
  IF ::FField != NIL
    value := ::FField:AsString()
  ELSE
    value := AsString( ::FBlock:Eval() )
  ENDIF
RETURN value

/*
  End Class wxGET
*/

/*
  wxHBTextCtrl
*/
CLASS wxHBTextCtrl FROM wxTextCtrl
PRIVATE:
  DATA FWXHGet
  METHOD UpdateVar( event )
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( window, id, wxhGet, pos, size, style, validator, name )
  METHOD PickList
PUBLISHED:
ENDCLASS

/*
  New
*/
METHOD New( window, id, wxhGet, pos, size, style, validator, name ) CLASS wxHBTextCtrl

  Super:New( window, id, RTrim( wxhGet:AsString() ), pos, size, style, validator, name )

  IF name = NIL
    ::SetName( wxhGet:Name )
    ::SetLabel( wxhGet:Name )
  ENDIF

  ::FWXHGet := wxhGet

  /* the update to VAR event */
  ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS, {|event| ::UpdateVar( event ) } )

RETURN Self

/*
  PickList
  Teo. Mexico 2009
*/
METHOD PROCEDURE PickList CLASS wxHBTextCtrl
  LOCAL s
  LOCAL parentWnd

  IF ::FWXHGet:Field == NIL
    RETURN
  ENDIF

  parentWnd := ::GetParent()
  ? "parentWnd, textCtrl:",parentWnd:ObjectH, ::ObjectH

  ::FWXHGet:Field:GetItDoPick( parentWnd )

  s := RTrim( ::FWXHGet:Field:Value )

  IF RTrim( ::GetValue() ) == s
    RETURN /* no changes */
  ENDIF

  ::SetValue( s )

RETURN

/*
  UpdateVar
  Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxHBTextCtrl
  IF ::FWXHGet == NIL
    RETURN
  ENDIF
  IF event:GetEventType() = wxEVT_KILL_FOCUS
    ::FWXHGet:Block:Eval( ::GetValue() )
  ENDIF
RETURN

/*
  End Class wxHBTextCtrl
*/
