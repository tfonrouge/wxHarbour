/*
 * $Id$
 */

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
  DATA FAlwaysShowSelectedRow	INIT .T.
  DATA FColPos          INIT 0
  DATA FDataSource
  DATA FDataSourceType
  DATA FRecNo           INIT 0
  DATA FRowPos          INIT 0
  METHOD GetColCount INLINE Len( ::browseTableBase:ColumnList )
  METHOD GetRecNo
  METHOD SetDataSource( dataSource )
  METHOD SetRowCount( rowCount ) INLINE ::grid:RowCount := rowCount
  METHOD SetAlwaysShowSelectedRow( alwaysShowSelectedRow )
PROTECTED:
  METHOD browseTableBase INLINE ::grid:GetTable()
PUBLIC:

  DATA grid AS OBJECT

  CONSTRUCTOR New( dataSource, window, id, pos, size, style, name )
  METHOD ClearObjData

  /* Begin TBrowse compatible */
  /* TBrowse compatible vars */
  DATA cargo
  DATA GoBottomBlock
  DATA GoTopBlock
  DATA SkipBlock

  PROPERTY ColCount READ GetColCount
  PROPERTY ColPos READ FColPos WRITE grid:SetColPos
  PROPERTY MaxRows READ grid:GetMaxRows
  PROPERTY RowCount READ grid:GetRowCount WRITE grid:SetRowCount
  PROPERTY RowPos READ FRowPos WRITE grid:SetRowPos

  /* TBrowse compatible methods */
  METHOD AddColumn( column )
  METHOD DelColumn( pos )
  METHOD Down
  METHOD End
  METHOD GetColumn( nCol ) INLINE ::browseTableBase:GetColumn( nCol )
  METHOD GoBottom
  METHOD GoTop
  METHOD Home
  METHOD Left
  METHOD PageDown
  METHOD PageUp
  METHOD RefreshAll
  METHOD Right
  METHOD Up
  /* End TBrowse compatible */

  DATA AutoFill INIT .T.	/* autofill columns with DataSource data */
  DATA BottomFirst INIT .F.
  DATA FillColumnsChecked INIT .F.
  DATA KeyEventBlock
  DATA SelectCellBlock

  METHOD DeleteAllColumns
  METHOD FillColumns
  METHOD Fit INLINE ::grid:Fit
  METHOD GoFirstPos
  METHOD OnKeyDown( event )
  METHOD OnSelectCell( event )
  METHOD SetColumnAlignment( nCol, align )

  PROPERTY AlwaysShowSelectedRow READ FAlwaysShowSelectedRow WRITE SetAlwaysShowSelectedRow
  PROPERTY BlockParam READ browseTableBase:GetBlockParam WRITE browseTableBase:SetBlockParam
  PROPERTY ColumnList READ browseTableBase:GetColumnList WRITE browseTableBase:SetColumnList
  PROPERTY ColumnZero READ browseTableBase:GetColumnZero WRITE browseTableBase:SetColumnZero
  PROPERTY DataSource READ FDataSource WRITE SetDataSource
  PROPERTY DataSourceType READ FDataSourceType
  PROPERTY RecNo READ GetRecNo

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( window, id, label, pos, size, style, name, onKey ) CLASS wxhBrowse
  LOCAL boxSizer
  LOCAL scrollBar

  Super:New( window, wxID_ANY, pos, size, wxTAB_TRAVERSAL, name ) /* container of type wxPanel */

  IF label == NIL
    boxSizer := wxBoxSizer():New( wxHORIZONTAL )
  ELSE
    boxSizer := wxStaticBoxSizer():New( wxHORIZONTAL, Self, label )
  ENDIF

  ::SetSizer( boxSizer )

  ::grid := wxhGridBrowse():New( Self, id, NIL, NIL, style, "wxhGridBrowse" )

  boxSizer:Add( ::grid, 1, _hb_BitOr( wxGROW, wxALL ), 5 )

  boxSizer:Add( wxStaticLine():New( Self, wxID_ANY, NIL, NIL, wxLI_VERTICAL ), 0, wxGROW, 5 )

  scrollBar := wxScrollBar():New( Self, wxID_ANY, NIL, NIL, wxSB_VERTICAL )

  scrollBar:SetScrollBar( 0, 1, 100, 1 )

  boxSizer:Add( scrollBar, 0, _hb_BitOr( wxGROW, wxLEFT, wxRIGHT ), 5 )
  
  ::grid:EnableGridLines( .F. )
  ::grid:EnableDragRowSize( .F. )
  ::grid:SetColLabelSize( 22 )
  ::grid:SetRowLabelSize( 0 )

  ::grid:SetTable( wxhBrowseTableBase():New(), .T. )

  IF !onKey == NIL
    ::KeyEventBlock := onKey
  ENDIF

