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

#define nextCtrlOnEnter		.T.

/*
	wxhFuncs
	Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

#include "wxh/textctrl.ch"
#include "wxh/bitmap.ch"
#include "wxh/button.ch"

#include "wxharbour.ch"

#ifdef __XHARBOUR__

#include "wx_hbcompat.ch"

#endif

REQUEST QQOUT
REQUEST WXTOOLBARTOOLBASE

STATIC containerObj
STATIC menuData

/*
	wxhHBValidator
	Teo. Mexico 2009
*/
CLASS wxhHBValidator FROM wxValidator
PRIVATE:
	DATA FBlock
	DATA FField
	DATA FName
	DATA dontUpdateVar INIT .F.
	METHOD GetMaxLength()
PROTECTED:
PUBLIC:

	DATA bAction
	DATA data
	DATA dataIsOEM INIT .T.
	DATA onSearch
	DATA Picture
	DATA warnBlock

	CONSTRUCTOR New()

	METHOD AddPostInfo()
	METHOD AsString()
	METHOD EvalWarnBlock()
	METHOD GetChoices()							/* returns a array of values */
	METHOD GetKeyValue()						/* returns key of ValidValues on TField (if any) */
	METHOD GetSelection()						/* returns numeric index of ValidValues on TField (if any) */
	METHOD IsModified()
	METHOD PickList( control )
	METHOD TextValue()							/* Text Value for control */
	METHOD UpdateVar( event )

	/* wxValidator methods */
	METHOD TransferFromWindow()
	METHOD TransferToWindow()
	METHOD Validate()

	PROPERTY Block READ FBlock
	PROPERTY Field READ FField
	PROPERTY maxLength READ GetMaxLength
	PROPERTY Name READ FName

	PUBLISHED:
ENDCLASS

/*
	New
	Teo. Mexico 2009
*/
METHOD New( name, var, block, picture, warn, bAction ) CLASS wxhHBValidator

	::FName	 := name

	IF HB_IsObject( var ) .AND. var:IsDerivedFrom("TField")
		::FField := var
		block := {|__localVal| iif( PCount() > 0, ::FField:Value := __localVal, ::FField:Value ) }
	ELSEIF Empty( name )
		block := {|__localVal| iif( PCount() > 0, ::data := __localVal, ::data ) }
	ENDIF

	::FBlock := block

	IF picture != NIL
		::Picture := picture
	ENDIF

	IF warn != NIL
		::warnBlock := warn
	ENDIF

	IF bAction != NIL
		::bAction := bAction
	ENDIF

RETURN Super:New()

/*
	AddPostInfo
	Teo. Mexico 2009
*/
METHOD PROCEDURE AddPostInfo() CLASS wxhHBValidator
	LOCAL contextListKey := wxGetApp():wxh_ContextListKey
	LOCAL parent := containerObj():LastParent()
	LOCAL control := ::GetWindow()
	
	/*
	 * connect events for changes
	 */
	/* @ CHECKBOX */
	IF control:IsDerivedFrom( "wxCheckBox" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_CHECKBOX_CLICKED, {|event| ::UpdateVar( event ) } )

	/* @ CHOICE */
	ELSEIF control:IsDerivedFrom( "wxChoice" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_CHOICE_SELECTED, {|event| ::UpdateVar( event ) } )

	/* @ COMBOBOX */
	ELSEIF control:IsDerivedFrom( "wxComboBox" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_COMBOBOX_SELECTED, {|event| ::UpdateVar( event ) } )
		control:ConnectCommandEvt( control:GetID(), wxEVT_COMMAND_TEXT_UPDATED, {|event| ::UpdateVar( event ) } )

	/* @ DATEPICKERCTRL */
	ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_DATE_CHANGED, {|event| ::UpdateVar( event ) } )

	/* @ GET */
	ELSEIF control:IsDerivedFrom( "wxTextCtrl" )
		IF nextCtrlOnEnter .AND. !control:IsMultiLine()
			parent:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_TEXT_ENTER, {|event|	 wxh_AddNavigationKeyEvent( event:GetEventObject():GetParent() ) } )
		ENDIF
		IF control:IsDerivedFrom( "wxSearchCtrl" ) .AND. ::onSearch != NIL
			control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SEARCHCTRL_SEARCH_BTN, ::onSearch )
		ENDIF
		IF ::Field != NIL .AND. !::Field:PickList == NIL
			control:ConnectMouseEvt( control:GetId(), wxEVT_LEFT_DCLICK, {|event| ::PickList( event:GetEventObject() ) } )
			IF control:IsDerivedFrom( "wxSearchCtrl" ) .AND. ::onSearch = NIL
				control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SEARCHCTRL_SEARCH_BTN, {|event| ::PickList( event:GetEventObject() ) } )
			ENDIF
			IF contextListKey != NIL
				control:ConnectKeyEvt( wxID_ANY, wxEVT_KEY_DOWN, ;
					BEGIN_CB|event|
						IF event:GetKeyCode() = contextListKey
							::PickList( event:GetEventObject() )
							RETURN NIL
						ENDIF
						event:Skip()
						RETURN NIL
					END_CB )
			ENDIF
		ENDIF
		control:SetSelection()
		IF ::maxLength != NIL
			control:SetMaxLength( ::maxLength )
		ENDIF

	/* @ RADIOBOX */
	ELSEIF control:IsDerivedFrom( "wxRadioBox" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_RADIOBOX_SELECTED, {|event| ::UpdateVar( event ) } )

	/* @ SPINCTRL */
	ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )
		control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SPINCTRL_UPDATED, {|event| ::UpdateVar( event ) } )

	ENDIF
	
	/* TField attributes */
	IF ::FField != NIL
		IF control:IsEnabled() .AND. ::FField:IsReadOnly()
			control:Disable()
		ENDIF
	ENDIF

	/*
	 * Common to all controls
	 */
	/* update var on kill focus, All controls ? */
	control:ConnectFocusEvt( control:GetId(), wxEVT_KILL_FOCUS, {|event| ::UpdateVar( event ) } )

	/* set default name if empty */
	IF Empty( control:GetName() )
		control:SetName( ::Name )
	ENDIF

RETURN

/*
	AsString
	Teo. Mexico 2009
*/
METHOD FUNCTION AsString() CLASS wxhHBValidator
	LOCAL value
	IF ::FField != NIL
		value := ::FField:AsString()
	ELSE
		value := AsString( ::FBlock:Eval() )
	ENDIF
RETURN value

/*
	EvalWarnBlock
	Teo. Mexico 2009
*/
METHOD FUNCTION EvalWarnBlock( control, showWarning ) CLASS wxhHBValidator
	LOCAL msg
	IF ::warnBlock != NIL .AND. ::warnBlock[ 1 ]:Eval( control )
		IF showWarning == NIL .OR. showWarning
			msg := iif( Empty( ::warnBlock[ 2 ] ), "Field has invalid data...", ::warnBlock[ 2 ] )
			wxMessageBox( msg, "Warning", HB_BitOr( wxOK, wxICON_EXCLAMATION ), control:GetParent() )
		ENDIF
		RETURN .T.
	ENDIF
RETURN .F.

/*
	GetChoices
	Teo. Mexico 2009
*/
METHOD FUNCTION GetChoices CLASS wxhHBValidator
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
METHOD FUNCTION GetKeyValue( n ) CLASS wxhHBValidator
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

RETURN n

/*
	GetMaxLength
	Teo. Mexico 2009
*/
METHOD FUNCTION GetMaxLength() CLASS wxhHBValidator
	LOCAL maxLength

	IF ::FField != NIL .AND. ::FField:IsDerivedFrom("TStringField")
		maxLength := ::FField:Size
	ENDIF

RETURN maxLength

