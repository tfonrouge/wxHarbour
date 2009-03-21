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
    wxh_ObjParams objParams = wxh_ObjParams( pGridEvent );

    objParams.Return( &gridEvent );

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

  if( GetTable() == NULL )
    return;

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
  if( pBrowseTableBase )
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
    PHB_ITEM pGridBrowse = wxh_ItemListGet_HB( this );
    if( pGridBrowse )
    {
      HB_FUNC_EXEC( WXKEYEVENT );
      PHB_ITEM pKeyEvent = hb_itemNew( hb_stackReturnItem() );
      wxh_ObjParams objParams = wxh_ObjParams( pKeyEvent );

      objParams.Return( &event );

      hb_objSendMsg( pGridBrowse, "OnKeyDown", 1, pKeyEvent );

      wxh_ItemListDel_WX( &event );
      hb_itemRelease( pKeyEvent );

    }

  }

  m_inOnKeyDown = false;
}