RETURN Self

/*
  AddColumn
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddColumn( column ) CLASS wxhBrowse
  AAdd( ::browseTableBase:ColumnList, column )
  ::browseTableBase:AppendCols( 1 )
  IF column:Width != NIL
    ::grid:SetColWidth( Len( ::browseTableBase:ColumnList ), column:Width )
  ENDIF
  //::grid:AutoSizeColumn( Len( ::browseTableBase:ColumnList ) - 1 )
RETURN

/*
  ClearObjData
  Teo. Mexico 2009
*/
METHOD PROCEDURE ClearObjData CLASS wxhBrowse
  ::browseTableBase:ClearObjData()
  ::GoTopBlock := NIL
  ::GoBottomBlock := NIL
  ::SkipBlock := NIL
  ::grid:SetTable( NIL )
  ::grid := NIL
RETURN

/*
  DelColumn
  Teo. Mexico 2008
*/
METHOD FUNCTION DelColumn( pos ) CLASS wxhBrowse
  LOCAL column
  LOCAL length := ::ColCount

  IF !Empty( pos ) .AND. pos > 0 .AND. pos <= length .AND. ::browseTableBase:DeleteCols( pos - 1, 1 )
    column := ::browseTableBase:ColumnList[ pos ]
    ADel( ::browseTableBase:ColumnList, pos )
    ASize( ::browseTableBase:ColumnList, length - 1 )
  ENDIF

RETURN column

/*
  DeleteAllColumns
  Teo. Mexico 2009
*/
METHOD PROCEDURE DeleteAllColumns CLASS wxhBrowse
  WHILE ::ColCount > 0
    ::DelColumn( 1 )
  ENDDO
RETURN

/*
  Down
  Teo. Mexico 2008
*/
METHOD FUNCTION Down CLASS wxhBrowse

  IF ::RowPos < ::RowCount
    ::RowPos += 1
  ELSE
    IF ::SkipBlock:Eval( 1 ) = 1
      ADel( ::browseTableBase:GridBuffer, 1 )
      ::browseTableBase:GetGridRowData( ::RowCount )
      ::grid:ForceRefresh()
      ::grid:SetGridCursor( ::grid:GetGridCursorRow(), ::grid:GetGridCursorCol() )
    ENDIF
  ENDIF

RETURN Self

/*
  End
  Teo. Mexico 2008
*/
METHOD FUNCTION End() CLASS wxhBrowse
  ::grid:SetColPos( ::ColCount() )
  ::grid:MakeCellVisible( ::grid:GetGridCursorRow(), ::grid:GetNumberCols() - 1 )
RETURN Self

/*
  FillColumns
  Teo. Mexico 2008
*/
  STATIC FUNCTION buildBlock( Self, col )
  RETURN {|key| ::DataSource[ key, col ] }

METHOD PROCEDURE FillColumns CLASS wxhBrowse
  LOCAL fld
  LOCAL vType := ValType( ::FDataSource )
  LOCAL itm1
  
  DO CASE
  CASE vType = "O" .AND. ::FDataSource:IsDerivedFrom( "TTable" )

    __wxh_BrowseAddColumn( .T., Self, "RecNo", {|| ::FDataSource:RecNo }, "9999999" )//, fld:Size )

    FOR EACH fld IN ::FDataSource:FieldList
      __wxh_BrowseAddColumn( .F., Self, fld:Label, ::FDataSource:GetDisplayFieldBlock( fld:__enumIndex() ), fld:Picture )//, fld:Size )
    NEXT

  CASE vType $ "AH" .AND. Len( ::FDataSource ) > 0

//     __wxh_BrowseAddColumn( .T., Self, "", {|| ::RecNo }, "9999" )

    IF !Empty( ::FDataSource )
      IF vType = "A"
        itm1 := ::FDataSource[ 1 ]
      ELSE
        itm1 := HB_HValueAt( ::FDataSource, 1 )
      ENDIF
      IF ValType( itm1 ) = "A"
        FOR EACH fld IN ::FDataSource[ 1 ]
          __wxh_BrowseAddColumn( .F., Self, NTrim( fld:__enumIndex() ), buildBlock( Self, fld:__enumIndex() ) )
        NEXT
      ELSE
        __wxh_BrowseAddColumn( .F., Self, "", {|key| ::FDataSource[ key ] } )
      ENDIF
    ENDIF

  ENDCASE

