/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_GridTableBase: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wx/generic/gridctrl.h"
#include "wxh.h"

#include "wxbase/wx_grid.h"
#include "wxbase/wx_gridtablebase.h"

/*
  ~wx_GridTableBase
  Teo. Mexico 2006
*/
wx_GridTableBase::~wx_GridTableBase()
{
  wx_ObjList_wxDelete( this );
}

/*
  GetNumberCols
  Teo. Mexico 2006
*/
int wx_GridTableBase::GetNumberCols()
{
  static PHB_DYNS pDyns = hb_dynsymFindName("GetNumberCols");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 0 );
  return hb_stackReturnItem()->item.asInteger.value;
#else
  return hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 0 )->item.asInteger.value;
#endif
}

/*
  GetNumberRows
  Teo. Mexico 2006
*/
int wx_GridTableBase::GetNumberRows()
{
  static PHB_DYNS pDyns = hb_dynsymFindName("GetNumberRows");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 0 );
  return hb_stackReturnItem()->item.asInteger.value;
#else
  return hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 0 )->item.asInteger.value;
#endif
}

/*
  GetNumberCols
  Teo. Mexico 2006
*/
wxString wx_GridTableBase::GetValue( int row, int col )
{
  static PHB_DYNS pDyns = hb_dynsymFindName("GetValue");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) );
  return wxString( hb_stackReturnItem()->item.asString.value, wxConvLocal );
#else
  return wxString( hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) )->item.asString.value, wxConvLocal );
#endif
}

/*
  IsEmptyCell
  Teo. Mexico 2006
*/
bool wx_GridTableBase::IsEmptyCell( int row, int col )
{
  static PHB_DYNS pDyns = hb_dynsymFindName("IsEmptyCell");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) );
  return hb_stackReturnItem()->item.asLogical.value;
#else
  return hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) )->item.asLogical.value;
#endif
}

wxString wx_GridTableBase::GetColLabelValue( int col )
{
  static PHB_DYNS pDyns = hb_dynsymFindName("GetColLabelValue");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 1, hb_itemPutNI( NULL, col ) );
  return wxString( hb_stackReturnItem()->item.asString.value, wxConvLocal );
#else
  return wxString( hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 1, hb_itemPutNI( NULL, col ) )->item.asString.value, wxConvLocal );
#endif
}

wxString wx_GridTableBase::GetRowLabelValue( int row )
{
  static PHB_DYNS pDyns = hb_dynsymFindName("GetRowLabelValue");
#ifdef __XHARBOUR__
  hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 1, hb_itemPutNI( NULL, row ) );
  return wxString( hb_stackReturnItem()->item.asString.value, wxConvLocal );
#else
  return wxString( hb_objSendMessage( wx_ObjList_hbGet( this ), pDyns, 1, hb_itemPutNI( NULL, row ) )->item.asString.value, wxConvLocal );
#endif
}

/*
  SetValue
  Teo. Mexico 2006
*/
void wx_GridTableBase::SetValue( int row, int col, const wxString& value )
{
  PHB_ITEM hbRow = hb_itemNew( NULL );
  PHB_ITEM hbCol = hb_itemNew( NULL );
  PHB_ITEM hbStr = hb_itemNew( NULL );

  hb_itemPutNI( hbRow, row );
  hb_itemPutNI( hbCol, col );
  hb_itemPutC( hbStr, value.mb_str() );

  hb_objSendMsg( wx_ObjList_hbGet( this ), "SetValue", 3, hbRow, hbCol, hbStr );
}

HB_FUNC( WXGRIDTABLEBASE_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable = new wx_GridTableBase;

  // Add object's to hash list
  wx_ObjList_New( gridTable, pSelf );

  hb_itemReturn( pSelf );
}

HB_FUNC( WXGRIDTABLEBASE_SETCOLLABELVALUE )
{
  ((wx_GridTableBase *) hb_stackSelfItem())->SetColLabelValue( hb_parnl(1), wxString( hb_parcx(2), wxConvLocal ) );
}

/*
  AppendCols
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDTABLEBASE_APPENDCOLS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable;
  size_t numCols = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  if( pSelf && (gridTable = (wx_GridTableBase *) wx_ObjList_wxGet( pSelf ) ) )
  {
    hb_retl( gridTable->AppendCols( numCols ) );
    gridTable->UpdateRowsCols();
  }
  else
    hb_ret();
}

/*
  AppendRows
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDTABLEBASE_APPENDROWS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable;
  size_t numRows = ISNIL( 1 ) ? 1 : hb_parni( 1 );
  if( pSelf && (gridTable = (wx_GridTableBase *) wx_ObjList_wxGet( pSelf ) ) )
  {
    hb_retl( gridTable->AppendRows( numRows ) );
    gridTable->UpdateRowsCols();
  }
  else
    hb_ret();
}

/*
  GetView
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDTABLEBASE_GETVIEW )
{
  PHB_ITEM pReturn = NULL, pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable;
  wx_Grid* grid;
  if( pSelf && (gridTable = (wx_GridTableBase *) wx_ObjList_wxGet( pSelf ) ) &&
        (grid = (wx_Grid *) gridTable->GetView()) )
    pReturn = wx_ObjList_hbGet( grid );

  if(pReturn)
    hb_itemReturn( pReturn );
  else
    hb_ret();
}

/*
  InsertCols
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDTABLEBASE_INSERTCOLS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable;
  size_t pos = ISNIL( 1 ) ? 0 : hb_parni(1);
  size_t numCols = ISNIL( 2 ) ? 1 : hb_parni(2);
  if( pSelf && (gridTable = (wx_GridTableBase *) wx_ObjList_wxGet( pSelf ) ) )
  {
    hb_retl( gridTable->InsertCols( pos, numCols ) );
    gridTable->UpdateRowsCols();
  }
  else
    hb_ret();
}

/*
  InsertRows
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDTABLEBASE_INSERTROWS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_GridTableBase* gridTable;
  size_t pos = ISNIL( 1 ) ? 0 : hb_parni(1);
  size_t numRows = ISNIL( 2 ) ? 1 : hb_parni(2);
  if( pSelf && (gridTable = (wx_GridTableBase *) wx_ObjList_wxGet( pSelf ) ) )
  {
    hb_retl( gridTable->InsertRows( pos, numRows ) );
    gridTable->UpdateRowsCols();
  }
  else
    hb_ret();
}

bool wx_GridTableBase::UpdateRowsCols()
{
     bool updated = FALSE;
     int rows = GetNumberRows();
     int cols = GetNumberCols();

     if (rows > m_rows)
     {
         if ( GetView() )
         {
             wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_ROWS_INSERTED,
                                     0, rows - m_rows );

             GetView()->ProcessTableMessage( msg );
             updated = TRUE;
         }
     }
     else if (rows < m_rows)
     {
         if ( GetView() )
         {
             wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_ROWS_DELETED,
                                     0, m_rows - rows );

             GetView()->ProcessTableMessage( msg );
             updated = TRUE;
         }
     }

     if (cols > m_cols)
     {
         if ( GetView() )
         {
             wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_COLS_INSERTED,
                                     0, cols - m_cols );

             GetView()->ProcessTableMessage( msg );
             updated = TRUE;
         }
     }
     else if (cols < m_cols)
     {
         if ( GetView() )
         {
             wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_COLS_DELETED,
                                     0, m_cols - cols );

             GetView()->ProcessTableMessage( msg );
             updated = TRUE;
         }
     }

     m_rows = rows;
     m_cols = cols;
     return updated;
}
