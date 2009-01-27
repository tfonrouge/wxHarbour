/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wx_object: Implementation
  Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/hashset.h"
#include "wxh.h"

#include "wxbase/wx_object.h"

/*
  TBaseClass::OnDestruct
  Teo. Mexico 2008
*/
HB_FUNC( TBASECLASS_WXDESTRUCT )
{
  PHB_ITEM pSelf = hb_stackSelfItem();

  /* 1: delete the C++ wxObject */
  /* 2: dont try to release event codeblocks because they are already released */

  /* As we are here, it means that there not exist another PHB_ITEM's of this HB class
     So, we just need to call the C++ destructor of this object */
  wxh_ItemListDel_HB( pSelf, true, false );
}

/*
  wxObject:ObjectH
  Teo. Mexico 2009
*/
HB_FUNC( WXOBJECT_OBJECTH )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  if( pSelf )
    hb_retptr( pSelf->item.asArray.value );
}

/*
  wxObject:ObjectP
  Teo. Mexico 2009
*/
HB_FUNC( WXOBJECT_OBJECTP )
{
  PHB_ITEM pSelf = hb_stackSelfItem();
  wxObject* wxObj = wxh_ItemListGetWX( pSelf );

  if( wxObj )
    hb_retptr( wxObj );
}
