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
  wxGridTableBase
  Teo. Mexico 2006
*/
CLASS wxGridTableBase FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New
  METHOD GetNumberCols BLOCK {|| 10 }
  METHOD GetNumberRows BLOCK {|| 10 }
  METHOD GetValue( row, col ) BLOCK {|Self, row, col| Self,LTrim(Str(row))+":"+LTrim(Str(col)) }
  METHOD IsEmptyCell( row, col ) BLOCK {|| .F. }
  METHOD SetColLabelValue( col, label )
  METHOD SetValue( row, col, value ) VIRTUAL
PUBLISHED:
ENDCLASS

/*
  EndClass wxGridTableBase
*/

/*
  wxGridTableBaseDb
  Teo. Mexico 2006
*/
CLASS wxGridTableBaseDb FROM wxGridTableBase
PUBLIC:

  METHOD New

  METHOD GetColLabelValue( col ) BLOCK {|Self,col| Self,FieldName( col + 1 ) }
  METHOD GetRowLabelValue( row ) BLOCK {|Self,row| Self,LTrim(Str( row + 1 )) }

  DATA GetNumberCols
  DATA GetNumberRows
  METHOD GetValue( row, col )
  METHOD SetValue( row, col, value )

ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New CLASS wxGridTableBaseDb
  Super:New()
  ::GetNumberCols := FCount()
  ::GetNumberRows := RecCount()
RETURN Self

/*
  GetValue
  Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxGridTableBaseDb
  LOCAL Result

  IF RecNo() != ++row
    DbGoTo( row )
  ENDIF

  Result := FieldGet(++col)

  IF ValType( Result ) = "C"
    RETURN Result
  ENDIF

RETURN "?"

/*
  SetValue
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value )

  ? "Changing:","Row:", row, "Col:", col, "Value:",value

RETURN
