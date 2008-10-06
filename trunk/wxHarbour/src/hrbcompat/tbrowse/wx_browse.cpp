/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_gridtablebase.h"
#include "wxbase/wx_grid.h"
#include "wxbase/wx_staticline.h"

#include "wx_browse.h"

BEGIN_EVENT_TABLE( wxhGridBrowse, wxScrolledWindow )
    EVT_SIZE( wxhGridBrowse::OnSize )
    EVT_KEY_DOWN( wxhGridBrowse::OnKeyDown )
END_EVENT_TABLE()

/*
  ~wxhBrowse
  Teo. Mexico 2008
*/
wxhBrowse::~wxhBrowse()
{
  wxh_ItemListDel( this );
}

void wxhGridBrowse::OnSize( wxSizeEvent& WXUNUSED(event) )
{
  if (m_targetWindow != this)
  {
//     cout << endl << "wxhGridBrowse::OnSize...";
    CalcDimensions();
    CalcRowCount();
  }
}

void wxhGridBrowse::CalcRowCount()
{
  wxSize size = GetGridWindow()->GetSize();

  if( size.GetHeight() == m_gridWindowHeight )
    return;

//   EnableScrolling( false, false );
  Scroll( 0, 0 );

  m_gridWindowHeight = size.GetHeight();

  BeginBatch();

  if( GetNumberRows() == 0 )
    AppendRows( 1 );

  //SetScrollbars(0, 0, 0, 0, true );
  wxRect cellRect( CellToRect( 0, 0 ) );

  int top,bottom;
  top = cellRect.GetTop();
  bottom = cellRect.GetBottom();

//   cout << endl << "m_gridWindowHeight : " << m_gridWindowHeight;
//   cout << endl << "               top : " << top;
//   cout << endl << "            bottom : " << bottom;

  m_rowCount = (int) floor( ( (m_gridWindowHeight - 10) / ( bottom - top ) ) ) - 1;

//   cout << endl << "m_rowCount           : " << m_rowCount;
//   cout << endl;

  if( m_rowCount == GetNumberRows() )
    return;

  if( m_rowCount > 0 )
  {
    if( m_rowCount < GetNumberRows() )
      DeleteRows( m_rowCount - 1, GetNumberRows() - m_rowCount );
    else
      AppendRows( m_rowCount - GetNumberRows() );
  }
  else
    DeleteRows( 0, GetNumberRows() );

  EndBatch();

}

/*
  OnKeyDown
  Teo. Mexico 2008
*/
void wxhGridBrowse::OnKeyDown( wxKeyEvent& event )
{
    if ( m_inOnKeyDown )
    {
        // shouldn't be here - we are going round in circles...
        //
        wxFAIL_MSG( wxT("wxGrid::OnKeyDown called while already active") );
    }

    m_inOnKeyDown = true;

    // propagate the event up and see if it gets processed
    wxWindow *parent = GetParent();
    wxKeyEvent keyEvt( event );
    keyEvt.SetEventObject( parent );

    if ( !parent->GetEventHandler()->ProcessEvent( keyEvt ) )
    {
        if (GetLayoutDirection() == wxLayout_RightToLeft)
        {
            if (event.GetKeyCode() == WXK_RIGHT)
                event.m_keyCode = WXK_LEFT;
            else if (event.GetKeyCode() == WXK_LEFT)
                event.m_keyCode = WXK_RIGHT;
        }

        // try local handlers
        switch ( event.GetKeyCode() )
        {
            case WXK_UP:
                if ( event.ControlDown() )
                    MoveCursorUpBlock( event.ShiftDown() );
                else
                    MoveCursorUp( event.ShiftDown() );
                break;

            case WXK_DOWN:
                if ( event.ControlDown() )
                    MoveCursorDownBlock( event.ShiftDown() );
                else
                    MoveCursorDown( event.ShiftDown() );
                break;

            case WXK_LEFT:
                if ( event.ControlDown() )
                    MoveCursorLeftBlock( event.ShiftDown() );
                else
                    MoveCursorLeft( event.ShiftDown() );
                break;

            case WXK_RIGHT:
                if ( event.ControlDown() )
                    MoveCursorRightBlock( event.ShiftDown() );
                else
                    MoveCursorRight( event.ShiftDown() );
                break;

            case WXK_RETURN:
            case WXK_NUMPAD_ENTER:
                if ( event.ControlDown() )
                {
                    event.Skip();  // to let the edit control have the return
                }
                else
                {
                    if ( GetGridCursorRow() < GetNumberRows()-1 )
                    {
                        MoveCursorDown( event.ShiftDown() );
                    }
                    else
                    {
                        // at the bottom of a column
                        DisableCellEditControl();
                    }
                }
                break;

            case WXK_ESCAPE:
                ClearSelection();
                break;

            case WXK_TAB:
                if (event.ShiftDown())
                {
                    if ( GetGridCursorCol() > 0 )
                    {
                        MoveCursorLeft( false );
                    }
                    else
                    {
                        // at left of grid
                        DisableCellEditControl();
                    }
                }
                else
                {
                    if ( GetGridCursorCol() < GetNumberCols() - 1 )
                    {
                        MoveCursorRight( false );
                    }
                    else
                    {
                        // at right of grid
                        DisableCellEditControl();
                    }
                }
                break;

            case WXK_HOME:
                if ( event.ControlDown() )
                {
                    MakeCellVisible( 0, 0 );
                    SetCurrentCell( 0, 0 );
                }
                else
                {
                    event.Skip();
                }
                break;

            case WXK_END:
                if ( event.ControlDown() )
                {
                    MakeCellVisible( m_numRows - 1, m_numCols - 1 );
                    SetCurrentCell( m_numRows - 1, m_numCols - 1 );
                }
                else
                {
                    event.Skip();
                }
                break;

            case WXK_PAGEUP:
                MovePageUp();
                break;

            case WXK_PAGEDOWN:
                MovePageDown();
                break;

            case WXK_SPACE:
//                 if ( event.ControlDown() )
//                 {
//                     if ( m_selection )
//                     {
//                         m_selection->ToggleCellSelection(
//                             m_currentCellCoords.GetRow(),
//                             m_currentCellCoords.GetCol(),
//                             event.ControlDown(),
//                             event.ShiftDown(),
//                             event.AltDown(),
//                             event.MetaDown() );
//                     }
//                     break;
//                 }

                if ( !IsEditable() )
                    MoveCursorRight( false );
                else
                    event.Skip();
                break;

            default:
                event.Skip();
                break;
        }
    }

    m_inOnKeyDown = false;
}

