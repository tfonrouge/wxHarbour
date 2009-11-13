/*
 * $Id$
 */

/*
	wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

	This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	(C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
	wx_SearchCtrl: Interface
	Teo. Mexico 2009
*/

#include <wx/srchctrl.h>

class wx_SearchCtrl : public wxSearchCtrl
{
private:
protected:
public:
	wx_SearchCtrl() : wxSearchCtrl() {}

	wx_SearchCtrl(wxWindow* parent, wxWindowID id, const wxString& value = _T(""), const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxValidator& validator = wxDefaultValidator, const wxString& name = wxSearchCtrlNameStr) : wxSearchCtrl( parent, id, value, pos, size, style, validator, name ) {}

	~wx_SearchCtrl();
};
