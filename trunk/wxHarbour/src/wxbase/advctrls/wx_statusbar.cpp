/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_StatusBar: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_statusbar.h"

/*
  ~wx_StatusBar
  Teo. Mexico 2006
*/
wx_StatusBar::~wx_StatusBar()
{
  wxh_ItemListDel_WX( this );
}

/*
  Constructor: wxStatusBar Object
  Teo. Mexico 2006
*/
HB_FUNC( WXSTATUSBAR_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
  wxWindowID id = (wxWindowID) hb_parni( 2 );
  long style = ISNIL( 3 ) ? wxST_SIZEGRIP : hb_parnl( 3 );
  const wxString& name = ISNIL( 4 ) ? _T("statusBar") : wxString( hb_parcx( 4 ), wxConvLocal );

  wx_StatusBar* statusBar = new wx_StatusBar( parent, id, style, name );

  // Add object's to hash list
  //wxh_ItemListAdd( statusBar, pSelf, objParams );
  objParams.PushObject( statusBar );

  hb_itemReturn( objParams.pSelf );

}

/*
  SetFieldsCount: message
  Teo. Mexico 2006
*/
HB_FUNC( WXSTATUSBAR_SETFIELDSCOUNT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_StatusBar* statusBar = (wx_StatusBar *) wxh_ItemListGet_WX( pSelf );

  int number = hb_parni(1);
  int* widths = NULL;

  if(ISARRAY(2) && hb_arrayLen( hb_param( 2, HB_IT_ARRAY ) ))
  {
    PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
    int* aInt = new int[ hb_arrayLen( pArray ) ];
    for( unsigned int i=0; i < hb_arrayLen( pArray ); i++ )
      aInt[i] = hb_arrayGetItemPtr( pArray, i+1 )->item.asInteger.value;
    widths = aInt;
    //if( pSelf && statusBar ) statusBar->SetFieldsCount( number, widths );
  }
  //else
    //if( pSelf && statusBar ) statusBar->SetFieldsCount( number, widths );
  if( pSelf && statusBar )
    statusBar->SetFieldsCount( number, widths );

  /* TODO: Check if this frees correctly the array */
  delete[] widths;

}

/*
  SetStatusText
  Teo. Mexico 2008
*/
HB_FUNC( WXSTATUSBAR_SETSTATUSTEXT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_StatusBar* statusBar = (wx_StatusBar *) wxh_ItemListGet_WX( pSelf );

  const wxString& text = wxString( hb_parcx( 1 ), wxConvLocal );
  int i = hb_parni( 2 );

  if( pSelf && statusBar )
    statusBar->SetStatusText( text, i );
}
