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
  TGridTableBrowse
  Teo. Mexico 2006
*/
CLASS wxGridTableBrowse FROM wxGridTableBase
PRIVATE:
  DATA FColumnList INIT {}
PROTECTED:
PUBLIC:
  DATA GetNumberCols INIT 0
  DATA GetNumberRows INIT 0
  METHOD GetColLabelValue( nCol ) INLINE ::FColumnList[ nCol ]:Heading
  METHOD GetRowLabelValue( nRow ) BLOCK {|| "" }
  METHOD GetValue( nRow, nCol ) BLOCK {|| NIL }
PUBLISHED:
ENDCLASS
/*
  EndClass TGridTableBrowse
*/

/*
  wxBrowse
  Teo. Mexico 2006
*/
CLASS wxBrowse FROM wxGrid
PRIVATE:
  DATA FGridTable
  METHOD GetColCount
PROTECTED:
PUBLIC:
  CONSTRUCTOR New
PUBLISHED:
  PROPERTY ColCount READ GetColCount
ENDCLASS

/*
  New
  Teo. Mexico 2006
*/
METHOD New CLASS wxBrowse
  Super:New()
  ::SetTable( wxGridTableBrowse():New() )
RETURN Self

/*
  EndClass wxBrowse
*/

/*
  wxBrowseDb
  Teo. Mexico 2006
*/
CLASS wxBrowseDb FROM wxBrowse
PRIVATE:
PROTECTED:
PUBLIC:
PUBLISHED:
ENDCLASS
/*
  EndClass wxBrowseDb
*/











