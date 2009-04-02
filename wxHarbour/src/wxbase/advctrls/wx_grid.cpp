/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Grid: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_gridtablebase.h"
#include "wxbase/wx_grid.h"

/*
  ~wx_Grid
  Teo. Mexico 2006
*/
wx_Grid::~wx_Grid()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxGrid Object
  Teo. Mexico 2006
*/
HB_FUNC( WXGRID_NEW )
{
//   PHB_ITEM pSelf = hb_stackSelfItem();
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  wxString name = wxString( hb_parcx( 6 ), wxConvLocal );

  wx_Grid* grid = new wx_Grid( parent, id, pos, size, style, name );

  objParams.Return( grid );
}

/*
  AutoSizeColumn
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMN )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  int col = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  bool setAsMin = ISNIL( 2 ) ? true : hb_parl( 2 );

  if( grid )
    grid->AutoSizeColumn( col, setAsMin );
}

/*
  AutoSizeColumns
  Teo. Mexico 2008
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

HB_FUNC( WXGRID_CREATEGRID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  int numRows = hb_parnl( 1 );
  int numCols = hb_parnl( 2 );

  wxGrid::wxGridSelectionModes selmode = (wxGrid::wxGridSelectionModes) hb_parnl( 3 );

  if( grid )
    hb_retl( grid->CreateGrid( numRows, numCols, selmode ));
  else
    hb_ret();
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

HB_FUNC( WXGRID_FIT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
    grid->Fit();
}

HB_FUNC( WXGRID_FORCEREFRESH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
    grid->ForceRefresh();
}

/*
  GetGridCursorCol
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETGRIDCURSORCOL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    hb_retni( grid->GetGridCursorCol() );
  }
}

/*
  GetGridCursorRow
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETGRIDCURSORROW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    hb_retni( grid->GetGridCursorRow() );
  }
}

/*
  GetNumberCols
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETNUMBERCOLS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberCols() );
  }
}

/*
  GetNumberRows
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETNUMBERROWS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberRows() );
  }
}

HB_FUNC( WXGRID_GETTABLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    wx_GridTableBase* gridTable = (wx_GridTableBase *) grid->GetTable();
    if( gridTable )
    {
      PHB_ITEM pGridTableBase = wxh_ItemListGet_HB( gridTable );
      hb_itemReturn( pGridTableBase );
    }
  }
}

/*
  IsVisible
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_ISVISIBLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    hb_retl( grid->IsVisible( hb_parni( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
  }
}

/*
  MakeCellVisible
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MAKECELLVISIBLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
    grid->MakeCellVisible( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
  MoveCursorLeft
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MOVECURSORLEFT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    hb_retl( grid->MoveCursorLeft( hb_parl( 1 ) ) );
  }
}

/*
  MoveCursorRight
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MOVECURSORRIGHT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    hb_retl( grid->MoveCursorRight( hb_parl( 1 ) ) );
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

HB_FUNC( WXGRID_SETCOLLABELSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    int height = hb_parni( 1 );
    grid->SetColLabelSize( height );
  }
}

HB_FUNC( WXGRID_SETCOLLABELVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    int col = hb_parni( 1 );
    wxString value = wxString( hb_parcx( 2 ), wxConvLocal );
    grid->SetColLabelValue( col, value );
  }
}

/*
  SetColSize
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_SETCOLSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    int col = hb_parni( 1 );
    int width = hb_parni( 2 );
    grid->SetColSize( col, width );
  }
}

HB_FUNC( WXGRID_SETDEFAULTCOLSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
  {
    int width = hb_parni( 1 );
    bool resizeExistingCols = hb_parl( 2 );
    grid->SetDefaultColSize( width, resizeExistingCols );
  }
}

HB_FUNC( WXGRID_SETDEFAULTROWSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

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
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

  if( grid )
    grid->SetGridCursor( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC( WXGRID_SETROWLABELSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGet_WX( pSelf );

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
