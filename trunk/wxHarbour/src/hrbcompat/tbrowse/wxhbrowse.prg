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

#define WXHBROWSE_FILL_FROM_TOP         1

/*
  wxhBrowse
  Teo. Mexico 2008
*/
CLASS wxhBrowse FROM wxPanel
PRIVATE:
  DATA FDataSource
  DATA FDataSourceType
  DATA FRecNo           INIT -1
  DATA FRefreshAll      INIT .T.
  DATA FRowIndexGetValue
  DATA FRowIndexSetValue
  DATA FRowList
  DATA FRowListSize     INIT 0
  DATA FTmpRowPos
  DATA gridTableBase
  METHOD FillRowList( index ) EXPORTED
  METHOD GetColCount INLINE Len( ::gridTableBase:ColumnList )
  METHOD GetColPos
  METHOD GetRowCount
  METHOD GetRowListSize
  METHOD GetRowPos
  METHOD SetColPos( colPos )
  METHOD SetDataSource( dataSource )
  METHOD SetRowCount( rowCount )
  METHOD SetRowListSize( size )
  METHOD SetRowPos( rowPos )
PROTECTED:
PUBLIC:


  CONSTRUCTOR New( dataSource, window, id, pos, size, style, name )
  METHOD wxNew( window, id, pos, size, style, name )

  /* Begin TBrowse compatible */
  /* TBrowse compatible vars */
  DATA cargo
  DATA GoBottomBlock
  DATA GoTopBlock
  DATA SkipBlock

  PROPERTY ColCount READ GetColCount
  PROPERTY RowCount READ GetRowCount
  PROPERTY ColPos READ GetColPos WRITE SetColPos
  PROPERTY RowPos READ GetRowPos WRITE SetRowPos

  /* TBrowse compatible methods */
  METHOD AddColumn( column )
  METHOD DelColumn( pos )
  METHOD Down
  METHOD GoBottom
  METHOD GoTop
  METHOD PageDown
  METHOD PageUp
  METHOD RefreshAll
  METHOD Up
  /* End TBrowse compatible */

  DATA BottomFirst INIT .F.

  METHOD AddAllColumns
  METHOD EventManager
  METHOD SetRowIndex( rowIndex )
  METHOD Initialized INLINE ::FRowList != NIL

  PROPERTY BlockParam READ gridTableBase:GetBlockParam WRITE gridTableBase:SetBlockParam
  PROPERTY ColumnList READ gridTableBase:GetColumnList WRITE gridTableBase:SetColumnList
  PROPERTY ColumnZero READ gridTableBase:GetColumnZero WRITE gridTableBase:SetColumnZero
  PROPERTY DataSource READ FDataSource WRITE SetDataSource
  PROPERTY RecNo READ FRecNo
  PROPERTY RowList READ FRowList
  PROPERTY RowListSize READ GetRowListSize WRITE SetRowListSize

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( dataSource, window, id, pos, size, style, name ) CLASS wxhBrowse

  /* TODO: Optimize this many calls: remove this New method, implement it in c++ */
  ::gridTableBase := wxhBrowseTableBase():New( Self )
  ::wxNew( ::gridTableBase, window, id, pos, size, style, name )

  IF dataSource != NIL
    ::SetDataSource( dataSource )
  ENDIF

RETURN Self

