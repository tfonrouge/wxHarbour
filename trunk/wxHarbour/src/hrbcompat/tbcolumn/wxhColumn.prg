/*
 * $Id$
 */

/*
	wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

	This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	(C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"

/*
	wxhBrowseColumn
	Teo. Mexico 2008
*/
CLASS wxhBrowseColumn
PRIVATE:

	DATA FAlign
	DATA FAligned INIT .F.
	DATA FBlock
	DATA FBlockField
	DATA FBrowse
	DATA FFooting
	DATA FHeading INIT ""
	DATA FTField
	DATA FPicture
	DATA FReadOnly INIT .F.
	DATA FValType
	DATA FWidth
	
	METHOD GetCanSetValue()
	METHOD SetAlign( align ) INLINE ::FAlign := align
	METHOD SetAligned( aligned ) INLINE ::FAligned := aligned
	METHOD SetBlock( block ) INLINE ::FBlock := block
	METHOD SetBlockField( xField )
	METHOD SetFooting( footing ) INLINE ::FFooting := footing
	METHOD SetHeading( heading )
	METHOD SetPicture( picture ) INLINE ::FPicture := picture
	METHOD SetReadOnly( readOnly ) INLINE ::FReadOnly := readOnly
	METHOD SetTField( tField )
	METHOD SetValType( valType ) INLINE ::FValType := valType
	METHOD SetWidth( width ) INLINE ::FWidth := width

PROTECTED:
PUBLIC:

	CONSTRUCTOR New( browse, heading, block )
	
	DATA colPos INIT 0

	DATA IsEditable INIT .F.
	
	DATA OnSetValue
	
	METHOD GetValue( rowParam, nCol )
	METHOD SetValue( rowParam, value )
	
	PROPERTY BlockField WRITE SetBlockField
	PROPERTY Browse READ FBrowse
	PROPERTY CanSetValue READ GetCanSetValue
	PROPERTY TField READ FTField

PUBLISHED:

	PROPERTY Align READ FAlign WRITE SetAlign
	PROPERTY Aligned READ FAligned WRITE SetAligned
	PROPERTY Block READ FBlock WRITE SetBlock
	PROPERTY Footing READ FFooting WRITE SetFooting
	PROPERTY Heading READ FHeading WRITE SetHeading
	PROPERTY Picture READ FPicture WRITE SetPicture
	PROPERTY ReadOnly READ FReadOnly WRITE SetReadOnly
	PROPERTY ValType READ FValType WRITE SetValType
	PROPERTY Width READ FWidth WRITE SetWidth

ENDCLASS

/*
	New
	Teo. Mexico 2008
*/
METHOD New( browse, heading, block ) CLASS wxhBrowseColumn

	::FBrowse := browse

	IF HB_IsObject( heading )
		::TField := heading
	ELSE
		::FHeading := heading
		::FBlock := block
	ENDIF

RETURN Self

/*
	GetCanSetValue
	Teo. Mexico 2009
*/
METHOD FUNCTION GetCanSetValue() CLASS wxhBrowseColumn
RETURN ! ::ReadOnly

/*
	GetValue
	Teo. Mexico 2010
*/
METHOD FUNCTION GetValue( rowParam, nCol ) CLASS wxhBrowseColumn
	LOCAL result

	IF ::FBlockField != NIL
		IF ::FTField = NIL
			SWITCH ValType( ::FBlockField )
			CASE 'B'
				::SetTField( ::FBlockField:Eval( rowParam:__FObj ) )
				IF ::FTField = NIL
					::FBlock := {|| "<err>" }
					::FBlockField := NIL
				ENDIF
				EXIT
			CASE 'C'
				::SetTField( rowParam:__FObj:FieldByName( ::FBlockField ) )
				::FBlockField := NIL
				IF ::FTField = NIL
					::FBlock := {|| "<err>" }
				ELSE
					::FBlock := ::FTField:Table:GetDisplayFieldBlock( ::FTField )
				ENDIF
				EXIT
			ENDSWITCH
		ENDIF
		IF ::FBlockField != NIL
			IF !rowParam:__FObj:Eof()
				result := ::FBlockField:Eval( rowParam:__FObj ):GetAsVariant()
			ELSE			
				result := ::FBlockField:Eval( rowParam:__FObj ):EmptyValue()
			ENDIF
		ENDIF
	ELSE
		result := ::FBlock:Eval( rowParam )
		IF HB_IsObject( rowParam )
			IF Empty( ::FHeading )
				::Heading := rowParam:__FLastLabel
			ENDIF
		ENDIF
	ENDIF

	IF ::ValType == NIL
		::ValType := ValType( Result )
	ENDIF

	IF !::FAligned
		::FAligned := .T.
		IF ::FAlign == NIL
			SWITCH ::ValType
			CASE 'N'
				::FAlign := wxALIGN_RIGHT
				::FBrowse:SetColFormatNumber( nCol - 1 )
				EXIT
			CASE 'C'
			CASE 'M'
				::FAlign := wxALIGN_LEFT
				EXIT
			CASE 'L'
				::FAlign := wxALIGN_CENTRE
//				 ::GetView():SetColFormatBool( nCol - 1 )
				::FBrowse:SetColumnAlignment( nCol - 1, ::FAlign )
				EXIT
			OTHERWISE
				::FAlign := wxALIGN_CENTRE
			END
		ENDIF
		::FBrowse:SetColumnAlignment( nCol - 1, ::FAlign )
	ENDIF

RETURN result

/*
	SetBlockField
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetBlockField( xField ) CLASS wxhBrowseColumn
	::FBlockField := xField
RETURN

/*
	SetHeading
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetHeading( heading ) CLASS wxhBrowseColumn
	IF ! ::FHeading == heading
		::FHeading := heading
		::browse:SetColLabelValue( ::colPos, heading )
	ENDIF
RETURN

/*
	SetTField
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetTField( tField ) CLASS wxhBrowseColumn
	IF HB_IsObject( tField ) .AND. tField:IsDerivedFrom( "TField" )
		::Heading := tField:Label
		::FPicture := tField:Picture
		::FTField := tField
		::FReadOnly := .F.
	ENDIF
RETURN

/*
	SetValue
	Teo. Mexico 2009
*/
METHOD FUNCTION SetValue( rowParam, value ) CLASS wxhBrowseColumn
	LOCAL state
	LOCAL table

	IF !::ReadOnly
		IF ::TField != NIL
			IF ::TField:Table:LinkedObjField != NIL
				table := ::TField:Table:LinkedObjField:Table
			ELSE
				table := ::TField:Table
			ENDIF
			IF table:Eof()
				RETURN .F.
			ENDIF
			state := table:State
			IF state = dsBrowse
				table:Edit()
			ENDIF
			::TField:AsString := value
			IF state = dsBrowse
				table:Post()
			ENDIF
		ELSE
			::Block:Eval( rowParam, value )
		ENDIF
	ENDIF
	
	IF ::OnSetValue != NIL
		::OnSetValue:Eval()
	ENDIF

RETURN .T.
