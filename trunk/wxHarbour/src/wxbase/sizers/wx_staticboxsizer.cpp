/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_StaticBoxSizer: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_staticboxsizer.h"

/*
  ~wx_StaticBoxSizer
  Teo. Mexico 2006
*/
wx_StaticBoxSizer::~wx_StaticBoxSizer()
{
  wxh_ItemListDel_WX( this );
}

HB_FUNC( WXSTATICBOXSIZER_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_StaticBoxSizer* boxSizer;

  if( ISOBJECT( 1 ) )
  {
    wxStaticBox* staticBox = (wxStaticBox *) hb_par_WX( 1 );
    boxSizer = new wx_StaticBoxSizer( staticBox, hb_parni( 2 ) );
  }
  else
  {
    wxWindow* parent = (wxStaticBox *) hb_par_WX( 2 );
    const wxString& label = wxh_parc( 3 );
    boxSizer = new wx_StaticBoxSizer( hb_parni( 1 ), parent, label );
  }

  // Add object's to hash list
  wxh_ItemListAdd( boxSizer, pSelf );

  hb_itemReturn( pSelf );

}

/*! IMPLEMENT THIS (SEE .prg SOURCE)
  wxStaticBoxSizer::GetStaticBox
  Teo. Mexico 2007
*/
// HB_FUNC( WXSTATICBOXSIZER_GETSTATICBOX )
// {
//   PHB_ITEM pSelf = hb_stackSelfItem();
//   PHB_ITEM pResult = NULL;
//   wx_StaticBoxSizer* sbSizer;
//   wxStaticBox* staticBox;
//
//   if( pSelf && (sbSizer = (wx_StaticBoxSizer *) wxh_ItemListGetWX( pSelf ) ) )
//     pResult = wxh_ItemListGetHB( staticBox );
//
//   if(pResult)
//     hb_itemReturn( pResult );
//   else
//     hb_ret();
// }
