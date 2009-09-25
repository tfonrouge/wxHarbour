/*
 * $Id$
 */

/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Grid: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_GridTableBase.h"
#include "wxbase/wx_Grid.h"

/*
  ~wx_Grid
  Teo. Mexico 2009
*/
wx_Grid::~wx_Grid()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxGrid Object
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = wxh_par_wxPoint( 3 );
  wxSize size = wxh_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  wxString name = wxh_parc( 6 );

  wx_Grid* grid = new wx_Grid( parent, id, pos, size, style, name );

  objParams.Return( grid );
}

/*
 AppendCols
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_APPENDCOLS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->AppendCols( hb_parni( 1 ) ) );
}

/*
 AppendRows
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_APPENDROWS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->AppendRows( hb_parni( 1 ) ) );
}

/*
 AutoSize
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_AUTOSIZE )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		grid->AutoSize();
}

/*
 AutoSizeColumn
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMN )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  int col = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  bool setAsMin = ISNIL( 2 ) ? true : hb_parl( 2 );

  if( grid )
    grid->AutoSizeColumn( col, setAsMin );
}

/*
  AutoSizeColumns
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMNS )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool setAsMin = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->AutoSizeColumns( setAsMin );
  }
}

/*
  AutoSizeRow
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_AUTOSIZEROW )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  int row = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  bool setAsMin = ISNIL( 2 ) ? true : hb_parl( 2 );

  if( grid )
    grid->AutoSizeRow( row, setAsMin );
}

/*
  AutoSizeRows
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_AUTOSIZEROWS )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool setAsMin = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->AutoSizeRows( setAsMin );
  }
}

/*
  BeginBatch
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_BEGINBATCH )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->BeginBatch();
  }
}

/*
  CanDragColMove
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CANDRAGCOLMOVE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->CanDragColMove() );
  }
}

/*
  CanDragColSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CANDRAGCOLSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->CanDragColSize() );
  }
}

/*
  CanDragRowSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CANDRAGROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->CanDragRowSize() );
  }
}

/*
  CanDragGridSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CANDRAGGRIDSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->CanDragGridSize() );
  }
}

/*
  CanEnableCellControl
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CANENABLECELLCONTROL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->CanEnableCellControl() );
  }
}

/*
  ClearGrid
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CLEARGRID )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->ClearGrid();
  }
}

/*
  ClearSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CLEARSELECTION )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->ClearSelection();
  }
}

/*
  CreateGrid
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_CREATEGRID )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  int numRows = hb_parnl( 1 );
  int numCols = hb_parnl( 2 );

  wxGrid::wxGridSelectionModes selmode = (wxGrid::wxGridSelectionModes) hb_parnl( 3 );

  if( grid )
    hb_retl( grid->CreateGrid( numRows, numCols, selmode ));
  else
    hb_ret();
}

/*
 DeleteCols
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_DELETECOLS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->DeleteCols( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
 DeleteRows
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_DELETEROWS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->DeleteRows( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
  DisableCellEditControl
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_DISABLECELLEDITCONTROL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->DisableCellEditControl();
  }
}

/*
  DisableDragColMove
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_DISABLEDRAGCOLMOVE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->DisableDragColMove();
  }
}

/*
  DisableDragColSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_DISABLEDRAGCOLSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->DisableDragColSize();
  }
}

/*
  DisableDragGridSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_DISABLEDRAGGRIDSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->DisableDragGridSize();
  }
}

/*
  DisableDragRowSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_DISABLEDRAGROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->DisableDragRowSize();
  }
}

/*
  EnableCellEditControl
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLECELLEDITCONTROL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableCellEditControl( enable );
  }
}

/*
  EnableDragColSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEDRAGCOLSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableDragColSize( enable );
  }
}

/*
  EnableDragColMove
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEDRAGCOLMOVE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableDragColMove( enable );
  }
}

/*
  EnableDragGridSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEDRAGGRIDSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableDragGridSize( enable );
  }
}

/*
  EnableDragRowSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEDRAGROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableDragRowSize( enable );
  }
}

/*
  EnableEditing
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEEDITING )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool editing = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableEditing( editing );
  }
}

/*
  wxGrid:EnableGridLines
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENABLEGRIDLINES )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    bool enable = ISNIL( 1 ) ? true : hb_parl( 1 );
    grid->EnableGridLines( enable );
  }
}

/*
  EndBatch
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ENDBATCH )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    grid->EndBatch();
}

/*
  Fit
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_FIT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    grid->Fit();
}

/*
  ForceRefresh
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_FORCEREFRESH )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    grid->ForceRefresh();
}

/*
  GetBatchCount
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_GETBATCHCOUNT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    hb_retni( grid->GetBatchCount() );
}

/*
  GetCellValue
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_GETCELLVALUE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    wxh_retc( grid->GetCellValue( hb_parni( 1 ), hb_parni( 2 ) ) );
  }
}

/*
 GetDefaultRowLabelSize
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETDEFAULTROWLABELSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    hb_retni( grid->GetDefaultRowLabelSize() );
  }
}

/*
 GetDefaultRowSize
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETDEFAULTROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    hb_retni( grid->GetDefaultRowSize() );
  }
}

/*
  GetGridCursorCol
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_GETGRIDCURSORCOL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retni( grid->GetGridCursorCol() );
  }
}

/*
  GetGridCursorRow
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_GETGRIDCURSORROW )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retni( grid->GetGridCursorRow() );
  }
}

/*
  GetNumberCols
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_GETNUMBERCOLS )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberCols() );
  }
}

/*
 GetNumberRows
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETNUMBERROWS )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberRows() );
  }
}

/*
 GetRowLabelSize
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETROWLABELSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    hb_retni( grid->GetRowLabelSize() );
  }
}

/*
 GetRowLabelValue
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETROWLABELVALUE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    wxh_retc( grid->GetRowLabelValue( hb_parni( 1 ) ) );
  }
}

/*
 GetRowSize
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid && grid->GetTable() )
  {
    hb_retni( grid->GetRowSize( hb_parni( 1 ) ) );
  }
}

/*
 GetTable
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_GETTABLE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    wx_GridTableBase* gridTable = (wx_GridTableBase *) grid->GetTable();
    if( gridTable )
    {
	  wxh_itemReturn( gridTable );
    }
  }
}

/*
 InsertCols
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_INSERTCOLS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->InsertCols( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
 InsertRows
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_INSERTROWS )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
		hb_retl( grid->InsertRows( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
  IsVisible
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_ISVISIBLE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->IsVisible( hb_parni( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
  }
}

/*
  MakeCellVisible
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_MAKECELLVISIBLE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    grid->MakeCellVisible( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
  MoveCursorLeft
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_MOVECURSORLEFT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->MoveCursorLeft( hb_parl( 1 ) ) );
  }
}

/*
  MoveCursorRight
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_MOVECURSORRIGHT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    hb_retl( grid->MoveCursorRight( hb_parl( 1 ) ) );
  }
}

/*
 SelectCol
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SELECTCOL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid )
  {
    grid->SelectCol( hb_parni( 1 ), hb_parnl( 2 ) );
  }
}

/*
 SelectRow
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SELECTROW )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( grid )
  {
    grid->SelectRow( hb_parni( 1 ), hb_parnl( 2 ) );
  }
}

/*
  wxGrid:SetCellAlignment
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_SETCELLALIGNMENT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    if( hb_pcount() == 3 )
    {
      grid->SetCellAlignment( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) );
    }
    else if( hb_pcount() == 4 )
    {
      grid->SetCellAlignment( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) );
    }
  }
}

/*
 SetCellBackgroundColour
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SETCELLBACKGROUNDCOLOUR )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
	{
		grid->SetCellBackgroundColour( hb_parni( 1 ), hb_parni( 2 ), wxh_par_wxColour( 3 ) );
	}
}

/*
 SetCellTextColour
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SETCELLTEXTCOLOUR )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
	{
		grid->SetCellTextColour( hb_parni( 1 ), hb_parni( 2 ), wxh_par_wxColour( 3 ) );
	}
}

/*
 SetCellValue
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SETCELLVALUE )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
	{
		grid->SetCellValue( hb_parni( 1 ), hb_parni( 2 ), wxh_parc( 3 ) );
	}
}

/*
  SetColFormatBool
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_SETCOLFORMATBOOL )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->SetColFormatBool( hb_parni( 1 ) );
  }
}

/*
  SetColFormatNumber
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_SETCOLFORMATNUMBER )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->SetColFormatNumber( hb_parni( 1 ) );
  }
}

/*
  SetColFormatFloat
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_SETCOLFORMATFLOAT )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->SetColFormatFloat( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) );
  }
}

HB_FUNC( WXGRID_SETCOLLABELSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    int height = hb_parni( 1 );
    grid->SetColLabelSize( height );
  }
}

HB_FUNC( WXGRID_SETCOLLABELVALUE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    int col = hb_parni( 1 );
    wxString value = wxh_parc( 2 );
    grid->SetColLabelValue( col, value );
  }
}

/*
  SetColSize
  Teo. Mexico 2009
*/
HB_FUNC( WXGRID_SETCOLSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    int col = hb_parni( 1 );
    int width = hb_parni( 2 );
    grid->SetColSize( col, width );
  }
}

