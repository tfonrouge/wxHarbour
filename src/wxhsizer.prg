/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxSizer
  Teo. Mexico 2006
*/

/* Abstract Class */

#include "hbclass.ch"
#include "property.ch"
#include "wx/wx.ch"

/*
  wxSizer
  Teo. Mexico 2006
*/
CLASS wxSizer FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
  METHOD Add( p1, p2, p3, p4, p5, p6 )
PUBLISHED:
ENDCLASS

/*
  Add: Overloaded
  Teo. Mexico 2006
*/
FUNCTION Add( p1, p2, p3, p4, p5, p6 ) CLASS wxSizer
  LOCAL Result

  DO CASE
  CASE ValType( p1 ) = "O" .AND. p1:IsDerivedFrom("wxWindow")
    IF PCount() = 2
    ELSE
      ? "Adding wxWindow..."
      wx_Sizer_Add2( Self, p1, p2, p3, p4, p5 )
    ENDIF
  CASE ValType( p1 ) = "O" .AND. p1:IsDerivedFrom("wxSizer")
    IF PCount() = 2
    ELSE
      ? "Adding wxSizer..."
      wx_Sizer_Add4( Self, p1, p2, p3, p4, p5 )
    ENDIF
  CASE ValType( p1 ) = "N"
    ? "Adding SPACER..."
    Result := wx_Sizer_Add5( Self, p1, p2, p3, p4, p5, p6 )
  ENDCASE

RETURN Result

/*
  EndClass wxSizer
*/


