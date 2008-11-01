/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

#include "common.ch"
#include "error.ch"

PROCEDURE wxhErrorSys()
  ErrorBlock( {|oError| wxhDefError( oError ) } )
RETURN

STATIC FUNCTION wxhDefError( oError )
  LOCAL cMessage
  LOCAL cDOSError
  LOCAL aOptions
  LOCAL nChoice
  LOCAL n

  // By default, division by zero results in zero
  IF oError:genCode == EG_ZERODIV .AND. ;
    oError:canSubstitute
    RETURN 0
  ENDIF

  // By default, retry on RDD lock error failure */
  IF oError:genCode == EG_LOCK .AND. ;
    oError:canRetry
    // oError:tries++
    RETURN .T.
  ENDIF

  // Set NetErr() of there was a database open error
  IF oError:genCode == EG_OPEN .AND. ;
    oError:osCode == 32 .AND. ;
    oError:canDefault
    NetErr( .T. )
    RETURN .F.
  ENDIF

  // Set NetErr() if there was a lock error on dbAppend()
  IF oError:genCode == EG_APPENDLOCK .AND. ;
    oError:canDefault
    NetErr( .T. )
    RETURN .F.
  ENDIF

  cMessage := ErrorMessage( oError )
  IF ! Empty( oError:osCode )
    cDOSError := "(DOS Error " + hb_NToS( oError:osCode ) + ")"
  ENDIF

  // Build buttons

  aOptions := {}

  AAdd( aOptions, wxhLABEL_QUIT )

  IF oError:canRetry
    AAdd( aOptions, wxhLABEL_RETRY )
  ENDIF

  IF oError:canDefault
    AAdd( aOptions, wxhLABEL_DEFAULT )
  ENDIF

  IF ! ISNIL( cDOSError )
    cMessage += E"\n" + cDOSError
  ENDIF

  nChoice := 0
  DO WHILE nChoice == 0

    nChoice := wxhShowError( cMessage, aOptions )

  ENDDO

  IF ! Empty( nChoice )
    DO CASE
    CASE aOptions[ nChoice ] == "Break"
      Break( oError )
    CASE aOptions[ nChoice ] == wxhLABEL_RETRY
      RETURN .T.
    CASE aOptions[ nChoice ] == wxhLABEL_DEFAULT
      RETURN .F.
    ENDCASE
  ENDIF

  n := 1
  DO WHILE ! Empty( ProcName( ++n ) )

    OutErr( hb_OSNewLine() )
    OutErr( "Called from " + ProcName( n ) + ;
              "(" + hb_NToS( ProcLine( n ) ) + ")  " )

  ENDDO

  //wxGetApp():GetTopWindow():Close( .T. )
  wxGetApp():ExitMainLoop()
  wxExit() /* TODO: Fix gpf at exit */

  ErrorLevel( 1 )
  wxKill( wxGetProcessId() )
  QUIT


RETURN .F.

STATIC FUNCTION ErrorMessage( oError )

   // start error message
   LOCAL cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   // add subsystem name if available
   IF ISCHARACTER( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF ISNUMBER( oError:subCode )
      cMessage += "/" + hb_NToS( oError:subCode )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF ISCHARACTER( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE !Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   RETURN cMessage
