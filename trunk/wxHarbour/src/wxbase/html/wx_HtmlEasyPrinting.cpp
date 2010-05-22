/*
 * $Id$
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_HtmlEasyPrinting: Implementation
 Teo. Mexico 2010
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_HtmlEasyPrinting.h"

/*
 ~wx_HtmlEasyPrinting
 Teo. Mexico 2010
 */
wx_HtmlEasyPrinting::~wx_HtmlEasyPrinting()
{
	wxh_ItemListDel_WX( this );
}

/*
 wxHtmlEasyPrinting:New
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_NEW )
{
	wxh_ObjParams objParams = wxh_ObjParams();
	
	const wxString& name = ISNIL( 1 ) ? wxString( _T("Printing") ) : wxh_parc( 1 );
	wxWindow* parent = (wxWindow *) objParams.paramParent( 2 );

	objParams.Return( new wx_HtmlEasyPrinting( name, parent ) );
}

/*
 GetParentWindow
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_GETPARENTWINDOW )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		wxh_itemReturn( htmlEasyPrinting->GetParentWindow() );
	}
}

/*
 GetPrintData
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_GETPRINTDATA )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		wxh_itemReturn( htmlEasyPrinting->GetPrintData() );
	}
}

/*
 GetPageSetupData
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_GETPAGESETUPDATA )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		wxh_itemReturn( htmlEasyPrinting->GetPageSetupData() );
	}
}

/*
 PreviewFile
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_PREVIEWFILE )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		hb_retl( htmlEasyPrinting->PreviewFile( wxh_parc( 1 ) ) );
	}
}

/*
 PreviewText
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_PREVIEWTEXT )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		hb_retl( htmlEasyPrinting->PreviewText( wxh_parc( 1 ), wxh_parc( 2 ) ) );
	}
}

/*
 PrintFile
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_PRINTFILE )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		hb_retl( htmlEasyPrinting->PrintFile( wxh_parc( 1 ) ) );
	}
}

/*
 PrintText
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_PRINTTEXT )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		hb_retl( htmlEasyPrinting->PrintText( wxh_parc( 1 ), wxh_parc( 2 ) ) );
	}
}

/*
 PageSetup
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_PAGESETUP )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		htmlEasyPrinting->PageSetup();
	}
}

/*
 SetFonts
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_SETFONTS )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		const int len = 7;
		const int* sizes = NULL;
		int aInt[ len ] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL };
		
		if( hb_pcount() > 2 )
		{
			wxh_par_arrayInt( 3, &aInt[ 0 ], len );
			sizes = &aInt[ 0 ];
		}

		htmlEasyPrinting->SetFonts( wxh_parc( 1 ), wxh_parc( 2 ), sizes );
	}
}

/*
 SetHeader
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_SETHEADER )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		htmlEasyPrinting->SetHeader( wxh_parc( 1 ), hb_parni( 2 ) );
	}
}

/*
 SetFooter
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_SETFOOTER )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		htmlEasyPrinting->SetFooter( wxh_parc( 1 ), hb_parni( 2 ) );
	}
}

/*
 SetParentWindow
 Teo. Mexico 2010
 */
HB_FUNC( WXHTMLEASYPRINTING_SETPARENTWINDOW )
{
	wxHtmlEasyPrinting* htmlEasyPrinting = (wxHtmlEasyPrinting *) wxh_ItemListGet_WX( hb_stackSelfItem() );
	
	if( htmlEasyPrinting )
	{
		htmlEasyPrinting->SetParentWindow( (wxWindow *) wxh_par_WX( 1 ) );
	}
}
