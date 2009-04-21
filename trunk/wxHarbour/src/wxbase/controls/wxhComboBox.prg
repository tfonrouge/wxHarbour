/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxComboBox
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
  wxComboBox
  Teo. Mexico 2009
*/
CLASS wxComboBox FROM wxControlWithItems
PRIVATE:
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( parent, id, value, pos, size, choices, style, validator, name )

  METHOD CanCopy
  METHOD CanCut
  METHOD CanPaste
  METHOD CanRedo
  METHOD CanUndo
  METHOD Copy
  METHOD Cut
  METHOD GetCurrentSelection
  METHOD GetInsertionPoint
//   METHOD GetLastPoint
  METHOD GetSelection( from, to )
  METHOD GetValue
  METHOD Paste
  METHOD Redo
  METHOD Replace( from, to, text )
  METHOD Remove( from, to )
  METHOD SetInsertionPoint( pos )
  METHOD SetInsertionPointEnd
  METHOD SetSelection( from, to )
  METHOD SetValue( text )
  METHOD Undo

PUBLISHED:
ENDCLASS

/*
  EndClass wxComboBox
*/

/*
  wxHBComboBox
  Teo. Mexico 2009
*/
CLASS wxHBComboBox FROM wxComboBox
PRIVATE:
  DATA FWXHGet
  METHOD UpdateVar( event )
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, value, pos, size, choices, style, validator, name, wxhGet )
  PROPERTY WXHGet READ FWXHGet
PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2009
*/
METHOD New( parent, id, value, pos, size, choices, style, validator, name, wxhGet ) CLASS wxHBComboBox

  IF choices = NIL .AND. wxhGet != NIL .AND. wxhGet:Field != NIL
    choices := wxhGet:GetChoices()
  ENDIF

  IF wxhGet != NIL .AND. value = NIL
    value := RTrim( wxhGet:AsString() )
  ENDIF

  Super:New( parent, id, value, pos, size, choices, style, validator, name )

  IF name = NIL
    ::SetName( wxhGet:Name )
  ENDIF

  ::FWXHGet := wxhGet

  ::SetSelection( ::FWXHGet:GetSelection() )

  /* the update to VAR event */
  ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS, {|event|  event:GetEventObject():UpdateVar( event ) } )
  ::ConnectCommandEvt( ::GetId(), wxEVT_COMMAND_COMBOBOX_SELECTED, {|event| event:GetEventObject():UpdateVar( event ) } )

RETURN Self

/*
  UpdateVar
  Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxHBComboBox
  LOCAL value
  LOCAL evtType

  IF ::FWXHGet == NIL
    RETURN
  ENDIF

  evtType := event:GetEventType()

  IF evtType = wxEVT_COMMAND_COMBOBOX_SELECTED .OR. evtType = wxEVT_KILL_FOCUS
    //value := ::FWXHGet:GetKeyValue( ::GetValue() )
    value := ::GetValue()
    IF value != NIL
      ::FWXHGet:Block:Eval( value )
    ENDIF
  ENDIF

RETURN

/*
  End Class wxHBComboBox
*/
