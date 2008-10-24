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
  DATA FCurRow
  DATA FIgnoreCellEvalError INIT .F.
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
  METHOD SetValue( row, col, value )

  PROPERTY BlockParam READ FBlockParam WRITE SetBlockParam
  PROPERTY Browse READ FBrowse
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
  GetRowLabelValue
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseTableBase

  IF !::FBrowse:SelectRowIndex( row )
    RETURN ""
  ENDIF

  IF ::FColumnZero = NIL
    RETURN LTrim( Str( ::FBrowse:RecNo ) )
  ENDIF

RETURN ::GetCellValue( ::FColumnZero )

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase

  col++

  IF !::FBrowse:SelectRowIndex( row )
    RETURN ""
  ENDIF

RETURN ::GetCellValue( ::FColumnList[ col ] )

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
