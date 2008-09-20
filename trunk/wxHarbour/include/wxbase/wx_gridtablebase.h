/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_GridTableBase: Interface
  Teo. Mexico 2006
*/

class wx_GridTableBase : public wxGridTableBase
{
private:
protected:
public:
  wx_GridTableBase() : wxGridTableBase() { m_rows = 0; m_cols = 0; }

  ~wx_GridTableBase();

  int m_rows, m_cols;

  int       GetNumberRows();
  int       GetNumberCols();
  wxString  GetValue( int row, int col );
  wxString  GetColLabelValue( int col );
  wxString  GetRowLabelValue( int row );
  bool      IsEmptyCell( int row, int col );
  void      SetValue( int row, int col, const wxString& value );

  virtual bool UpdateRowsCols();

};
