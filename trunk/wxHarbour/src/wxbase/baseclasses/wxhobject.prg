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
  TBaseClass
  Teo. Mexico 2006
*/
CLASS TBaseClass
PRIVATE:
PROTECTED:
PUBLIC:

  DESTRUCTOR OnDestruct()

  METHOD __Delete /* calls delete for wxObjs  */

  METHOD HB_Destruct
  METHOD ClearObjData VIRTUAL

PUBLISHED:
ENDCLASS

/*
  OnDestruct
  Teo. Mexico 2008
*/
METHOD PROCEDURE OnDestruct CLASS TBaseClass
//   ? "HB Destroying:",::ClassName()
  ::HB_Destruct()
RETURN

/*
  EndClass TBaseClass
*/

/*
  wxObject
  Teo. Mexico 2006
*/
CLASS wxObject FROM TBaseClass
PRIVATE:
PROTECTED:
PUBLIC:
  METHOD ObjectH        /* handle */
  METHOD ObjectP        /* pointer */

  METHOD OnWXHConnect

PUBLISHED:
ENDCLASS

METHOD PROCEDURE OnWXHConnect CLASS wxObject
  ? ProcName( 0 ),::ClassName()
RETURN

/*
  End Class wxObject
*/
