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
#include "inkey.ch"
#include "wxharbour.ch"

/*
  wxhBrowse
  Teo. Mexico 2008
*/
CLASS wxhBrowse FROM wxPanel
PRIVATE:
  DATA FIndexPosList INIT {}
  DATA FDataSource
  DATA FDataSourceType
  DATA FRecNo           INIT 1
  DATA gridTableBase
  METHOD Initialize
  METHOD SetDataSource( dataSource )
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( dataSource, window, id, pos, size, style, name )
  METHOD wxNew( window, id, pos, size, style, name )

  /* TBrowse compatible vars */
  DATA GoBottomBlock
  DATA GoTopBlock
  DATA SkipBlock
  METHOD RowCount
  /* TBrowse compatible vars */

  /* TBrowse compatible methods */
  METHOD AddColumn( column )
  METHOD DelColumn( pos )
  METHOD GoBottom
  METHOD GoTop
  /* TBrowse compatible methods */

  METHOD AddAllColumns
  METHOD EventManager

  PROPERTY BlockParam READ gridTableBase:GetBlockParam WRITE gridTableBase:SetBlockParam
  PROPERTY ColumnList READ gridTableBase:GetColumnList WRITE gridTableBase:SetColumnList
  PROPERTY ColumnZero READ gridTableBase:GetColumnZero WRITE gridTableBase:SetColumnZero
  PROPERTY DataSource READ FDataSource WRITE SetDataSource
  PROPERTY RecNo READ FRecNo
  PROPERTY RowIndex READ gridTableBase:RowIndex WRITE gridTableBase:SetRowIndex

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( dataSource, window, id, pos, size, style, name ) CLASS wxhBrowse

  /* TODO: Optimize this many calls: remove this New method, implement it in c++ */
  ::gridTableBase := wxhBrowseTableBase():New()
  ::wxNew( ::gridTableBase, window, id, pos, size, style, name )

  IF dataSource != NIL
    ::SetDataSource( dataSource )
  ENDIF

//   ::Initialize()

  AltD()
  ::GoTop()

RETURN Self

/*
  AddAllColumns
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddAllColumns CLASS wxhBrowse
  LOCAL fld

  DO CASE
  CASE ValType( ::FDataSource ) = "O" .AND. ::FDataSource:IsDerivedFrom( "TTable" )

    FOR EACH fld IN ::FDataSource:FieldList
      wxh_BrowseAddColumn( .F., Self, fld:Label, ::FDataSource:GetDisplayFieldBlock( fld:__enumIndex() ), fld:Picture )//, fld:Size )
    NEXT

//     ::Initialize()

  ENDCASE

RETURN

/*
  AddColumn
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddColumn( column ) CLASS wxhBrowse
  AAdd( ::gridTableBase:ColumnList, column )
  ::gridTableBase:AppendCols( 1 )
RETURN

/*
  DelColumn
  Teo. Mexico 2008
*/
METHOD FUNCTION DelColumn( pos ) CLASS wxhBrowse
  LOCAL column
  LOCAL length := Len( ::gridTableBase:ColumnList )

  IF !Empty( pos ) .AND. pos > 0 .AND. pos <= length .AND. ::gridTableBase:DeleteCols( pos - 1, 1 )
    column := ::gridTableBase:ColumnList[ pos ]
    ADel( ::gridTableBase:ColumnList, pos )
    ASize( ::gridTableBase:ColumnList, length - 1 )
  ENDIF

RETURN column

/*
  EventManager
  Teo. Mexico 2008
*/
METHOD PROCEDURE EventManager( nKey ) CLASS wxhBrowse

  DO CASE
  CASE nKey = K_PGUP

  ENDCASE

RETURN

