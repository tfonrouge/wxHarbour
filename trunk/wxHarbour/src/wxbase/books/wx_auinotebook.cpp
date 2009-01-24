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
  wx_AuiNotebook: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/notebook.h"

#include "wxbase/wx_auinotebook.h"

/*
  ~wx_AuiNotebook
  Teo. Mexico 2006
*/
wx_AuiNotebook::~wx_AuiNotebook()
{
  wxh_ItemListDel_WX( this );
}
/*
  wxAuiNotebook:New
  Teo. Mexico 2008
*/
HB_FUNC( WXAUINOTEBOOK_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_AuiNotebook* auiNotebook;
  if( hb_pcount() )
  {
    wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : hb_par_wxPoint( 3 );
    const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : hb_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxAUI_NB_DEFAULT_STYLE : hb_parni( 5 );
    auiNotebook = new wx_AuiNotebook( parent, id, pos, size, style );
  }
  else
    auiNotebook = new wx_AuiNotebook();

  // Add object's to hash list
  wxh_ItemListAdd( auiNotebook, pSelf );

  hb_itemReturn( pSelf );
}

/*
  wxAuiNotebook:AddPage
  Teo. Mexico 2007
*/
HB_FUNC( WXAUINOTEBOOK_ADDPAGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) wxh_ItemListGetWX( pSelf );
  wxWindow* page = (wxWindow *) hb_par_WX( 1 );
  bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
  //const wxBitmap& bitmap = hb_par_WX( 4 );
  if( pSelf && auiNotebook && page )
    auiNotebook->AddPage( page, wxh_parc( 2 ), select/*, bitmap*/ );
}
