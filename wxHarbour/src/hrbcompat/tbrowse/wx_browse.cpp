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

HB_FUNC_EXTERN( WXGRIDEVENT);
HB_FUNC_EXTERN( WXKEYEVENT);

BEGIN_EVENT_TABLE( wxhGridBrowse, wxScrolledWindow )
  EVT_KEY_DOWN( wxhGridBrowse::OnKeyDown )
  EVT_SIZE( wxhGridBrowse::OnSize )
END_EVENT_TABLE()

BEGIN_EVENT_TABLE( wxhBrowse, wx_Panel )
  EVT_GRID_SELECT_CELL( wxhBrowse::OnSelectCell )
END_EVENT_TABLE()

/*
  ~wxhBrowse
  Teo. Mexico 2008
*/
wxhBrowse::~wxhBrowse()
{
  wxh_ItemListDel_WX( this->m_gridBrowse );
  wxh_ItemListDel_WX( this );
}

/*
  OnSelectCell
  Teo. Mexico 2008
*/
void wxhBrowse::OnSelectCell( wxGridEvent& gridEvent )
{

  PHB_ITEM pWxhBrowse = wxh_ItemListGet_HB( this );

  if( pWxhBrowse )
  {
    HB_FUNC_EXEC( WXGRIDEVENT );
    PHB_ITEM pGridEvent = hb_itemNew( hb_stackReturnItem() );
    WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pGridEvent );

    wxhScopeList.PushObject( &gridEvent );

    hb_objSendMsg( pWxhBrowse, "OnSelectCell", 1, pGridEvent );

    wxh_ItemListDel_WX( &gridEvent );
    hb_itemRelease( pGridEvent );
  }
  else
    gridEvent.Skip();

}

/*
  CalcRowCount
  Teo. Mexico 2008
*/
void wxhGridBrowse::CalcRowCount()
{

  wxSize size = GetGridWindow()->GetSize();

  if( size.GetHeight() == m_gridWindowHeight )
    return;

  /* needed to calculate cell row height */
  if( GetNumberRows() == 0 )
    AppendRows( 1 );

  m_gridWindowHeight = size.GetHeight();

  wxRect cellRect( CellToRect( 0, 0 ) );

  int top,bottom;
  top = cellRect.GetTop();
  bottom = cellRect.GetBottom();

  m_rowCount = max( 0, ( (m_gridWindowHeight - 10) / ( bottom - top ) ) - 1 );

  // TODO: Need to calculate the exact rows available
//   if( m_rowCount > 0 )
//   {
//     MakeCellVisible( 0, GetGridCursorCol() );
//     if( !IsVisible( m_rowCount - 1, 0, false ) )
//       --m_rowCount;
//   }

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

  m_maxRows = GetNumberRows();

  PHB_ITEM pBrowseTableBase = wxh_ItemListGet_HB( this->GetTable() );
  if( pBrowseTableBase && hb_itemType( pBrowseTableBase ) == HB_IT_OBJECT )
    hb_objSendMsg( pBrowseTableBase, "FillGridBuffer", 0 );
  else
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 1, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );

}