RETURN

/*
  GetRecNo
  Teo. Mexico 2008
*/
METHOD FUNCTION GetRecNo CLASS wxhBrowse
  IF ::FDataSourceType = "O"
    RETURN ::FDataSource:RecNo
  ENDIF
RETURN ::FRecNo

/*
  GoBottom
  Teo. Mexico 2008
*/
METHOD FUNCTION GoBottom CLASS wxhBrowse

  ::GoBottomBlock:Eval()
  ::browseTableBase:FillGridBuffer()
  ::RowPos := ::RowCount

  ::grid:ForceRefresh()

RETURN Self

/*
  GoFirstPos
  Teo. Mexico 2008
*/
METHOD PROCEDURE GoFirstPos CLASS wxhBrowse
  IF ::BottomFirst
    ::GoBottomBlock:Eval()
  ELSE
    ::GoTopBlock:Eval()
  ENDIF
RETURN

/*
  GoTop
  Teo. Mexico 2008
*/
METHOD FUNCTION GoTop CLASS wxhBrowse

  ::GoTopBlock:Eval()
  ::browseTableBase:FillGridBuffer()
  ::RowPos := 1

  ::grid:ForceRefresh()

RETURN Self

/*
  Home
  Teo. Mexico 2008
*/
METHOD FUNCTION Home CLASS wxhBrowse
  ::grid:SetColPos( 1 ) /* no freeze cols yet implemented */
  ::grid:MakeCellVisible( ::grid:GetGridCursorRow(), 0 )
RETURN Self

/*
  Left
  Teo. Mexico 2008
*/
METHOD FUNCTION Left CLASS wxhBrowse
  ::grid:MoveCursorLeft()
RETURN Self

/*
  OnKeyDown
  Teo. Mexico 2008
*/
METHOD PROCEDURE OnKeyDown( keyEvent ) CLASS wxhBrowse

  IF ::KeyEventBlock != NIL
    IF ::KeyEventBlock:Eval( Self, keyEvent )
      RETURN /* event key processed */
    ENDIF
  ENDIF
  
  SWITCH keyEvent:GetKeyCode()
  CASE WXK_UP
    ::Up()
    EXIT
  CASE WXK_DOWN
    ::Down()
    EXIT
  CASE WXK_LEFT
    ::Left()
    EXIT
  CASE WXK_RIGHT
    IF keyEvent:GetModifiers() = wxMOD_CONTROL
      keyEvent:Skip( .F. )
    ELSE
      ::Right()
    ENDIF
    EXIT
  CASE WXK_HOME
    IF keyEvent:GetModifiers() = wxMOD_CONTROL
      ::Home()
    ELSE
      ::RowPos := 1
    ENDIF
    EXIT
  CASE WXK_END
    IF keyEvent:GetModifiers() = wxMOD_CONTROL
      ::End()
    ELSE
      ::RowPos := ::RowCount
    ENDIF
    EXIT
  CASE WXK_PAGEUP
    IF keyEvent:GetModifiers() = wxMOD_CONTROL
      ::GoTop()
    ELSE
      IF ::RowPos = 1
        ::PageUp()
      ELSE
        ::RowPos := 1
      ENDIF
    ENDIF
    EXIT
  CASE WXK_PAGEDOWN
    IF keyEvent:GetModifiers() = wxMOD_CONTROL
      ::GoBottom()
    ELSE
      IF ::RowPos = ::RowCount
        ::PageDown()
      ELSE
        ::RowPos := ::RowCount
      ENDIF
    ENDIF
    EXIT
  _SW_OTHERWISE
    keyEvent:Skip()
  END

RETURN

/*
  OnSelectCell
  Teo. Mexico 2008
*/
METHOD PROCEDURE OnSelectCell( gridEvent ) CLASS wxhBrowse
  LOCAL row

  IF !gridEvent:Selecting()
    gridEvent:Skip()
    RETURN
  ENDIF

  row := gridEvent:GetRow()
  
  IF ::FAlwaysShowSelectedRow
    ::grid:ShowRow( row )
  ENDIF

  ::browseTableBase:CurRowIndex := row

  ::FColPos := gridEvent:GetCol() + 1
  ::FRowPos := row + 1

  IF ::SelectCellBlock != NIL .AND. ::RowCount > 0
    ::SelectCellBlock:Eval( Self, gridEvent )
  ENDIF

  gridEvent:Skip()

