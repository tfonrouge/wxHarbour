/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_FileDialog: Interface
    Teo. Mexico 2008
*/

#include <wx/filedlg.h>

class wx_FileDialog : public wxFileDialog
{
private:
protected:
public:

    wx_FileDialog(wxWindow* parent, const wxString& message = wxT("Choose a file"), const wxString& defaultDir = wxT(""), const wxString& defaultFile = wxT(""), const wxString& wildcard = wxT("*.*"), long style = wxFD_DEFAULT_STYLE, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, const wxString& name = wxT("filedlg") ) : wxFileDialog( parent, message, defaultDir, defaultFile, wildcard, style, pos, size, name ) {};

    ~wx_FileDialog();

};
