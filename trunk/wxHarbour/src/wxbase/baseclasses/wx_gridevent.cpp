/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_GridEvent: Implementation
  Teo. Mexico 2008
*/

#include "wx/wx.h"

#include "wxh.h"

/*
  GetCol
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDEVENT_GETCOL )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxGridEvent *gridEvent = (wxGridEvent *) wxh_ItemListGet_WX( pSelf );

  if( gridEvent )
    hb_retni( gridEvent->GetCol() );
}

/*
  GetRow
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDEVENT_GETROW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxGridEvent *gridEvent = (wxGridEvent *) wxh_ItemListGet_WX( pSelf );

  if( gridEvent )
    hb_retni( gridEvent->GetRow() );
  else
    hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 1, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
  Selecting
  Teo. Mexico 2008
*/
HB_FUNC( WXGRIDEVENT_SELECTING )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxGridEvent *gridEvent = (wxGridEvent *) wxh_ItemListGet_WX( pSelf );

  if( gridEvent )
    hb_retl( gridEvent->Selecting() );
}
