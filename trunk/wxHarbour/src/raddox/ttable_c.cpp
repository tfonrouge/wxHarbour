/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxh.h"

#define SND_BUFFERSIZE  1000

/*
  TTable:SendToServer
  Teo. Mexico 2008
*/
HB_FUNC( TTABLE_SENDTOSERVER )
{
  char pBuffer[ SND_BUFFERSIZE ];
  ULONG bufSize;
  hb_procname( 1, pBuffer, FALSE );
  bufSize = strlen( pBuffer ) + 1;

  int iPCount = hb_pcount();

  if( iPCount )
  {
    ULONG ulSize;
    for( int i = 1; i <= iPCount; i++ )
    {
      ulSize = hb_serializeItem( hb_param( i, HB_IT_ANY ) );
    }
  }

  cout << pBuffer << "@" << endl;
}