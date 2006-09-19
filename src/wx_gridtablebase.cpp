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

#include "wx_gridtablebase.h"

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
  static PHB_SYMB pSymb = hb_dynsymFindName("GetNumberCols")->pSymbol;
  return hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 0 )->item.asInteger.value;
}

/*
  GetNumberRows
  Teo. Mexico 2006
*/
int wx_GridTableBase::GetNumberRows()
{
  static PHB_SYMB pSymb = hb_dynsymFindName("GetNumberRows")->pSymbol;
  return hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 0 )->item.asInteger.value;
}

/*
  GetNumberCols
  Teo. Mexico 2006
*/
wxString wx_GridTableBase::GetValue( int row, int col )
{
  static PHB_SYMB pSymb = hb_dynsymFindName("GetValue")->pSymbol;
  return wxString( hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) )->item.asString.value, wxConvLocal );
}

/*
  IsEmptyCell
  Teo. Mexico 2006
*/
bool wx_GridTableBase::IsEmptyCell( int row, int col )
{
  static PHB_SYMB pSymb = hb_dynsymFindName("IsEmptyCell")->pSymbol;
  return hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 2, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ) )->item.asLogical.value;
}

wxString wx_GridTableBase::GetColLabelValue( int col )
{
  static PHB_SYMB pSymb = hb_dynsymFindName("GetColLabelValue")->pSymbol;
  return wxString( hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 1, hb_itemPutNI( NULL, col ) )->item.asString.value, wxConvLocal );
}

wxString wx_GridTableBase::GetRowLabelValue( int row )
{
  static PHB_SYMB pSymb = hb_dynsymFindName("GetRowLabelValue")->pSymbol;
  return wxString( hb_objSendSymbol( wx_ObjList_hbGet( this ), pSymb, 1, hb_itemPutNI( NULL, row ) )->item.asString.value, wxConvLocal );
}

/*
  SetValue
  Teo. Mexico 2006
*/
void wx_GridTableBase::SetValue( int row, int col, const wxString& value )
{
  static PHB_SYMB pSymb = hb_dynsymFindName("SetValue")->pSymbol;
  //hb_objSendSymbol( xHObj, pSymb, 3, hb_itemPutNI( NULL, row ), hb_itemPutNI( NULL, col ), value );
}

extern "C"
{

  HB_FUNC( WXGRIDTABLEBASE_NEW ) {
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

}