/*
  GoBottom
  Teo. Mexico 2008
*/
METHOD FUNCTION GoBottom CLASS wxhBrowse
  LOCAL i := 0,j,nTop

  IF Len( ::FIndexPosList ) != ::RowCount
    ASize( ::FIndexPosList, ::RowCount )
  ENDIF

  IF ::RowCount = 0
    RETURN Self
  ENDIF

  SWITCH ::FDataSourceType
  CASE 'C'
    ::GoBottomBlock:Eval()
    IF ::FDataSource:Eof()
      ::SetRowCount( 0 )
      RETURN Self
    ENDIF
    FOR i := ::RowCount TO 1 STEP -1
      ::FIndexPosList[ i ] := ::FDataSource:RecNo
      IF ::SkipBlock:Eval( -1 ) != 1
        EXIT
      ENDIF
    NEXT
    EXIT
  CASE 'A'
    IF Len( ::FDataSource ) = 0
      ::SetRowCount( 0 )
      RETURN Self
    ENDIF
    nTop := ::GoTopBlock:Eval()
    ::GoBottomBlock:Eval()
    j := ::FRecNo
    FOR i := j TO 1 STEP -1
      ::FIndexPosList[ i ] := ::FRecNo
      IF ::FRecNo < nTop .OR. ::SkipBlock:Eval( -1 ) != 1
        EXIT
      ENDIF
    NEXT
    EXIT
  END

  IF i < ::RowCount
    FOR j:=1 TO ::RowCount - i
      ADel( ::FIndexPosList, 1 )
    NEXT
    ::SetRowCount( i )
  ENDIF

RETURN Self

/*
  GoTop
  Teo. Mexico 2008
*/
METHOD FUNCTION GoTop CLASS wxhBrowse
  LOCAL i

  IF Len( ::FIndexPosList ) != ::RowCount
    ASize( ::FIndexPosList, ::RowCount )
  ENDIF

  IF ::RowCount = 0
    RETURN Self
  ENDIF

  ::GoTopBlock:Eval()

  SWITCH ::FDataSourceType
  CASE 'C'
    IF ::FDataSource:Eof()
      ::SetRowCount( 0 )
      RETURN Self
    ELSE
      FOR i:=1 TO ::RowCount
        ::FIndexPosList[ i ] := ::FDataSource:RecNo
        IF ::SkipBlock:Eval( 1 ) != 1
          EXIT
        ENDIF
      NEXT
      IF i < ::RowCount
        ::SetRowCount( i )
      ENDIF
    ENDIF
    EXIT
  CASE 'A'
    IF ::FRecNo = 0
      ::SetRowCount( 0 )
      RETURN Self
    ENDIF
    FOR i:=1 TO ::RowCount
      ::FIndexPosList[ i ] := ::FRecNo
      IF ::SkipBlock:Eval( 1 ) != 1
        EXIT
      ENDIF
    NEXT
  END

  IF i < ::RowCount
    ASize( ::FIndexPosList, i )
    ::SetRowCount( i )
  ENDIF

RETURN Self

/*
  SetDataSource
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetDataSource( dataSource ) CLASS wxhBrowse
  LOCAL table
  LOCAL oldPos

  ::FDataSource := dataSource
  ::FDataSourceType := ValType( dataSource )
  ::ColumnList := {}
  ::ColumnZero := NIL
  ::BlockParam := NIL

  DO CASE
  CASE ::FDataSourceType == "C"        /* path/filename for a database browse */
    table := TTable():New()
    table:TableName := dataSource
    table:Open()
    ::FDataSource := table
    ::BlockParam := table:DisplayFields()
    ::FDataSourceType := "O"

    ::GoTopBlock    := {|| table:First() }
    ::GoBottomBlock := {|| table:Last() }
    ::SkipBlock     := {|n| table:Next( n ) }

    ::RowIndex  := {|n| table:RecNo := ::FIndexPosList[ n ] }

  CASE ::FDataSourceType == "A"        /* Array browse */
    ::FDataSource := dataSource

    ::GoTopBlock    := {|| ::FRecNo := 1 }
    ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
    ::SkipBlock     := {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo - n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

    ::RowIndex := {|n| n }

  CASE ::FDataSourceType == "H"        /* Hash browse */
    ::FDataSource := dataSource
  OTHERWISE
    ::FDataSource := NIL
  ENDCASE

RETURN

/*
  End Class wxhBrowse
*/
