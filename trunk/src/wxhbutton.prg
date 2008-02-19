/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxButton
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx/wx.ch"

/*
  wxButton
  Teo. Mexico 2006
*/
CLASS wxButton FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, label, pos, size, style, validator, name )
PUBLISHED:
ENDCLASS

/*
  EndClass wxButton
*/

/*
 * wxh_Button
 * Teo. Mexico 2008
 */
FUNCTION wxh_Button( window, id, label, pos, size, style, validator, name, proportion, flag, border )
  LOCAL Result

  IF window = NIL
    window := wxh_LastTopLevelWindow()
  ENDIF

  Result := wxButton():New( window, id, label, pos, size, style, validator, name )

  wxh_SizerAdd( , Result, proportion, flag, border )

RETURN Result
