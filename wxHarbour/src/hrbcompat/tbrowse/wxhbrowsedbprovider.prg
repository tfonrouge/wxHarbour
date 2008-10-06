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
  DATA FBlockParam
  DATA FBrowse
  DATA FColumnList INIT {}
  DATA FColumnZero
  DATA FRowIndex
  METHOD GetCellValue( column )
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( browse )

  /* TBrowse compatible methods */
  /* TBrowse compatible methods */

  METHOD GetColLabelValue( col )
  METHOD GetRowLabelValue( row )
  METHOD GetValue( row, col )
  METHOD SetBlockParam( blockParam ) INLINE ::FBlockParam := blockParam
  METHOD SetColumnList( columnList )
  METHOD SetColumnZero( columnZero ) INLINE ::FColumnZero := columnZero
  METHOD SetRowIndex( rowIndex ) INLINE ::FRowIndex := rowIndex
  METHOD SetValue( row, col, value )

  PROPERTY BlockParam READ FBlockParam WRITE SetBlockParam
  PROPERTY ColumnList READ FColumnList WRITE SetColumnList
  PROPERTY DataSource READ FDataSource WRITE SetDataSource

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( browse ) CLASS wxhBrowseTableBase
  Super:New()
  ::FBrowse := browse
RETURN Self

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
  IF Empty( ::FColumnZero )
    RETURN LTrim( Str( row + 1 ) )
  ENDIF
  IF ::FBrowse:FRowListSize < row
    ::FBrowse:GoTop()
    RETURN ""
  ENDIF
  ::FRowIndex:Eval( row + 1 )
RETURN ::GetCellValue( ::FColumnZero )

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase

  row++

  IF col >= ::GetNumberCols()
    RETURN "<error>" /* raise error ? */
  ENDIF

  IF ::FBrowse:FRowListSize < row
    ::FBrowse:GoTop()
    RETURN ""
  ENDIF

  ::FRowIndex:Eval( row )

RETURN ::GetCellValue( ::FColumnList[ col + 1 ] )

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
  SetValue
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value ) CLASS wxhBrowseTableBase

  ? "Changing:","Row:", row, "Col:", col, "Value:",value

RETURN

/*
  End Class wxhBrowseTableBase
*/
