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
  DATA FenableBlock
  METHOD GetEnableBlock
  METHOD SetEnableBlock( enable )
PROTECTED:
PUBLIC:

  /* Harbour specific */
  DATA wxhGet			/* holds a wxhGet object */
  METHOD GetPointSize()
  PROPERTY enableBlock READ GetEnableBlock WRITE SetEnableBlock
  /* Harbour specific */

  METHOD Centre( direction )
  METHOD Close( force )
  METHOD Destroy
  METHOD Disable
  METHOD Enable( enable )
  METHOD FindFocus
  METHOD FindWindowById( id, parent )
  METHOD FindWindowByLabel( label, parent )
  METHOD FindWindowByName( name, parent )
  METHOD Freeze
  METHOD GetChildren()
  METHOD GetFont
  METHOD GetGrandParent()
  METHOD GetId
  METHOD GetLabel
  METHOD GetName
  METHOD GetParent
  METHOD GetSizer
  METHOD Hide( Value )
  METHOD IsEnabled
  METHOD IsShown
  METHOD MakeModal( flag )
  METHOD PopupMenu( menu, pos )
      /* PopupMenu( menu, x, y ) */
  METHOD Raise
  METHOD SetFocus
  METHOD SetId( id )
  METHOD SetLabel( label )
  METHOD SetMaxSize( size )
  METHOD SetMinSize( size )
  METHOD SetName( name )
  METHOD SetSizer( sizer, deleteOld )
  METHOD SetToolTip
  METHOD Show( Value /* defaults to TRUE */ )
  METHOD Thaw
  METHOD Validate INLINE .T. //VIRTUAL
PUBLISHED:
ENDCLASS

/*
  GetEnableBlock
  Teo. Mexico 2009
*/
METHOD FUNCTION GetEnableBlock CLASS wxWindow
  LOCAL valType

  valType := ValType( ::FenableBlock )

  IF ! valType $ "BL"
    RETURN .F.
  ENDIF

  IF valType = "B"
    RETURN ::FenableBlock:Eval( Self )
  ENDIF

RETURN ::FenableBlock

/*
  SetEnableBlock
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetEnableBlock( enable ) CLASS wxWindow

  ::FenableBlock := enable

  ::Enable( ::GetEnableBlock() )

RETURN

/*
  End Class wxWindow
*/
