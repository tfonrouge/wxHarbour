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
  DATA FBlockParamType
  DATA FColumnList INIT {}
  DATA FColumnZero
  DATA FCurRowIndex //INIT 0
  DATA FGridBuffer
  DATA FGridBufferSize     INIT 0
  DATA FIgnoreCellEvalError INIT .F.
  METHOD GetBlockParam
  METHOD GetBrowse
  METHOD GetCellValueAtCol( nCol )
  METHOD SetCurRowIndex( rowIndex )
  METHOD SetGridBufferSize( size )
PROTECTED:
PUBLIC:

  METHOD ClearObjData INLINE ::FColumnList := NIL

  /* TBrowse compatible methods */
  /* TBrowse compatible methods */

  METHOD FillGridBuffer
  METHOD GetColLabelValue( col )
  METHOD GetGridRowData( row )
  METHOD GetRowLabelValue( row )
  METHOD GetValue( row, col )
  METHOD Initialized INLINE ::FGridBuffer != NIL
  METHOD SetBlockParam( blockParam )
  METHOD SetColumnList( columnList )
  METHOD SetColumnZero( columnZero ) INLINE ::FColumnZero := columnZero
  METHOD SetValue( row, col, value )

  PROPERTY BlockParam READ GetBlockParam WRITE SetBlockParam
  PROPERTY CurRowIndex READ FCurRowIndex WRITE SetCurRowIndex
  PROPERTY ColumnList READ FColumnList WRITE SetColumnList
  PROPERTY GridBuffer READ FGridBuffer

PUBLISHED:
ENDCLASS

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
  LOCAL browse := ::GetBrowse()

  IF browse:SkipBlock == NIL
    RETURN
  ENDIF

  browse:SkipBlock:Eval( 0 )

  IF ::FCurRowIndex = NIL .OR. ( browse:DataSourceType = "O" .AND. browse:DataSource:Eof() )
    browse:GoFirstPos()
  ENDIF

  ::FCurRowIndex := 0

  n := browse:MaxRows()

  IF browse:DataSourceType $ "AH" .AND. Len( browse:DataSource ) = 0
    n := 0
  ENDIF

  IF ::FGridBufferSize != n
    ::SetGridBufferSize( n )
  ENDIF

  IF Empty( ::FGridBuffer )
    RETURN
  ENDIF

  n := browse:SkipBlock:Eval( -1 )
  topRecord := n = 0

  IF !topRecord
    browse:SkipBlock:Eval( -n )
  ENDIF

  /* Fill in the First row */
  ::GetGridRowData( 1 )

  rowPos := 1

  direction := 1
  i := 2

  WHILE i <= browse:MaxRows()
    n := browse:SkipBlock:Eval( direction )
    totalSkipped += n
    IF n != direction
      IF direction = 1
        /* check if we are filling from right after GoTop */
        IF topRecord
          ::SetGridBufferSize( i - 1 )
          EXIT
        ENDIF
        /* go to first record */
        browse:SkipBlock:Eval( - totalSkipped )
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
    browse:SkipBlock:Eval( - totalSkipped )
  ENDIF

  browse:RowPos := rowPos /* the very first record from where scan was started */

RETURN

/*
  GetBlockParam
  Teo. Mexico 2009
*/
METHOD FUNCTION GetBlockParam CLASS wxhBrowseTableBase

  IF ::FBlockParamType = "B"
    RETURN ::FBlockParam:Eval( ::GetBrowse() )
  ENDIF

RETURN ::FBlockParam

/*
  GetBrowse
  Teo. Mexico 2009
*/
METHOD FUNCTION GetBrowse CLASS wxhBrowseTableBase
RETURN ::GetView():GetParent()

