/*
 * $Id: dbf_ctrls1.prg 459 2010-11-13 21:13:47Z tfonrouge $
 */

/*
	dbf_ctrls1 sample
	Teo. Mexico 2010
*/

#ifdef _DEBUG_
#ifdef HB_OS_UNIX
	REQUEST HB_GT_XWC_DEFAULT
#endif
#ifdef HB_OS_WINDOWS
	REQUEST HB_GT_WVT_DEFAULT
#endif
#else
	REQUEST HB_GT_NUL_DEFAULT
#endif

#include "wxharbour.ch"

FUNCTION Main

	IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
	MyApp
	Teo. Mexico 2010
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
	DATA frame
PUBLIC:
	METHOD OnInit()
PUBLISHED:
ENDCLASS
/*
	EndClass MyApp
*/

/*
	OnInit
	Teo. Mexico 2010
*/
METHOD FUNCTION OnInit() CLASS MyApp
	LOCAL b

	USE test NEW SHARED

	CREATE FRAME ::frame ;
		TITLE "Browse/GET sample"

	BEGIN BOXSIZER VERTICAL
	
		@ BROWSE VAR b DATASOURCE "test" ;
			ONSELECTCELL {|| ::frame:TransferDataToWindow() } ;
			SIZERINFO ALIGN EXPAND STRETCH
			
			ADD BCOLUMN TO b "First"  BLOCK {|| TEST->first }
			ADD BCOLUMN TO b "Last"   BLOCK {|| TEST->last }
			ADD BCOLUMN TO b "Street" BLOCK {|| TEST->street }
	
		BEGIN FLEXGRIDSIZER COLS 6 GROWABLECOLS 2,4,6 ALIGN EXPAND
			@ SAY "First:" SIZERINFO ALIGN RIGHT
				@ GET TEST->first NOEDITABLE ;
					SIZERINFO ALIGN EXPAND
			@ SAY "Last:" SIZERINFO ALIGN RIGHT
				@ GET TEST->last ;
					SIZERINFO ALIGN EXPAND
			@ SAY "Street:" SIZERINFO ALIGN RIGHT
				@ GET TEST->street ;
					SIZERINFO ALIGN EXPAND
		END SIZER
		
		BEGIN BOXSIZER HORIZONTAL ALIGN CENTER
			@ BUTTON "Next" ACTION TEST->( b:Down() )
		END SIZER

		@ BUTTON ID wxID_EXIT ACTION ::frame:Close() SIZERINFO ALIGN RIGHT

	END SIZER
	
	b:AutoSizeColumns( .F. )

	b:ConnectGridEvt( b:GetId(), wxEVT_GRID_LABEL_LEFT_DCLICK, {|gridEvent| gridEvent:GetEventObject():AutoSizeColumns( .F. )  } )

	SHOW WINDOW ::frame FIT CENTRE

RETURN .T. // If main window is a wxDialog, we need to return false on OnInit