/*
	GetSelection
	Teo. Mexico 2009
*/
METHOD GetSelection CLASS wxhHBValidator
	LOCAL n := 0
	LOCAL itm
	LOCAL key

	key := ::FBlock:Eval()

	IF ::FField != NIL .AND. ::FField:ValidValues != NIL

		SWITCH ValType( ::FField:ValidValues )
		CASE 'A'		/* Array */
			FOR EACH itm IN ::FField:ValidValues
				IF HB_IsArray( itm )
					IF ValType( itm[ 1 ] ) == ValType( key ) .AND. itm[ 1 ] == key
						RETURN itm:__enumIndex()
					ENDIF
				ELSE
				ENDIF
			NEXT
			EXIT
		CASE 'H'		/* Hash */
		n := HB_HPos( ::FField:ValidValues, key )
			EXIT
		_SW_OTHERWISE
			EXIT
		END

	ELSE

		n := key

	ENDIF

RETURN n

/*
	IsModified
	Teo. Mexico 2009
*/
METHOD IsModified( control ) CLASS wxhHBValidator
	LOCAL modified

	// TODO: Check why TAB on a TextCtrl marks buffer as dirty
	// modified := control:IsModified()
	modified := .F.

	IF !modified
		IF ::dataIsOEM
			modified := ! RTrim( wxh_wxStringToOEM( control:GetValue() ) ) == RTrim( ::AsString() )
		ELSE
			modified := ! RTrim( control:GetValue() ) == RTrim( ::AsString() )
		ENDIF
	ENDIF

RETURN modified

/*
	PickList
	Teo. Mexico 2009
*/
METHOD PROCEDURE PickList( control ) CLASS wxhHBValidator
	LOCAL s
	LOCAL parentWnd
	LOCAL selectionMade
	LOCAL value, rawValue
	
	parentWnd := control:GetParent()

	::dontUpdateVar := .T.
	selectionMade := ::Field:OnPickList( parentWnd )
	::dontUpdateVar := .F.

	IF selectionMade
		s := RTrim( ::Field:Value )
		rawValue := control:GetValue()
		IF ::dataIsOEM
			value := RTrim( wxh_wxStringToOEM( rawValue ) )
		ELSE
			value := RTrim( rawValue )
		ENDIF
		IF s == value
			RETURN /* no changes */
		ENDIF
		control:ChangeValue( wxh_OEMTowxString( s ) )
	ENDIF

	control:SetFocus()

RETURN

/*
	TextValue
	Teo. Mexico 2009
*/
METHOD FUNCTION TextValue() CLASS wxhHBValidator
	LOCAL value

	value := RTrim( ::AsString() )

	IF ::Field != NIL
		IF ::Field:Table:dataIsOEM
			value := wxh_OEMTowxString( value )
		ENDIF
	ENDIF

RETURN value

/*
	TransferFromWindow
	Teo. Mexico 2009
*/
METHOD TransferFromWindow() CLASS wxhHBValidator
	LOCAL control
	LOCAL value
	LOCAL Result := .T.
	
	control := ::GetWindow()

	IF control:IsDerivedFrom( "wxTextCtrl" )

		IF ::dataIsOEM
			value := wxh_wxStringToOEM( control:GetValue() )
		ELSE
			value := control:GetValue()
		ENDIF

		::FBlock:Eval( value )
	
		value := ::FBlock:Eval()
		
		SWITCH ValType( value )
		CASE 'C'
			EXIT
		CASE 'D'
			value := FDateS( value )
			EXIT
		CASE 'N'
			IF Empty( ::picture )
				value := Str( value )
			ELSE
				value := Transform( value, ::picture )
			ENDIF
			EXIT
		END

		control:ChangeValue( wxh_OEMTowxString( RTrim( value ) ) )

	ELSEIF control:IsDerivedFrom( "wxCheckBox" )

		::FBlock:Eval( control:GetValue() )

	ELSEIF control:IsDerivedFrom( "wxChoice" )

		value := ::GetKeyValue( control:GetCurrentSelection() )

		::FBlock:Eval( value )

	ELSEIF control:IsDerivedFrom( "wxComboBox" )

		value := control:GetValue()

		::FBlock:Eval( value )
		
	ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )

		value := control:GetValue()

		::FBlock:Eval( value )
		
	ELSEIF control:IsDerivedFrom( "wxRadioBox" )

		value := ::GetKeyValue( control:GetSelection() )

		::FBlock:Eval( value )

	ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )

		::FBlock:Eval( control:GetValue() )

	ELSE

		Result := .F.

	ENDIF

RETURN Result

/*
	TransferToWindow
	Teo. Mexico 2009
*/
METHOD TransferToWindow() CLASS wxhHBValidator
	LOCAL control
	LOCAL Result := .T.
	
	control := ::GetWindow()
	
	IF control != NIL .AND. ::FBlock != NIL

		/*
		 * Assign initial value
		 */
		/* @ CHECKBOX */
		IF control:IsDerivedFrom( "wxCheckBox" )

			IF !control:Is3State()
				control:SetValue( ::Block:Eval() )
			ENDIF

		/* @ CHOICE */
		ELSEIF control:IsDerivedFrom( "wxChoice" )
	
			control:SetSelection( ::GetSelection() )

		/* @ COMBOBOX */
		ELSEIF control:IsDerivedFrom( "wxComboBox" )

			control:SetSelection( ::GetSelection() )

		/* @ DATEPICKERCTRL */
		ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )

			control:SetValue( ::Block:Eval() )

		/* @ GET */
		ELSEIF control:IsDerivedFrom( "wxTextCtrl" )

			control:ChangeValue( ::TextValue() )

		/* @ RADIOBOX */
		ELSEIF control:IsDerivedFrom( "wxRadioBox" )

			control:SetSelection( ::GetSelection() )

		/* @ SPINCTRL */
		ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )

			control:SetValue( ::Block:Eval() )

		ELSE

			Result := .F.

		ENDIF
		
	ELSE
	
		Result := .F.

	ENDIF
	
RETURN Result

/*
	UpdateVar
	Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event ) CLASS wxhHBValidator
	LOCAL evtType
	LOCAL control
	LOCAL oldValue
	
	IF ::dontUpdateVar .OR. ::FBlock == NIL
		RETURN
	ENDIF

	evtType := event:GetEventType()
	control := event:GetEventObject()
	oldValue := ::FBlock:Eval()

	IF control:IsDerivedFrom( "wxTextCtrl" )
		IF AScan( { wxEVT_KILL_FOCUS, wxEVT_COMMAND_TEXT_ENTER }, evtType ) > 0
			IF ::IsModified( control ) .OR. evtType == wxEVT_COMMAND_TEXT_ENTER
				::TransferFromWindow()
			ENDIF
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxCheckBox" )
		IF evtType = wxEVT_COMMAND_CHECKBOX_CLICKED
			::TransferFromWindow()
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxChoice" )
		IF evtType = wxEVT_COMMAND_CHOICE_SELECTED
			::TransferFromWindow()
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxComboBox" )
		IF evtType = wxEVT_COMMAND_COMBOBOX_SELECTED .OR. evtType = wxEVT_KILL_FOCUS
			::TransferFromWindow()
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )
		IF evtType = wxEVT_DATE_CHANGED
			::TransferFromWindow()
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxRadioBox" )
		IF evtType = wxEVT_COMMAND_RADIOBOX_SELECTED
			::TransferFromWindow()
		ENDIF

	ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )
		IF evtType = wxEVT_COMMAND_SPINCTRL_UPDATED
			::TransferFromWindow()
		ENDIF

	ELSE

		RETURN	// no control found

	ENDIF

	::TransferToWindow()

	/* changed ? */
	IF !oldValue == ::FBlock:Eval()
		IF ::bAction != NIL
			::bAction:Eval( event )
		ENDIF
	ENDIF

	::EvalWarnBlock( control )

RETURN

/*
	Validate
	Teo. Mexico 2009
*/
METHOD Validate( parent ) CLASS wxhHBValidator

	IF ::warnBlock != NIL
		WXH_UNUSED( parent )
		RETURN ::warnBlock[ 1 ]:Eval( ::GetWindow() )
	ENDIF

RETURN .T.

/*
	End Class wxGET
*/

