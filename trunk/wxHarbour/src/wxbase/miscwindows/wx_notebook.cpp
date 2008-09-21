/*
 * $Id: cgi.prg 7769 2007-09-23 02:45:29Z tfonrouge $
 */

/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Notebook: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/notebook.h"

#include "wxbase/wx_notebook.h"

/*
  ~wx_Notebook
  Teo. Mexico 2006
*/
wx_Notebook::~wx_Notebook()
{
  wx_ObjList_wxDelete( this );
}
/*
  wxNotebook(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxString& name = wxNotebookNameStr)
  */

HB_FUNC( WXNOTEBOOK_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_Notebook* noteBook;
  if( hb_pcount() )
  {
    wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : hb_par_wxPoint( 3 );
    const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : hb_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? 0 : hb_parnl( 5 );
    const wxString& name = ISNIL( 6 ) ? wxNotebookNameStr : wxString( hb_parcx( 6 ), wxConvLocal );
    noteBook = new wx_Notebook( parent, id, pos, size, style, name );
  }
  else
    noteBook = new wx_Notebook();

  // Add object's to hash list
  wx_ObjList_New( noteBook, pSelf );

  hb_itemReturn( pSelf );
}

/*
  wxNotebook:AddPage
  Teo. Mexico 2007
*/
HB_FUNC( WXNOTEBOOK_ADDPAGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxNotebook* Notebook = (wxNotebook *) wx_ObjList_wxGet( pSelf );
  wxNotebookPage* page = (wxNotebookPage *) hb_par_WX( 1 );
  bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
  int imageld = ISNIL( 4 ) ? -1 : hb_parni( 4 );
  if( pSelf && Notebook && page )
    Notebook->AddPage( page, wxString( hb_parcx( 2 ), wxConvLocal), select, imageld );
}
