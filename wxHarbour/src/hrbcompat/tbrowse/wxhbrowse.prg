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
CLASS wxhBrowse FROM wxGrid
PRIVATE:
PROTECTED:
PUBLIC:

  DATA boxSizer
  DATA panel
  DATA scrollBar

  CONSTRUCTOR New( dataSource, window, id, pos, size, style, name )
  METHOD wxNew( window, id, pos, size, style, name )

  METHOD AddAllColumns

  /* don't call this methods here */
  METHOD AppendCols( numCols )          VIRTUAL
  METHOD AppendRows( numRows )          VIRTUAL
  METHOD DeleteCols( pos, numCols )     VIRTUAL
  METHOD DeleteRows( pos, numRows )     VIRTUAL
  METHOD InsertCols( pos, numCols )     VIRTUAL
  METHOD InsertRows( pos, numRows )     VIRTUAL
  /* don't call this methods here */

  /* TBrowse compatible vars */
  METHOD RowCount
  /* TBrowse compatible vars */

  /* TBrowse compatible methods */
  METHOD AddColumn( column )    INLINE ::GetTable():AddColumn( column )
  METHOD DelColumn( pos )       INLINE ::GetTable():DelColumn( pos )
  METHOD GoBottom               INLINE ::GetTable():GoBottomBlock:Eval()
  METHOD GoTop                  INLINE ::GetTable():GoTopBlock:Eval()
  /* TBrowse compatible methods */

  METHOD EventManager

  PROPERTY index READ GetTable():index

PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( dataSource, window, id, pos, size, style, name ) CLASS wxhBrowse

  ::panel := wxPanel():New( window )
  ::boxSizer := wxBoxSizer():New( wxHORIZONTAL )
  ::panel:SetSizer( ::boxSizer )

  ::wxNew( ::panel, id, pos, size, style, name )

  ::boxSizer:Add( Self, 1, HB_BitOr( wxGROW, wxALL), 5 )
  ::scrollBar := wxScrollBar():New( ::panel, NIL, NIL, NIL, wxSB_VERTICAL )
  ::scrollBar:SetScrollbar( 2, 0, 4, 1 )
  ::boxSizer:Add( ::scrollBar, 0, wxGROW, 5 )

  ::scrollBar:Connect( ::scrollBar:GetId(), wxEVT_SCROLL_LINEUP, {|| ::EventManager( K_PGUP ) } )

  ::SetTable( wxhBrowseTableBase():New( dataSource ), .T. )
  ::GoTop()

RETURN Self

/*
  AddAllColumns
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddAllColumns CLASS wxhBrowse
  LOCAL dataSource
  LOCAL fld

  dataSource := ::GetTable():DataSource

  DO CASE
  CASE ValType( dataSource ) = "O" .AND. dataSource:IsDerivedFrom( "TTable" )
    FOR EACH fld IN dataSource:FieldList
      wxh_BrowseAddColumn( .F., Self, fld:Label, dataSource:GetDisplayFieldBlock( fld:__enumIndex() ), fld:Picture )//, fld:Size )
    NEXT
  ENDCASE

RETURN

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
  End Class wxhBrowse
*/