/*
  GetCellValueAtCol
  Teo. Mexico 2008
*/
METHOD FUNCTION GetCellValueAtCol( nCol ) CLASS wxhBrowseTableBase
  LOCAL Result
  LOCAL column
  LOCAL width
  LOCAL picture

  IF nCol = 0
    column := ::FColumnZero
  ELSE
    column := ::FColumnList[ nCol ]
  ENDIF

  picture  := column:Picture
  width    := column:Width

  IF ::FIgnoreCellEvalError
    TRY
      Result := column:Block:Eval( ::BlockParam )
    CATCH
      Result := "<error on block>"
    END
  ELSE
    Result := column:Block:Eval( ::BlockParam )
  ENDIF

  IF column:ValType == NIL
    column:ValType := ValType( Result )
  ENDIF

  IF !column:Aligned
    column:Aligned := .T.
    IF column:Align = NIL
      SWITCH column:ValType
      CASE 'N'
        column:Align := wxALIGN_RIGHT
        ::GetBrowse:grid:SetColFormatNumber( nCol - 1 )
        EXIT
      CASE 'C'
      CASE 'M'
        column:Align := wxALIGN_LEFT
        EXIT
      CASE 'L'
        column:Align := wxALIGN_CENTRE
//         ::GetBrowse:grid:SetColFormatBool( nCol - 1 )
        ::GetBrowse:SetColumnAlignment( nCol, column:Align )
        EXIT
      _SW_OTHERWISE
        column:Align := wxALIGN_CENTRE
      END
    ENDIF
    ::GetBrowse:SetColumnAlignment( nCol, column:Align )
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
  LOCAL browse := ::GetBrowse()

  IF ::FGridBuffer[ row ] = NIL
    ::FGridBuffer[ row ] := {=>}
  ENDIF

  /* Column Zero */
  IF ::FColumnZero = NIL
    ::FGridBuffer[ row, 0 ] := LTrim( Str( browse:RecNo ) )
  ELSE
    ::FGridBuffer[ row, 0 ] := ::GetCellValueAtCol( 0 )
  ENDIF

  FOR EACH itm IN ::FColumnList
    ::FGridBuffer[ row, itm:__enumIndex() ] := ::GetCellValueAtCol( itm:__enumIndex() )
  NEXT

RETURN

/*
  GetRowLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseTableBase
  LOCAL Result := ""
  LOCAL oErr

  IF ::FGridBuffer == NIL .OR. ++row > Len( ::FGridBuffer )
    RETURN Result
  ENDIF

  BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

    Result := ::FGridBuffer[ row, 0 ]

  RECOVER USING oErr

    ? "ERROR GetRowLabelValue: " + oErr:Description

    Result := "ERR:" + NTrim( row )

  END SEQUENCE

RETURN Result

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase
  LOCAL Result := ""
  ++row
  ++col

  IF ::FGridBuffer == NIL .OR. row > Len( ::FGridBuffer )
    RETURN Result
  ENDIF

  BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }
    Result := ::FGridBuffer[ row, col ]
  RECOVER
    Result := ""
  END SEQUENCE

RETURN Result

/*
  SetBlockParam
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetBlockParam( blockParam ) CLASS wxhBrowseTableBase

  ::FBlockParam := blockParam
  ::FBlockParamType := ValType( blockParam )

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
  LOCAL browse := ::GetBrowse()

  IF rowIndex >= browse:RowCount .OR. ::FCurRowIndex = NIL
    RETURN
  ENDIF

  n := rowIndex - ::FCurRowIndex

  IF browse:SkipBlock:Eval( n ) != n
    ::FCurRowIndex := NIL
    browse:SkipBlock:Eval( 0 ) /* forces state at Eof/Bof */
  ELSE
    ::FCurRowIndex := rowIndex
  ENDIF

RETURN

/*
  SetGridBufferSize
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetGridBufferSize( size ) CLASS wxhBrowseTableBase
  LOCAL browse := ::GetBrowse()

  IF ::FGridBuffer = NIL
    ::FGridBuffer := Array( size )
  ELSE
    ASize( ::FGridBuffer, size )
  ENDIF
  ::FGridBufferSize := size
  IF browse:RowCount != size
    browse:RowCount := size
  ENDIF
  browse:grid:ForceRefresh()
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