/*
  AddAllColumns
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddAllColumns CLASS wxhBrowse
  LOCAL fld

  DO CASE
  CASE ValType( ::FDataSource ) = "O" .AND. ::FDataSource:IsDerivedFrom( "TTable" )

    wxh_BrowseAddColumn( .T., Self, "RecNo", {|| ::FDataSource:RecNo }, "9999999" )//, fld:Size )

    FOR EACH fld IN ::FDataSource:FieldList
      wxh_BrowseAddColumn( .F., Self, fld:Label, ::FDataSource:GetDisplayFieldBlock( fld:__enumIndex() ), fld:Picture )//, fld:Size )
    NEXT

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
  LOCAL length := ::ColCount

  IF !Empty( pos ) .AND. pos > 0 .AND. pos <= length .AND. ::gridTableBase:DeleteCols( pos - 1, 1 )
    column := ::gridTableBase:ColumnList[ pos ]
    ADel( ::gridTableBase:ColumnList, pos )
    ASize( ::gridTableBase:ColumnList, length - 1 )
  ENDIF

RETURN column

/*
  Down
  Teo. Mexico 2008
*/
METHOD FUNCTION Down CLASS wxhBrowse
  LOCAL n

  IF ::RowPos < ::RowCount
    ::RowPos += 1
  ELSE
    n := ::SkipBlock:Eval( ::RowCount )
    IF n != ::RowCount
      ::SkipBlock:Eval( - n )
    ELSE
      ::SkipBlock:Eval( - ( ::RowCount - 1 ) )
    ENDIF
    ::RefreshAll()
  ENDIF

RETURN Self

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
  FillRowList
  Teo. Mexico 2008
*/
METHOD PROCEDURE FillRowList CLASS wxhBrowse
  LOCAL i
  LOCAL n
  LOCAL direction
  LOCAL totalSkipped := 0
  LOCAL topRecord

  ::FTmpRowPos := ::RowPos

  IF ::FRowListSize != ::RowCount
    ::SetRowListSize( ::RowCount )
  ENDIF

  IF Empty( ::FRowList )
    ::SetRowListSize( 1 ) /* allow to give a try on next call on FillRowList */
    RETURN
  ENDIF

  /* search first top row reference */
  IF ::FRowList[ 1 ] = NIL

    IF ::BottomFirst
      ::GoBottom()
    ELSE
      ::GoTop()
    ENDIF

    IF ::FRowIndexGetValue = NIL
      ::FRowList[ 1 ] := ::FRecNo
    ELSE
      ::FRowList[ 1 ] := ::FRowIndexGetValue:Eval()
    ENDIF

  ENDIF

  ::FRowIndexSetValue:Eval( 1 )
  n := ::SkipBlock:Eval( -1 )
  topRecord := n = 0
  ::SkipBlock:Eval( n )

  direction := 1
  i := 2

  WHILE i <= ::RowCount
    n := ::SkipBlock:Eval( direction )
    totalSkipped += n
    IF n != direction
      IF direction = 1
        /* check if we are filling from right after GoTop */
        IF topRecord
          ::SetRowListSize( i - 1 )
          EXIT
        ENDIF
        direction := -1
        ::FRowIndexSetValue:Eval( i - 1 ) /* */
        LOOP
      ELSE /* we are at an premature bof */
        ::SetRowListSize( i - 1 )
        EXIT
      ENDIF
    ENDIF
    IF direction = 1
      n := i
    ELSE
      n := 1
      AIns( ::FRowList, 1 )
    ENDIF
    IF ::FRowIndexGetValue = NIL
      ::FRowList[ n ] := ::FRecNo
    ELSE
      ::FRowList[ n ] := ::FRowIndexGetValue:Eval()
    ENDIF
    i++
  ENDDO

  /* normal fill (top-down) requiere repos at rowIndex 1 */
  IF direction = 1
    ::SkipBlock:Eval( - totalSkipped )
  ENDIF

  IF ::FTmpRowPos > ::RowCount
    ::RowPos := ::RowCount
  ELSE
    ::RowPos := ::FTmpRowPos
  ENDIF

RETURN

/*
  GetRowListSize
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRowListSize CLASS wxhBrowse
  IF ::FRowListSize = 0 //.OR. !::FRowListSize != ::RowCount
    ::GoBottom()
  ENDIF
RETURN ::FRowListSize

/*
  GoBottom
  Teo. Mexico 2008
*/
METHOD FUNCTION GoBottom CLASS wxhBrowse

  ::FRecNo := ::GoBottomBlock:Eval()
  ::FTmpRowPos := ::RowCount
  ::RowPos := ::RowCount

  /* we move to the first record-at-row 1 */
  ::SkipBlock:Eval( - ( ::RowCount - 1 ) )

  ::RefreshAll()

