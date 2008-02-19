/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_BoxSizer: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wx_boxsizer.h"

/*
  ~wx_BoxSizer
  Teo. Mexico 2006
*/
wx_BoxSizer::~wx_BoxSizer()
{
  wx_ObjList_wxDelete( this );
}

HB_FUNC( WXBOXSIZER_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wx_BoxSizer* boxSizer = new wx_BoxSizer( hb_parni( 1 ) );

  // Add object's to hash list
  wx_ObjList_New( boxSizer, pSelf );

  hb_itemReturn( pSelf );

}

/*
  wxTextCtrl:GetValue
  Teo. Mexico 2007
*/
HB_FUNC( WXBOXSIZER_GETORIENTATION )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxBoxSizer* boxSizer;
  if ( pSelf && (boxSizer = (wxBoxSizer *) wx_ObjList_wxGet( pSelf ) ) )
    hb_retni( boxSizer->GetOrientation() );
  else
    hb_retni( 0 );
}
