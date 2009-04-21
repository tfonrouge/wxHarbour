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

#include "wxbase/wx_AuiNotebook.h"

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
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_AuiNotebook* auiNotebook;

  if( hb_pcount() )
  {
    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : hb_par_wxPoint( 3 );
    const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : hb_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxAUI_NB_DEFAULT_STYLE : hb_parni( 5 );
    auiNotebook = new wx_AuiNotebook( parent, id, pos, size, style );
  }
  else
    auiNotebook = new wx_AuiNotebook();

  objParams.Return( auiNotebook );
}

/*
  wxAuiNotebook:AddPage
  Teo. Mexico 2007
*/
HB_FUNC( WXAUINOTEBOOK_ADDPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  //const wxBitmap& bitmap = objParam.paramParent( 4 );
  if( auiNotebook )
  {
    wxWindow* page = (wxWindow *) objParams.paramParent( 1 );
    if( page )
    {
      bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
      auiNotebook->AddPage( page, wxh_parc( 2 ), select/*, bitmap*/ );
    }
  }
}

/*
  wxAuiNotebook:DeletePage
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_DELETEPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retl( auiNotebook->DeletePage( hb_parnl( 1 ) ) );
  }
}

/*
  wxAuiNotebook:GetPage
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_itemReturn( wxh_ItemListGet_HB( auiNotebook->GetPage( hb_parnl( 1 ) ) ) );
  }
}

/*
  wxAuiNotebook:GetPageCount
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETPAGECOUNT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retnl( auiNotebook->GetPageCount() );
  }
}

/*
  wxAuiNotebook:GetSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETSELECTION )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retnl( auiNotebook->GetSelection() );
  }
}

/*
  wxAuiNotebook:RemovePage
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_REMOVEPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retl( auiNotebook->RemovePage( hb_parnl( 1 ) ) );
  }
}

/*
  wxAuiNotebook:SetPageText
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_SETPAGETEXT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retl( auiNotebook->SetPageText( hb_parnl( 1 ), wxh_parc( 2 ) ) );
  }
}
/*
  wxAuiNotebook:SetSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_SETSELECTION )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_wxObject();

  if( auiNotebook )
  {
    hb_retnl( auiNotebook->SetSelection( hb_parnl( 1 ) ) );
  }
}
