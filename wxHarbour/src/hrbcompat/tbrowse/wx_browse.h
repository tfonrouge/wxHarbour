/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxbase/wx_panel.h"

/* forward class declararion */
class wxhBrowse;
class wxGridSelection;

/*
  wxhGridBrowse : Interface
  Teo. Mexico 2008
*/
class wxhGridBrowse : public wx_Grid
{
private:
  DECLARE_EVENT_TABLE()
  void OnKeyDown( wxKeyEvent& );
  void OnSize( wxSizeEvent& );
  void OnSelectCell( wxGridEvent& );
protected:
  wxGridSelection  *m_selection;
public:
  wxhGridBrowse() : wx_Grid() { m_rowCount = 0; m_gridWindowHeight = -1; }
  wxhGridBrowse( wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxWANTS_CHARS, const wxString& name = _T("wxhGridBrowse") ) : wx_Grid( parent, id, pos, size, style, name ) { m_rowCount = 0; m_gridWindowHeight = -1; }

  int m_gridWindowHeight;
  int m_rowCount;
  int m_maxRows;

  void CalcRowCount();

//   ~wxhGridBrowse();
};

/*
  wxhBrowse
  Teo. Mexico 2008
*/
class wxhBrowse : public wx_Panel
{
private:
//   DECLARE_EVENT_TABLE()
//   void OnSelectCell( wxGridEvent& );
protected:
public:
  wxhBrowse() : wx_Panel() {}
  wxhBrowse( wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxTAB_TRAVERSAL, const wxString& name = _T("wxhBrowse") ) : wx_Panel( parent, id, pos, size, style, name ) {}

//   ~wxhBrowse();
};
