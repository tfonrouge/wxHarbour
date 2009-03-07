/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_gridtablebase.h"
#include "wxbase/wx_grid.h"
#include "wxbase/wx_staticline.h"

#include "wx_browse.h"

/*
  Constructor: wxhBrowse Object
  Teo. Mexico 2009
*/
HB_FUNC( WXHGRIDBROWSE_NEW )
{
  wxh_ObjParams objParams = wxh_ObjParams();

  wxhBrowse* browse = ( wxhBrowse* ) objParams.paramParent( 1 );
  wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
  wxPoint pos = hb_par_wxPoint( 3 );
  wxSize size = hb_par_wxSize( 4 );
  long style = ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
  const wxString& name = ISNIL( 6 ) ? _T("wxhGridBrowse") : wxh_parc( 6 );

  browse->m_gridBrowse = new wxhGridBrowse( browse, id, pos, size, style, name );

  browse->m_gridBrowse->m_browse = browse;

  objParams.Return( browse->m_gridBrowse );
}
