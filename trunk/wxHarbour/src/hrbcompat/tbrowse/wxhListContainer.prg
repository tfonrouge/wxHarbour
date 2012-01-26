/*
 * $Id: wxhBrowse.prg 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"

CLASS TListContainer
PRIVATE:
PROTECTED:

    DATA FItmKey
    DATA FItmValue
    DATA FList
    DATA FListType
    DATA FMasterSource
    DATA FReadOnly INIT .F.
    DATA FRecNo INIT 0
    DATA FState INIT dsBrowse

    METHOD SetReadOnly( readOnly ) INLINE ::FReadOnly := readOnly
    METHOD SetRecNo( recNo ) INLINE ::FRecNo := recNo

PUBLIC:

    DATA oldReadOnlyState

    CONSTRUCTOR New( list )

    METHOD Bof() INLINE Len( ::FList ) = 0
    METHOD DbGoBottom()
    METHOD DbGoTop()
    METHOD Edit()
    METHOD Eof() INLINE Len( ::FList ) = 0
    METHOD Insert()
    METHOD Post()
    METHOD SkipBrowse( n )
    METHOD Validate() INLINE .T.

    PROPERTY List READ FList
    PROPERTY ListType READ FListType
    PROPERTY MasterSource READ FMasterSource
    PROPERTY ReadOnly READ FReadOnly WRITE SetReadOnly
    PROPERTY RecNo READ FRecNo WRITE SetRecNo
    PROPERTY State READ FState
    
    METHOD __OpIndex( index, value ) OPERATOR "[]"
    
ENDCLASS

/*
    New
    Teo. Mexico 2012
*/
METHOD New( list ) CLASS TListContainer
    LOCAL vt := ValType( list )
    SWITCH vt
    CASE "A"
    CASE "H"
        ::FListType := vt
        ::FList := list
        EXIT
    OTHERWISE
        ::FList := NIL
        ::FListType := NIL
    ENDSWITCH

RETURN Self

/*
    __OpIndex
    Teo. Mexico 2012
*/
METHOD FUNCTION __OpIndex( index, value ) CLASS TListContainer
    IF PCount() > 1
        ::FList[ index ] := value
    ENDIF
RETURN ::FList[ index ]

/*
    DbGoBottom
    Teo. Mexico 2012
*/
METHOD FUNCTION DbGoBottom() CLASS TListContainer
RETURN ::FRecNo := Len( ::FList )

/*
    DbGoTop
    Teo. Mexico 2012
*/
METHOD FUNCTION DbGoTop() CLASS TListContainer
RETURN ::FRecNo := 1

/*
    Edit
    Teo. Mexico 2012
*/
METHOD FUNCTION Edit() CLASS TListContainer
    ::FState := dsEdit
RETURN .T.

/*
    Insert
    Teo. Mexico 2012
*/
METHOD FUNCTION Insert() CLASS TListContainer
    ::FState := dsInsert
RETURN .T.

/*
    Post
    Teo. Mexico 2012
*/
METHOD FUNCTION Post() CLASS TListContainer
    IF ::FState $ { dsInsert, dsEdit }
        ::FState := dsBrowse
        RETURN .T.
    ENDIF
RETURN .F.

/*
    SkipBrowse
    Teo. Mexico 2012
*/
METHOD FUNCTION SkipBrowse( n ) CLASS TListContainer
    LOCAL oldPos
    
    oldPos := ::FRecNo

    ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( ::FList ), ::FRecNo + n ) )

RETURN  ::FRecNo - oldPos
