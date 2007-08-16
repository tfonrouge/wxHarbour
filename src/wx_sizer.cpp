/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Sizer: Implementation
  Teo. Mexico 2006
*/

/* C++ Abstract Class */

#include "wx/wx.h"

#include "wxh.h"

#include "wx_sizer.h"

HB_FUNC( WX_SIZER_ADD2 )
{
  wxSizer* sizer = (wxSizer *) hb_par_WX( 1 );
  sizer->Add( (wxWindow *) hb_par_WX( 2 ), hb_parnl(3), hb_parnl(4), hb_parnl(5), (wxObject *) hb_par_WX( 6 ) );
}

HB_FUNC( WX_SIZER_ADD4 )
{
  wxSizer* sizer = (wxSizer *) hb_par_WX( 1 );
  sizer->Add( (wxSizer *) hb_par_WX( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), (wxObject *) hb_par_WX( 6 ) );
}

HB_FUNC( WX_SIZER_ADD5 )
{
  wxSizer* sizer = (wxSizer *) hb_par_WX( 1 );
  sizer->Add( hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), hb_parnl( 6 ), (wxObject *) hb_par_WX( 7 ) );
}

