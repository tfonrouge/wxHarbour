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

#include "hbclass.ch"
#include "property.ch"

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
	DATA FValType
	DATA FWidth

	METHOD SetAlign( align ) INLINE ::FAlign := align
	METHOD SetAligned( aligned ) INLINE ::FAligned := aligned
	METHOD SetBlock( block ) INLINE ::FBlock := block
	METHOD SetFooting( footing ) INLINE ::FFooting := footing
	METHOD SetHeading( heading ) INLINE ::FHeading := heading
	METHOD SetPicture( picture ) INLINE ::FPicture := picture
	METHOD SetValType( valType ) INLINE ::FValType := valType
	METHOD SetWidth( width ) INLINE ::FWidth := width

PROTECTED:
PUBLIC:

	CONSTRUCTOR New( heading, block )
	
	DATA IsEditable INIT .F.
	
	PROPERTY TField READ FTField

PUBLISHED:
	PROPERTY Align READ FAlign WRITE SetAlign
	PROPERTY Aligned READ FAligned WRITE SetAligned
	PROPERTY Block READ FBlock WRITE SetBlock
	PROPERTY Footing READ FFooting WRITE SetFooting
	PROPERTY Heading READ FHeading WRITE SetHeading
	PROPERTY Picture READ FPicture WRITE SetPicture
	PROPERTY ValType READ FValType WRITE SetValType
	PROPERTY Width READ FWidth WRITE SetWidth
ENDCLASS

/*
	New
	Teo. Mexico 2008
*/
METHOD New( heading, block ) CLASS wxhBColumn

	IF ValType( heading ) = "O"

		::FHeading := heading:Label
		::FBlock := heading:Table:GetDisplayFieldBlock( heading )
		::FTField := heading

	ELSE
	
		IF heading != NIL
			::FHeading := heading
		ENDIF

		::FBlock := block

	ENDIF

RETURN Self

/*
	wxhBColumnNew
	Teo. Mexico 2008
*/
FUNCTION wxhBColumnNew( heading, block )
RETURN wxhBColumn():New( heading, block )

/*
	EndClass wxhBColumn
*/