RETURN

/*
  PageDown
  Teo. Mexico 2008
*/
METHOD FUNCTION PageDown CLASS wxhBrowse
  LOCAL rowPos := ::RowPos

  ::SkipBlock:Eval( ::RowCount - ::RowPos + 1 )
  ::browseTableBase:FillGridBuffer()
  ::grid:ForceRefresh()
  ::RowPos := rowPos

RETURN Self

/*
  PageUp
  Teo. Mexico 2008
*/
METHOD FUNCTION PageUp CLASS wxhBrowse

  ::SkipBlock:Eval( -::RowPos - ::RowCount + 1)
  ::browseTableBase:FillGridBuffer()

  ::grid:ForceRefresh()

RETURN Self

/*
  RefreshAll
  Teo. Mexico 2008
*/
METHOD FUNCTION RefreshAll CLASS wxhBrowse
  ::browseTableBase:FillGridBuffer()
  ::grid:ForceRefresh()
RETURN Self

/*
  Right
  Teo. Mexico 2008
*/
METHOD FUNCTION Right CLASS wxhBrowse
  ::grid:MoveCursorRight()
RETURN Self

/*
  SetColumnAlignment
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetColumnAlignment( nCol, align ) CLASS wxhBrowse
  LOCAL i

  FOR i:=0 TO ::RowCount - 1
    ::grid:SetCellAlignment( align, i, nCol - 1 )
  NEXT

RETURN

/*
  SetDataSource
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetDataSource( dataSource ) CLASS wxhBrowse
  LOCAL table
  LOCAL oldPos
  LOCAL vt := ValType( dataSource )

  ::FDataSourceType := NIL
  ::ColumnList := {}
  ::ColumnZero := NIL
  ::BlockParam := NIL

  ::FDataSource := NIL

  SWITCH vt
  CASE 'A'        /* Array browse */
    ::FDataSource := dataSource
    ::FDataSourceType := "A"
    ::BlockParam := {|Self| ::RecNo }

    ::GoTopBlock    := {|| ::FRecNo := 1 }
    ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
    ::SkipBlock     := {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

    EXIT

  CASE 'C'        /* path/filename for a database browse */
    table := TTable():New( , dataSource )

    ::SetDataSource( table )

    EXIT

  CASE 'H'        /* Hash browse */
    /* TODO: Implement this */
    ::FDataSource := dataSource
    ::FDataSourceType := "H"
    ::BlockParam := {|Self| HB_HKeyAt( ::DataSource, ::RecNo ) }

    ::GoTopBlock    := {|| ::FRecNo := 1 }
    ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
    ::SkipBlock     := {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

    EXIT

  CASE 'O'
	
	IF dataSource:IsDerivedFrom("TTable")
	  ::FDataSource := dataSource
	  ::FDataSourceType := "O"
	  ::BlockParam := dataSource:DisplayFields()

	  ::GoTopBlock    := {|| dataSource:DbGoTop() }
	  ::GoBottomBlock := {|| dataSource:DbGoBottom() }
	  ::SkipBlock     := {|n| dataSource:SkipBrowse( n ) }
	  
	  ::browseTableBase:gridDataIsOEM := dataSource:dataIsOEM

	ELSE
	  wxhAlert("Invalid object assigned to wxhBrowse...")
	ENDIF

    EXIT

  END

RETURN

/*
  SetAlwaysShowSelectedRow
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetAlwaysShowSelectedRow( alwaysShowSelectedRow ) CLASS wxhBrowse
  ::grid:ShowRow( NIL, alwaysShowSelectedRow )
  ::FAlwaysShowSelectedRow := alwaysShowSelectedRow
RETURN

/*
  Up
  Teo. Mexico 2008
*/
METHOD FUNCTION Up CLASS wxhBrowse

  IF ::RowPos > 1
    ::RowPos -= 1
  ELSE
    IF ::SkipBlock:Eval( -1 ) = -1
      AIns( ::browseTableBase:GridBuffer, 1 )
      ::browseTableBase:GetGridRowData( 1 )
      ::grid:ForceRefresh()
      ::grid:SetGridCursor( ::grid:GetGridCursorRow(), ::grid:GetGridCursorCol() )
    ENDIF
  ENDIF

RETURN Self

/*
  End Class wxhBrowse
*/
