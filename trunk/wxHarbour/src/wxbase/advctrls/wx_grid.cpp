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
  wxh_ItemListDel( this );
}

/*
  Constructor: wxGrid Object
  Teo. Mexico 2006
*/
HB_FUNC( WXGRID_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  wxString name = wxString( hb_parcx( 6 ), wxConvLocal );

  wx_Grid* grid = new wx_Grid( parent, id, pos, size, style, name );

  // Add object's to hash list
  wxh_ItemListAdd( grid, pSelf );

  hb_itemReturn( pSelf );
}

/*
  AutoSizeColumn
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMN )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int col = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  bool setAsMin = ISNIL( 2 ) ? true : hb_parl( 2 );
  if( pSelf && grid )
    grid->AutoSizeColumn( col, setAsMin );
}

HB_FUNC( WXGRID_CREATEGRID )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int numRows = hb_parnl( 1 );
  int numCols = hb_parnl( 2 );
  wxGrid::wxGridSelectionModes selmode = (wxGrid::wxGridSelectionModes) hb_parnl(3);
  if( pSelf && grid )
    hb_retl( grid->CreateGrid( numRows, numCols, selmode ));
  else
    hb_ret();
}

HB_FUNC( WXGRID_FIT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
    grid->Fit();
}

HB_FUNC( WXGRID_FORCEREFRESH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
    grid->ForceRefresh();
}

/*
  GetGridCursorCol
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETGRIDCURSORCOL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
  {
    hb_retni( grid->GetGridCursorCol() );
  }
  else
    hb_ret();
}

/*
  GetGridCursorRow
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETGRIDCURSORROW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
  {
    hb_retni( grid->GetGridCursorRow() );
  }
  else
    hb_ret();
}

/*
  GetNumberCols
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETNUMBERCOLS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberCols() );
  }
  else
    hb_ret();
}

/*
  GetNumberRows
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_GETNUMBERROWS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid && grid->GetTable() )
  {
    hb_retnl( grid->GetTable()->GetNumberRows() );
  }
  else
    hb_ret();
}

HB_FUNC( WXGRID_GETTABLE )
{
  PHB_ITEM pReturn = NULL, pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  wx_GridTableBase* gridTable = (wx_GridTableBase *) grid->GetTable();
  if( pSelf && grid && gridTable )
    pReturn = wxh_ItemListGetHB( gridTable );

  if(pReturn)
    hb_itemReturn( pReturn );
  else
    hb_ret();
}

/*
  IsVisible
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_ISVISIBLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
  {
    hb_retl( grid->IsVisible( hb_parni( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
  }
  else
    hb_ret();
}

/*
  MakeCellVisible
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MAKECELLVISIBLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
    grid->MakeCellVisible( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
  MoveCursorLeft
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MOVECURSORLEFT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
  {
    hb_retl( grid->MoveCursorLeft( hb_parl( 1 ) ) );
  }
  else
    hb_ret();
}

/*
  MoveCursorRight
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_MOVECURSORRIGHT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
  {
    hb_retl( grid->MoveCursorRight( hb_parl( 1 ) ) );
  }
  else
    hb_ret();
}

HB_FUNC( WXGRID_SETCOLLABELSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int height = hb_parni(1);
  if( pSelf && grid )
    grid->SetColLabelSize( height );
}

HB_FUNC( WXGRID_SETCOLLABELVALUE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int col = hb_parni(1);
  wxString value = wxString( hb_parcx(2), wxConvLocal );
  if( pSelf && grid )
    grid->SetColLabelValue( col, value );
}

/*
  SetColSize
  Teo. Mexico 2008
*/
HB_FUNC( WXGRID_SETCOLSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int col = hb_parni( 1 );
  int width = hb_parni( 2 );
  if( pSelf && grid )
    grid->SetColSize( col, width );
}

HB_FUNC( WXGRID_SETDEFAULTCOLSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int width = hb_parni(1);
  bool resizeExistingCols = hb_parl( 2 );
  if( pSelf && grid )
    grid->SetDefaultColSize( width, resizeExistingCols );
}

HB_FUNC( WXGRID_SETDEFAULTROWSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int height = hb_parni(1);
  bool resizeExistingRows = hb_parl( 2 );
  if( pSelf && grid )
    grid->SetDefaultRowSize( height, resizeExistingRows );
}

/*
  SetGridCursor
*/
HB_FUNC( WXGRID_SETGRIDCURSOR )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  if( pSelf && grid )
    grid->SetGridCursor( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC( WXGRID_SETROWLABELSIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  int width = hb_parni(1);
  if( pSelf && grid )
    grid->SetRowLabelSize( width );
}

HB_FUNC( WXGRID_SETTABLE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Grid* grid = (wx_Grid *) wxh_ItemListGetWX( pSelf );
  wx_GridTableBase* gridTable = (wx_GridTableBase *) hb_par_WX(1);
  bool takeOwnership = hb_parl(2);
  wxGrid::wxGridSelectionModes selmode = (wxGrid::wxGridSelectionModes) hb_parnl(3);
  if( pSelf && grid )
    grid->SetTable( gridTable, takeOwnership, selmode );
}
