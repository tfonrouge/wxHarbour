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
#include "xerror.ch"

#include "wxharbour.ch"

/*
  wxhBrowseTableBase
  Teo. Mexico 2008
*/
CLASS wxhBrowseTableBase FROM wxGridTableBase
PRIVATE:
  DATA FBlockParam
  DATA FBrowse
  DATA FColumnList INIT {}
  DATA FColumnZero
  DATA FCurRowIndex //INIT 0
  DATA FGridBuffer
  DATA FGridBufferSize     INIT 0
  DATA FIgnoreCellEvalError INIT .F.
  METHOD GetCellValue( column )
  METHOD SetBrowse( browse )
  METHOD SetCurRowIndex( rowIndex )
  METHOD SetGridBufferSize( size )
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( browse )

  /* TBrowse compatible methods */
  /* TBrowse compatible methods */

  METHOD FillGridBuffer
  METHOD GetColLabelValue( col )
  METHOD GetGridRowData( row )
  METHOD GetRowLabelValue( row )
  METHOD GetValue( row, col )
  METHOD Initialized INLINE ::FGridBuffer != NIL
  METHOD SetBlockParam( blockParam ) INLINE ::FBlockParam := blockParam
  METHOD SetColumnList( columnList )
  METHOD SetColumnZero( columnZero ) INLINE ::FColumnZero := columnZero
  METHOD SetValue( row, col, value )

  PROPERTY BlockParam READ FBlockParam WRITE SetBlockParam
  PROPERTY Browse READ FBrowse WRITE SetBrowse
  PROPERTY CurRowIndex READ FCurRowIndex WRITE SetCurRowIndex
  PROPERTY ColumnList READ FColumnList WRITE SetColumnList
  PROPERTY GridBuffer READ FGridBuffer

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2009
*/
METHOD New( browse ) CLASS wxhBrowseTableBase
  Super:New()
  ::FBrowse := browse
RETURN Self

/*
  FillGridBuffer
  Teo. Mexico 2008
*/
METHOD PROCEDURE FillGridBuffer CLASS wxhBrowseTableBase
  LOCAL i
  LOCAL n
  LOCAL direction
  LOCAL totalSkipped := 0
  LOCAL topRecord
  LOCAL rowPos

  IF ::FBrowse:SkipBlock == NIL
    RETURN
  ENDIF

  ::FBrowse:SkipBlock:Eval( 0 )

  IF ::FCurRowIndex = NIL .OR. ( ::FBrowse:DataSourceType = "O" .AND. ::FBrowse:DataSource:Eof() )
    ::FBrowse:GoFirstPos()
  ENDIF

  ::FCurRowIndex := 0

  IF ::FGridBufferSize != ::FBrowse:MaxRows()
    ::SetGridBufferSize( ::FBrowse:MaxRows() )
  ENDIF

  IF Empty( ::FGridBuffer )
    RETURN
  ENDIF

  n := ::FBrowse:SkipBlock:Eval( -1 )
  topRecord := n = 0

  IF !topRecord
    ::FBrowse:SkipBlock:Eval( -n )
  ENDIF

  /* Fill in the First row */
  ::GetGridRowData( 1 )

  rowPos := 1

  direction := 1
  i := 2

  WHILE i <= ::FBrowse:MaxRows()
    n := ::FBrowse:SkipBlock:Eval( direction )
    totalSkipped += n
    IF n != direction
      IF direction = 1
        /* check if we are filling from right after GoTop */
        IF topRecord
          ::SetGridBufferSize( i - 1 )
          EXIT
        ENDIF
        /* go to first record */
        ::FBrowse:SkipBlock:Eval( - totalSkipped )
        direction := -1
        LOOP
      ELSE /* we are at an premature bof */
        ::SetGridBufferSize( i - 1 )
        EXIT
      ENDIF
    ENDIF
    IF direction = 1
      n := i
    ELSE
      n := 1
      AIns( ::FGridBuffer, 1 )
      ++rowPos
    ENDIF

    ::GetGridRowData( n )

    i++

  ENDDO

  /* normal fill (top-down) require repos at rowIndex 1 */
  IF direction = 1
    ::FBrowse:SkipBlock:Eval( - totalSkipped )
  ENDIF

  ::FBrowse:RowPos := rowPos /* the very first record from where scan was started */

RETURN

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

  IF ::FIgnoreCellEvalError
    TRY
      Result := column:Block:Eval( ::FBlockParam )
    CATCH
      Result := "<error on block>"
    END
  ELSE
    Result := column:Block:Eval( ::FBlockParam )
  ENDIF

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
  col++
  IF col < 1
    RETURN ""
  ENDIF
RETURN ::FColumnList[ col ]:Heading

/*
  GetGridRowData
  Teo. Mexico 2008
*/
METHOD PROCEDURE GetGridRowData( row ) CLASS wxhBrowseTableBase
  LOCAL itm

  IF ::FGridBuffer[ row ] = NIL
    ::FGridBuffer[ row ] := {=>}
  ENDIF

  /* Column Zero */
  IF ::FColumnZero = NIL
    ::FGridBuffer[ row, 0 ] := LTrim( Str( ::FBrowse:RecNo ) )
  ELSE
    ::FGridBuffer[ row, 0 ] := ::GetCellValue( ::FColumnZero )
  ENDIF

  FOR EACH itm IN ::FColumnList
    ::FGridBuffer[ row, itm:__enumIndex() ] := ::GetCellValue( ::FColumnList[ itm:__enumIndex() ] )
  NEXT

RETURN

 /*
  GetRowLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseTableBase

  ++row

  IF row > Len( ::FGridBuffer )
    RETURN ""
  ENDIF

RETURN ::FGridBuffer[ row, 0 ]

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase

  ++row
  ++col

  IF row > Len( ::FGridBuffer )
    RETURN ""
  ENDIF

RETURN ::FGridBuffer[ row, col ]

/*
  SetBrowse
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetBrowse( browse ) CLASS wxhBrowseTableBase
  IF ::FBrowse == NIL
    ::FBrowse := browse
  ENDIF
RETURN

/*
  SetColumnList
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetColumnList( columnList ) CLASS wxhBrowseTableBase
  ::FColumnList := columnList
  ::DeleteCols( 0, ::GetNumberCols() )
  ::AppendCols( Len( columnList ) )
RETURN

/*
  SetCurRowIndex
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetCurRowIndex( rowIndex ) CLASS wxhBrowseTableBase
  LOCAL n

  IF rowIndex >= ::FBrowse:RowCount
    RETURN
  ENDIF

  n := rowIndex - ::FCurRowIndex

  IF ::FBrowse:SkipBlock:Eval( n ) != n
    ::FCurRowIndex := NIL
    ::FBrowse:SkipBlock:Eval( 0 ) /* forces state at Eof/Bof */
  ELSE
    ::FCurRowIndex := rowIndex
  ENDIF

RETURN

/*
  SetGridBufferSize
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetGridBufferSize( size ) CLASS wxhBrowseTableBase
  IF ::FGridBuffer = NIL
    ::FGridBuffer := Array( size )
  ELSE
    ASize( ::FGridBuffer, size )
  ENDIF
  ::FGridBufferSize := size
  IF ::FBrowse:RowCount != size
    ::FBrowse:RowCount := size
  ENDIF
  ::FBrowse:gridBrowse:ForceRefresh()
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
