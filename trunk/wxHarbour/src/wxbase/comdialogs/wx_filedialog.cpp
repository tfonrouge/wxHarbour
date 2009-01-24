/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_filedialog.h"

/*
  ~wxFileDialog
  Teo. Mexico 2008
*/
wx_FileDialog::~wx_FileDialog()
{
  wxh_ItemListDel_WX( this );
}

/*
  wxFileDialog
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxWindow* parent = (wxWindow *) hb_par_WX( 1 );
  const wxString& message = ISNIL( 2 ) ? _T("Choose a file") : wxh_parc( 2 );
  const wxString& defaultDir = ISNIL( 3 ) ? _T("") : wxh_parc( 3 );
  const wxString& defaultFile = ISNIL( 4 ) ? _T("") : wxh_parc( 4 );
  const wxString& wildcard = ISNIL( 5 ) ? _T("*.*") : wxh_parc( 5 );
  long style = ISNIL( 6 )  ? wxFD_DEFAULT_STYLE : hb_parni( 6 );
  wxPoint pos = hb_par_wxPoint( 7 );
  wxSize size = hb_par_wxSize( 8 );
  const wxString& name = ISNIL( 9 ) ? _T("FileDlg") : wxh_parc( 9 );

  wxFileDialog* fileDlg = new wx_FileDialog( parent, message, defaultDir, defaultFile, wildcard, style, pos, size, name );

  // Add object's to hash list
  wxh_ItemListAdd( fileDlg, pSelf );

  hb_itemReturn( pSelf );

}

/*
  GetDirectory
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETDIRECTORY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retc( fileDlg->GetDirectory().mb_str() );
  else
    hb_ret();
}

/*
  GetFilename
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILENAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retc( fileDlg->GetFilename().mb_str() );
  else
    hb_ret();
}

/*
  GetFilenames
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILENAMES )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );
  wxArrayString filenames;

  if( pSelf && fileDlg )
  {
    PHB_ITEM pResult = hb_itemArrayNew( 0 );
    fileDlg->GetFilenames( filenames );
    size_t count = filenames.GetCount();
    if( hb_arraySize( pResult, count ) )
    {
      for( size_t n = 0; n < count; n++ )
      {
        hb_itemPutC( hb_arrayGetItemPtr( pResult, n + 1 ), filenames[ n ].mb_str() );
      }
      hb_itemReturnRelease( pResult );
      return;
    }
    hb_itemRelease( pResult );
  }
  hb_ret();
}

/*
  GetFilterIndex
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILTERINDEX )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retni( fileDlg->GetFilterIndex() );
  else
    hb_ret();
}

/*
  GetMessage
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETMESSAGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retc( fileDlg->GetMessage().mb_str() );
  else
    hb_ret();
}

/*
  GetPath
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETPATH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retc( fileDlg->GetPath().mb_str() );
  else
    hb_ret();
}

/*
  GetPaths
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETPATHS )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );
  wxArrayString paths;

  if( pSelf && fileDlg )
  {
    PHB_ITEM pResult = hb_itemArrayNew( 0 );
    fileDlg->GetPaths( paths );
    size_t count = paths.GetCount();
    if( hb_arraySize( pResult, count ) )
    {
      for( size_t n = 0; n < count; n++ )
      {
        hb_itemPutC( hb_arrayGetItemPtr( pResult, n + 1 ), paths[ n ].mb_str() );
      }
      hb_itemReturnRelease( pResult );
      return;
    }
    hb_itemRelease( pResult );
  }
  hb_ret();
}

/*
  GetWildcard
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETWILDCARD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retc( fileDlg->GetWildcard().mb_str() );
  else
    hb_ret();
}

/*
  SetDirectory
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETDIRECTORY )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& directory = wxh_parc( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetDirectory( directory );
}

/*
  SetFilename
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETFILENAME )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& filename = wxh_parc( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetFilename( filename );
}

/*
  SetFilterIndex
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETFILTERINDEX )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  int filterIndex = hb_parni( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetFilterIndex( filterIndex );
}

/*
  SetMessage
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETMESSAGE )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& message = wxh_parc( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetMessage( message );
}

/*
  SetPath
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETPATH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& path = wxh_parc( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetPath( path );
}

/*
  SetWildcard
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETWILDCARD )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  const wxString& wildcard = wxh_parc( 1 );
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    fileDlg->SetWildcard( wildcard );
}

/*
  ShowModal
  Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SHOWMODAL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxFileDialog* fileDlg = (wxFileDialog *) wxh_ItemListGetWX( pSelf );

  if( pSelf && fileDlg )
    hb_retni( fileDlg->ShowModal() );
  else
    hb_ret();
}
