/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxh.h
  Teo. Mexico 2006
*/

extern "C"
{
#include "hbvmopt.h"
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbapicls.h"
#include "hbvm.h"
#include "hbstack.h"
}

wxObject*     hb_par_WX( int param );
wxPoint       hb_par_wxPoint( int param );
wxSize        hb_par_wxSize( int param );
//void          SetxHObj( unsigned int* ptr, PHB_ITEM xHObjFrom, PHB_ITEM* xHObjTo );

void          wx_ObjList_New( wxObject* wxObj, PHB_ITEM pSelf );
void          wx_ObjList_wxDelete( wxObject* wxObj );
PHB_ITEM      wx_ObjList_hbGet( wxObject* wxObj );
wxObject*     wx_ObjList_wxGet( PHB_ITEM pSelf );

