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
	wxhBColumn
	Teo. Mexico 2008
*/
CLASS wxhBColumn
PRIVATE:

	DATA FAlign
	DATA FAligned INIT .F.
	DATA FBlock
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
	METHOD SetFooting( footing ) INLINE ::FFooting := footing
	METHOD SetHeading( heading ) INLINE ::FHeading := heading
	METHOD SetPicture( picture ) INLINE ::FPicture := picture
	METHOD SetReadOnly( readOnly ) INLINE ::FReadOnly := readOnly
	METHOD SetTField( tField )
	METHOD SetValType( valType ) INLINE ::FValType := valType
	METHOD SetWidth( width ) INLINE ::FWidth := width

PROTECTED:
PUBLIC:

	CONSTRUCTOR New( heading, block )
	
	DATA IsEditable INIT .F.
	
	DATA OnSetValue
	
	METHOD GetValue( rowParam )
	METHOD SetValue( rowParam, value )
	
	PROPERTY CanSetValue READ GetCanSetValue
	PROPERTY TField READ FTField WRITE SetTField

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
METHOD New( heading, block ) CLASS wxhBColumn

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
METHOD FUNCTION GetCanSetValue() CLASS wxhBColumn
RETURN ! ::ReadOnly

/*
	GetValue
	Teo. Mexico 2010
*/
METHOD FUNCTION GetValue( rowParam ) CLASS wxhBColumn
	IF ::FTField != NIL
		RETURN ::FTField:GetAsVariant()
	ENDIF
RETURN ::FBlock:Eval( rowParam )

/*
	SetTField
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetTField( tField ) CLASS wxhBColumn
	IF HB_IsObject( tField ) .AND. tField:IsDerivedFrom( "TField" )
		::FHeading := tField:Label
		::FPicture := tField:Picture
		::FTField := tField
		::FReadOnly := .F.
	ENDIF
RETURN

/*
	SetValue
	Teo. Mexico 2009
*/
METHOD FUNCTION SetValue( rowParam, value ) CLASS wxhBColumn
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

/*
	wxhBColumnNew
	Teo. Mexico 2008
*/
FUNCTION wxhBColumnNew( heading, block )
RETURN wxhBColumn():New( heading, block )

/*
	EndClass wxhBColumn
*/