/*
	ContainerObj
	Teo. Mexico 2009
*/
FUNCTION ContainerObj
	IF containerObj == NIL
		containerObj := TContainerObj():New()
	ENDIF
RETURN containerObj

/*
	__wxh_BookAddPage
	Teo. Mexico 2009
*/
PROCEDURE __wxh_BookAddPage( title, select, imageId )

	containerObj():AddToNextBookPage( {"title"=>title,"select"=>select,"imageId"=>imageId} )

RETURN

/*
	__wxh_BookBegin
	Teo. Mexico 2009
*/
FUNCTION __wxh_BookBegin( bookClass, parent, id, pos, size, style, name, opChanged, opChanging )
	LOCAL book

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	book := bookClass:New( parent, id, pos, size, style, name )
	
	IF opChanged != NIL
		book:ConnectNotebookEvt( book:GetID(), wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED, opChanging )
	ENDIF
	
	IF opChanging != NIL
		book:ConnectNotebookEvt( book:GetID(), wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING, opChanging )
	ENDIF
	
	containerObj():SetLastChild( book )

	containerObj():AddToParentList( book )

RETURN book

/*
	__wxh_BookEnd
	Teo. Mexico 2009
*/
PROCEDURE __wxh_BookEnd( book )
	containerObj():RemoveLastParent( book )
RETURN

/*
 * __wxh_BoxSizerBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_BoxSizerBegin( parent, label, orient, strech, align, border, sideBorders )
	LOCAL sizer
	LOCAL lastSizer

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	lastSizer := containerObj():LastSizer()

	IF label == NIL
		sizer := wxBoxSizer():New( orient )
	ELSE
		sizer := wxStaticBoxSizer():New( orient, parent, label )
		//sizer := wxStaticBoxSizer():New( wxStaticBox():New( parent, , label ) , orient )
	ENDIF

	IF lastSizer == NIL
		IF parent == NIL
			wxhAlert( "Sizer declared with no parent on sight..." )
		ENDIF
		__wxh_SetSizer( parent, sizer )
	ELSE
		__wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
	ENDIF

	containerObj():AddToSizerList( sizer )

RETURN sizer

/*
	__wxh_Browse
	Teo. Mexico 2009
 */
FUNCTION __wxh_Browse( fromClass, dataSource, window, id, label, pos, size, minSize, style, name, keyDownEventBlock, onSelectCell )
	LOCAL browse
	LOCAL panel
	LOCAL boxSizer
	LOCAL scrollBar

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	panel := wxPanel():New( window, wxID_ANY, pos, size, wxTAB_TRAVERSAL ) /* container of type wxPanel */

	IF label == NIL
		boxSizer := wxBoxSizer():New( wxHORIZONTAL )
	ELSE
		boxSizer := wxStaticBoxSizer():New( wxHORIZONTAL, panel, label )
	ENDIF

	panel:SetSizer( boxSizer )
	
	IF !Empty( fromClass )
		browse := __ClsInstFromName( fromClass ):New( panel, id, NIL, NIL, style, name )
	ELSE
		browse := wxhBrowse():New( panel, id, NIL, {200,150}, style, name )
	ENDIF

	IF !browse:IsDerivedFrom( "wxhBrowse" )
		browse:IsNotDerivedFrom_wxhBrowse()
	ENDIF
	
	IF dataSource != NIL
		browse:DataSource := dataSource
	ENDIF

	browse:keyDownEventBlock := keyDownEventBlock
	browse:SelectCellBlock := onSelectCell

	IF minSize != NIL
		browse:SetMinSize( minSize )
	ENDIF

//
	boxSizer:Add( browse, 1, _hb_BitOr( wxGROW, wxALL ), 5 )

	boxSizer:Add( wxStaticLine():New( panel, wxID_ANY, NIL, NIL, wxLI_VERTICAL ), 0, wxGROW, 5 )

	scrollBar := wxScrollBar():New( panel, wxID_ANY, NIL, NIL, wxSB_VERTICAL )

	scrollBar:SetScrollBar( 0, 1, 100, 1 )

	boxSizer:Add( scrollBar, 0, _hb_BitOr( wxGROW, wxLEFT, wxRIGHT ), 5 )
//

	containerObj():SetLastChild( panel )

RETURN browse

/*
	__wxh_BrowseAddColumn
	Teo. Mexico 2009
*/
PROCEDURE __wxh_BrowseAddColumn( zero, wxhBrw, title, block, picture, width, type, wp )
	LOCAL column := wxhBColumn():New( title, block )

	column:Picture := picture
	column:Width	 := width

	IF zero
		wxhBrw:ColumnZero := column
	ELSE
		wxhBrw:AddColumn( column )
	ENDIF

	IF type != NIL
		type := Upper( type )
		DO CASE
		CASE type == "BOOL"
			wxhBrw:SetColFormatBool( wxhBrw:ColCount() - 1 )
		CASE type == "NUMBER"
			wxhBrw:SetColFormatNumber( wxhBrw:ColCount() - 1 )
		CASE type == "FLOAT"
			IF wp != NIL
				wxhBrw:SetColFormatFloat( wxhBrw:ColCount() - 1, wp[ 1 ], wp[ 2 ] )
			ENDIF
		ENDCASE
	ENDIF

RETURN

