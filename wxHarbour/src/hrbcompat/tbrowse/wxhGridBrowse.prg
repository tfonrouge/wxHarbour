/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
  wxhGridBrowse
  Teo. Mexico 2008
*/
CLASS wxhGridBrowse FROM wxGrid
PRIVATE:
  DATA FHeight INIT 0
PROTECTED:
PUBLIC:

  CONSTRUCTOR New( parent, id, pos, size, style, name )

  METHOD CalcMaxRows /* array of { width, height } */
  METHOD GetMaxRows
  METHOD GetRowCount
  METHOD OnKeyDown( keyEvent ) INLINE ::GetParent():OnKeyDown( keyEvent )
  METHOD OnSelectCell( event ) INLINE ::GetParent():OnSelectCell( event )
  METHOD OnSize( sizeEvent )
  METHOD SetColPos( colPos )
  METHOD SetColWidth( col, colWidth )
  METHOD SetRowCount( rowCount )
  METHOD SetRowPos( rowPos )
  METHOD ShowRow( row )

PUBLISHED:
ENDCLASS

/*
  OnSize
  Teo. Mexico 2009
*/
METHOD FUNCTION OnSize( size ) CLASS wxhGridBrowse
  LOCAL Result := .T.
  LOCAL browse := ::GetParent()
  LOCAL maxRows,rowCount
  LOCAL height
  LOCAL n
  LOCAL column

  IF !browse:FillColumnsChecked .AND. browse:AutoFill
    IF browse:ColCount = 0
      IF browse:DataSource != NIL
        browse:FillColumns()
      ENDIF
    ENDIF
    browse:FillColumnsChecked := .T.
  ENDIF

  rowCount := ::GetRowCount()
  maxRows := ::CalcMaxRows()

  height := size[ 2 ]

  IF ::FHeight != height .AND. maxRows != rowCount

    IF rowCount > 0
      IF rowCount < ::GetNumberRows()
        ::DeleteRows( rowCount - 1, ::GetNumberRows() - rowCount )
      ELSE
        ::AppendRows( rowCount - ::GetNumberRows() )
        FOR n:=1 TO ::GetNumberCols
          column := ::GetTable():ColumnList[ n ]
          browse:SetColumnAlignment( n, column:Align )
        NEXT
      ENDIF
    ELSE
      ::DeleteRows( 0, ::GetNumberRows() )
    ENDIF

    ::GetTable():FillGridBuffer()

    ::FHeight := height

  ENDIF

RETURN Result

/*
  EndClass wxhGridBrowse
*/
