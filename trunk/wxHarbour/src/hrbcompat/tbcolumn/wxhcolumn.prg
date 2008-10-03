/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
  wxhBColumn
  Teo. Mexico 2008
*/
CLASS wxhBColumn
PRIVATE:

  DATA FBlock
  DATA FFooting
  DATA FHeading INIT ""
  DATA FPicture
  DATA FWidth

  METHOD SetBlock( block ) INLINE ::FBlock := block
  METHOD SetFooting( footing ) INLINE ::FFooting := footing
  METHOD SetHeading( heading ) INLINE ::FHeading := heading
  METHOD SetPicture( picture ) INLINE ::FPicture := picture
  METHOD SetWidth( width ) INLINE ::FWidth := width

PROTECTED:
PUBLIC:

  CONSTRUCTOR New( heading, block )

PUBLISHED:
  PROPERTY Block READ FBlock WRITE SetBlock
  PROPERTY Footing READ FFooting WRITE SetFooting
  PROPERTY Heading READ FHeading WRITE SetHeading
  PROPERTY Picture READ FPicture WRITE SetPicture
  PROPERTY Width READ FWidth WRITE SetWidth
ENDCLASS

/*
  New
  Teo. Mexico 2008
*/
METHOD New( heading, block ) CLASS wxhBColumn

  IF heading != NIL
    ::FHeading := heading
  ENDIF

  ::FBlock := block

RETURN Self

/*
  wxhBColumnNew
  Teo. Mexico 2008
*/
FUNCTION wxhBColumnNew( heading, block )
RETURN wxhBColumn():New( heading, block )

/*
  EndClass wxhBColumn
*/
