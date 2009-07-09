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
  wx_Notebook: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/notebook.h"

#include "wxbase/wx_Notebook.h"

/*
  ~wx_Notebook
  Teo. Mexico 2009
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
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_Notebook* noteBook;

  if( hb_pcount() )
  {
    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
    const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? 0 : hb_parnl( 5 );
    const wxString& name = ISNIL( 6 ) ? _T("noteBook") : wxh_parc( 6 );
    noteBook = new wx_Notebook( parent, id, pos, size, style, name );
  }
  else
    noteBook = new wx_Notebook();

  objParams.Return( noteBook );
}

/*
  wxNotebook:AddPage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ADDPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxNotebookPage* page = (wxNotebookPage *) objParams.paramParent( 1 );
    if( page )
    {
      bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
      int imageld = ISNIL( 4 ) ? -1 : hb_parni( 4 );
      hb_retl( noteBook->AddPage( page, wxh_parc( 2 ), select, imageld ) );
    }
  }
}

/*
  wxNotebook:AdvanceSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ADVANCESELECTION )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    bool forward = ISNIL( 1 ) ? true : hb_parl( 1 );
    noteBook->AdvanceSelection( forward );
  }
}

/*
  wxNotebook:AssignImageList
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ASSIGNIMAGELIST )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxImageList *imageList = (wxImageList *) objParams.param( 1 );
    if( imageList )
    {
      noteBook->AssignImageList( imageList );
    }
  }
}

/*
  wxNotebook:ChangeSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_CHANGESELECTION )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retni( noteBook->ChangeSelection( hb_parni( 1 ) ) );
  }
}

/*
  wxNotebook:DeleteAllPages
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_DELETEALLPAGES )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retl( noteBook->DeleteAllPages() );
  }
}

/*
  wxNotebook:DeletePage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_DELETEPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retl( noteBook->DeletePage( hb_parni( 1 ) ) );
  }
}

/*
  wxNotebook:GetCurrentPage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETCURRENTPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxh_itemReturn( noteBook->GetCurrentPage() );
  }
}

/*
  wxNotebook:GetImageList
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETIMAGELIST )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    /* TODO: Check why it's neccesary to cast to wxObject* */
    wxh_itemReturn( (wxObject *) noteBook->GetImageList() );
  }
}

/*
  wxNotebook:GetPage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxh_itemReturn( noteBook->GetPage( hb_parni( 1 ) ) );
  }
}

/*
  wxNotebook:GetPageCount
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGECOUNT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retni( noteBook->GetPageCount() );
  }
}

/*
  wxNotebook:GetPageImage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGEIMAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retni( noteBook->GetPageImage( hb_parni( 1 ) ) );
  }
}

/*
  wxNotebook:GetPageText
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGETEXT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxh_retc( noteBook->GetPageText( hb_parni( 1 ) ) );
  }
}

/*
  wxNotebook:GetRowCount
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETROWCOUNT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retni( noteBook->GetRowCount() );
  }
}

/*
  wxNotebook:GetSelection
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETSELECTION )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retni( noteBook->GetSelection() );
  }
}

/*
  wxNotebook:GetThemeBackgroundColour
  Teo. Mexico 2009
*/
// HB_FUNC( WXNOTEBOOK_GETTHEMEBACKGROUNDCOLOUR )
// {
//   wxh_ObjParams objParams = wxh_ObjParams();
//
//   wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();
//
//   if( noteBook )
//   {
//     hb_itemReturn( wxh_ItemListGet_HB( noteBook->GetThemeBackgroundColour() ) );
//   }
// }

/*
  wxNotebook:HitTest
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_HITTEST )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    long flags;
    hb_retni( noteBook->HitTest( wxh_par_wxPoint( 1 ), &flags ) );
    if( ( hb_pcount() == 2 ) && ISBYREF( 2 ) )
      hb_stornl( flags, 2 );
  }
}

/*
  wxNotebook:InsertPage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_INSERTPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxNotebookPage* page = (wxNotebookPage *) objParams.paramParent( 2 );
    if( page )
    {
      bool select = ISNIL( 4 ) ? false : hb_parl( 4 );
      int imageld = ISNIL( 5 ) ? -1 : hb_parni( 5 );
      hb_retl( noteBook->InsertPage( hb_parnl( 1 ), page, wxh_parc( 3 ), select, imageld ) );
    }
  }
}

/*
  wxNotebook:RemovePage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_REMOVEPAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retl( noteBook->RemovePage( hb_parnl( 1 ) ) );
  }
}

/*
  wxNotebook:SetImageList
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETIMAGELIST )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    wxImageList *imageList = (wxImageList *) objParams.param( 1 );
    if( imageList )
    {
      noteBook->SetImageList( imageList );
    }
  }
}

/*
  wxNotebook:SetPadding
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPADDING )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    noteBook->SetPadding( wxh_par_wxSize( 1 ) );
  }
}

/*
  wxNotebook:SetPageSize
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGESIZE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    noteBook->SetPageSize( wxh_par_wxSize( 1 ) );
  }
}

/*
  wxNotebook:SetPageImage
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGEIMAGE )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retl( noteBook->SetPageImage( hb_parnl( 1 ), hb_parni( 2 ) ) );
  }
}

/*
  wxNotebook:SetPageText
  Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGETEXT )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxNotebook* noteBook = (wxNotebook *) objParams.Get_wxObject();

  if( noteBook )
  {
    hb_retl( noteBook->SetPageText( hb_parnl( 1 ), wxh_parc( 2 ) ) );
  }
}
