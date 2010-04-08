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

#include "dbinfo.ch"

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
	DATA looked
	DATA brw
	DATA btnRLock
	DATA dlg
	METHOD ToogleBtn()
	METHOD UnLock( recNo )
PUBLIC:
	METHOD OnInit()
PUBLISHED:
ENDCLASS

/*
	OnInit
	Teo. Mexico 2010
*/
METHOD FUNCTION OnInit() CLASS MyApp

	USE test NEW SHARED

	CREATE DIALOG ::dlg ;
		TITLE "Browse/GET sample"

	BEGIN BOXSIZER VERTICAL
	
		@ BUTTON "Fit" ACTION ::brw:AutoSizeColumns( .F. )
	
		@ BROWSE VAR ::brw DATASOURCE "test" ;
			ONSELECTCELL {|| ::UnLock( RecNo() ), ::dlg:TransferDataToWindow() } ;
			MINSIZE 600,400 ;
			SIZERINFO ALIGN EXPAND STRETCH
			
			ADD BCOLUMN TO ::brw "First"  BLOCK {|| TEST->first }
			ADD BCOLUMN TO ::brw "Last"   BLOCK {|| TEST->last }
			ADD BCOLUMN TO ::brw "Street" BLOCK {|| TEST->street }
	
		BEGIN FLEXGRIDSIZER COLS 6 GROWABLECOLS 2,4,6 ALIGN EXPAND
			@ SAY "First:" SIZERINFO ALIGN RIGHT
				@ GET TEST->first ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
					SIZERINFO ALIGN EXPAND
			@ SAY "Last:" SIZERINFO ALIGN RIGHT
				@ GET TEST->last ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
					SIZERINFO ALIGN EXPAND
			@ SAY "Street:" SIZERINFO ALIGN RIGHT
				@ GET TEST->street ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
					SIZERINFO ALIGN EXPAND
		END SIZER
		
		@ BUTTON "RLock" VAR ::btnRLock ACTION ::ToogleBtn()

		@ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
		
		BEGIN BOXSIZER HORIZONTAL ALIGN CENTER
			@ SPACER
			@ BUTTON "Up" ACTION TEST->( ::UnLock(), ::brw:Up() )
			@ BUTTON "Down" ACTION TEST->( ::UnLock(), ::brw:Down() )
		END SIZER

		@ BUTTON ID wxID_EXIT ACTION ::dlg:Close() SIZERINFO ALIGN RIGHT

	END SIZER
	
	::brw:AutoSizeColumns( .F. )

	::brw:ConnectGridEvt( ::brw:GetId(), wxEVT_GRID_LABEL_LEFT_DCLICK, {|gridEvent| gridEvent:GetEventObject():AutoSizeColumns( .F. )  } )

	SHOW WINDOW ::dlg FIT CENTRE MODAL

RETURN .F. // If main window is a wxDialog, we need to return false on OnInit

/*
	ToogleBtn
	Teo. Mexico 2010
*/
METHOD PROCEDURE ToogleBtn() CLASS MyApp
	IF ::looked = NIL
		IF RLock()
			::looked := RecNo()
			::btnRLock:SetLabel( "UnLock" )
		ENDIF
	ELSE
		::UnLock()
	ENDIF
RETURN

/*
	UnLock
	Teo. Mexico 2010
*/
METHOD PROCEDURE UnLock( recNo ) CLASS MyApp
	IF ::looked != NIL
		IF recNo = NIL .OR. recNo != ::looked
			DbUnLock()
			::btnRLock:SetLabel( "RLock" )
			::looked := NIL
			::brw:RefreshAll()
		ENDIF
	ENDIF
RETURN

/*
	EndClass MyApp
*/
