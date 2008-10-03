/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#ifdef __XHARBOUR__
#include "wx_hbcompat.ch"
#endif

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

/*
  wxhBrowseTableBase
  Teo. Mexico 2008
*/
CLASS wxhBrowseTableBase FROM wxGridTableBase
PRIVATE:
  DATA FIndex
PROTECTED:
  DATA FBlockParam
  DATA FColumnList INIT {}
  DATA FDataSource
  DATA FDataSourceType
  METHOD GetCellValue( column )
  METHOD SetDataSource( dataSource )
  METHOD SetIndex( index )
PUBLIC:

  /* TBrowse compatible vars */
  DATA GoBottomBlock
  DATA GoTopBlock
  DATA SkipBlock
  /* TBrowse compatible vars */

  DATA ColumnZero

  CONSTRUCTOR New( dataSource )

  /* TBrowse compatible methods */
  METHOD AddColumn( column )
  METHOD DelColumn( pos )
  /* TBrowse compatible methods */

  METHOD GetColLabelValue( col )
  METHOD GetRowLabelValue( row )
  METHOD GetValue( row, col )
  METHOD SetValue( row, col, value )

  PROPERTY ColumnList READ FColumnList
  PROPERTY DataSource READ FDataSource WRITE SetDataSource
  PROPERTY Index READ FIndex WRITE SetIndex

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( dataSource ) CLASS wxhBrowseTableBase

  Super:New()

  ::SetDataSource( dataSource )

RETURN Self

/*
  AddColumn
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddColumn( column ) CLASS wxhBrowseTableBase
  AAdd( ::FColumnList, column )
  ::AppendCols( 1 )
RETURN

/*
  DelColumn
  Teo. Mexico 2008
*/
METHOD FUNCTION DelColumn( pos ) CLASS wxhBrowseTableBase
  LOCAL column
  LOCAL length := Len( ::FColumnList )

  IF !Empty( pos ) .AND. pos > 0 .AND. pos <= length .AND. ::DeleteCols( pos - 1, 1 )
    column := ::FColumnList[ pos ]
    ADel( ::FColumnList, pos )
    ASize( ::FColumnList, length - 1 )
  ENDIF

RETURN column

/*
  GetCellValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetCellValue( column ) CLASS wxhBrowseTableBase
  LOCAL Result
  LOCAL width
  LOCAL picture

  picture  := column:Picture
  width    := column:Width

  Result := column:Block:Eval( ::FBlockParam )

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
  GetColLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetColLabelValue( col ) CLASS wxhBrowseTableBase
  IF col < 0
    RETURN ""
  ENDIF
RETURN ::FColumnList[ col + 1 ]:Heading

/*
  GetRowLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseTableBase
  IF Empty( ::ColumnZero )
    RETURN LTrim( Str( row + 1 ) )
  ENDIF
  ::index := row + 1
RETURN ::GetCellValue( ::ColumnZero )

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase

  IF col >= ::GetNumberCols()
    RETURN "<error>" /* raise error ? */
  ENDIF

  ::index := row + 1

RETURN ::GetCellValue( ::FColumnList[ col + 1 ] )

/*
  SetDataSource
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetDataSource( dataSource ) CLASS wxhBrowseTableBase
  LOCAL vt := ValType( dataSource )
  LOCAL table
  LOCAL oldPos

  ::FColumnList := {}
  ::DeleteRows( 0, ::GetNumberRows() )
  ::DeleteCols( 0, ::GetNumberCols() )
  ::ColumnZero  := NIL
  ::FBlockParam := NIL
  ::FDataSourceType := NIL

  DO CASE
  CASE vt == "C"        /* path/filename for a database browse */
    table := TTable():New()
    table:TableName := dataSource
    table:Open()
    ::FDataSource := table
    ::FBlockParam := table:DisplayFields()
    ::FDataSourceType := "O"

    ::GoTopBlock    := {|| table:First() }
    ::GoBottomBlock := {|| table:Last() }
    ::SkipBlock     := {|n| table:Next( n ) }

  CASE vt == "A"        /* Array browse */
    ::FDataSource := dataSource

    ::GoTopBlock    := {|| ::Index := 1 }
    ::GoBottomBlock := {|| ::Index := Len( dataSource ) }
    ::SkipBlock     := {|n| oldPos := n, ::Index := iif( n < 0, Max( 1, ::Index - n ), Min( Len( dataSource ), ::Index + n ) ), ::Index - oldPos }
  CASE vt == "H"        /* Hash browse */
    ::FDataSource := dataSource
  OTHERWISE
    ::FDataSource := NIL
  ENDCASE

RETURN

/*
  SetIndex
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetIndex( index ) CLASS wxhBrowseTableBase
  ::FIndex := index

  DO CASE
  CASE ::FDataSourceType = "O"
    ::FDataSource:RecNo := index
  ENDCASE

RETURN

/*
  SetValue
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value ) CLASS wxhBrowseTableBase

  ? "Changing:","Row:", row, "Col:", col, "Value:",value

RETURN

/*
  End Class wxhBrowseTableBase
*/