/*
	__wxh_Button
	Teo. Mexico 2009
*/
FUNCTION __wxh_Button( window, id, label, bmp, pos, size, style, validator, name, default, bAction )
	LOCAL button
	LOCAL bitmap

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	IF bmp != NIL
		bitmap := __wxh_GetBitmapResource( bmp )
	ENDIF

	IF bitmap == NIL
		button := wxButton():New( window, id, label, pos, size, style, validator, name )
	ELSE
		IF style == NIL
			style := wxBU_AUTODRAW
		ELSE
			style := _hb_BitOr( style, wxBU_AUTODRAW )
		ENDIF
		button := wxBitmapButton():New( window, id, bitmap, pos, size, style, validator, name )
	ENDIF

	IF bAction != NIL
		button:ConnectCommandEvt( button:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
	ENDIF

	IF default == .T.
		button:SetDefault()
	ENDIF

	containerObj():SetLastChild( button )

RETURN button

/*
	__wxh_CheckBox
	Teo. Mexico 2009
*/
FUNCTION __wxh_CheckBox( window, id, label, pos, size, style, name )
	LOCAL checkBox
	LOCAL validator

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	checkBox := wxCheckBox():New( window, id, label, pos, size, style, validator, name )

	validator:AddPostInfo()

	containerObj():SetLastChild( checkBox )

RETURN checkBox

/*
	__wxh_Choice
	Teo. Mexico 2009
*/
FUNCTION __wxh_Choice( parent, id, point, size, choices, style, name )
	LOCAL choice
	LOCAL validator

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	IF choices == NIL .AND. validator:Field != NIL
		choices := validator:GetChoices()
	ENDIF

	choice := wxChoice():New( parent, id, point, size, choices, style, validator, name )

	validator:AddPostInfo()

	containerObj():SetLastChild( choice )

RETURN choice

/*
	__wxh_ComboBox
	Teo. Mexico 2009
*/
FUNCTION __wxh_ComboBox( parent, id, value, point, size, choices, style, name )
	LOCAL comboBox
	LOCAL validator

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	IF choices == NIL .AND. validator:Field != NIL
		choices := validator:GetChoices()
	ENDIF

	IF value == NIL
		value := RTrim( validator:AsString() )
	ENDIF

	comboBox := wxComboBox():New( parent, id, value, point, size, choices, style, validator, name )

	validator:AddPostInfo()

	containerObj():SetLastChild( comboBox )

RETURN comboBox

/*
 * __wxh_DatePickerCtrl
 * Teo. Mexico 2009
 */
FUNCTION __wxh_DatePickerCtrl( parent, id, pos, size, style, name, toolTip )
	LOCAL dateCtrl
	LOCAL validator
	
	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	dateCtrl := wxDatePickerCtrl():New( parent, id, NIL, pos, size, style, validator, name )

	IF toolTip != NIL
		dateCtrl:SetToolTip( toolTip )
	ENDIF

	validator:AddPostInfo()
	
	containerObj():SetLastChild( dateCtrl )

RETURN dateCtrl

/*
	__wxh_Dialog
	Teo. Mexico 2009
*/
FUNCTION __wxh_Dialog( fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose, initDlg )
	LOCAL dlg
	
	IF Empty( fromClass )
		dlg := wxDialog():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
	ELSE
		dlg := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
		IF !dlg:IsDerivedFrom( "wxDialog" )
			dlg:IsNotDerivedFrom_wxDialog()
		ENDIF
	ENDIF
	
	IF onClose != NIL
		dlg:ConnectCloseEvt( dlg:GetId(), wxEVT_CLOSE_WINDOW, onClose )
	ENDIF

	IF initDlg != NIL
		dlg:ConnectInitDialogEvt( dlg:GetId(), wxEVT_INIT_DIALOG, initDlg )
	ENDIF

	containerObj():AddToParentList( dlg )

RETURN dlg

/*
	__wxh_EnableControl
	Teo. Mexico 2009
*/
STATIC PROCEDURE __wxh_EnableControl( evtCtrl, ctrl, id, enabled )
	LOCAL vt := ValType( enabled )
	
	SWITCH vt
	CASE 'B'
		evtCtrl:ConnectUpdateUIEvt( id, wxEVT_UPDATE_UI, {|updateUIEvent| updateUIEvent:Enable( enabled:Eval() ) } )
		EXIT
	CASE 'L'
		IF ctrl != NIL
			ctrl:Enable( enabled )
		ENDIF
		EXIT
	END

RETURN

/*
 * __wxh_FlexGridSizerBegin
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_FlexGridSizerBegin( rows, cols, vgap, hgap, growableCols, growableRows, strech, align, border, sideBorders )
	LOCAL sizer
	LOCAL parent
	LOCAL lastSizer
	LOCAL itm
	
	sizer := wxFlexGridSizer():New( rows, cols, vgap, hgap )
	
	IF !Empty( growableRows )
	FOR EACH itm IN growableRows
		sizer:AddGrowableRow( itm )	 // ROW 1 becomes ROW 0
	NEXT
	ENDIF

	IF !Empty( growableCols )
	FOR EACH itm IN growableCols
		sizer:AddGrowableCol( itm )	 // COLUMN 1 becomes COLUMN 0
	NEXT
	ENDIF

	parent := containerObj():LastParent()
	lastSizer := containerObj():LastSizer

	IF lastSizer == NIL
		__wxh_SetSizer( parent, sizer )
	ELSE
		__wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
	ENDIF

	containerObj():AddToSizerList( sizer )

RETURN

/*
	__wxh_Frame
	Teo. Mexico 2009
*/
FUNCTION __wxh_Frame( frameType, fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose )
	LOCAL oWnd

	IF Empty( fromClass )

		DO CASE
		CASE frameType == "MDIPARENT"
			oWnd := wxMDIParentFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
		CASE frameType == "MDICHILD"
			oWnd := wxMDIChildFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
		OTHERWISE
			oWnd := wxFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
		ENDCASE

	ELSE

		oWnd := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )

		DO CASE
		CASE frameType == "MDIPARENT"
			IF !oWnd:IsDerivedFrom( "wxMDIParentFrame" )
				oWnd:IsNotDerivedFrom_wxMDIParentFrame()
			ENDIF
		CASE frameType == "MDICHILD"
			IF !oWnd:IsDerivedFrom( "wxMDIChildFrame" )
				oWnd:IsNotDerivedFrom_wxMDIChildFrame()
			ENDIF
		OTHERWISE
			IF !oWnd:IsDerivedFrom( "wxFrame" )
				oWnd:IsNotDerivedFrom_wxFrame()
			ENDIF
		ENDCASE

	ENDIF

	IF onClose != NIL
		oWnd:ConnectCloseEvt( oWnd:GetId(), wxEVT_CLOSE_WINDOW, onClose )
	ENDIF

	containerObj():AddToParentList( oWnd )

RETURN oWnd

/*
	__wxh_Gauge
	Teo. Mexico 2009
*/
FUNCTION __wxh_Gauge( window, id, range, pos, size, style, validator, name, type )
	LOCAL gauge

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	IF type != NIL
		IF style == NIL
			style := type
		ELSE
			style := _hb_BitOr( style, type )
		ENDIF
	ENDIF

	gauge := wxGauge():New( window, id, range, pos, size, style, validator, name )

	containerObj():SetLastChild( gauge )

RETURN gauge

/*
	__wxh_GetBitmapResource
	Teo. Mexico 2009
*/
FUNCTION __wxh_GetBitmapResource( bmp )
	LOCAL bitmap

	SWITCH ValType( bmp )
	CASE 'C'
		IF File( bmp )
			bitmap := wxBitmap():New()
			IF Upper( Right( bmp, 3 ) ) == "XPM"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_XPM )
			ELSEIF Upper( Right( bmp, 3 ) ) == "BMP"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_BMP )
			ELSEIF Upper( Right( bmp, 3 ) ) == "GIF"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_GIF )
			ELSEIF Upper( Right( bmp, 3 ) ) == "XBM"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_XBM )
			ELSEIF Upper( Right( bmp, 3 ) ) == "JPG"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_JPEG )
			ELSEIF Upper( Right( bmp, 3 ) ) == "PNG"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_PNG )
			ELSEIF Upper( Right( bmp, 3 ) ) == "PCX"
				bitmap:LoadFile( bmp, wxBITMAP_TYPE_PCX )
			ENDIF
			IF bitmap:IsOk()				
				EXIT
			ENDIF
		ENDIF
		bitmap := wxBitmap():New( 0 )	 // missing image
		EXIT
	CASE 'O'
		IF bmp:IsDerivedFrom("wxBitmap")
			bitmap := bmp
		ENDIF
		EXIT
	CASE 'N'
		bitmap := wxBitmap():New( bmp )
		EXIT
	_SW_OTHERWISE
		bitmap := wxBitmap():New( 0 )	 // missing image
	END

RETURN bitmap


/*
	__wxh_Grid
	Teo. Mexico 2009
 */
FUNCTION __wxh_Grid( window, id, pos, size, style, name, rows, cols )
	LOCAL grid

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	grid := wxGrid():New( window, id, pos, size, style, name )

	IF cols != NIL .OR. rows != NIL
		grid:CreateGrid( rows, cols )
	ENDIF

	containerObj():SetLastChild( grid )

RETURN grid

/*
 * __wxh_GridSizerBegin
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_GridSizerBegin( rows, cols, vgap, hgap, strech, align, border, sideBorders )
	LOCAL sizer
	LOCAL parent
	LOCAL lastSizer

	sizer := wxGridSizer():New( rows, cols, vgap, hgap )

	parent := containerObj():LastParent()
	lastSizer := containerObj():LastSizer

	IF lastSizer == NIL
		__wxh_SetSizer( parent, sizer )
	ELSE
		__wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
	ENDIF

	containerObj():AddToSizerList( sizer )

RETURN

/*
	__wxh_ListCtrl
	Teo. Mexico 2009
*/
FUNCTION __wxh_ListCtrl( window, id, value, pos, size, style, validator, name, bAction )
	LOCAL listCtrl

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	listCtrl := wxListCtrl():New( window, id, value, pos, size, style, validator, name )

	IF bAction != NIL
		listCtrl:ConnectCommandEvt( listCtrl:GetID(), wxEVT_COMMAND_TEXT_UPDATED, bAction )
	ENDIF

	containerObj():SetLastChild( listCtrl )

RETURN listCtrl

