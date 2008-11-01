/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

#include "dialog.ch"

/*
  wxhShowError
  Teo. Mexico 2008
*/
FUNCTION wxhShowError( cMessage, aOptions )
  LOCAL retVal := 0
  LOCAL dlg
  LOCAL itm
  LOCAL i,id
  LOCAL b
  LOCAL aStack := {}
  LOCAL s

  /*
    TODO: Check if we have enough resources to do this
  */

  i := 2
  WHILE ! Empty( s := ProcName( ++i ) )
    AAdd( aStack, { s, ProcLine( i ), ProcFile( i ) } )
  ENDDO

  CREATE DIALOG dlg ;
         WIDTH 600 HEIGHT 400 ;
         TITLE "Error System" ;
         STYLE HB_BITOR( wxDEFAULT_DIALOG_STYLE, wxSTAY_ON_TOP )

  BEGIN BOXSIZER VERTICAL
    @ SAY cMessage
    BEGIN NOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
      ADD BOOK PAGE "Error Object" FROM
        BEGIN PANEL
        END PANEL
      ADD BOOK PAGE "Call Stack" FROM
        @ BROWSE VAR b DATASOURCE aStack //SIZERINFO ALIGN EXPAND STRETCH
    END NOTEBOOK
    BEGIN BOXSIZER HORIZONTAL
      FOR EACH itm IN aOptions
        i := itm:__enumIndex()
        DO CASE
        CASE itm == wxhLABEL_QUIT
          id := wxID_CANCEL
          itm := NIL
        CASE itm == wxhLABEL_RETRY
          id := wxID_REDO
          itm := NIL
        CASE itm == wxhLABEL_DEFAULT
          id := wxID_DEFAULT
          itm := NIL
        OTHERWISE
          id := wxID_ANY
        ENDCASE
        @ BUTTON itm ID id ACTION {|| retVal := i, dlg:Close() }
//         @ BUTTON "Fit" ACTION b:grid:Fit()
      NEXT
    END SIZER
  END SIZER

  b:grid:Fit()

  ADD BCOLUMN b TITLE "ProcName" BLOCK aStack[ b:RecNo, 1 ] WIDTH 30
  ADD BCOLUMN b TITLE "ProcLine" BLOCK aStack[ b:RecNo, 2 ] PICTURE "99999"
  ADD BCOLUMN b TITLE "ProcFile" BLOCK aStack[ b:RecNo, 3 ] WIDTH 20

  SHOW WINDOW dlg MODAL //FIT

RETURN retVal
