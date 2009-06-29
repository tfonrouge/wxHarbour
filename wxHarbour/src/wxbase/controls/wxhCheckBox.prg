/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxCheckBox
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
  wxCheckBox
  Teo. Mexico 2009
*/
CLASS wxCheckBox FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, label, pos, size, style, validator, name )

  METHOD Get3StateValue
  METHOD GetValue INLINE ::IsChecked()
  METHOD Is3rdStateAllowedForUser
  METHOD Is3State
  METHOD IsChecked
  METHOD Set3StateValue( value )
  METHOD SetValue( value )

PUBLISHED:
ENDCLASS

/*
  EndClass wxCheckBox
*/

/*
  wxHBCheckBox
  Teo. Mexico 2009
*/
CLASS wxHBCheckBox FROM wxCheckBox
PRIVATE:
  DATA FWXHGet
  METHOD UpdateVar( event )
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( window, id, label, wxhGet, pos, size, style, validator, name )
PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2009
*/
METHOD New( window, id, label, wxhGet, pos, size, style, validator, name ) CLASS wxHBCheckBox

  Super:New( window, id, label, pos, size, style, validator, name )

  IF wxhGet != NIL
    ::FWXHGet := wxhGet
    IF name == NIL
      ::SetName( wxhGet:Name )
    ENDIF
    IF !::Is3State()
      ::SetValue( ::FWXHGet:Block:Eval() )
    ENDIF
  ENDIF

  /* the update to VAR event */
  ::ConnectCommandEvt( ::GetId(), wxEVT_COMMAND_CHECKBOX_CLICKED, {|event| ::UpdateVar( event ) } )

RETURN Self

/*
  UpdateVar
  Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxHBCheckBox

  IF ::FWXHGet == NIL
    RETURN
  ENDIF

  IF event:GetEventType() = wxEVT_COMMAND_CHECKBOX_CLICKED
    ::FWXHGet:Block:Eval( ::GetValue() )
  ENDIF

RETURN

/*
  End Class wxHBCheckBox
*/
