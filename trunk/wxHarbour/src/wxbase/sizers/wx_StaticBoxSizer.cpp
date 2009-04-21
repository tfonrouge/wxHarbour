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
  wxh_ObjParams objParams = wxh_ObjParams();

  wx_StaticBoxSizer* boxSizer;

  if( ISOBJECT( 1 ) )
  {
    wxStaticBox* staticBox = (wxStaticBox *) objParams.paramParent( 1 );
    boxSizer = new wx_StaticBoxSizer( staticBox, hb_parni( 2 ) );
  }
  else
  {
    wxWindow* parent = (wxStaticBox *) objParams.paramParent( 2 );
    const wxString& label = wxh_parc( 3 );
    boxSizer = new wx_StaticBoxSizer( hb_parni( 1 ), parent, label );
  }

  objParams.Return( boxSizer );
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
//   if( pSelf && (sbSizer = (wx_StaticBoxSizer *) wxh_ItemListGet_WX( pSelf ) ) )
//     pResult = wxh_ItemListGet_HB( staticBox );
//
//   if(pResult)
//     hb_itemReturn( pResult );
//   else
//     hb_ret();
// }
