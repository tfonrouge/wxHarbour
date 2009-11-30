/*
 * $Id$
 */

/*
	(C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
	wxarel
	Teo. Mexico 2006
*/

#include "wxharbour.ch"

FUNCTION Main()

	IMPLEMENT_APP( MyApp():New() )

RETURN NIL

CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
	DATA frame
	METHOD OnInit()
PUBLISHED:
ENDCLASS

METHOD FUNCTION OnInit() CLASS MyApp
	LOCAL g_cve := ""
	LOCAL cComentario := ""

	CREATE FRAME ::frame ;
		TITLE "Frame1"

	BEGIN BOXSIZER VERTICAL
	    BEGIN FLEXGRIDSIZER COLS 2 GROWABLECOLS 2 ALIGN EXPAND
		@ SAY "Codigo" SIZERINFO ALIGN RIGHT
		@ GET g_cve SIZERINFO ALIGN LEFT
    		@ SAY "Comentario" SIZERINFO ALIGN RIGHT
		@ GET cComentario MULTILINE SIZERINFO ALIGN EXPAND
	    END SIZER
	    @ BUTTON "ShowTitle" ACTION {|| wxMessageBox( wxGetApp():frame:GetTitle() ) }
	END SIZER	

	SHOW WINDOW ::frame FIT CENTRE

RETURN .T.
