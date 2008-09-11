/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
  wxWindow
  Teo. Mexico 2006
*/
CLASS wxWindow FROM wxEvtHandler
PRIVATE:
PROTECTED:
PUBLIC:
  METHOD Centre( direction )
  METHOD Close( force )
  METHOD Destroy
  METHOD FindWindowByName( name, parent )
  METHOD FindWindowByLabel( label, parent )
  METHOD GetId
  METHOD GetLabel
  METHOD GetName
  METHOD GetParent
  METHOD GetSizer
  METHOD Hide( Value )
  METHOD IsShown
  METHOD SetSizer( sizer, deleteOld )
  METHOD Show( Value /* defaults to TRUE */ )
PUBLISHED:
ENDCLASS
/*
  End Class wxWindow
*/
