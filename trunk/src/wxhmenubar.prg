/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxMenuBar
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"

/*
  TGlobal class to hold global vars...
  Teo. Mexico 2007
*/
CLASS TGlobal
PRIVATE:
PROTECTED:
PUBLIC:
  DATA g_menuID INIT 1
  DATA g_menuList
PUBLISHED:
ENDCLASS

/*
  EndClass TGlobal
*/

/*
  Global function
  Teo. Mexico 2007
*/
FUNCTION Global
  STATIC Global
  IF Global = NIL
    Global := TGlobal():New()
  ENDIF
RETURN Global

/*
  DefineMenu: Wrapper for wxMenuBar
  Teo. Mexico 2006
*/
FUNCTION DefineMenuBar( style )
  Global():g_menuID := 1
RETURN wxMenuBar():New( style )

/*
  EndMenuBar
  Teo. Mexico 2006
*/
PROCEDURE EndMenuBar
  GetLastFrame():SetMenuBar( GetLastMenuBar() )
RETURN

/*
  wxMenuBar
  Teo. Mexico 2006
*/
CLASS wxMenuBar FROM wxWindow
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( style )
  METHOD Append( menu, title )
PUBLISHED:
ENDCLASS

/*
  End Class wxMenuBar
*/








