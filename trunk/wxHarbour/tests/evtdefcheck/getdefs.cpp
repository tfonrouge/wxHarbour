/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxh.h"

#include <map>

//WX_DECLARE_STRING_HASH_MAP( int, MAP_DEFS );

static map<string, int> map_defs;

/*
  fill_map_defs
  Teo. Mexico 2009
*/
void fill_map_defs()
{
  map_defs[ "wxEVT_COMMAND_SPINCTRL_UPDATED" ] = wxEVT_COMMAND_SPINCTRL_UPDATED;
  map_defs[ "wxEVT_SOCKET" ] = wxEVT_SOCKET;
  map_defs[ "wxEVT_TIMER" ] = wxEVT_TIMER;
  map_defs[ "wxEVT_IDLE" ] = wxEVT_IDLE;
  map_defs[ "wxEVT_GRID_COL_MOVE" ] = wxEVT_GRID_COL_MOVE;
  map_defs[ "wxEVT_DETAILED_HELP" ] = wxEVT_DETAILED_HELP;
  map_defs[ "wxEVT_KILL_FOCUS" ] = wxEVT_KILL_FOCUS;
}

/*
  wxh_GetwxDef
  Teo. Mexico 2009
*/
HB_FUNC( WXH_GETWXDEF )
{
  map<string, int>::iterator it;

  if( map_defs.size() == 0 )
    fill_map_defs();

  string key = hb_parc( 1 );

  it = map_defs.find( key );

  if( it != map_defs.end() )
  {
    hb_retni( it->second );
  }
}