/*
  OnSize
  Teo. Mexico 2008
*/
void wxhGridBrowse::OnSize( wxSizeEvent& WXUNUSED(event) )
{
  if (m_targetWindow != this)
  {
    CalcDimensions();
    CalcRowCount();
  }
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
    //wxFAIL_MSG( wxT("wxhGridBrowse::OnKeyDown called while already active") );
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

    /* process event on our hbclass wxhBrowse:OnKeyDown, returns true if processed */
    PHB_ITEM pWxhBrowse = wxh_ItemListGet_HB( this->m_browse );
    if( pWxhBrowse )
    {
      HB_FUNC_EXEC( WXKEYEVENT );
      PHB_ITEM pKeyEvent = hb_itemNew( hb_stackReturnItem() );
      WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pKeyEvent );

      wxhScopeList.PushObject( &event );

      hb_objSendMsg( pWxhBrowse, "OnKeyDown", 1, pKeyEvent );

      hb_itemRelease( pKeyEvent );

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
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxhBrowse Object
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_WXNEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList1 = WXH_SCOPELIST( pSelf );

  /* get harbour params */
  PHB_ITEM pGridBrowse = hb_param( 1, HB_IT_OBJECT );
  WXH_SCOPELIST wxhScopeList2 = WXH_SCOPELIST( pGridBrowse );

//   wx_GridTableBase *tableBase = (wx_GridTableBase *) wxh_param_WX_Parent( 2, &wxhScopeList2 );

  wxWindow* parent = (wxWindow *) wxh_param_WX_Parent( 3, &wxhScopeList1 );

  wxWindowID id = ISNIL( 4 ) ? wxID_ANY : hb_parni( 4 );
  const wxString &label = wxh_parc( 5 );
  wxPoint pos = hb_par_wxPoint( 6 );
  wxSize size = hb_par_wxSize( 7 );
  long style = ISNIL( 8 ) ? wxWANTS_CHARS : hb_parnl( 8 );
  wxString name = wxh_parc( 9 );

  /* the main window container */
  wxhBrowse *browse = new wxhBrowse( parent, wxID_ANY, pos, size, wxTAB_TRAVERSAL, name );

  /* the browse window controls: sizer, browse, scrollbar */
  wxBoxSizer *boxSizer;
  if( ISNIL( 5 ) )
    boxSizer = new wxBoxSizer( wxHORIZONTAL );
  else
    boxSizer = new wxStaticBoxSizer( wxHORIZONTAL, browse, label );

  browse->SetSizer( boxSizer );
  browse->m_gridBrowse = new wxhGridBrowse( browse, id, wxDefaultPosition, wxDefaultSize, style, _T("wxhGridBrowse") );
  boxSizer->Add( browse->m_gridBrowse, 1, wxGROW | wxALL, 5 );
  wxStaticLine* staticLine = new wxStaticLine( browse, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxLI_VERTICAL );
  boxSizer->Add( staticLine, 0, wxGROW, 5 );
  wxScrollBar* scrollBar = new wxScrollBar( browse, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxSB_VERTICAL );
  scrollBar->SetScrollbar(0, 1, 100, 1);
  boxSizer->Add( scrollBar, 0, wxGROW | wxLEFT | wxRIGHT, 5 );

//   if( tableBase )
//     browse->m_gridBrowse->SetTable( tableBase, true );

  browse->m_gridBrowse->m_browse = browse;

  wxhScopeList1.PushObject( browse );
  wxhScopeList2.PushObject( browse->m_gridBrowse );

  hb_itemReturn( pSelf );
}

/*
  GetMaxRows
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_GETMAXROWS )
{
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  int rowCount = 0;

  if( browse )
  {
    rowCount = browse->m_gridBrowse->m_maxRows;
  }

  hb_retnl( rowCount );
}

/*
  GetRowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_GETROWCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int rowCount = 0;
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( pSelf );
  if( pSelf && browse )
  {
    rowCount = browse->m_gridBrowse->m_rowCount;
  }
  hb_retnl( rowCount );
}

/*
  SetColPos
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_SETCOLPOS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( pSelf );
  int col = hb_parni( 1 );
  if( pSelf && browse )
  {
    int row = browse->m_gridBrowse->GetGridCursorRow();
    browse->m_gridBrowse->SetGridCursor( row, col - 1 );
  }
}

/*
  SetColWidth
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_SETCOLWIDTH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( pSelf );
  int col = hb_parni( 1 ) - 1;
  int width = hb_parni( 2 );
  if( pSelf && browse )
  {
    int pointSize = ( browse->m_gridBrowse->GetCellFont( 0, col ) ).GetPointSize();
    browse->m_gridBrowse->SetColSize( col, pointSize * width );
  }
}

/*
  SetRowCount
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_SETROWCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int rowCount = hb_parni( 1 );
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( pSelf );
  if( pSelf && browse && ( rowCount != browse->m_gridBrowse->m_rowCount ) )
  {
    if( rowCount > browse->m_gridBrowse->m_rowCount )
      browse->m_gridBrowse->AppendRows( rowCount - browse->m_gridBrowse->m_rowCount );
    else
      browse->m_gridBrowse->DeleteRows( rowCount - 1, browse->m_gridBrowse->m_rowCount - rowCount );
    browse->m_gridBrowse->m_rowCount = rowCount;
  }
}

/*
  SetRowPos
  Teo. Mexico 2008
*/
HB_FUNC( WXHBROWSE_SETROWPOS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxhBrowse* browse = (wxhBrowse *) wxh_ItemListGet_WX( pSelf );
  int row = hb_parni( 1 );

  if( pSelf && browse )
  {
    int col = browse->m_gridBrowse->GetGridCursorCol();
    browse->m_gridBrowse->SetFocus();
    browse->m_gridBrowse->MakeCellVisible( row - 1, col );
    browse->m_gridBrowse->SetGridCursor( row - 1, col );
  }
  hb_ret();
}