/*
 SetDefaultCellAlignment
 Teo. Mexico 2009
 */
HB_FUNC( WXGRID_SETDEFAULTCELLALIGNMENT )
{
	wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( grid )
	{
		grid->SetDefaultCellAlignment( hb_parni( 1 ), hb_parni( 2 ) );
	}
}

HB_FUNC( WXGRID_SETDEFAULTCOLSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    int width = hb_parni( 1 );
    bool resizeExistingCols = hb_parl( 2 );
    grid->SetDefaultColSize( width, resizeExistingCols );
  }
}

HB_FUNC( WXGRID_SETDEFAULTROWSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    int height = hb_parni(1);
    bool resizeExistingRows = hb_parl( 2 );
    grid->SetDefaultRowSize( height, resizeExistingRows );
  }
}

/*
  SetGridCursor
*/
HB_FUNC( WXGRID_SETGRIDCURSOR )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
    grid->SetGridCursor( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC( WXGRID_SETROWLABELSIZE )
{
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( grid )
  {
    grid->SetRowLabelSize( hb_parni( 1 ) );
  }
}

HB_FUNC( WXGRID_SETTABLE )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wx_Grid* grid = (wx_Grid *) objParams.Get_wxObject();

  if( grid ) /* gridTable can be NULL */
  {
    wx_GridTableBase* gridTable = (wx_GridTableBase *) objParams.paramChild( 1 );
    if( gridTable )
    {
      grid->SetTable( gridTable, hb_parl( 2 ), (wxGrid::wxGridSelectionModes) hb_parnl( 3 ) );
    }
  }
}
