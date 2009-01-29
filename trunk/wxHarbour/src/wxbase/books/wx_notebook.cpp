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
  wxh_ItemListDel_WX( this );
}
/*
  wxNotebook(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxString& name = wxNotebookNameStr)
  */

HB_FUNC( WXNOTEBOOK_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wx_Notebook* noteBook;

  if( hb_pcount() )
  {
    wxWindow* parent = (wxWindow *) wxh_param_WX_Parent( 1, &wxhScopeList );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : hb_par_wxPoint( 3 );
    const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : hb_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? 0 : hb_parnl( 5 );
    const wxString& name = ISNIL( 6 ) ? wxNotebookNameStr : wxh_parc( 6 );
    noteBook = new wx_Notebook( parent, id, pos, size, style, name );
  }
  else
    noteBook = new wx_Notebook();

  // Add object's to hash list
  //wxh_ItemListAdd( noteBook, pSelf );
  wxhScopeList.PushObject( noteBook );

  hb_itemReturn( pSelf );
}

/*
  wxNotebook:AddPage
  Teo. Mexico 2007
*/
HB_FUNC( WXNOTEBOOK_ADDPAGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  WXH_SCOPELIST wxhScopeList = WXH_SCOPELIST( pSelf );

  wxNotebook* Notebook = (wxNotebook *) wxh_ItemListGet_WX( pSelf );
  wxNotebookPage* page = (wxNotebookPage *) wxh_param_WX_Parent( 1, &wxhScopeList );

  if( Notebook && page )
  {
    bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
    int imageld = ISNIL( 4 ) ? -1 : hb_parni( 4 );
    Notebook->AddPage( page, wxh_parc( 2 ), select, imageld );
  }
}