RETURN Self

/*
  GoTop
  Teo. Mexico 2008
*/
METHOD FUNCTION GoTop CLASS wxhBrowse
  ::FRecNo := ::GoTopBlock:Eval()
  ::FTmpRowPos := 1
  ::RowPos := 1

  ::RefreshAll()

RETURN Self

/*
  PageDown
  Teo. Mexico 2008
*/
METHOD FUNCTION PageDown CLASS wxhBrowse
  LOCAL n

  n := ::SkipBlock:Eval( ::RowCount )
  IF n = ::RowCount
    n := ::SkipBlock:Eval( ::RowCount )
    IF n = ::RowCount
      ::SkipBlock:Eval( - n )
      ::RefreshAll()
    ELSE
      ::GoBottom()
    ENDIF
  ELSE
    ::GoBottom()
  ENDIF

RETURN Self

/*
  PageUp
  Teo. Mexico 2008
*/
METHOD FUNCTION PageUp CLASS wxhBrowse
  LOCAL n

  n := ::SkipBlock:Eval( - ::RowCount )
  IF n = - ::RowCount
    ::RefreshAll()
  ELSE
    ::GoTop()
  ENDIF

RETURN Self

/*
  SetDataSource
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetDataSource( dataSource ) CLASS wxhBrowse
  LOCAL table
  LOCAL oldPos
  LOCAL vt := ValType( dataSource )

  ::FDataSource := dataSource
  ::FDataSourceType := NIL
  ::ColumnList := {}
  ::ColumnZero := NIL
  ::BlockParam := NIL

  DO CASE
  CASE vt == "C"        /* path/filename for a database browse */
    table := TTable():New()
    table:TableName := dataSource
    table:Open()
    ::FDataSource := table
    ::BlockParam := table:DisplayFields()
    ::FDataSourceType := "O"

    ::GoTopBlock    := {|| table:DbGoTop() }
    ::GoBottomBlock := {|| table:DbGoBottom() }
    ::SkipBlock     := {|n| table:SkipBrowse( n ) }

    ::FRowIndexSetValue := {|n| table:RecNo := ::FRowList[ n ] }
    ::FRowIndexGetValue := {|| table:RecNo }

  CASE vt == "A"        /* Array browse */
    ::FDataSource := dataSource

    ::GoTopBlock    := {|| ::FRecNo := 1 }
    ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
    ::SkipBlock     := {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

    ::FRowIndexSetValue := {|n| ::FRecNo := ::FRowList[ n ] }
    ::FRowIndexGetValue := NIL

  CASE vt == "H"        /* Hash browse */
    ::FDataSource := dataSource
  OTHERWISE
    ::FDataSource := NIL
  ENDCASE

RETURN

/*
  SetRowIndex
  Teo. Mexico 2008
*/
METHOD FUNCTION SetRowIndex( rowIndex ) CLASS wxhBrowse

  IF Empty( ::FRowList )
    ::FillRowList()
  ENDIF

  IF rowIndex >= ::RowCount
    RETURN .F.
  ENDIF

RETURN .T.

/*
  SetRowListSize
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetRowListSize( size ) CLASS wxhBrowse
  IF ::FRowList = NIL
    ::FRowList := Array( size )
  ELSE
    ASize( ::FRowList, size )
  ENDIF
  ::FRowListSize := size
  IF ::RowCount != size
    ::SetRowCount( size )
  ENDIF
  ::RefreshAll()
RETURN

/*
  Up
  Teo. Mexico 2008
*/
METHOD FUNCTION Up CLASS wxhBrowse

  IF ::RowPos > 1
    ::RowPos -= 1
  ELSE
    ::SkipBlock:Eval( -1 )
    ::RefreshAll()
  ENDIF

RETURN Self

/*
  End Class wxhBrowse
*/
