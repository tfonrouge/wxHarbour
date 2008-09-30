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
  wxhBrowseDb
  Teo. Mexico 2008
*/
CLASS wxhBrowseDb FROM wxGrid
PRIVATE:
PROTECTED:
PUBLIC:

  METHOD New( table, window, id, pos, size, style, name )

  METHOD AddAllColumns

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( table, window, id, pos, size, style, name ) CLASS wxhBrowseDb

  Super:New( window, id, pos, size, style, name )

  ::SetTable( wxhBrowseDbProvider():New( table ), .F. )

RETURN Self

/*
  AddAllColumns
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddAllColumns CLASS wxhBrowseDb
  LOCAL table
  LOCAL fld

  table := ::GetTable():Table

  FOR EACH fld IN table:FieldList
    wxh_BrowseDbAddColumn( .F., Self, fld:Label, table:GetDisplayFieldBlock( fld:__enumIndex() ), fld:Picture )//, fld:Size )
  NEXT

RETURN

/*
  End Class wxhBrowseDb
*/

/*
  wxhBrowseDbProvider
  Teo. Mexico 2008
*/
CLASS wxhBrowseDbProvider FROM wxGridTableBase
PRIVATE:
  DATA FTable
  METHOD GetResult( hColumn )
  METHOD SetTable( table )
PROTECTED:
  METHOD BuildTableFromAlias( tableName )
PUBLIC:

  DATA ColCount INIT 0
  DATA ColumnList INIT {}
  DATA ColumnZero
  DATA RowCount INIT 5

  METHOD New( table )

  METHOD AddColumn( hColumn )

  METHOD GetColLabelValue( col )
  METHOD GetRowLabelValue( row )

  METHOD GetNumberCols
  METHOD GetNumberRows
  METHOD GetValue( row, col )
  METHOD SetValue( row, col, value )

PUBLISHED:

  PROPERTY Table READ FTable WRITE SetTable

ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( table ) CLASS wxhBrowseDbProvider

  Super:New()

  ::SetTable( table )

RETURN Self

/*
  AddColumn
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddColumn( hColumn ) CLASS wxhBrowseDbProvider
  AAdd( ::ColumnList, hColumn )
  ::ColCount := Len( ::ColumnList )
  ::AppendCols()
RETURN

/*
  BuildTableFromAlias
  Teo. Mexico 2008
*/
METHOD FUNCTION BuildTableFromAlias( tableName ) CLASS wxhBrowseDbProvider
  LOCAL table

  table := TTable():New()
  table:TableName := tableName
  table:Open()

RETURN table

/*
  GetColLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetColLabelValue( col ) CLASS wxhBrowseDbProvider
  IF col < 0
    RETURN ""
  ENDIF
RETURN ::ColumnList[ col + 1, "title" ]

/*
  GetResult
  Teo. Mexico 2008
*/
METHOD FUNCTION GetResult( hColumn ) CLASS wxhBrowseDbProvider
  LOCAL Result
  LOCAL width
  LOCAL picture

  picture  := hColumn[ "picture" ]
  width    := hColumn[ "width" ]

  Result := hColumn[ "block" ]:Eval( ::FTable:DisplayFields() )

  IF picture != NIL
    Result := Transform( Result, picture )
  ENDIF

  SWITCH ValType( Result )
  CASE 'N'
    Result := Str( Result )
    EXIT
  CASE 'D'
    Result := FDateS( Result )
    EXIT
  CASE 'L'
    Result := iif( Result, "True", "False" )
    EXIT
  CASE 'C'
  CASE 'M'
    EXIT
  #ifdef __XHARBOUR__
  DEFAULT
  #else
  OTHERWISE
  #endif
    Result := "<unknown type '" + ValType( Result ) + "'>"
  END

  IF width != NIL
    Result := Left( Result, width )
  ENDIF

RETURN Result

/*
  GetRowLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseDbProvider
  IF Empty( ::ColumnZero )
    RETURN LTrim( Str( row + 1 ) )
  ENDIF
  ::FTable:RecNo := row + 1
RETURN ::GetResult( ::ColumnZero )

/*
  GetNumberCols
  Teo. Mexico 2008
*/
METHOD FUNCTION GetNumberCols CLASS wxhBrowseDbProvider
RETURN ::ColCount

/*
  GetNumberRows
  Teo. Mexico 2008
*/
METHOD FUNCTION GetNumberRows CLASS wxhBrowseDbProvider
RETURN ::RowCount

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseDbProvider

  IF col >= ::ColCount
    RETURN "<error>" /* raise error ? */
  ENDIF

  ::FTable:RecNo := row + 1

  IF ::FTable:Eof()
    RETURN ""
  ENDIF

RETURN ::GetResult( ::ColumnList[ col + 1 ] )

/*
  SetTable
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetTable( table ) CLASS wxhBrowseDbProvider
  IF ValType( table ) = "C"
    table := ::BuildTableFromAlias( table )
  ENDIF
  ::FTable := table
  ::ColCount := 0
  ::RowCount := table:Alias:RecCount()
  ::ColumnList := {}
  ::ColumnZero := NIL
RETURN

/*
  SetValue
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value ) CLASS wxhBrowseDbProvider

  ? "Changing:","Row:", row, "Col:", col, "Value:",value

RETURN

/*
  End Class wxhBrowseDbProvider
*/