/*
  ~wxhGridBrowse
  Teo. Mexico 2008
*/
wxhGridBrowse::~wxhGridBrowse()
{
  wxh_ItemListDel( this );
}

/*
  Constructor: wxhBrowse Object
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_WXNEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase *tableBase = (wx_GridTableBase *) hb_par_WX( 1 );
  wxWindow* parent = (wxWindow *) hb_par_WX( 2 );
  wxWindowID id = ISNIL( 3 ) ? wxID_ANY : hb_parni( 3 );
  wxPoint pos = hb_par_wxPoint( 4 );
  wxSize size = hb_par_wxSize( 5 );
  long style = ISNIL( 6 ) ? wxWANTS_CHARS : hb_parnl( 6 );
  wxString name = wxString( hb_parcx( 7 ), wxConvLocal );

  wxhBrowse *browse = new wxhBrowse( parent, wxID_ANY, pos, size, wxTAB_TRAVERSAL, name );

  wxBoxSizer *boxSizer = new wxBoxSizer( wxHORIZONTAL );
  browse->SetSizer( boxSizer );
  browse->m_gridBrowse = new wxhGridBrowse( browse, id, wxDefaultPosition, wxDefaultSize, style, _T("wxhGridBrowse") );
  boxSizer->Add( browse->m_gridBrowse, 1, wxGROW|wxALL, 5 );
  wxStaticLine* staticLine = new wxStaticLine( browse, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxLI_VERTICAL );
  boxSizer->Add( staticLine, 0, wxGROW, 5 );
  wxScrollBar* scrollBar = new wxScrollBar( browse, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxSB_VERTICAL );
  scrollBar->SetScrollbar(0, 1, 100, 1);
  boxSizer->Add( scrollBar, 0, wxGROW|wxLEFT|wxRIGHT, 5 );

  if( tableBase )
    browse->m_gridBrowse->SetTable( tableBase, true );

  browse->m_gridBrowse->m_browse = browse;

  // Add object's to hash list
  wxh_ItemListAdd( browse, pSelf );

  hb_itemReturn( pSelf );
}

/*
  Initialize
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_INITIALIZE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGetWX( pSelf );
  wxSizeEvent event;
  if( pSelf && browse )
  {
    browse->OnSize( event );
    browse->m_gridBrowse->CalcRowCount();
  }
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
    rowCount = browse->m_gridBrowse->m_rowCount;
  }
  hb_retnl( rowCount );
}

/*
  SetRowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_SETROWCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int rowCount = hb_parni( 1 );
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGetWX( pSelf );
  if( pSelf && browse && ( rowCount != browse->m_gridBrowse->m_rowCount ) )
  {
    if( rowCount > browse->m_gridBrowse->m_rowCount )
      browse->m_gridBrowse->AppendRows( rowCount - browse->m_gridBrowse->m_rowCount );
    else
      browse->m_gridBrowse->DeleteRows( rowCount - 1, browse->m_gridBrowse->m_rowCount - rowCount );
    browse->m_gridBrowse->m_rowCount = rowCount;
  }
}
