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

#include "wxbase/wx_HtmlWindow.h"

/*
 ~wx_HtmlWindow
 Teo. Mexico 2010
 */
wx_HtmlWindow::~wx_HtmlWindow()
{
    wxh_ItemListDel_WX( this );
}

/*
 * OnOpeningURL
 */
wxHtmlOpeningStatus wx_HtmlWindow::OnOpeningURL( wxHtmlURLType type, const wxString& url, wxString *redirect )
{
    PHB_ITEM hbType = hb_itemNew( NULL );
    PHB_ITEM hbUrl = hb_itemNew( NULL );
    PHB_ITEM hbRedirect = hb_itemNew( NULL );
    
    hb_itemPutNI( hbType, type );
    hb_itemPutC( hbUrl, url.mb_str() ); 
    hb_itemPutC( hbRedirect, redirect->mb_str() ); 

    hb_objSendMsg( wxh_ItemListGet_HB( this ), "OnOpeningURL", 3, hbType, hbUrl, hbRedirect );

    hb_itemRelease( hbType );
    hb_itemRelease( hbUrl );
    hb_itemRelease( hbRedirect );

    return wxHtmlOpeningStatus( hb_itemGetNI( hb_stackReturnItem() ) );
}

/*
 * New
 */
HB_FUNC( WXHTMLWINDOW_NEW )
{
    wxh_ObjParams objParams = wxh_ObjParams();
    
    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxPoint pos = wxh_par_wxPoint( 3 );
    wxSize size = wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxHW_DEFAULT_STYLE : hb_parnl( 5 );
    wxString name = ISNIL( 6 ) ? _T("htmlWindow") : wxh_parc( 6 );

    objParams.Return( new wx_HtmlWindow( parent, id, pos, size, style, name ) );

}

/*
 * AppendToPage
 */
HB_FUNC( WXHTMLWINDOW_APPENDTOPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->AppendToPage( wxh_parc( 1 ) ) );
    }
}

/*
 * GetOpenedAnchor
 */
HB_FUNC( WXHTMLWINDOW_GETOPENEDANCHOR )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->GetOpenedAnchor() );
    }
}

/*
 * GetOpenedPage
 */
HB_FUNC( WXHTMLWINDOW_GETOPENEDPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->GetOpenedPage() );
    }
}

/*
 * GetRelatedFrame
 */
HB_FUNC( WXHTMLWINDOW_GETRELATEDFRAME )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_itemReturn( htmlWindow->GetRelatedFrame() );
    }
}

/*
 * HistoryBack
 */
HB_FUNC( WXHTMLWINDOW_HISTORYBACK )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryBack() );
    }
}

/*
 * HistoryCanBack
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCANBACK )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryCanBack() );
    }
}

/*
 * HistoryCanForward
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCANFORWARD )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryCanForward() );
    }
}

/*
 * HistoryClear
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCLEAR )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->HistoryClear();
    }
}

/*
 * HistoryForward
 */
HB_FUNC( WXHTMLWINDOW_HISTORYFORWARD )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryForward() );
    }
}

/*
 * LoadPage
 */
HB_FUNC( WXHTMLWINDOW_LOADPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->LoadPage( wxh_parc( 1 ) ) );
    }
}

/*
 * SetPage
 */
HB_FUNC( WXHTMLWINDOW_SETPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) wxh_ItemListGet_WX( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->SetPage( wxh_parc( 1 ) ) );
    }
}

