/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

/*
  wxhGET
  Teo. Mexico 2008
*/
CLASS wxhGET
PRIVATE:
  DATA FBlock EXPORTED
  DATA FName
  DATA FVar
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( varName, block )

  METHOD AsString

  PROPERTY Name READ FName
  PROPERTY Var READ FVar

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( name, var, block )
  ::FName  := name
  ::FVar   := var
  ::FBlock := block
RETURN Self

/*
  AsString
  Teo. Mexico 2008
*/
METHOD FUNCTION AsString CLASS wxhGET
  LOCAL value
  IF HB_ISOBJECT( ::FVar )
    IF ::FVar:IsDerivedFrom( "TField" )
      value := ::FVar:AsString()
    ELSE
      value := "Object: " + ::FVar:ClassName
    ENDIF
  ELSE
    value := ::FBlock:Eval()
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
PUBLISHED:
ENDCLASS

/*
  New
*/
METHOD New( window, id, wxhGet, pos, size, style, validator, name ) CLASS wxHBTextCtrl

  Super:New( window, id, wxhGet:AsString(), pos, size, style, validator, name )

  IF name = NIL
    ::SetName( wxhGet:Name )
    ::SetLabel( wxhGet:Name )
  ENDIF

  ::FWXHGet := wxhGet

  /* the update to VAR event */
  ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS, {|event| ::UpdateVar( event ) } )

RETURN Self

/*
  UpdateVar
  Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxHBTextCtrl
  IF ::FWXHGet == NIL
    RETURN
  ENDIF
  IF event:GetEventType() = wxEVT_KILL_FOCUS
    IF  HB_IsObject( ::FWXHGet:Var )
      IF ::FWXHGet:Var:IsDerivedFrom( "TField" )
        ::FWXHGet:Var:Value := ::GetValue()
      ENDIF
    ELSE
      ::FWXHGet:FBlock:Eval( ::GetValue() )
    ENDIF
  ENDIF
RETURN

/*
  End Class wxHBTextCtrl
*/
