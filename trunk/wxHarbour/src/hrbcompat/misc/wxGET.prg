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

#ifdef __XHARBOUR__

#include "wx_hbcompat.ch"

#endif

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

  METHOD GetChoices             /* returns a array of values */
  METHOD GetKeyValue            /* returns key of ValidValues on TField (if any) */
  METHOD GetSelection           /* returns numeric index of ValidValues on TField (if any) */

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
  GetChoices
  Teo. Mexico 2009
*/
METHOD GetChoices CLASS wxhGET
  LOCAL Result
  LOCAL itm
  LOCAL validValues

  IF ::FField != NIL .AND. ::FField:ValidValues != NIL
  
	validValues := ::FField:GetValidValues()

    SWITCH ValType( validValues )
    CASE 'A'
      Result := {}
      FOR EACH itm IN validValues
        IF HB_IsArray( itm )
          AAdd( Result, itm[ 1 ] )
        ELSE
          AAdd( Result, itm )
        ENDIF
      NEXT
      EXIT
    CASE 'H'
      Result := {}
      FOR EACH itm IN validValues
        AAdd( Result, itm:__enumValue() )
      NEXT
      EXIT
    END

  ENDIF

RETURN Result

/*
  GetKeyValue
  Teo. Mexico 2009
*/
METHOD GetKeyValue( n ) CLASS wxhGET
  LOCAL itm

  IF ::FField != NIL .AND. ::FField:ValidValues != NIL

    SWITCH ValType( ::FField:ValidValues )
    CASE 'A'
      IF n > 0 .AND. n <= Len( ::FField:ValidValues )
        itm := ::FField:ValidValues[ n ]
        IF HB_IsArray( itm )
          RETURN itm[ 1 ]
        ELSE
          RETURN itm
        ENDIF
      ENDIF
      EXIT
    CASE 'H'
      itm := HB_HKeys( ::FField:ValidValues )
      IF n > 0 .AND. n <= len( itm )
        RETURN itm[ n ]
      ENDIF
      EXIT
    END

  ENDIF

RETURN NIL

/*
  GetSelection
  Teo. Mexico 2009
*/
METHOD GetSelection CLASS wxhGET
  LOCAL n := 0
  LOCAL itm
  LOCAL key

  key := ::FBlock:Eval()

  IF ::FField != NIL .AND. ::FField:ValidValues != NIL

    SWITCH ValType( ::FField:ValidValues )
    CASE 'A'    /* Array */
      FOR EACH itm IN ::FField:ValidValues
        IF HB_IsArray( itm )
          IF ValType( itm[ 1 ] ) == ValType( key ) .AND. itm[ 1 ] == key
            RETURN itm:__enumIndex()
          ENDIF
        ELSE
        ENDIF
      NEXT
      EXIT
    CASE 'H'    /* Hash */
      n := HB_HScan( ::FField:ValidValues, key )
      EXIT
    _SW_OTHERWISE
      EXIT
    END

  ENDIF

RETURN n

/*
  End Class wxGET
*/

/*
  wxHBTextCtrl
*/
CLASS wxHBTextCtrl FROM wxTextCtrl
PRIVATE:
  DATA bAction
  DATA FWXHGet
  DATA FContextListKey INIT wxGetApp():wxh_ContextListKey
  DATA dontUpdateVar INIT .F.
  METHOD UpdateVar( event )
PROTECTED:
PUBLIC:
  DATA Picture
  DATA WarnBlock
  DATA nextCtrlOnEnter INIT .T.

  CONSTRUCTOR New( window, id, wxhGet, pos, size, style, validator, name )

  METHOD PickList

  PROPERTY WXHGet READ FWXHGet

PUBLISHED:
ENDCLASS

/*
  New
*/
METHOD New( window, id, wxhGet, pos, size, style, validator, name, picture, warn, toolTip, bAction ) CLASS wxHBTextCtrl

  /* nextCtrlOnEnter */
  IF ::nextCtrlOnEnter
    IF style = NIL
      style := wxTE_PROCESS_ENTER
    ELSE
      style := _hb_BitOr( style, wxTE_PROCESS_ENTER )
    ENDIF
  ENDIF

  Super:New( window, id, RTrim( wxhGet:AsString() ), pos, size, style, validator, name )

  IF name = NIL
    ::SetName( wxhGet:Name )
//     ::SetLabel( wxhGet:Name )
  ENDIF

  ::bAction := bAction

  ::FWXHGet := wxhGet

  /* the update to VAR event */
  IF ::nextCtrlOnEnter .AND. !::IsMultiLine()
    window:ConnectCommandEvt( ::GetId(), wxEVT_COMMAND_TEXT_ENTER, {|event|  wxh_AddNavigationKeyEvent( event:GetEventObject():GetParent() ) } )
  ENDIF

  ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS, {|event|  event:GetEventObject():UpdateVar( event ) } )

  IF picture != NIL
    ::Picture := picture
  ENDIF

  IF warn != NIL
    ::WarnBlock := warn
  ENDIF

  IF ::FWXHGet != NIL .AND. ::FWXHGet:Field != NIL .AND. HB_IsBlock( ::FWXHGet:Field:GetItPick )
    ::ConnectMouseEvt( ::GetId(), wxEVT_LEFT_DCLICK, {|event| event:GetEventObject():PickList() } )
	IF ::FContextListKey != NIL
	  ::ConnectKeyEvt( wxID_ANY, wxEVT_KEY_DOWN, ;
		{|event|
		  IF event:GetKeyCode() = ::FContextListKey
			event:GetEventObject():PickList()
			RETURN NIL
		  ENDIF
		  event:Skip()
		  RETURN NIL
		} )
	ENDIF
  ENDIF

  IF toolTip != NIL
    ::SetToolTip( toolTip )
  ENDIF

RETURN Self

/*
  PickList
  Teo. Mexico 2009
*/
METHOD PROCEDURE PickList CLASS wxHBTextCtrl
  LOCAL s
  LOCAL parentWnd
  LOCAL selectionMade
  
  IF ::FWXHGet:Field == NIL
    RETURN
  ENDIF

  parentWnd := ::GetParent()

  ::dontUpdateVar := .T.
  selectionMade := ::FWXHGet:Field:GetItDoPick( parentWnd )
  ::dontUpdateVar := .F.
  
  IF selectionMade
	s := RTrim( ::FWXHGet:Field:Value )
	IF RTrim( ::GetValue() ) == s
	  RETURN /* no changes */
	ENDIF
	::SetValue( s )
  ENDIF

RETURN

/*
  UpdateVar
  Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxHBTextCtrl
  LOCAL evtType

  IF ::FWXHGet == NIL .OR. ::dontUpdateVar
    RETURN
  ENDIF

  evtType := event:GetEventType()

  IF AScan( { wxEVT_KILL_FOCUS, wxEVT_COMMAND_TEXT_ENTER }, evtType ) > 0
  
    IF ! RTrim( ::FWXHGet:AsString() ) == RTrim( ::GetValue() ) .OR. evtType == wxEVT_COMMAND_TEXT_ENTER
      ::FWXHGet:Block:Eval( ::GetValue() )
      ::SetValue( RTrim( ::FWXHGet:Block:Eval() ) )
      IF ::bAction != NIL
        ::bAction:Eval( Self )
      ENDIF
    ENDIF

  ENDIF

RETURN

/*
  End Class wxHBTextCtrl
*/
