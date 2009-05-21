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

#include "wxbase/wx_GridTableBase.h"
#include "wxbase/wx_Grid.h"
#include "wxbase/wx_StaticLine.h"

#include "wx_Browse.h"

HB_FUNC_EXTERN( WXGRIDEVENT);
HB_FUNC_EXTERN( WXKEYEVENT);

BEGIN_EVENT_TABLE( wxhGridBrowse, wxScrolledWindow )
  EVT_KEY_DOWN( wxhGridBrowse::OnKeyDown )
  EVT_SIZE( wxhGridBrowse::OnSize )
  EVT_GRID_SELECT_CELL( wxhGridBrowse::OnSelectCell )
END_EVENT_TABLE()

/*
  OnKeyDown
  Teo. Mexico 2009
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
      PHB_ITEM pKeyEvent = hb_stackReturnItem();
      wxh_ObjParams objParams = wxh_ObjParams( pKeyEvent );

      objParams.Return( &event );

      hb_objSendMsg( pGridBrowse, "OnKeyDown", 1, pKeyEvent );

      wxh_ItemListDel_WX( &event );
    }
  }

  m_inOnKeyDown = false;
}

/*
  OnSelectCell
  Teo. Mexico 2009
*/
void wxhGridBrowse::OnSelectCell( wxGridEvent& gridEvent )
{

  PHB_ITEM pWxhBrowse = wxh_ItemListGet_HB( this );

  if( pWxhBrowse )
  {
    HB_FUNC_EXEC( WXGRIDEVENT );
    PHB_ITEM pGridEvent = hb_stackReturnItem();
    wxh_ObjParams objParams = wxh_ObjParams( pGridEvent );

    objParams.Return( &gridEvent );

    hb_objSendMsg( pWxhBrowse, "OnSelectCell", 1, pGridEvent );

    wxh_ItemListDel_WX( &gridEvent );
  }
  else
    gridEvent.Skip();

}

/*
  OnSize
  Teo. Mexico 2009
*/
void wxhGridBrowse::OnSize( wxSizeEvent& event )
{
  if (m_targetWindow != this)
  {
    PHB_ITEM pGridBrowse = wxh_ItemListGet_HB( this );

    if( pGridBrowse )
    {
      PHB_ITEM pSize = hb_itemNew( NULL );
      hb_arrayNew( pSize, 2 );
      hb_arraySetNI( pSize, 1, event.GetSize().GetWidth() );
      hb_arraySetNI( pSize, 2, event.GetSize().GetHeight() );
      hb_objSendMsg( pGridBrowse, "OnSize", 1, pSize );
      hb_itemRelease( pSize );

      event.Skip();
    }
  }
}

/*
  Constructor: wxhGridBrowse Object
  Teo. Mexico 2009
*/
HB_FUNC( WXHGRIDBROWSE_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxhBrowse* browse = ( wxhBrowse* ) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = wxh_par_wxPoint( 3 );
  wxSize size = wxh_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  const wxString& name = ISNIL( 6 ) ? _T("wxhGridBrowse") : wxh_parc( 6 );

  wxhGridBrowse* gridBrowse = new wxhGridBrowse( browse, id, pos, size, style, name );

  objParams.Return( gridBrowse );
}

/*
  wxhGridBrowse:CalcRowCount
  Teo. Mexico 2009
*/
HB_FUNC( WXHGRIDBROWSE_CALCMAXROWS )
{
  wxhGridBrowse* gridBrowse = (wxhGridBrowse *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  gridBrowse->m_maxRows = 0;

  if( gridBrowse )
  {
    gridBrowse->CalcDimensions();

    wxSize size = gridBrowse->GetGridWindow()->GetSize();

    /* needed to calculate cell row height */
    if( gridBrowse->GetNumberRows() == 0 )
      gridBrowse->AppendRows( 1 );

    gridBrowse->m_gridWindowHeight = size.GetHeight();

    wxRect cellRect( gridBrowse->CellToRect( 0, 0 ) );

    int top,bottom;
    top = cellRect.GetTop();
    bottom = cellRect.GetBottom();

    gridBrowse->m_maxRows = max( 0, ( ( gridBrowse->m_gridWindowHeight - 10 ) / ( bottom - top ) ) - 1 );
  }

  hb_retni( gridBrowse->m_maxRows );
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
  Teo. Mexico 2009
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
  Teo. Mexico 2009
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
  Teo. Mexico 2009
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
  Teo. Mexico 2009
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
  Teo. Mexico 2009
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