/*
	__wxh_MenuBarBegin
	Teo. Mexico 2009
*/
FUNCTION __wxh_MenuBarBegin( window, style )
	menuData := TGlobal():New()
	menuData:g_menuBar := wxMenuBar():New( style )
	IF window == NIL
		//menuData:g_window := __wxh_LastTopLevelWindow()
		menuData:g_window := containerObj():LastParent( "wxFrame" )
	ELSE
		menuData:g_window := window
	ENDIF
RETURN menuData:g_menuBar

/*
	__wxh_MenuBegin
	Teo. Mexico 2009
*/
FUNCTION __wxh_MenuBegin( title, evtHandler )
	LOCAL hData := {=>}
	LOCAL menu

	IF menuData == NIL
		menuData := TGlobal():New()
		AAdd( menuData:g_menuList, NIL ) /* a NULL MenuBar (1st item in array) */
	ENDIF

	IF evtHandler != NIL
		menuData:g_window := evtHandler
	ENDIF

	menu := wxMenu():New()
	hData["menu"] := menu
	hData["title"] := title
	AAdd( menuData:g_menuList, hData )

RETURN menu

/*
	__wxh_MenuEnd
	Teo. Mexico 2009
*/
PROCEDURE __wxh_MenuEnd
	LOCAL hData
	LOCAL menuListSize
	LOCAL menuItem
	LOCAL nLast
	LOCAL parentMenu

	IF Empty( menuData:g_menuList )
		menuData:g_window:SetMenuBar( menuData:g_menuBar )
		menuData := NIL
		RETURN
	ENDIF

	nLast := menuData:lenMenuList

	hData := menuData:g_menuList[ nLast ]

	menuListSize := Len( menuData:g_menuList )

	IF menuListSize = 1 /* Append to menuBar */

		menuData:g_menuBar:Append( hData["menu"], hData["title"] )

	ELSE								/* Append SubMenu */

		parentMenu := menuData:g_menuList[ nLast -1 ]

		IF parentMenu == NIL
			menuData := NIL
			RETURN
		ELSE
			menuItem := wxMenuItem():New( parentMenu["menu"], menuData:g_menuID++, hData["title"], "", wxITEM_NORMAL, hData["menu"] )
			parentMenu["menu"]:Append( menuItem )
		ENDIF

	ENDIF

	ASize( menuData:g_menuList, menuListSize - 1)

RETURN

/*
	__wxh_MenuItemAdd
	Teo. Mexico 2009
*/
FUNCTION __wxh_MenuItemAdd( id, text, helpString, kind, bAction, enabled )
	LOCAL menu
	LOCAL menuItem
	LOCAL nLast

	IF id=NIL
		id := menuData:g_menuID++
	ENDIF

	IF menuData:g_menuList == NIL
		wxhAlert( "No Menu at sight to add this MenuItem. Check your DEFINE MENU and ADD MENUITEM definition at line " + LTrim(Str(ProcLine( 1 ))) + " on " + ProcName( 1 ) )
		RETURN NIL
	ENDIF

	nLast := menuData:lenMenuList
	menu := menuData:g_menuList[ nLast ]["menu"]

	menuItem := wxMenuItem():New( menu, id, text, helpString, kind )
	menu:Append( menuItem )

	IF bAction = NIL
		menuItem:Enable( .F. )
	ELSE
		menuData:g_window:ConnectCommandEvt( id, wxEVT_COMMAND_MENU_SELECTED, bAction )
	ENDIF
	
	__wxh_EnableControl( menu, menuItem, id, enabled )

RETURN menuItem

/*
 * __wxh_PanelBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_PanelBegin( parent, id, pos, size, style, name, bEnabled )
	LOCAL panel

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	panel := wxPanel():New( parent, id, pos, size, style, name )

	__wxh_EnableControl( parent, panel, panel:GetId(), bEnabled )

	containerObj():SetLastChild( panel )

	containerObj():AddToParentList( panel )

RETURN panel

/*
	__wxh_PanelEnd
	Teo. Mexico 2009
*/
PROCEDURE __wxh_PanelEnd
	containerObj():RemoveLastParent( "wxPanel" )
RETURN

/*
	__wxh_RadioBox
	Teo. Mexico 2009
*/
FUNCTION __wxh_RadioBox( parent, id, label, point, size, choices, majorDimension, style, name )
	LOCAL radioBox
	LOCAL validator

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	IF choices == NIL .AND. validator:Field != NIL
		choices := validator:GetChoices()
	ENDIF

	radioBox := wxRadioBox():New( parent, id, label, point, size, choices, majorDimension, style, validator, name )

	validator:AddPostInfo()

	containerObj():SetLastChild( radioBox )

RETURN radioBox

/*
 * __wxh_SAY
 * Teo. Mexico 2009
 */
FUNCTION __wxh_SAY( window, id, label, pos, size, style, name )
	LOCAL Result

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	__wxh_TransWidth( NIL, window, Len( label ), size )

	Result := wxStaticText():New( window, id, label, pos, size, style, name )

	containerObj():SetLastChild( Result )

RETURN Result

