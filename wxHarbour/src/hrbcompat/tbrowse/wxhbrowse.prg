/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
 * wxh_BrowseDb
 * Teo. Mexico 2008
 */
FUNCTION wxh_BrowseDb( table, window, id, pos, size, style, name )
  LOCAL Result

  IF window = NIL
    window := wxh_LastTopLevelWindow()
  ENDIF

  Result := wxBrowseDb():New( table, window, id, pos, size, style, name )

RETURN Result

/*
  wxh_Column
  Teo. Mexico 2008
*/
PROCEDURE wxh_Column( zero, wxBrw, title, block, picture, width )
  LOCAL hColumn := HB_HSetCaseMatch( {=>}, .F. )

  hColumn["title"]   := title
  hColumn["block"]   := block
  hColumn["picture"] := picture
  hColumn["width"]   := width

  IF zero
    wxBrw:GetTable():ColumnZero := hColumn
  ELSE
    wxBrw:GetTable():AddColumn( hColumn )
  ENDIF

RETURN

/*
  wxBrowseDb
  Teo. Mexico 2008
*/
CLASS wxBrowseDb FROM wxGrid
PRIVATE:
PROTECTED:
PUBLIC:

  METHOD New( table, window, id, pos, size, style, name )

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( table, window, id, pos, size, style, name ) CLASS wxBrowseDb

  Super:New( window, id, pos, size, style, name )

  ::SetTable( wxBrowseDbProvider():New( table ), .F. )

RETURN Self

/*
  End Class wxBrowseDb
*/

/*
  wxBrowseDbProvider
  Teo. Mexico 2008
*/
CLASS wxBrowseDbProvider FROM wxGridTableBase
PRIVATE:
  DATA FTable
  METHOD GetResult( hColumn )
  METHOD SetTable( table )
PROTECTED:
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
METHOD New( table ) CLASS wxBrowseDbProvider

  Super:New()

  ::SetTable( table )

RETURN Self

/*
  AddColumn
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddColumn( hColumn ) CLASS wxBrowseDbProvider
  AAdd( ::ColumnList, hColumn )
  ::ColCount := Len( ::ColumnList )
  ::AppendCols()
RETURN

/*
  GetColLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetColLabelValue( col ) CLASS wxBrowseDbProvider
  IF col < 0
    RETURN ""
  ENDIF
RETURN ::ColumnList[ col + 1, "title" ]

/*
  GetResult
  Teo. Mexico 2008
*/
METHOD FUNCTION GetResult( hColumn ) CLASS wxBrowseDbProvider
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
  OTHERWISE
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
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxBrowseDbProvider
  IF Empty( ::ColumnZero )
    RETURN LTrim( Str( row + 1 ) )
  ENDIF
  ::FTable:RecNo := row + 1
RETURN ::GetResult( ::ColumnZero )

/*
  GetNumberCols
  Teo. Mexico 2008
*/
METHOD FUNCTION GetNumberCols CLASS wxBrowseDbProvider
RETURN ::ColCount

/*
  GetNumberRows
  Teo. Mexico 2008
*/
METHOD FUNCTION GetNumberRows CLASS wxBrowseDbProvider
RETURN ::RowCount

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxBrowseDbProvider

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
METHOD PROCEDURE SetTable( table ) CLASS wxBrowseDbProvider
  ::FTable := table
  ::ColCount := 0
  ::RowCount := 5
  ::ColumnList := {}
  ::ColumnZero := NIL
RETURN

/*
  SetValue
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value ) CLASS wxBrowseDbProvider

  ? "Changing:","Row:", row, "Col:", col, "Value:",value

RETURN

/*
  End Class wxBrowseDbProvider
*/
