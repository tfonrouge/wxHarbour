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

	CREATE FRAME ::frame ;
		TITLE "Frame1"
		
	@ BUTTON "ShowTitle" ACTION {|| wxMessageBox( wxGetApp():frame:GetTitle() ) }

	SHOW WINDOW ::frame FIT CENTRE

RETURN .T.
