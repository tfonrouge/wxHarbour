/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_Bitmap: Implementation
 Teo. Mexico 2009
 */

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Bitmap.h"

/*
 ~wx_Bitmap
 Teo. Mexico 2009
 */
wx_Bitmap::~wx_Bitmap()
{
  wxh_ItemListDel_WX( this );
}

/*
 New
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();
  
  wx_Bitmap* bitmap;
  
  switch( hb_pcount() )
  {
	case 0 :
    {
      bitmap = new wx_Bitmap();
    }
	  break;
	case 1 :
    {
      char * bits = hb_parc( 1 );
      bitmap = new wx_Bitmap( &bits );
    }
	  break;
	case 2:
    {
      const wxString& name = wxh_parc( 1 );
      long type = hb_parnl( 2 );	  
      bitmap = new wx_Bitmap( name, type );
    }
	  break;
	default :
	  bitmap = new wx_Bitmap();
	  break;
  }
  
  objParams.Return( bitmap );
}

/*
 wxBitmap:AddHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_ADDHANDLER )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	bitmap->AddHandler( (wxBitmapHandler *) wxh_par_WX( 1 ) );
  }
}

/*
 wxBitmap:CleanUpHandlers
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_CLEANUPHANDLERS )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	bitmap->CleanUpHandlers();
  }
}

/*
 wxBitmap:ConvertToImage
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_CONVERTTOIMAGE )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	wxImage image = bitmap->ConvertToImage();
	wxh_itemReturn( &image );
  }
}

/*
 wxBitmap:CopyFromIcon
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_COPYFROMICON )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	const wxIcon& icon = *(wxIcon *) wxh_par_WX( 1 );
    hb_retl( bitmap->CopyFromIcon( icon ) );
  }
}

/*
 wxBitmap:GetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETDEPTH )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    hb_retni( bitmap->GetDepth() );
  }
}

/*
 wxBitmap:GetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETHEIGHT )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    hb_retni( bitmap->GetHeight() );
  }
}

/*
 wxBitmap:GetMask
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETMASK )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    wxh_itemReturn( bitmap->GetMask() );
  }
}

/*
 wxBitmap:GetPalette
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETPALETTE )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    wxh_itemReturn( bitmap->GetPalette() );
  }
}

/*
 wxBitmap:GetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_GETWIDTH )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    hb_retni( bitmap->GetWidth() );
  }
}

/*
 wxBitmap:InitStandardHandlers
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_INITSTANDARDHANDLERS )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    bitmap->InitStandardHandlers();
  }
}

/*
 wxBitmap:InsertHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_INSERTHANDLER )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	bitmap->InsertHandler( (wxBitmapHandler *) wxh_par_WX( 1 ) );
  }
}

/*
 wxBitmap:IsOk
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_ISOK )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    hb_retl( bitmap->IsOk() );
  }
}

/*
 wxBitmap:LoadFile
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_LOADFILE )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    if( HB_ISNIL( 2 ) )
      hb_retl( bitmap->LoadFile( wxh_parc( 1 ) ) );
    else
      hb_retl( bitmap->LoadFile( wxh_parc( 1 ), wxBitmapType( hb_parni( 2 ) ) ) );
  }
}

/*
 wxBitmap:RemoveHandler
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_REMOVEHANDLER )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    hb_retl( bitmap->RemoveHandler( wxh_parc( 1 ) ) );
  }
}

/*
 wxBitmap:SaveFile
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SAVEFILE )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	wxPalette *palette = ISNIL( 3 ) ? NULL : (wxPalette *) wxh_par_WX( 3 );
    hb_retl( bitmap->SaveFile( wxh_parc( 1 ), (wxBitmapType) hb_parni( 2 ), palette ) );
  }
}

/*
 wxBitmap:SetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETDEPTH )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    bitmap->SetDepth( hb_parni( 1 ) );
  }
}

/*
 wxBitmap:SetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETHEIGHT )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    bitmap->SetHeight( hb_parni( 1 ) );
  }
}

/*
 wxBitmap:SetMask
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETMASK )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    bitmap->SetMask( (wxMask *) wxh_par_WX( 1 ) );
  }
}

/*
 wxBitmap:SetPalette
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETPALETTE )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
	const wxPalette& palette = * (wxPalette *) wxh_par_WX( 1 );
    bitmap->SetPalette( palette );
  }
}

/*
 wxBitmap:SetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAP_SETWIDTH )
{
  wxBitmap* bitmap = (wxBitmap *) wxh_ItemListGet_WX( hb_stackSelfItem() );
  
  if( bitmap )
  {
    bitmap->SetWidth( hb_parni( 1 ) );
  }
}
