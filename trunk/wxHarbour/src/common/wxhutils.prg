/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"

/*
    Choose() : Elige de un array de opciones a un array de selecciones
    Teo. 1995
*/
FUNCTION Choose(se,ao,as,def,lSoftCompare)
    LOCAL n

    IF ValType( ao[1] ) = "A"
        IF lSoftCompare = .T.
            IF (n:=ascan(ao[1],{|e| se = e }))>0
                RETURN ao[2,n]
            ENDIF
        ELSE
            IF (n:=ascan(ao[1],{|e| se == e }))>0
                RETURN ao[2,n]
            ENDIF
        ENDIF
    ELSE
        IF lSoftCompare = .T.
            IF (n:=ascan(ao,{|e| se = e }))>0
                RETURN as[n]
            ENDIF
        ELSE
            IF (n:=ascan(ao,{|e| se == e }))>0
                RETURN as[n]
            ENDIF
        ENDIF
    ENDIF

    IF !def==NIL
        RETURN def
    ENDIF

    DO CASE
    CASE valtype(as[1])=="C"
        RETURN ""
    CASE valtype(as[1])=="N"
        RETURN 0
    CASE valtype(as[1])=="D"
        RETURN ctod("")
    ENDCASE

RETURN NIL

/*
    wxhAlert
    Teo. Mexico 2009
*/
FUNCTION wxhAlert( cMessage, aOptions )
    LOCAL result

    IF aOptions = NIL
        aOptions := 0
    ENDIF

    result := wxMessageBox( cMessage, "Message", HB_BitOr( aOptions, wxICON_EXCLAMATION ) )

RETURN result

/*
    wxhAlertYesNo
    Teo. Mexico 2009
*/
FUNCTION wxhAlertYesNo( cMessage )
    LOCAL result

    result := wxMessageBox( cMessage, "Message!", HB_BitOr( wxYES_NO, wxICON_QUESTION ) )
    SWITCH result
    CASE wxYES
        result := 1
        EXIT
    CASE wxNO
        result := 2
        EXIT
    OTHERWISE
        result := 0
    ENDSWITCH

RETURN result
