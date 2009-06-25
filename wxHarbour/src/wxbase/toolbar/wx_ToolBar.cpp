/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_ToolBar: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ToolBar.h"

/*
  ~wx_ToolBar
  Teo. Mexico 2009
*/
wx_ToolBar::~wx_ToolBar()
{
  wxh_ItemListDel_WX( this );
}

HB_FUNC( WXTOOLBAR_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  const wxPoint& pos = wxh_par_wxPoint( 4 );
  const wxSize& size = wxh_par_wxSize( 5 );
  long style = hb_parnl( 6 );
  const wxString& name = wxh_parc( 8 );

  wx_ToolBar* toolBar = new wx_ToolBar( parent, id, pos, size, style, name );

  objParams.Return( toolBar );
}

/*
  wxToolBar:AddControl
  Teo. Mexico 2009
*/
HB_FUNC( WXTOOLBAR_ADDCONTROL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );

  if( toolBar )
    wxh_itemReturn( toolBar->AddControl( (wxControl *) wxh_par_WX( 1 ) ) );
}

/*
 wxToolBar:AddSeparator
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDSEPARATOR )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	toolBar->AddSeparator();
}

/*
 wxToolBar:AddTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDTOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	if( hb_pcount() == 1 )
	{
	  wxh_itemReturn( toolBar->AddTool( (wxToolBarToolBase *) wxh_par_WX( 1 ) ) );
	}
	else if( hb_pcount() > 5 || ISOBJECT( 4 ) )
	{
	  const wxBitmap& bitmap1 = * (wxBitmap *) wxh_par_WX( 3 );
	  const wxBitmap& bitmap2 = ISNIL( 4 ) ? wxNullBitmap : * (wxBitmap *) wxh_par_WX( 4 );
	  wxItemKind kind = ISNIL( 5 ) ? wxITEM_NORMAL : (wxItemKind) hb_parni( 5 );
	  wxh_itemReturn( toolBar->AddTool( hb_parni( 1 ), wxh_parc( 2 ), bitmap1, bitmap2, kind, wxh_parc( 6 ), wxh_parc( 7 ), wxh_par_WX( 8 ) ) );
	}
	else
	{
	  const wxBitmap& bitmap1 = * (wxBitmap *) wxh_par_WX( 3 );
	  wxItemKind kind = ISNIL( 5 ) ? wxITEM_NORMAL : (wxItemKind) hb_parni( 5 );
	  wxh_itemReturn( toolBar->AddTool( hb_parni( 1 ), wxh_parc( 2 ), bitmap1, wxh_parc( 4 ), kind ) );
	}
  }
}

/*
 wxToolBar:AddCheckTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDCHECKTOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	wxh_itemReturn( toolBar->AddCheckTool( hb_parni( 1 ), wxh_parc( 2 ), * (wxBitmap *) wxh_par_WX( 3 ), * (wxBitmap *) wxh_par_WX( 4 ), wxh_parc( 5 ), wxh_parc( 6 ), wxh_par_WX( 7 ) ) );
}

/*
 wxToolBar:AddRadioTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDRADIOTOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	wxh_itemReturn( toolBar->AddRadioTool( hb_parni( 1 ), wxh_parc( 2 ), * (wxBitmap *) wxh_par_WX( 3 ), * (wxBitmap *) wxh_par_WX( 4 ), wxh_parc( 5 ), wxh_parc( 6 ), wxh_par_WX( 7 ) ) );
}

/*
 wxToolBar:ClearTools
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_CLEARTOOLS )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	toolBar->ClearTools();
}

/*
 wxToolBar:DeleteTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_DELETETOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	hb_retl( toolBar->DeleteTool( hb_parni( 1 ) ) );
}

/*
 wxToolBar:DeleteToolByPos
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_DELETETOOLBYPOS )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	hb_retl( toolBar->DeleteToolByPos( hb_parnl( 1 ) ) );
}

/*
 wxToolBar:EnableTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ENABLETOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	toolBar->EnableTool( hb_parni( 1 ), hb_parl( 2 ) );
}

/*
 wxToolBar:FindById
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDBYID )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	wxh_itemReturn( toolBar->FindById( hb_parni( 1 ) ) );
}

/*
 wxToolBar:FindControl
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDCONTROL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	wxh_itemReturn( toolBar->FindById( hb_parni( 1 ) ) );
}

/*
 wxToolBar:FindToolForPosition
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDTOOLFORPOSITION )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	wxh_itemReturn( toolBar->FindToolForPosition( hb_parni( 1 ), hb_parni( 2 ) ) );
}

/*
 wxToolBar:GetToolsCount
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSCOUNT )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
	hb_parni( toolBar->GetToolsCount() );
}

/*
 wxToolBar:GetToolSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSIZE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxSize size = toolBar->GetToolSize();
	wxh_ret_wxSize( &size );
  }
}

/*
 wxToolBar:GetToolBitmapSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLBITMAPSIZE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxSize size = toolBar->GetToolBitmapSize();
	wxh_ret_wxSize( &size );
  }
}

/*
 wxToolBar:GetMargins
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETMARGINS )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxSize size = toolBar->GetMargins();
	wxh_ret_wxSize( &size );
  }
}

/*
 wxToolBar:GetToolClientData
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLCLIENTDATA )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_itemReturn( toolBar->GetToolClientData( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:GetToolEnabled
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLENABLED )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retl( toolBar->GetToolEnabled( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:GetToolLongHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLLONGHELP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_retc( toolBar->GetToolLongHelp( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:GetToolPacking
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLPACKING )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retni( toolBar->GetToolPacking() );
  }
}

/*
 wxToolBar:GetToolPos
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLPOS )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retni( toolBar->GetToolPos( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:GetToolSeparation
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSEPARATION )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retni( toolBar->GetToolSeparation() );
  }
}

/*
 wxToolBar:GetToolShortHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSHORTHELP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_retc( toolBar->GetToolShortHelp( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:GetToolState
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSTATE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retl( toolBar->GetToolState( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:InsertControl
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_INSERTCONTROL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_itemReturn( toolBar->InsertControl( hb_parnl( 1 ), (wxControl *) wxh_par_WX( 2 ) ) );
  }
}

/*
 wxToolBar:InsertSeparator
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_INSERTSEPARATOR )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_itemReturn( toolBar->InsertSeparator( hb_parnl( 1 ) ) );
  }
}

/*
 wxToolBar:InsertTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_INSERTTOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	if( ISOBJECT( 2 ) )
	{
	  wxh_itemReturn( toolBar->InsertTool( hb_parnl( 1 ), (wxToolBarToolBase *) wxh_par_WX( 2 ) ) );
	}
	else if( hb_pcount() > 2 )
	{
	  const wxBitmap& bitmap2 = ISNIL( 4 ) ? wxNullBitmap : * (wxBitmap *) wxh_par_WX( 4 );
	  bool isToggle = ISLOG( 5 ) ? false : hb_parl( 5 );
	  wxh_itemReturn( toolBar->InsertTool( hb_parnl( 1 ), hb_parni( 2 ), * (wxBitmap *) wxh_par_WX( 3 ), bitmap2, isToggle, wxh_par_WX( 6 ), wxh_parc( 7 ), wxh_parc( 8 ) ) );
	}
  }
}

/*
 wxToolBar:OnLeftClick
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ONLEFTCLICK )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retl( toolBar->OnLeftClick( hb_parni( 1 ), hb_parl( 2 ) ) );
  }
}

/*
 wxToolBar:OnMouseEnter
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ONMOUSEENTER )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->OnMouseEnter( hb_parni( 1 ) );
  }
}

/*
 wxToolBar:OnRightClick
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ONRIGHTCLICK )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->OnRightClick( hb_parni( 1 ), hb_parnd( 2 ), hb_parnd( 3 ) );
  }
}

/*
 wxToolBar:Realize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_REALIZE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	hb_retl( toolBar->Realize() );
  }
}

/*
 wxToolBar:RemoveTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_REMOVETOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	wxh_itemReturn( toolBar->RemoveTool( hb_parni( 1 ) ) );
  }
}

/*
 wxToolBar:SetBitmapResource
 Teo. Mexico 2009
 */
