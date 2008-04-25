/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_Validator: Implementation
  Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wx_validator.h"

/*
  ~wx_Validator
  Teo. Mexico 2006
*/
wx_Validator::~wx_Validator()
{
  wx_ObjList_wxDelete( this );
}

HB_FUNC( WXVALIDATOR_NEW )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  wx_Validator* validator = new wx_Validator;

  // Add object's to hash list
  wx_ObjList_New( validator, pSelf );


  hb_itemReturn( pSelf );
}