/*
	__wxh_ScrollBar
	Teo. Mexico 2009
*/
FUNCTION __wxh_ScrollBar( window, id, pos, size, orient, style, validator, name, bAction )
	LOCAL sb

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	IF Empty( style )
		style := orient
	ELSE
		style := _hb_BitOr( orient, style )
	ENDIF

	sb := wxScrollBar():New( window, id, pos, size, style, validator, name )
	sb:SetScrollbar( 0, 1, 100, 1)

	IF bAction != NIL
		sb:ConnectCommandEvt( sb:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
	ENDIF

	containerObj():SetLastChild( sb )

RETURN sb

/*
	__wxh_SearchCtrl
	Teo. Mexico 2009
*/
FUNCTION __wxh_SearchCtrl( window, id, pos, size, style, name, onSearch, onCancel )
	LOCAL searchCtrl
	LOCAL validator

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	/* nextCtrlOnEnter */
	IF nextCtrlOnEnter
		IF style == NIL
			style := wxTE_PROCESS_ENTER
		ELSE
			style := _hb_BitOr( style, wxTE_PROCESS_ENTER )
		ENDIF
	ENDIF

	searchCtrl := wxSearchCtrl():New( window, id, NIL, pos, size, style, validator, name )

	IF onSearch != NIL
		validator:onSearch := onSearch
	ENDIF
	
	IF onCancel != NIL
		searchCtrl:ConnectCommandEvt( searchCtrl:GetID(), wxEVT_COMMAND_SEARCHCTRL_CANCEL_BTN, onCancel )
	ENDIF

	validator:AddPostInfo()

	containerObj():SetLastChild( searchCtrl )

RETURN searchCtrl

/*
	__wxh_SetSizer
	Teo. Mexico 2009
*/
PROCEDURE __wxh_SetSizer( window, sizer )
	LOCAL bookCtrl
	LOCAL IsWindowBook := .F.

	FOR EACH bookCtrl IN containerObj():BookCtrls
		IF window:IsDerivedFrom( bookCtrl )
			IsWindowBook := .T.
		ENDIF
	NEXT

	IF IsWindowBook
		wxhAlert( "Sizer cannot be a direct child of a " + window:ClassName() + " control.;Check your Sizer definition at line " + LTrim(Str(ProcLine(2))) + " on " + ProcName( 2 ) )
	ENDIF

	window:SetSizer( sizer )

RETURN

/*
	__wxh_ShowWindow : shows wxFrame/wxDialog
	Teo. Mexico 2009
*/
FUNCTION __wxh_ShowWindow( oWnd, modal, fit, centre )
	LOCAL Result
	LOCAL ctrl

	containerObj():ClearData()

	IF fit
		IF oWnd:GetSizer() != NIL
			oWnd:GetSizer():SetSizeHints( oWnd )
		ENDIF
	ENDIF

	IF centre
		oWnd:Centre()
	ENDIF
	
	/* Transfer data to windows for wxFrame's (this in wxDialog's are automatically) */
	IF oWnd:IsDerivedFrom("wxFrame")
		oWnd:TransferDataToWindow()
	ENDIF

	IF .T. /* Focus on first available control */
		FOR EACH ctrl IN oWnd:GetChildren()
			IF ctrl != NIL .AND. ctrl:IsDerivedFrom("wxTextCtrl")
				ctrl:SetFocus()
				EXIT
			ENDIF
		NEXT
	ENDIF

	IF modal
		IF !oWnd:IsDerivedFrom("wxDialog")
			oWnd:IsNotDerivedFrom_wxDialog()
		ENDIF
		Result := oWnd:ShowModal()
	ELSE
		Result := oWnd:Show( .T. )
	ENDIF

RETURN Result

/*
 * __wxh_SizerEnd
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_SizerEnd
	containerObj():RemoveLastSizer()
RETURN

/*
 * __wxh_SizerInfoAdd
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_SizerInfoAdd( child, parentSizer, strech, align, border, sideBorders, flag, useLast, addSizerInfoToLastItem )
	LOCAL sizerInfo

	IF Empty( containerObj():ParentList )
		RETURN
	ENDIF

	IF HB_HHasKey( containerObj():LastItem(), "ignoreSizerInfoAdd" )
		HB_HDel( containerObj():LastItem(), "ignoreSizerInfoAdd" )
		RETURN
	ENDIF

	IF child == NIL .AND. ! ( addSizerInfoToLastItem == .T. )

		/* Check if last child has been processed */
		IF containerObj():GetLastChild()[ "processed" ]
			RETURN
		ENDIF

		child := containerObj():GetLastChild()[ "child" ]
		sizerInfo := containerObj():GetLastChild()[ "sizerInfo" ]

		/* no sizerInfo available */
		IF sizerInfo == NIL
			RETURN
		ENDIF

		containerObj():GetLastChild()[ "processed" ] := .T. /* mark processed */

		strech			:= sizerInfo[ "strech" ]
		align				:= sizerInfo[ "align" ]
		border			:= sizerInfo[ "border" ]
		sideBorders := sizerInfo[ "sideBorders" ]
		flag				:= sizerInfo[ "flag" ]

	ENDIF

	/* collect default parentSizer */
	IF parentSizer == NIL
		/* check if we have a parent control */
		IF containerObj():GetLastChild()[ "child" ] == NIL
			IF containerObj():GetLastParent( -1 ) != NIL
				parentSizer := ATail( containerObj():GetLastParent( -1 )[ "sizers" ] )
			ENDIF
		ELSE
			parentSizer := containerObj():LastSizer()
		ENDIF
	ENDIF

	IF parentSizer == NIL
		//wxhAlert( "No parent Sizer available.", {"QUIT"})
		//TRACE "Child:", child:ClassName, "No parent Sizer available"
		RETURN
	ENDIF

	IF strech == NIL
		strech := 0
	ENDIF

	IF align == NIL
		IF parentSizer != NIL
			IF parentSizer:IsDerivedFrom("wxGridSizer")
				align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
			ELSE
				IF parentSizer:GetOrientation() = wxVERTICAL
					align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
				ELSE
					align := _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
				ENDIF
			ENDIF
		ELSE
			align := 0
		ENDIF
	ENDIF

	/* TODO: Make a more configurable way to do this */
	IF parentSizer != NIL .AND. parentSizer:IsDerivedFrom("wxGridSizer")
		align := _hb_BitOr( align, wxALIGN_CENTER_VERTICAL )
	ENDIF

	IF sideBorders == NIL
		sideBorders := wxALL
	ENDIF

	IF border == NIL
		border := 5
	ENDIF

	IF flag == NIL
		flag := 0
	ENDIF

	/* just add to last item */
	IF addSizerInfoToLastItem == .T.

		IF ! useLast == .T.
			sizerInfo := { "strech"=>strech, "align"=>align, "border"=>border, "sideBorders"=>sideBorders, "flag"=>flag }
			containerObj():AddSizerInfoToLastItem( sizerInfo )
		ENDIF

		RETURN

	ENDIF

	containerObj():SizerAddOnLastChild()

	parentSizer:Add( child, strech, _hb_BitOr( align, sideBorders, flag ), border )

RETURN

/*
 * __wxh_Spacer
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_Spacer( width, height, strech, align, border )
	LOCAL lastSizer

	containerObj():SizerAddOnLastChild()

	lastSizer := containerObj():LastSizer()

	IF lastSizer == NIL
		wxhAlert( "No Sizer available to add a Spacer",{"QUIT"})
		RETURN
	ENDIF

	IF width == NIL
		width := 5
	ENDIF

	IF height == NIL
		height := 5
	ENDIF

	IF strech == NIL
		strech := 1
	ENDIF

	IF align == NIL
		IF lastSizer:IsDerivedFrom("wxBoxSizer")
			IF !lastSizer:GetOrientation() = wxHORIZONTAL
				align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
			ELSE
				align := _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
			ENDIF
		ENDIF
	ENDIF

	IF border == NIL
		border := 5
	ENDIF

	lastSizer:Add( width, height, strech, align, border )

RETURN

/*
	__wxh_SpinCtrl
	Teo. Mexico 2009
*/
FUNCTION __wxh_SpinCtrl( parent, id, pos, size, style, min, max, name )
	LOCAL spinCtrl
	LOCAL validator

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF
	
	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	spinCtrl := wxSpinCtrl():New( parent, id, /* value */, pos, size, style, min, max, 0 /* initial */, name )
	
	spinCtrl:SetValidator( validator )
	
	validator:AddPostInfo()

	containerObj():SetLastChild( spinCtrl )

RETURN spinCtrl

/*
	__wxh_StaticBitmap
	Teo. Mexico 2009
*/
FUNCTION __wxh_StaticBitmap( parent, id, label, pos, size, style, name )
	LOCAL staticBitmap
	LOCAL bmp

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	bmp := __wxh_GetBitmapResource( label )

	staticBitmap := wxStaticBitmap():New( parent, id, bmp, pos, size, style, name )

	containerObj():SetLastChild( staticBitmap )

RETURN staticBitmap

/*
	__wxh_StaticLine
	Teo. Mexico 2009
*/
FUNCTION __wxh_StaticLine( window, id, pos, orient, name )
	LOCAL sl

	IF window == NIL
		window := containerObj():LastParent()
	ENDIF

	sl := wxStaticLine():New( window, id, pos, NIL, orient, name )

	containerObj():SetLastChild( sl )

RETURN sl

/*
	__wxh_StaticText
	Teo. Mexico 2009
*/
FUNCTION __wxh_StaticText( parent, id, label, pos, size, style, name )
	LOCAL staticText

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	staticText := wxStaticText():New( parent, id, label, pos, size, style, name )

	containerObj():SetLastChild( staticText )

RETURN staticText

/*
	__wxh_StatusBar
	Teo. Mexico 2009
*/
FUNCTION __wxh_StatusBar( oW, id, style, name, fields, widths )
	LOCAL sb

	IF oW == NIL
		oW := containerObj():LastParent()
	ENDIF

	sb := wxStatusBar():New( oW, id, style, name )

	IF widths!=NIL .AND. fields=NIL
		fields := Len( widths )
	ENDIF

	IF fields != NIL
		sb:SetFieldsCount( fields, widths )
	ENDIF

	oW:SetStatusBar( sb )

RETURN sb

/*
 * __wxh_TextCtrl
 * Teo. Mexico 2009
 */
FUNCTION __wxh_TextCtrl( parent, id, pos, size, multiLine, style, name, toolTip )
	LOCAL textCtrl
	LOCAL validator
	LOCAL pickBtn
	
	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	validator := containerObj():LastItem()[ "wxhHBValidator" ]

	IF multiLine == .T.
		IF Empty( style )
			style := wxTE_MULTILINE
		ELSE
			style := _hb_BitOr( wxTE_MULTILINE, style )
		ENDIF
	ENDIF

	//__wxh_TransWidth( NIL, window, Len( wxhHBValidator:AsString ), size )

	/* nextCtrlOnEnter */
	IF nextCtrlOnEnter
		IF style == NIL
			style := wxTE_PROCESS_ENTER
		ELSE
			style := _hb_BitOr( style, wxTE_PROCESS_ENTER )
		ENDIF
	ENDIF

	pickBtn := validator:Field != NIL .AND. !validator:Field:PickList == NIL

	IF pickBtn
		textCtrl := wxSearchCtrl():New( parent, id, NIL, pos, size, style, validator, name )
	ELSE
		textCtrl := wxTextCtrl():New( parent, id, NIL, pos, size, style, validator, name )
	ENDIF

	IF toolTip != NIL
		textCtrl:SetToolTip( toolTip )
	ENDIF

	validator:AddPostInfo()
	
	containerObj():SetLastChild( textCtrl )

RETURN textCtrl

/*
	__wxh_ToolAdd
	Teo. Mexico 2009
*/
PROCEDURE __wxh_ToolAdd( type, toolId, label, bmp1, bmp2, shortHelp, longHelp, clientData, bAction, enabled )
	LOCAL toolBar
	LOCAL tbtb		// toolBarToolBase
	LOCAL bitmap1, bitmap2

	toolBar := containerObj:LastParent()

	IF toolBar != NIL .AND. toolBar:IsDerivedFrom("wxToolBar")

		IF type == "SEPARATOR"

			toolBar:AddSeparator()

		ELSE

			bitmap1 := __wxh_GetBitmapResource( bmp1 )
			bitmap2 := __wxh_GetBitmapResource( bmp2 )
			
			IF type == "CHECK"
				tbtb := toolBar:AddCheckTool( toolId, label, bitmap1, bitmap2, shortHelp, longHelp, clientData )
			ELSEIF type == "RADIO"
				tbtb := toolBar:AddRadioTool( toolId, label, bitmap1, bitmap2, shortHelp, longHelp, clientData )
			ELSEIF type == "BUTTON"
				tbtb := toolBar:AddTool( toolId, label, bitmap1, bitmap2, NIL, shortHelp, longHelp, clientData )
			ENDIF

			IF tbtb != NIL
				IF bAction != NIL
					toolBar:ConnectCommandEvt( toolId, wxEVT_COMMAND_MENU_SELECTED, bAction )
				ENDIF
				__wxh_EnableControl( toolBar, tbtb, toolId, enabled )
			ENDIF

		ENDIF

	ELSE

		wxhAlert( "ToolBar control not in sight..." )

	ENDIF

RETURN

/*
 * __wxh_ToolBarBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_ToolBarBegin( parent, id, toFrame, pos, size, style, name )
	LOCAL toolBar

	IF parent == NIL
		parent := containerObj():LastParent()
	ENDIF

	IF toFrame == .T.
		IF parent:IsDerivedFrom("wxFrame")
			toolBar := parent:CreateToolBar( style, id, name )
		ELSE
			wxhAlert( "Frame not in sight..." )
		ENDIF
	ELSE
		toolBar := wxToolBar():New( parent, id, pos, size, style, name )
	ENDIF

	containerObj():SetLastChild( toolBar )

	containerObj():AddToParentList( toolBar )

RETURN toolBar

/*
	__wxh_ToolBarEnd
	Teo. Mexico 2009
*/
PROCEDURE __wxh_ToolBarEnd()
	LOCAL toolBar

	toolBar := containerObj():LastParent()
	toolBar:Realize()

	containerObj():RemoveLastParent( "wxToolBar" )

RETURN

/*
	__wxh_TransWidth
	Teo. Mexico 2009
*/
STATIC FUNCTION __wxh_TransWidth( width, window, defaultWidth, aSize )
	LOCAL pointSize

	IF window != NIL

		pointSize := window:GetPointSize() - 3

		IF aSize != NIL
			width := aSize[ 1 ]
		ENDIF

		IF width == NIL
			width := -1
		ENDIF

		IF HB_ISCHAR( width )
			width := pointSize * Val( width )
		ELSEIF ( width == NIL .OR. ( HB_ISNUMERIC( width ) .AND. width = -1 ) ) .AND. defaultWidth != NIL
			width := pointSize * defaultWidth
		ENDIF

		IF aSize != NIL
			aSize[ 1 ] := width
		ENDIF

	ENDIF

RETURN width

/*
	__wxh_TreeCtrl
	Teo. Mexico 2009
 */
FUNCTION __wxh_TreeCtrl( window, id, pos, size, style, validator, name )
	LOCAL Result

	IF window == NIL
		window := ContainerObj():LastParent()
	ENDIF

	Result := wxTreeCtrl():New( window, id, pos, size, style, validator, name )

	containerObj():SetLastChild( Result )

RETURN Result

/*
	wxhInspectVar
	Teo. Mexico 2009
*/
PROCEDURE wxhInspectVar( xVar )
	LOCAL oDlg
	LOCAL aMsg
	LOCAL value
	LOCAL cMsg,msgAccs
	LOCAL a,aMethods
	LOCAL oErr

	SWITCH ValType( xVar )
	CASE 'O'
		aMsg := xVar:ClassSel()
		ASort( aMsg,,, {|x,y| PadR( x, 64 ) < PadR( y, 64 ) } )
		a := {}
		aMethods := {}

		FOR EACH cMsg IN aMsg
			msgAccs := SubStr( cMsg, 2 )
			IF cMsg = "_" .AND. AScan( aMsg, msgAccs,,, .T. ) != 0
				BEGIN SEQUENCE WITH {|oErr| break( oErr ) }
					//value := AsString( __wxh_objGetDataValue( xVar, msgAccs ) )
					value := "xVar:msgAccs"
				RECOVER USING oErr
					value := oErr:Description
				END SEQUENCE
				AAdd( a, { msgAccs, value })
			ELSEIF AScan( aMsg, "_" + msgAccs,,, .T. ) = 0
				AAdd( aMethods, msgAccs )
			ENDIF
		NEXT
		a := __objGetValueList( xVar, .T., 0 )
		EXIT
	END

	IF Empty( a )
		wxMessageBox("Cannot inspect value.","wxhInspectVar", wxICON_EXCLAMATION )
		RETURN
	ENDIF

	CREATE DIALOG oDlg ;
				 HEIGHT 800 WIDTH 600 ;
				 TITLE "Inspecting Var: "

	BEGIN BOXSIZER VERTICAL
		@ BROWSE DATASOURCE a ;
			SIZERINFO ALIGN EXPAND STRETCH
		BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
			@ BUTTON ID wxID_CLOSE ACTION oDlg:Close()
		END SIZER
	END SIZER

	SHOW WINDOW oDlg MODAL CENTRE

RETURN

/*
	TContainerObj
	Teo. Mexico 2009
*/
CLASS TContainerObj
PRIVATE:
	DATA FMainContainerStack INIT {}
	METHOD GetParentList INLINE ATail( ::FMainContainerStack )
PROTECTED:
PUBLIC:
	DATA BookCtrls INIT { "wxNotebook", "wxListbook", "wxAuiNotebook" }
	METHOD AddSizerInfoToLastItem( sizerInfo )
	METHOD AddToNextBookPage( hInfo )
	METHOD AddToParentList( parent )
	METHOD AddToSizerList( sizer )
	METHOD CheckForAddPage
	METHOD ClearData
	METHOD GetLastChild
	METHOD GetLastParent( index )
	METHOD LastItem INLINE ATail( ATail( ::FMainContainerStack ) )
	METHOD LastParent
	METHOD LastSizer
	METHOD RemoveLastParent
	METHOD RemoveLastSizer
	METHOD SetLastChild( child )
	METHOD SizerAddOnLastChild
	PROPERTY ParentList READ GetParentList
PUBLISHED:
ENDCLASS

/*
	AddSizerInfoToLastItem
	Teo. Mexico 2009
*/
METHOD PROCEDURE AddSizerInfoToLastItem( sizerInfo ) CLASS TContainerObj

	/* if has not child yet defined then is a parent ctrl */
	IF ATail( ::ParentList )[ "lastChild" ][ "child" ] == NIL
		/* control is in lastChild in the previuos Parent list */
		IF ::GetLastParent( -1 ) != NIL
			::GetLastParent( -1 )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
		ENDIF
	ELSE
		ATail( ::ParentList )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
	ENDIF

RETURN

/*
	AddToNextBookPage
	Teo. Mexico 2009
*/
METHOD PROCEDURE AddToNextBookPage( hInfo ) CLASS TContainerObj
	LOCAL bookCtrl
	LOCAL IsParentBook := .F.

	FOR EACH bookCtrl IN ::BookCtrls
		IF ::LastParent():IsDerivedFrom( bookCtrl )
			IsParentBook := .T.
		ENDIF
	NEXT

	IF !IsParentBook
		wxhAlert( "Previuos page not a " + bookCtrl + " control" )
		RETURN
	ENDIF

	ATail( ::ParentList )[ "pageInfo" ] := hInfo

RETURN

/*
	AddToParentList
	Teo. Mexico 2009
*/
METHOD PROCEDURE AddToParentList( parent ) CLASS TContainerObj
	IF parent:IsDerivedFrom( "wxFrame" ) .OR. ;
		 parent:IsDerivedFrom( "wxDialog" ) .OR. ;
		 ::ParentList == NIL
		AAdd( ::FMainContainerStack, {} )
	ENDIF
	IF parent == NIL
		wxhAlert( "Trying to add a NIL value to the ParentList stack",{"QUIT"})
		::QUIT()
	ENDIF
	
	parent:SetExtraStyle( wxWS_EX_VALIDATE_RECURSIVELY )

	AAdd( ::ParentList, { "parent"=>parent, "sizers"=>{}, "pageInfo"=>NIL, "lastChild"=>{ "child"=>NIL, "processed"=>.F., "sizerInfo"=>NIL, "wxhHBValidator"=>NIL } } )
RETURN

/*
	AddToSizerList
	Teo. Mexico 2009
*/
METHOD PROCEDURE AddToSizerList( sizer ) CLASS TContainerObj
	AAdd( ATail( ::ParentList )[ "sizers" ], sizer )
RETURN

/*
	ClearData
	Teo. Mexico 2009
*/
METHOD PROCEDURE ClearData CLASS TContainerObj
	HB_ADel( ::FMainContainerStack, Len( ::FMainContainerStack ), .T. )
RETURN

/*
	CheckForAddPage
	Teo. Mexico 2009
*/
METHOD PROCEDURE CheckForAddPage( window ) CLASS TContainerObj
	LOCAL hInfo
	LOCAL bookCtrl
	LOCAL IsParentBook := .F.

	FOR EACH bookCtrl IN ::BookCtrls
		IF ::LastParent():IsDerivedFrom( bookCtrl )
			IsParentBook := .T.
		ENDIF
	NEXT

	IF IsParentBook
		hInfo := ATail( ::ParentList )[ "pageInfo" ]
		IF	hInfo != NIL
			::LastParent():AddPage( window, hInfo["title"], hInfo["select"], hInfo["imageId"] )
			ATail( ::ParentList )[ "pageInfo" ] := NIL
		ELSE
			::LastParent():AddPage( window, "Tab" )
		ENDIF
	ENDIF

RETURN

/*
	GetLastChild
	Teo. Mexico 2009
*/
METHOD FUNCTION GetLastChild CLASS TContainerObj
	IF Empty( ::ParentList )
		RETURN NIL
	ENDIF
RETURN ATail( ::ParentList )[ "lastChild" ]

/*
	GetLastParent
	Teo. Mexico 2009
*/
METHOD FUNCTION GetLastParent( index ) CLASS TContainerObj
	IF Empty( index )
		RETURN ATail( ::ParentList )
	ENDIF
	index := Len( ::ParentList ) + index
	IF index < 1 .OR. index > Len( ::ParentList )
		RETURN NIL
	ENDIF
RETURN ::ParentList[ index ]

/*
	LastParent
	Teo. Mexico 2009
*/
METHOD FUNCTION LastParent CLASS TContainerObj
	IF Empty( ::ParentList )
		RETURN NIL
	ENDIF
RETURN ATail( ::ParentList )[ "parent" ]

/*
	LastSizer
	Teo. Mexico 2009
*/
METHOD FUNCTION LastSizer CLASS TContainerObj
	IF Empty( ::ParentList )
		RETURN NIL
	ENDIF
RETURN ATail( ATail( ::ParentList )[ "sizers" ] )

/*
	RemoveLastParent
	Teo. Mexico 2009
*/
METHOD PROCEDURE RemoveLastParent( className ) CLASS TContainerObj

	/* do some checking */
	IF className != NIL
		IF !Upper( ATail( ::ParentList )[ "parent" ]:ClassName ) == Upper( className )
			wxhAlert("Attempt to remove wrong parent on stack (ClassName not equal).;"+Upper( ATail( ::ParentList )[ "parent" ]:ClassName ) + "==" + Upper( className )+";"+"Check for missing/wrong END ... clauses to your controls definition.",{"QUIT"})
			::QUIT()
		ENDIF
	ENDIF

	ASize( ::ParentList, Len( ::ParentList ) - 1 )

	::SizerAddOnLastChild()

RETURN

/*
	RemoveLastSizer
	Teo. Mexico 2009
*/
METHOD PROCEDURE RemoveLastSizer CLASS TContainerObj
	LOCAL a
	a := ATail( ::ParentList )[ "sizers" ]
	IF Empty( a )
		wxhAlert("Attempt to remove a Sizer on a empty sizers stack.",{"QUIT"})
		//::QUIT()
	ENDIF
	::SizerAddOnLastChild()
	ASize( a, Len( a ) - 1 )
RETURN

/*
	SetLastChild
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetLastChild( child ) CLASS TContainerObj
	LOCAL parent

	IF Empty( ::ParentList )
		RETURN
	ENDIF

	IF ::GetLastChild()[ "child" ] == child
		RETURN
	ENDIF

	parent := ::LastParent()

	IF parent != NIL .AND. parent:IsDerivedFrom("wxToolBar")
		parent:AddControl( child )
	ENDIF

	::SizerAddOnLastChild()

	::CheckForAddPage( child )

	::GetLastChild()[ "child" ] := child
	::GetLastChild()[ "processed" ] := .F.

RETURN

/*
	SizerAddOnLastChild
	Teo. Mexico 2009
*/
METHOD PROCEDURE SizerAddOnLastChild CLASS TContainerObj
	LOCAL child
	LOCAL sizerInfo

	IF Empty( ::ParentList )
		RETURN
	ENDIF

	child := ::GetLastChild()[ "child" ]

	IF child != NIL .AND. ! ::GetLastChild()[ "processed" ]

		::GetLastChild()[ "processed" ] := .T. /* avoid infinite recursion */

		sizerInfo := ::GetLastChild()[ "sizerInfo" ]
		::GetLastChild()[ "sizerInfo" ] := NIL

		IF sizerInfo == NIL
			__wxh_SizerInfoAdd( child )
		ELSE
			__wxh_SizerInfoAdd( child, NIL, sizerInfo[ "strech" ], sizerInfo[ "align" ], sizerInfo[ "border" ], sizerInfo[ "sideBorders" ], sizerInfo[ "flag" ] )
		ENDIF

	ENDIF

RETURN

/*
	End Class TContainerObj
*/

/*
	TGlobal class to hold global vars...
	Teo. Mexico 2009
*/
CLASS TGlobal
PRIVATE:
PROTECTED:
PUBLIC:
	DATA g_menuID INIT 1
	DATA g_menuList
	DATA g_menuBar
	DATA g_window

	CONSTRUCTOR New()

	METHOD lenMenuList INLINE Len( ::g_menuList )
PUBLISHED:
ENDCLASS

/*
	New
	Teo. Mexico 2009
*/
METHOD New() CLASS TGlobal
	::g_menuList := {}
RETURN Self

/*
	End Class TGlobal
*/
