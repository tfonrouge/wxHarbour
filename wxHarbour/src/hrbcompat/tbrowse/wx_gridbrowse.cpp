/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_gridtablebase.h"
#include "wxbase/wx_grid.h"
#include "wxbase/wx_staticline.h"

#include "wx_browse.h"

/*
  Constructor: wxhBrowse Object
  Teo. Mexico 2009
*/
HB_FUNC( WXHGRIDBROWSE_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxhBrowse* browse = ( wxhBrowse* ) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  const wxString& name = ISNIL( 6 ) ? _T("wxhGridBrowse") : wxh_parc( 6 );

  wxhGridBrowse* gridBrowse = new wxhGridBrowse( browse, id, pos, size, style, name );

  objParams.Return( gridBrowse );
}

/*
  wxhGridBrowse:MaxRows
  Teo. Mexico 2009
*/
HB_FUNC( WXHGRIDBROWSE_GETMAXROWS )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( gridBrowse )
  {
    hb_retnl( gridBrowse->m_maxRows );
  }
}

/*
  wxhGridBrowse:RowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHGRIDBROWSE_GETROWCOUNT )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( gridBrowse )
  {
    hb_retnl( gridBrowse->m_rowCount );
  }
}

/*
  wxhGridBrowse:SetColPos
  Teo. Mexico 2008
*/
HB_FUNC( WXHGRIDBROWSE_SETCOLPOS )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  if( gridBrowse )
  {
    int col = hb_parni( 1 ) - 1;
    int row = gridBrowse->GetGridCursorRow();
    gridBrowse->SetGridCursor( row, col );
  }
}

/*
  wxhGridBrowse:SetColWidth
  Teo. Mexico 2008
*/
HB_FUNC( WXHGRIDBROWSE_SETCOLWIDTH )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  if( gridBrowse )
  {
    int col = hb_parni( 1 ) - 1;
    int pointSize = ( gridBrowse->GetCellFont( 0, col ) ).GetPointSize();
    int width = hb_parni( 2 );
    gridBrowse->SetColSize( col, pointSize * width );
  }
}

/*
  wxhGridBrowse:SetRowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHGRIDBROWSE_SETROWCOUNT )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  int rowCount = hb_parni( 1 );
  if( gridBrowse && ( rowCount != gridBrowse->m_rowCount ) )
  {
    if( rowCount > gridBrowse->m_rowCount )
      gridBrowse->AppendRows( rowCount - gridBrowse->m_rowCount );
    else
      gridBrowse->DeleteRows( rowCount - 1, gridBrowse->m_rowCount - rowCount );
    gridBrowse->m_rowCount = rowCount;
  }
}

/*
  wxhGridBrowse:SetRowPos
  Teo. Mexico 2008
*/
HB_FUNC( WXHGRIDBROWSE_SETROWPOS )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  if( gridBrowse )
  {
    int row = hb_parni( 1 );
    int col = gridBrowse->GetGridCursorCol();
    gridBrowse->SetFocus();
    gridBrowse->MakeCellVisible( row - 1, col );
    gridBrowse->SetGridCursor( row - 1, col );
  }
}