#ifdef __WXWINCE__
HB_FUNC( WXTOOLBAR_SETBITMAPRESOURCE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetBitmapResource( hb_parni( 1 ) );
  }
}
#endif

/*
 wxToolBar:SetMargins
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETMARGINS )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	if( hb_pcount() == 2 )
	{
	  toolBar->SetMargins( hb_parni( 1 ), hb_parni( 2 ) );
	}
	else if( hb_pcount() == 1 )
	{
	  toolBar->SetMargins( wxh_par_wxSize( 1 ) );
	}
  }
}

/*
 wxToolBar:SetToolBitmapSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLBITMAPSIZE )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolBitmapSize( wxh_par_wxSize( 1 ) );
  }
}

/*
 wxToolBar:SetToolClientData
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLCLIENTDATA )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolClientData( hb_parni( 1 ), wxh_par_WX( 1 ) );
  }
}

/*
 wxToolBar:SetToolDisabledBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLDISABLEDBITMAP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolDisabledBitmap( hb_parni( 1 ), * (wxBitmap *) wxh_par_WX( 1 ) );
  }
}

/*
 wxToolBar:SetToolLongHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLLONGHELP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolLongHelp( hb_parni( 1 ), wxh_parc( 2 ) );
  }
}

/*
 wxToolBar:SetToolPacking
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLPACKING )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolPacking( hb_parni( 1 ) );
  }
}

/*
 wxToolBar:SetToolShortHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLSHORTHELP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolShortHelp( hb_parni( 1 ), wxh_parc( 2 ) );
  }
}

/*
 wxToolBar:SetToolNormalBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLNORMALBITMAP )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolNormalBitmap( hb_parni( 1 ), * (wxBitmap *) wxh_par_WX( 1 ) );
  }
}

/*
 wxToolBar:SetToolSeparation
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLSEPARATION )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->SetToolSeparation( hb_parni( 1 ) );
  }
}

/*
 wxToolBar:ToggleTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_TOGGLETOOL )
{
  wxToolBar* toolBar = (wxToolBar *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( toolBar )
  {
	toolBar->ToggleTool( hb_parni( 1 ), hb_parl( 2 ) );
  }
}
