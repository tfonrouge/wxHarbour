/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxhFuncs
  Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx/wx.ch"

STATIC sizerList := {}

/*
 * wxh_SAYGET
 * Teo. Mexico 2008
 */
FUNCTION wxh_SAYGET
RETURN NIL

/*
 * wxh_SAY
 * Teo. Mexico 2008
 */
FUNCTION wxh_SAY( window, id, label, pos, size, style, name )

  IF window = NIL
    window := wxh_LastTopLevelWindow()
  ENDIF

RETURN wxStaticText():New( window, id, label, pos, size, style, name )

/*
 * wxh_GET
 * Teo. Mexico 2008
 */
FUNCTION wxh_GET( var, window, id, value, pos, size, style, validator, name )

  IF window = NIL
    window := wxh_LastTopLevelWindow()
  ENDIF

  ? var

RETURN wxTextCtrl():New( window, id, value, pos, size, style, validator, name )

/*
 * wxh_DefineBoxSizer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_DefineBoxSizer( orientation, proportion, flag, border, sideBorders )
  LOCAL setSizer
  LOCAL sizer

  setSizer := Len( sizerList ) = 0

  AAdd( sizerList, sizer := wxBoxSizer():New( orientation ) )

  IF setSizer
    wxh_LastTopLevelWindow():SetSizer( sizer )
  ELSE
    wxh_SizerAdd( sizerList[ Len( sizerList ) - 1 ], sizer, proportion, flag, border, sideBorders )
  ENDIF

RETURN

/*
 * wxh_SizerAdd
 * Teo. Mexico 2008
 */
PROCEDURE wxh_SizerAdd( parent, child, proportion, flag, border, sideBorders )

  IF parent = NIL
    parent := sizerList[ Len( sizerList ) ]
  ENDIF

  IF proportion = NIL
    proportion := 0
  ENDIF

  IF flag = NIL
    IF parent:GetOrientation() = wxVERTICAL
      flag := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
    ELSE
      flag := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
    ENDIF
  ENDIF

  IF sideBorders = NIL
    flag := HB_BITOR( flag, wxALL )
  ELSE
    flag := HB_BITOR( flag, sideBorders )
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  parent:Add( child, proportion, flag, border )

RETURN

/*
 * wxh_EndDefineBoxSizer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_EndDefineBoxSizer
  ASize( sizerList, Len( sizerList ) - 1 )
RETURN

/*
 * wxh_DefineSpacer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_DefineSpacer( width, height, proportion, flag, border )

  IF width = NIL
    width := 5
  ENDIF

  IF height = NIL
    height := 5
  ENDIF

  IF proportion = NIL
    proportion := 1
  ENDIF

  IF flag = NIL
    IF !ATail( sizerList ):GetOrientation() = wxHORIZONTAL
      flag := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
    ELSE
      flag := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
    ENDIF
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  ATail( sizerList ):Add( width, height, proportion, flag, border )

RETURN

/*
 * wxh_SizerList
 * Teo. Mexico 2008
 */
FUNCTION wxh_SizerList
RETURN sizerList
