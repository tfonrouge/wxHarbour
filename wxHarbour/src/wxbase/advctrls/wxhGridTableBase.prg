/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxGridTableBase
    Teo. Mexico 2009
*/
CLASS wxGridTableBase FROM wxObject
PRIVATE:
    METHOD GetGridDataIsOEM()
    METHOD SetGridDataIsOEM()
PROTECTED:
PUBLIC:
    CONSTRUCTOR New
    METHOD AppendCols( numCols )
    METHOD AppendRows( numRows )
    METHOD DeleteCols( pos, numCols )
    METHOD DeleteRows( pos, numRows )
    METHOD GetNumberCols
    METHOD GetNumberRows
    METHOD GetValue( row, col ) BLOCK {|Self, row, col| Self,LTrim(Str(row))+":"+LTrim(Str(col)) }
    METHOD GetView
    METHOD InsertCols( pos, numCols )
    METHOD InsertRows( pos, numRows )
    METHOD IsEmptyCell( row, col ) BLOCK {|| .F. }
    METHOD SetValue( row, col, value ) VIRTUAL
PUBLISHED:
    PROPERTY GridDataIsOEM READ GetGridDataIsOEM WRITE SetGridDataIsOEM
ENDCLASS

/*
    EndClass wxGridTableBase
*/
