/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Browse: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_gridtablebase.h"
#include "wxbase/wx_grid.h"
#include "wx_browse.h"

BEGIN_EVENT_TABLE( wxhBrowse, wxScrolledWindow )
    EVT_SIZE( wxhBrowse::OnSize )
END_EVENT_TABLE()

void wxhBrowse::OnSize( wxSizeEvent& WXUNUSED(event) )
{
  if (m_targetWindow != this)
  {
    CalcDimensions();
    CalcRowCount();
  }
}

void wxhBrowse::CalcRowCount()
{
  int nInc,curNumberRows;
  int offs = 0, n = 0;
  wxSize size = GetGridWindow()->GetSize();

  if( size.GetHeight() == m_gridWindowHeight )
    return;

  m_gridWindowHeight = size.GetHeight();

  //cout << endl << "m_gridWindowHeight: " << m_gridWindowHeight;

  BeginBatch();

  do {
    MakeCellVisible( 0, 0 );
    m_rowCount = 0;
    curNumberRows = GetNumberRows();
    for( int i = 0; i < curNumberRows; i++ )
    {
      if( IsVisible( i, 0, true ) )
        m_rowCount++;
    }

    nInc = curNumberRows - m_rowCount;

    if( curNumberRows > (m_rowCount + offs) )
    {
      if( curNumberRows == (m_rowCount + offs + 1) )
        break;
      else
      {
        DeleteRows( curNumberRows - 1, 1 );
        continue;
      }
    }

    if( nInc >= 0 )
    {
      AppendRows( nInc + 1 );
    }

  } while ( ++n < 200 );

  /* this is to fix the real visible rows in case that we have a horz scroll bar */
  if( m_rowCount < GetNumberRows() )
    DeleteRows( m_rowCount - 1, GetNumberRows() - m_rowCount );

  //AppendRows( m_rowCount );

  this->EndBatch();

}

/*
  ~wxhBrowse
  Teo. Mexico 2008
*/
wxhBrowse::~wxhBrowse()
{
  wxh_ItemListDel( this );
}

/*
  Constructor: wxhBrowse Object
  Teo. Mexico 2006
*/
HB_FUNC( WXHBROWSE_WXNEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  wxString name = wxString( hb_parcx( 6 ), wxConvLocal );

  wx_Grid* grid = new wxhBrowse( parent, id, pos, size, style, name );

  // Add object's to hash list
  wxh_ItemListAdd( grid, pSelf );

  hb_itemReturn( pSelf );
}

/*
  RowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_ROWCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int rowCount = 0;
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGetWX( pSelf );
  if( pSelf && browse )
  {
    rowCount = browse->m_rowCount;
  }
  hb_retnl( rowCount );
}
