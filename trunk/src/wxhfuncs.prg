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
 * wxh_BeginBoxSizer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_BeginBoxSizer( staticBox, orient, strech, align, border, sideBorders )
  LOCAL setSizer
  LOCAL sizer

  setSizer := Len( sizerList ) = 0

  IF staticBox = NIL
    sizer := wxBoxSizer():New( orient )
  ELSE
    sizer := wxStaticBoxSizer():New( staticBox, orient )
  ENDIF

  AAdd( sizerList, sizer )

  IF setSizer
    wxh_LastTopLevelWindow():SetSizer( sizer )
  ELSE
    wxh_SizerAdd( sizerList[ Len( sizerList ) - 1 ], sizer, strech, align, border, sideBorders )
  ENDIF

RETURN

/*
 * wxh_BeginGridSizer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_BeginGridSizer( rows, cols, vgap, hgap, strech, align, border, sideBorders )
  LOCAL setSizer
  LOCAL sizer

  setSizer := Len( sizerList ) = 0

  sizer := wxGridSizer():New( rows, cols, vgap, hgap )

  AAdd( sizerList, sizer )

  IF setSizer
    wxh_LastTopLevelWindow():SetSizer( sizer )
  ELSE
    wxh_SizerAdd( sizerList[ Len( sizerList ) - 1 ], sizer, strech, align, border, sideBorders )
  ENDIF

RETURN

/*
 * wxh_SizerAdd
 * Teo. Mexico 2008
 */
PROCEDURE wxh_SizerAdd( parent, child, strech, align, border, sideBorders, flag )

  IF parent = NIL
    parent := sizerList[ Len( sizerList ) ]
  ENDIF

  IF strech = NIL
    strech := 0
  ENDIF

  IF align = NIL
    IF parent:IsDerivedFrom("wxGridSizer")
      align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
    ELSE
      IF parent:GetOrientation() = wxVERTICAL
        align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
      ELSE
        align := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
      ENDIF
    ENDIF
  ENDIF

  IF sideBorders = NIL
    sideBorders := wxALL
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  IF flag = NIL
    flag := 0
  ENDIF

  parent:Add( child, strech, HB_BITOR( align, sideBorders, flag ), border )

RETURN

/*
 * wxh_EndDefineBoxSizer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_EndSizer
  ASize( sizerList, Len( sizerList ) - 1 )
RETURN

/*
 * wxh_Spacer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_Spacer( width, height, strech, align, border )

  IF width = NIL
    width := 5
  ENDIF

  IF height = NIL
    height := 5
  ENDIF

  IF strech = NIL
    strech := 1
  ENDIF

  IF align = NIL
    IF !ATail( sizerList ):GetOrientation() = wxHORIZONTAL
      align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
    ELSE
      align := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
    ENDIF
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  ATail( sizerList ):Add( width, height, strech, align, border )

RETURN

/*
 * wxh_SizerList
 * Teo. Mexico 2008
 */
FUNCTION wxh_SizerList
RETURN sizerList
